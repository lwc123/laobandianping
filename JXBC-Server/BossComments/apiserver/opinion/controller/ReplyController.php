<?php

namespace app\opinion\controller;

use app\common\models\ErrorCode;
use app\common\models\Result;
use app\opinion\services\OpinionService;
use think\Request;

class ReplyController
{


    /**
     * @SWG\POST(
     * path="/opinion/Reply/create",
     * summary="添加点评评论",
     * description="",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/OpinionReply")
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
    public function create(Request $request)
    {
        $request = $request->put();
        if (empty($request['OpinionId'])) {
            return Result::error(ErrorCode::OpinionId_Empty, '请选择要评论的点评');
        }
        if (empty($request['Content'])) {
            return Result::error(ErrorCode::Content_Empty, '请填写内容');
        }
        return OpinionService::ReplyCreate($request);
    }


}	

 