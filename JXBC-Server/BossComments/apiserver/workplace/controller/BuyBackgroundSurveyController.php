<?php

namespace app\workplace\controller;

use app\common\controllers\PaymentHandlerController;
use app\workplace\models\Company;
use think\Request;
use app\common\models\Result;
use app\workplace\models\BoughtCommentRecord;
use app\common\controllers\MicroServiceApiController;
use app\appbase\models\TradeStatus;
use app\workplace\services\NoticeByCommentService;
use app\common\modules\ChannelApiClient;

class BuyBackgroundSurveyController extends PaymentHandlerController {
	/**
	 * @SWG\POST(
	 * path="/workplace/BuyBackgroundSurvey/Preprocess",
	 * summary="购买背景调查(评价、离职报告)前的预处理",
	 * tags={"PaymentBizProcessor"},
	 * @SWG\Parameter(
	 * name="body",
	 * in="body",
	 * description="支付参数",
	 * required=true,
	 * @SWG\Schema(ref="#/definitions/Payment"),
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="交易记录信息，包括交易编码和第三方支付所需的（签名后）参数",
	 * @SWG\Schema(type="boolean")
	 * ),
	 * @SWG\Response(
	 * response="412",
	 * description="不符合预期的输入参数",
	 * @SWG\Schema(
	 * ref="#/definitions/Error"
	 * )
	 * )
	 * )
	 */
	public function Preprocess(Request $request) {
		$payment = $request->put ();
		 
		return true;
	}
	
	/**
	 * @SWG\POST(
	 * path="/workplace/BuyBackgroundSurvey/BizProcess",
	 * summary="购买背景调查(评价、离职报告)后，添加评价购买记录",
	 * tags={"PaymentBizProcessor"},
	 * @SWG\Parameter(
	 * name="body",
	 * in="body",
	 * description="交易记录信息",
	 * required=true,
	 * @SWG\Schema(ref="#/definitions/TradeJournal"),
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="业务处理结果[BizId=RecordId]",
	 * @SWG\Schema(
	 * ref="#/definitions/Result"
	 * )
	 * ),
	 * @SWG\Response(
	 * response="412",
	 * description="不符合预期的输入参数",
	 * @SWG\Schema(
	 * ref="#/definitions/Error"
	 * )
	 * )
	 * )
	 */
	public function BizProcess(Request $request) {
		$tradeJournal = $this->loadTradeJournal ( $request );
		$records = json_decode ( $tradeJournal ["CommodityExtension"] );
		if (empty ( $records ) || ! is_array ( $records ) || count ( $records ) < 1) {
			exception ( '非法请求', 412 );
		}
		
		if($tradeJournal["TradeStatus"] == TradeStatus::BizCompleted) {
			return Result::success ("");
		}
		
		$ids = array ();
		foreach ( $records as $item ) {

		    //评价类型都购买时
            if (array_key_exists ( "BoughtDepartureReport", $item ) && array_key_exists ( "BoughtStageEvaluation", $item )) {
                $record = new BoughtCommentRecord ( [
                    'CompanyId' => $tradeJournal ["OwnerId"],
                    'PassportId' => $tradeJournal ["BuyerId"],
                    'ArchiveId' => $item->ArchiveId,
                    'BoughtDepartureReport' => $item->BoughtDepartureReport,
                    'BoughtStageEvaluation' => $item->BoughtStageEvaluation,
                    'ArchiveCompanyId' => $item->ArchiveCompanyId
                ] );
            }
            //单独购买离职报告
            elseif (array_key_exists ( "BoughtDepartureReport", $item ) && array_key_exists ( "BoughtStageEvaluation", $item )==false) {
                $record = new BoughtCommentRecord ( [
                    'CompanyId' => $tradeJournal ["OwnerId"],
                    'PassportId' => $tradeJournal ["BuyerId"],
                    'ArchiveId' => $item->ArchiveId,
                    'BoughtDepartureReport' => $item->BoughtDepartureReport,
                    'ArchiveCompanyId' => $item->ArchiveCompanyId
                ] );
            }
            //单独购买阶段评价
            elseif (array_key_exists ( "BoughtDepartureReport", $item )==false && array_key_exists ( "BoughtStageEvaluation", $item )) {
                $record = new BoughtCommentRecord ( [
                    'CompanyId' => $tradeJournal ["OwnerId"],
                    'PassportId' => $tradeJournal ["BuyerId"],
                    'ArchiveId' => $item->ArchiveId,
                    'BoughtStageEvaluation' => $item->BoughtStageEvaluation,
                    'ArchiveCompanyId' => $item->ArchiveCompanyId
                ] );
            }

			$record->save ();
			$ids [] = $record ["RecordId"];

		}
        NoticeByCommentService::BuyBackgroundSurvey($ids,$tradeJournal ["TradeCode"]);

		$company = Company::get($tradeJournal ["OwnerId"]);
		if(!empty($company) && $company["InternalChannel"]==0 && !empty($company["ChannelCode"])) {
            $openedEnterpriseInfo = array(
                "channel_code"  => $company["ChannelCode"],
                "business_id"   => $tradeJournal ["OwnerId"],
                "user_id"        => $tradeJournal ["BuyerId"],
                "paytime"        => date("Y-m-d H:i:s", $_SERVER['REQUEST_TIME']),
                "amount"         => abs($tradeJournal ["TotalFee"]),
            );
            ChannelApiClient::SendTradeJournal($openedEnterpriseInfo);
        }

		return Result::success ( implode ( ',', $ids ) );
	}
}
