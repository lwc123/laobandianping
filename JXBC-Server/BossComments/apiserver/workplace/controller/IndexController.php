<?php
namespace app\workplace\controller;
use app\common\controllers\ApiController;
use think\Controller;
use think\Db;
use think\Config;
use think\Request;
use DateTimeZone;
use app\common\models\Pagination;
use app\appbase\models\UserPassport;
use app\common\modules\DbHelper;
use app\common\modules\ChannelApiClient;
use app\appbase\models\TradeJournal;
use app\workplace\models\Company;


class IndexController extends ApiController
{
    public function index(Request $request)
    {
        return  "欢迎试试来到BossCommentApi，请访问其他controller";
    }
    
    public function users(Request $request)
    { 
        $queryParams = $request->get();
        
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        
        if(empty($request->get("MinSignedUpTime"))) {
            $queryParams["MinSignedUpTime"] = DbHelper::getZeroDbDate();
        }
        if(empty($request->get("MaxSignedUpTime"))) {
            $queryParams["MaxSignedUpTime"] = DbHelper::getMaxDbDate();
        }
        
        $list = UserPassport::findByQuery($queryParams, $pagination);

        $test = array("code"=>"PHP", "name"=>"Perl");


        echo json_encode($queryParams)."<br/>";
        echo json_encode($pagination)."<br/>";
        echo json_encode($list);
    }
}


