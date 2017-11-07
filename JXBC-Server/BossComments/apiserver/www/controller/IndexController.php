<?php
namespace app\www\controller;

use app\workplace\models\ArchiveComment;
use app\workplace\models\Company;
use app\workplace\models\EmployeArchive;
use think\Request;
use think\Controller;

class IndexController extends Controller
{
    public function index(Request $request)
    {
        $CompanyNames = Company::where('AuditStatus', '2')->order('CreatedTime desc')->select();
        $CompanyName = [];
        $TestData = array(
            "南通一点通教育科技有限公司",
            "西安鸿浩汇通地产有限公司",
            "奉行天下科技有限公司",
            "深圳晟泰伟业金融服务有限公司",
            "苏州立荣万家投资集团有限公司",
            "深圳力天华庭资产管理有限公司",
            "南宁翔宇商贸有限公司 ",
            "大连亿方机械制造有限公司",
            "北京蓝色畅想广告传媒有限公司",
            "北京安通天下物流有限公司",
            "龙猫科技有限公司",
            "霸王别姬科技有限公司",
            "沙哈拉沙漠科技有限公司",
            "ABCDEFG有限公司",
            "bed有限公司",
            "密植科技有限公司",
            "北京科技有限公司",
            "北京双旗有限公司"
            );
        if ($CompanyNames) {
            foreach ($CompanyNames as $key => $val) {
                if (strstr($val['CompanyName'], '有限公司') && in_array($val['CompanyName'], $TestData, TRUE) == false) {
                    $CompanyName[$key] = $val['CompanyName'];
                }
            }
        }
        $CompanyName = implode(',', $CompanyName);
        $this->view->assign('CompanyName', $CompanyName);
        if ($request->isMobile())
            return $this->fetch("index-mobile");
        else
            return $this->fetch();
    }

    public function AboutUS(Request $request)
    {
        if ($request->isMobile())
            return $this->fetch("AboutUS-mobile");
        else
            return $this->fetch();
    }

    public function _empty()
    {
        return $this->fetch();
    }
}


