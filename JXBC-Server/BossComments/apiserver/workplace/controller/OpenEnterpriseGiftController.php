<?php

namespace app\workplace\controller;

use app\common\controllers\PaymentHandlerController;
use think\Request;
use app\common\models\Result;
use app\workplace\models\BoughtCommentRecord;
use app\common\controllers\MicroServiceApiController;
use app\appbase\models\TradeStatus;

class OpenEnterpriseGiftController extends PaymentHandlerController {
	/**
	 * @SWG\POST(
	 * path="/workplace/OpenEnterpriseGift/Preprocess",
	 * summary="开户赠送企业消费金额时的预处理",
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
	 * path="/workplace/OpenEnterpriseGift/BizProcess",
	 * summary="开户赠送企业消费金额时业务处理;",
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
        $tradeJournal = $request->put();
        return Result::success($tradeJournal ["TradeCode"]);
	}
}
