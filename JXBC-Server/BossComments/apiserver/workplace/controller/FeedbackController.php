<?php
namespace app\workplace\controller;

use app\common\controllers\AuthenticatedApiController;
use app\common\models\ErrorCode;
use app\common\models\Result;
use app\workplace\models\Feedback;
use think\Request;

class FeedbackController extends AuthenticatedApiController
{
    /**
     * @SWG\POST(
     * path="/workplace/Feedback/add",
     * summary="提交反馈意见",
     * description="",
     * tags={"Feedback"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/Feedback"),
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/Result"),
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
    public function add(Request $request)
    {
        $feedback = $request->put();
        $feedback['PassportId']=$this->PassportId;
        if (empty($feedback['PassportId']) && empty($feedback['Content'])) {
            return Result::error(ErrorCode::SubmitFailed, '提交失败');
        }
        $frequency=$this->frequency();
        if ($frequency>2){
            return Result::error(ErrorCode::MultipleCommit, '今日提交次数已超额');
        }
        $save = new Feedback($feedback);
        $save->allowField(true)->save();
        if (empty($save)) {
            return Result::error(ErrorCode::SubmitFailed, '提交失败');
        }
        return Result::success($save['FeedbackId']);
    }


    /**
     * @SWG\GET(
     * path="/workplace/Feedback/frequency",
     * summary="查看用户当天提交的次数",
     * description="返回int值",
     * tags={"Feedback"},
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(type="integer")
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
    public function frequency()
    {
        $PassportId = $this->PassportId;
        $frequency=0;
        if (empty($PassportId)){
            return $frequency;
        }
        $frequency=Feedback::whereTime('CreatedTime', 'd')->where('PassportId',$PassportId)->count();
        return $frequency;
    }

}