<?php

namespace app\workplace\controller;

use app\common\controllers\PaymentHandlerController;
use think\Request;
use app\common\models\Result;
use app\workplace\models\BoughtCommentRecord;
use app\common\controllers\MicroServiceApiController;
use app\appbase\models\TradeStatus;
use app\workplace\models\PrivatenessServiceContract;
use app\workplace\services\NoticeByOpenEnterpriseService;

class OpenPersonalServiceController extends PaymentHandlerController {
	/**
	 * @SWG\POST(
	 * path="/workplace/OpenPersonalService/Preprocess",
	 * summary="购买老板点评个人服务前的预处理",
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
	 * path="/workplace/OpenPersonalService/BizProcess",
	 * summary="购买老板点评个人服务后，修改个人合同信息",
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
		$PassportId = $tradeJournal ["BuyerId"];
		if ($tradeJournal ["TradeStatus"] == TradeStatus::BizCompleted) {
			return Result::success ( $PassportId );
		}
		
		$updateservicecontract = PrivatenessServiceContract::where ( ['PassportId'=>$PassportId,'ContractStatus'=>1 ] )->update ( [
				'ContractStatus'=>2,
				'TradeCode'=>$tradeJournal ["TradeCode"],
				'PaidWay'=>$tradeJournal ["PayWay"],
				'ServiceBeginTime'=>date("Y-m-d H:i:s"),
				'ServiceEndTime'=>date("Y-m-d H:i:s" ,strtotime("+1 year"))
		 ] 
		 );
        //个人用户开通会员OpenVip
        NoticeByOpenEnterpriseService::OpenVip($PassportId);
		return Result::success ($PassportId);
	}

}
