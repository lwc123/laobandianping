<?php
namespace app\workplace\controller;
use app\common\controllers\CompanyApiController;
use app\workplace\models\DrawMoneyRequest;
use app\workplace\services\DrawMoneyRequestService;
use app\workplace\models\CompanyBankCard;
use think\Request;
use app\workplace\models\Company;
use app\workplace\models\DrawMoneyAuditStatus;
class DrawMoneyRequestController extends CompanyApiController {
	
	/**
	 * @SWG\POST(
	 * path="/workplace/DrawMoneyRequest/add",
	 * summary="提现申请",
	 * description="",
	 * tags={"DrawMoneyRequest"},
	 * @SWG\Parameter(
	 * name="body",
	 * in="body",
	 * description="",
	 * required=true,
	 * @SWG\Schema(ref="#/definitions/DrawMoneyRequest")
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="Wait",
	 * @SWG\Schema(ref="#/definitions/Result")
	 * ),
	 * @SWG\Response(
	 * response="412",
	 * description="参数不符合要求",
	 * @SWG\Schema(
	 * ref="#/definitions/Error"
	 * )
	 * )
	 * )
	 */
	public function add(Request $request) {
		// 获取JSON数据
		$Request = $request->put ();
		if ($Request) { 
			$Request ['PresenterId'] = $this->PassportId;
            $Request ['AuditStatus']  = DrawMoneyAuditStatus::Submited;
			$DrawMoneyRequest =DrawMoneyRequestService::DrawMoneyRequestCreate($Request);
			return $DrawMoneyRequest;
		}
	}
	
	/**
	 * @SWG\GET(
	 * path="/workplace/DrawMoneyRequest/BankCardList",
	 * summary="公司银行卡列表",
	 * description="",
	 * tags={"DrawMoneyRequest"},
	 * @SWG\Parameter(
	 * name="CompanyId",
	 * in="query",
	 * description="公司ID",
	 * required=true,
	 * type="integer"
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="",
	 * @SWG\Schema(
	 * ref="#/definitions/CompanyBankCard"
	 * )
	 * ),
	 * @SWG\Response(
	 * response="412",
	 * description="参数不符合要求",
	 * @SWG\Schema(
	 * ref="#/definitions/Error"
	 * )
	 * )
	 * )
	 */
	public function BankCardList(Request $request) {
		// 获取JSON数据
		$Request = $request->param (); 
		if ($Request) { 
			$BankCardList =CompanyBankCard::where('CompanyId',$Request['CompanyId'])->order('UseTime' ,'desc')->select();
			 
			return $BankCardList;
		}
	}
	
	
}