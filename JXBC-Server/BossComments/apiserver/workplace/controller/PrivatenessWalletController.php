<?php
namespace app\workplace\controller;

use app\common\modules\DbHelper;
use think\Request;
use think\Db;
use app\common\controllers\AuthenticatedApiController;
use app\appbase\models\TradeJournal;
use app\appbase\models\TradeType;
use app\appbase\models\TradeMode;
use app\appbase\models\Wallet;

/**
 * @SWG\Tag(
 *   name="PrivatenessWallet",
 *   description="个人钱包相关API"
 * )
 */ 
class PrivatenessWalletController extends AuthenticatedApiController {
    /**  
     * @SWG\GET(
     *   path="/workplace/PrivatenessWallet/Wallet",
     *   summary="个人钱包",
     *   description="",     
     *   tags={"PrivatenessWallet"},  
     *   @SWG\Response(
     *     response=200,
     *     description="个人钱包[Wallet]",
     *     @SWG\Schema(
     *       type="array",
     *       @SWG\Items(ref="#/definitions/Wallet")
     *     )
     *   ),
     *   @SWG\Response(
     *     response="412",
     *     description="不符合预期的输入参数",
     *      @SWG\Schema(   
     *        ref="#/definitions/Error"
     *      )
     *   )
     * )
     */
    public function Wallet(Request $request)
    {
        $wallet = Wallet::GetPrivatenessWallet($this->PassportId);
        
        return $wallet;
    }
    
    /**  
     * @SWG\GET(
     *   path="/workplace/PrivatenessWallet/TradeHistory",
     *   summary="个人钱包记录",
     *   description="",     
     *   tags={"PrivatenessWallet"},
     *   @SWG\Parameter(
     *     name="mode",
	 * 	   in="query",
	 * 	   description="交易模式，参见枚举[TradeMode], 默认为[TradeMode.All]",
	 * 	   required=false,
	 * 	   type="integer"
     *   ),       
     *   @SWG\Parameter(
     *     name="page",
	 * 	   in="query",
	 * 	   description="页码",
	 * 	   required=false,
	 * 	   type="integer"
     *   ),    
     *   @SWG\Parameter(
     *     name="size",
	 * 	   in="query",
	 * 	   description="每页数量",
	 * 	   required=false,
	 * 	   type="integer"
     *   ),     
     *   @SWG\Response(
     *     response=200,
     *     description="个人钱包记录[TradeJournal]",
     *     @SWG\Schema(
     *       type="array",
     *       @SWG\Items(ref="#/definitions/TradeJournal")
     *     )
     *   ),
     *   @SWG\Response(
     *     response="412",
     *     description="不符合预期的输入参数",
     *      @SWG\Schema(   
     *        ref="#/definitions/Error"
     *      )
     *   )
     * )
     */
    public function TradeHistory(Request $request)
    {
        $mode = $request->get("mode");
        if(!isset ($mode)) {
            $mode = TradeMode::All;
        }

        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));

        $list = TradeJournal::FindPersonalTradeHistory($this->PassportId, $mode, $pagination);
        
        return $list;
    }
}
