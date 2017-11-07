<?php

namespace app\workplace\controller;

use app\common\controllers\AuthenticatedApiController;
use app\workplace\models\ThirdPersonalCredit;
use app\workplace\services\ThirdPersonalCreditService;
use think\Config;
use think\Controller;
use think\Request;
use think\Log;

/**
 * @SWG\Tag(
 *   name="ThirdPersonalCredit",
 *   description="第三方信用信息"
 * )
 */
class ThirdPersonalCreditController extends  AuthenticatedApiController {
    public function __construct() {
        parent::__construct();
        Config::set('default_return_type',"json");
    }

    /**
     * @SWG\GET(
     *     path="/workplace/ThirdPersonalCredit/findExistsCredits",
     *     summary="查询信用分数（伯乐分、信用贷等）",
     *     description="",
     *     tags={"thirdapis"},
     *     @SWG\Parameter(
     *         name="IDCard",
     *         in="query",
     *         description="身份证",
     *         required=true,
     *         type="integer"
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="已获得的第三方信用信息",
     *         @SWG\Schema(
     *             type="array",
     *             @SWG\Items(ref="#/definitions/ThirdPersonalCredit")
     *         )
     *     ),
     *     @SWG\Response(
     *         response="412",
     *         description="不符合预期的输入参数",
     *         @SWG\Schema(
     *             ref="#/definitions/Error"
     *         )
     *     )
     * )
     */
    public function findExistsCredits(Request $request) {
        $idCard = $request -> get("IDCard");
        if(empty($idCard)) return null;

        $queryResult = ThirdPersonalCredit::findExistsCredits($idCard);
        return json_encode($queryResult);
    }
}


