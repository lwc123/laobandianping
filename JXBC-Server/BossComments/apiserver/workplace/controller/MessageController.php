<?php
namespace app\workplace\controller;
use app\common\controllers\AuthenticatedApiController;
use app\workplace\services\HelperService;
use app\workplace\services\MessageService;
use think\Request;
use app\workplace\models\Message;

class MessageController extends AuthenticatedApiController
{
    /**
     * @SWG\GET(
     * path="/workplace/Message/getlist",
     * summary="获取个人消息",
     * description="档案id或者离职报告id = BizId，BizType=0 不可点消息，BizType=2 离职报告 ，BizType=3阶段评价",
     * tags={"Message"},
     * @SWG\Parameter(
     * name="MessageType",
     * in="query",
     * description="1：通知，2：待处理事项",
     * required=false,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="Size",
     * in="query",
     * description="每页个数",
     * required=false,
     * type="integer"
     * ),
     *
     * @SWG\Parameter(
     * name="Page",
     * in="query",
     * description="页数",
     * required=false,
     * type="integer"
     * ),
     *
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/Message"
     * )
     * ),
     * @SWG\Response(
     * response="412",
     * description="错误提示",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function getlist(Request $request){
        $papms= $request->get();
        if (empty($papms['Size'])){$papms['Size']=1;}
        if (empty($papms['Page'])){$papms['Page']=5;}
        $papms['PassportId']=$this->PassportId;
        $list=MessageService::MessageList($papms);
        return $list;
    }


    /**
     * @SWG\GET(
     * path="/workplace/Message/readMsg",
     * summary="标记消息为已读状态（待处理消息访问）",
     * description="",
     * tags={"Message"},
     * @SWG\Parameter(
     * name="MessageId",
     * in="query",
     * description="消息id",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(type="boolean")
     * ),
     * @SWG\Response(
     * response="412",
     * description="错误提示",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */

    public function readMsg(Request $request){

        $message_id = $request->param('MessageId');
        $passportId=$this->PassportId;
        if (empty($message_id)) {

            exception ( 'MessageId is null', 412 );
        }

        $status = MessageService::readMsg($message_id,$passportId);
        return $status;
    }

    /**
     * @SWG\GET(
     * path="/workplace/Message/getAppMsg",
     * summary="获取个人消息(1.0版本)",
     * description="档案id或者离职报告id = BizId，BizType=0 不可点消息，BizType=2 离职报告 ，BizType=3阶段评价",
     * tags={"Message"},
     * @SWG\Parameter(
     * name="Size",
     * in="query",
     * description="每页个数",
     * required=false,
     * type="integer"
     * ),
     *
     * @SWG\Parameter(
     * name="Page",
     * in="query",
     * description="页数",
     * required=false,
     * type="integer"
     * ),
     *
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/Message"
     * )
     * ),
     * @SWG\Response(
     * response="412",
     * description="错误提示",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function  getAppMsg(Request $request){
        $pagepapms= $request->get();
        $page = HelperService::page(intval($pagepapms['Page']),intval($pagepapms['Size']));
        $msg_data = Message::where('ToPassportId',$this->PassportId)
            ->limit($page['start'],$page['size'])->order( 'CreatedTime desc' )->select ();

        foreach ($msg_data as $key=>$value){
            MessageService::readMsg($value['MessageId'],$this->PassportId);
        }

        return $msg_data;
    }




    /**
     * @SWG\GET(
     * path="/workplace/Message/unread",
     * summary="获取消息列表红点逻辑",
     * description="",
     * tags={"Message"},
     * @SWG\Parameter(
     * name="MessageType",
     * in="query",
     * description="1：通知，2：待处理事项",
     * required=false,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(type="boolean")
     * ),
     * @SWG\Response(
     * response="412",
     * description="错误提示",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function unread(Request $request){
        $papms['MessageType']=$request->param('MessageType');
        $papms['PassportId']=$this->PassportId;
        return MessageService::getRedDotLogic($papms);
    }

}
