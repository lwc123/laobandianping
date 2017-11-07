<?php
namespace app\www\controller;
use think\Config;
use think\Request;
use think\Controller;
use app\workplace\models\Message;
use app\common\modules\DbHelper;
use app\www\services\PaginationServices;
use app\workplace\services\MessageService;
use app\common\modules\ResourceHelper;



class NoticeMessageController extends CompanyBaseController
{
    /**
     * 消息页面
     * @param Request $request
     * @return
     */
    public function messageList(Request $request){

        $request = $request->param();

        if(empty($request['MessageType'])){
            $request['MessageType']=2;
        }
       if(empty($request['page'])){
            $request['page']=1;
        }
        if(empty($request['size'])){
            $request['size']=9;
        }
            $pagination =  DbHelper::BuildPagination($request['page'] ,$request['size'] );
            $request['PassportId']=$this->PassportId;

            if ($request['MessageType'] == 2) {
                $MessageType = 'NEQ';
            }else{
                $MessageType = 'eq';
            }
            $urlQuery='CompanyId='.$request['CompanyId'].'&MessageType='.$request['MessageType'];
            $pagination->PageSize=7;
            $pagination->TotalCount =Message::where('ToPassportId', $request['PassportId'])->where('BizType', $MessageType, 0)->count();
            $noticeCount =Message::where('ToPassportId', $request['PassportId'])->where('BizType', 'eq', 0)->where('IsRead', 0)->count();
            $messageCount =Message::where('ToPassportId', $request['PassportId'])->where('BizType', 'NEQ', 0)->where('IsRead', 0)->count();
            $pageNavigation = PaginationServices::getPagination($pagination, $urlQuery,'messageList');
            $list = Message::where('ToPassportId', $request['PassportId'])->where('BizType', $MessageType, 0)->page($pagination->PageIndex, $pagination->PageSize)->order('CreatedTime desc')->select();
            $arr =json($list);
            if (empty($arr)) {
                return $list;
            }
            foreach ($list as $keys => $value) {
                //时间转换
                $list[$keys]['time'] =getDealTime($value['CreatedTime']);
                if ($value['BizType'] > 0) {
                    $url = '/_files/message-images/comment' . $value['BizType'] . '.png';
                } else {
                    $url = '/_files/message-images/week' . date('w', strtotime($value['CreatedTime'])) . '.png';
                }
                $list[$keys]['Picture'] = ResourceHelper::ToAbsoluteUri($url);
                if(strlen($value['Content'])>120){
                    $list[$keys]['Content'] = substr_replace($value['Content'],'......',120);
                }
            }
        $this->assign('list',$list);
        $this->assign('noticeCount',$noticeCount);
        $this->assign('messageCount',$messageCount);
        $this->assign('pagination',$pageNavigation);
        return $this->fetch();
    }

    /**
     * @param Request $request通知详情
     */
    public function noticeDetail(Request $request)
    {

        $message_id = $request->param('MessageId');
        $passportId=$this->PassportId;
        if (empty($message_id)) {
            exception ( 'MessageId is null', 412 );
        }
        $detail = MessageService::detail($message_id,$passportId);
        //时间转换
        $detail['time'] =getDealTime($detail['CreatedTime']);
        $this->assign('detail',$detail);
        return $this->fetch();
    }
}
