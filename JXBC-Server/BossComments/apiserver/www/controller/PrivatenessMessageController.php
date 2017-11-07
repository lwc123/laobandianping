<?php
namespace app\www\controller;
use app\common\modules\DbHelper;
use think\Request;
use app\www\services\PaginationServices;
use app\workplace\models\Message;
use app\common\modules\ResourceHelper;

class PrivatenessMessageController extends PrivatenessBaseController
{
    public function Index(Request $request){
        $request = $request->param();


        if(empty($request['page'])){
            $request['page']=1;
        }
        if(empty($request['size'])){
            $request['size']=7;
        }
        $pagination =  DbHelper::BuildPagination($request['page'] ,$request['size'] );
        $request['PassportId']=$this->PassportId;
        $pagination->PageSize =7;
        $urlQuery='MessageType='.$request['MessageType'];
        $pagination->TotalCount =Message::where('ToPassportId', $request['PassportId'])->where('BizType', 'eq', 0)->count();
        $noticeCount =Message::where('ToPassportId', $request['PassportId'])->where('BizType', 'eq', 0)->where('IsRead', 0)->count();
        $pageNavigation = PaginationServices::getPagination($pagination, $urlQuery,'Index');
        $list = Message::where('ToPassportId', $request['PassportId'])->where('BizType', 'eq', 0)->page($pagination->PageIndex, $pagination->PageSize)->order('CreatedTime desc')->select();
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
        $this->assign('pagination',$pageNavigation);
        return $this->fetch();
    }
}


