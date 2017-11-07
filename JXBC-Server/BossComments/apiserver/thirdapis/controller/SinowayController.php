<?php

namespace app\thirdapis\controller;

use app\common\controllers\AuthenticatedApiController;
use app\thirdapis\providers\SinowayApiProvider;
use app\workplace\services\ThirdPersonalCreditService;
use think\Config;
use think\Controller;
use think\Request;
use think\Log;

/**
 * @SWG\Tag(
 *   name="thirdapis_Sinoway",
 *   description="第三方API：华道征信(伯乐分、信用贷等)"
 * )
 */
class SinowayController extends Controller {
    public function __construct() {
        parent::__construct();
        Config::set('default_return_type',"json");
    }

    /**
     * @SWG\GET(
     *     path="/thirdapis/sinoway/sendQueryRequest",
     *     summary="查询华道征信的相关信用分数（伯乐分、信用贷等）",
     *     description="",
     *     tags={"thirdapis"},
     *     @SWG\Parameter(
     *         name="IDCard",
     *         in="query",
     *         description="身份证",
     *         required=true,
     *         type="integer"
     *     ),
     *     @SWG\Parameter(
     *         name="RealName",
     *         in="query",
     *         description="真实姓名",
     *         required=true,
     *         type="string"
     *     ),
     *     @SWG\Parameter(
     *         name="MobilePhone",
     *         in="query",
     *         description="手机号；指定手机号会返回准确结果；没有手机号会自动指定一个，通常会有结果，但也可能无返回结果）",
     *         required=false,
     *         type="string"
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="华道交易流水信息",
     *         @SWG\Schema(
     *             type="string"
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
    public function sendQueryRequest(Request $request) {
        $query = $request -> get();
        if(!array_key_exists("MobilePhone",$query) && empty($query["MobilePhone"])) {
            $query["MobilePhone"] = "13801230978";
        }
        $queryResult = ThirdPersonalCreditService::querySinowayCredit($query);
        return json_encode($queryResult);
    }

    /**
     * @SWG\POST(
     *     path="/thirdapis/sinoway/ReceiveCredit",
     *     summary="接受华道征信的推送结果",
     *     description="",
     *     tags={"thirdapis"},
     *     @SWG\Response(
     *         response=200,
     *         description="处理结果",
     *         @SWG\Schema(
     *             type="string"
     *         )
     *     )
     * )
     */
    public function ReceiveCredit(Request $request) {
        $product = $request -> get("product");
        if(!empty($product)) {
            $product = strstr($product,"?",true);
        }
        if(empty($product) && !empty($request -> get("prdcod"))) {
            $product = substr($request -> get("prdcod"), 0, 4);
        }
        $queryData = $request -> get("result");
        if(empty($queryData)){
            $queryData = file_get_contents('php://input');
        }

        Log::record("ReceiveCredit=> ".json_encode(array($product, $queryData)));

        //$queryData= "77spskjDSPR0WCHrHfjIW3fRt90r42nlvUMf3Y3dMHEc2nRecwyZoPQ0lXjg0IBeaFoPDCmzQDaO\n5WGV6YfxFgaGhCNT+JlbaVk3VQVGa0a8xWPLiwg0np7ZlI+mtOIG3y5obHu7Wi7++GD15D41GW+w\nnoiCLCBOeAwmDCSzMpNGz/HUNFbqa1i8Wr56bXWUstL1p2MLqMUobMOUnCwl55sg+AGElUhzgiQZ\nMbYTQgsVo/ARNPP66b7NeagiuAdAVg3jeLvLPZdZAVVDXm662yrXone+/jkM1C1ZOcqazzp7QQdt\nx5zVdWv1dEh4D1hlj30zxymBomRmOggUc4gAhWy4guiZH52pBP7fsI8B2f8+VdRiraZHP4kTUtOm\nYo+zTjNVXmC57DqM4aGSjKdc/L2JyztKDIfug3OlVR6KQFngllERrefe3G7fYHaztpF+hdpqJRZI\nHE/KmGOd3h53D+uHSnz/uG9wNtLZ+pI/5fOonI99zFuNNeyYD8hYrTjBEhQ7028nXrWVxkldcaw2\n4DjT2ypkzEWJbUriY0x9gUyw+eaAkoQT3oTFqYThz662VheLM/X/eMpDIkUlEi/93guVRx/ii9Fk\n6q5WQ3u+IqtklP7xh9IUYdcUPUvv+xGub+YiS8JgegtwJ0XU4PAdSg==";

        $isUpdated = ThirdPersonalCreditService::updateSinowayCredit($product, $queryData);

        return empty($isUpdated)?"failed":"success";
    }
}


