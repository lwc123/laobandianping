<?php

namespace app\opinion\controller;


use app\common\controllers\AuthenticatedApiController;
use app\opinion\models\Console;

class ConsoleController extends AuthenticatedApiController{


    /**
     * @SWG\GET(
     * path="/opinion/Console/index",
     * summary="个人工作台（红点和统计）",
     * description="",
     * tags={"Opinion"},
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/Console")
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
    public function index()
    {
        return Console::Console($this->PassportId);
    }


}	

 