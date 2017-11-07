<?php
namespace app\www\controller;

use app\workplace\models\ArchiveComment;
use app\workplace\models\CommentType;
use app\workplace\models\Company;
use app\workplace\models\EmployeArchive;

use app\workplace\models\PrivatenessServiceContract;
use app\workplace\services\PrivatenessService;
use think\Request;

class MyArchiveController extends PrivatenessBaseController
{
    public function Index()
    {
        //我的合同信息，是否绑定过身份证号
        $MyServiceContract = PrivatenessServiceContract::where('PassportId', $this->PassportId)->find();
        if (empty($MyServiceContract)) {
            //我的档案摘要信息
            $ArchiveSummary ['ArchiveNum'] = EmployeArchive::where('MobilePhone', $this->MyMobilePhone)->count('ArchiveId');
            if ($ArchiveSummary ['ArchiveNum'] > 0) {
                // 查询档案IDS
                $ArchiveIdArray = EmployeArchive::where('MobilePhone', $this->MyMobilePhone)->column('ArchiveId');
                if (isset ($ArchiveIdArray)) {
                    $ArchiveIds = implode(",", $ArchiveIdArray);
                    $ArchiveSummary ['StageEvaluationNum'] = ArchiveComment::where('ArchiveId', 'in', $ArchiveIds)->where([
                        'CommentType' => CommentType::StageEvaluation,
                        'AuditStatus' => 2
                    ])->count('CommentId');
                    $ArchiveSummary ['DepartureReportNum'] = ArchiveComment::where('ArchiveId', 'in', $ArchiveIds)->where([
                        'CommentType' => CommentType::DepartureReport,
                        'AuditStatus' => 2
                    ])->count('CommentId');
                } else {
                    $ArchiveSummary ['StageEvaluationNum'] = 0;
                    $ArchiveSummary ['DepartureReportNum'] = 0;
                }
            } else {
                $ArchiveSummary ['StageEvaluationNum'] = 0;
                $ArchiveSummary ['DepartureReportNum'] = 0;
            }
            $this->view->assign('ArchiveSummary', $ArchiveSummary);
            return $this->fetch('index');
        } else {
            $myArchivesList = EmployeArchive::where('IDCard', $MyServiceContract ['IDCard'])->order('DimissionTime', 'desc')->select();
            if ($myArchivesList) {
                foreach ($myArchivesList as $key => $value) {
                    $myArchivesList [$key] ['CompanyName'] = Company::where('CompanyId', $value ['CompanyId'])->value('CompanyName');
                    $myArchivesList [$key] ['StageEvaluationNum'] = ArchiveComment::where([
                        'CompanyId' => $value ['CompanyId'],
                        'ArchiveId' => $value ['ArchiveId'],
                        'CommentType' => CommentType::StageEvaluation,
                        'AuditStatus' => 2
                    ])->count('CommentId');
                    $myArchivesList [$key] ['DepartureReportNum'] = ArchiveComment::where([
                        'CompanyId' => $value ['CompanyId'],
                        'ArchiveId' => $value ['ArchiveId'],
                        'CommentType' => CommentType::DepartureReport,
                        'AuditStatus' => 2
                    ])->count('CommentId');

                    if ($MyServiceContract ['ContractStatus'] == 2) {
                        $myArchivesList [$key] ['detail'] = 'detail?ArchiveId='.$value ['ArchiveId'];
                        $myArchivesList [$key] ['pay']='';
                        $myArchivesList [$key] ['looktext']='7天内可免费查看';
                    }else{
                        $myArchivesList [$key] ['detail'] = '#';
                        $myArchivesList [$key] ['pay']='see';
                        $myArchivesList [$key] ['looktext']='马上查看';
                    }

                }
            }

            $this->view->assign('list', $myArchivesList);
            return $this->fetch('list');
        }

    }

    /**绑定我的身份号
     * @param Request $request
     * @return mixed
     */
    public function BindingIDCard(Request $request)
    {
        $BindingIDCard = $request->param();
        if ($BindingIDCard) {
            $BindingIDCard ['PassportId'] = $this->PassportId;
            $Binding = PrivatenessService::BindingIDCard($BindingIDCard);
            return $Binding;
        }
    }

    /**详情
     * @param Request $request
     * @return mixed
     */
    public function detail(Request $request)
    {
        $Detail = $request->param();
        if ($Detail) {
            $Detail['PassportId'] = $this->PassportId;
            $detail = PrivatenessService::Detail($Detail);
            if (count($detail['Commests']) > 0) {
                $Commests = $detail['Commests'];
                foreach ($Commests as $keys => $value) {
                    $Commests[$keys] ['WorkAbilityText'] = achievement($value ['WorkAbility']);
                    $Commests[$keys] ['WorkAbilityText'] = achievement($value ['WorkAbility']);
                    $Commests[$keys] ['WorkAttitudeText'] = achievement($value ['WorkAttitude']);
                    $Commests[$keys] ['WorkPerformanceText'] = achievement($value ['WorkPerformance']);
                    $Commests[$keys] ['HandoverTimelyText'] = achievement($value ['HandoverTimely']);
                    $Commests[$keys] ['HandoverOverallText'] = achievement($value ['HandoverOverall']);
                    $Commests[$keys] ['HandoverSupportText'] = achievement($value ['HandoverSupport']);
                }
                $detail['Commests'] = $Commests;
            }
            $this->view->assign('detail', $detail);
            return $this->fetch();
        }
    }
}


