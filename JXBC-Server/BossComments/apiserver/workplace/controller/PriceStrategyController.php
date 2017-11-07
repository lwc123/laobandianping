<?php

namespace app\workplace\controller;

use think\Db;
use think\Request;
use app\common\controllers\AuthenticatedApiController;
use app\workplace\services\PriceStrategyService;
use app\workplace\models\PriceStrategy;
use think\Controller;


class PriceStrategyController extends  AuthenticatedApiController {

    /**
     * @SWG\GET(
     * path="/workplace/PriceStrategy/CurrentActivity",
     * summary="优惠活动",
     * description="",
     * tags={"PriceStrategy"},
     * @SWG\Parameter(
     * name="ActivityType",
     * in="query",
     * description="活动类型",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="Version",
     * in="query",
     * description="版本号",
     * required=true,
     * type="string"
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/PriceStrategy"),
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
    public function CurrentActivity(Request $request) {
        $CurrentActivity= $request->get ();
        if ($CurrentActivity) {
            $CurrentActivityOpen = PriceStrategyService::CurrentActivity($CurrentActivity);
            return $CurrentActivityOpen;
        }
    }



}