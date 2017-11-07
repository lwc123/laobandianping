<?php

namespace app\workplace\services;

use app\common\modules\DictionaryPool;
use app\workplace\models\ArchiveComment;
use app\workplace\models\ArchiveCommentLog;
use app\workplace\models\EmployeArchive;
use app\workplace\models\WorkItem;
use app\common\modules\ResourceHelper;
use app\workplace\models\CommentType;
use app\workplace\models\Department;
use app\common\modules\DbHelper;

class CommentService
{
    public static function CommentCreate($comment)
    {
        if (empty ($comment) || empty ($comment ['ArchiveId']) || empty ($comment ['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        // 是否离职报告,判断此档案是否添加过，没添加取报告数据
        if ($comment ['CommentType'] == CommentType::DepartureReport) {
            // 查询
            if (isset($comment ['DimissionSupply'])) {
                $DimissionSupply = $comment ['DimissionSupply'];
            } else {
                $DimissionSupply = '';
            }
            $Dimissiondate = [
                'DimissionTime' => date('Y-m-d H:i:s', strtotime($comment ['DimissionTime'])),
                'DimissionSalary' => $comment ['DimissionSalary'],
                'DimissionReason' => $comment ['DimissionReason'],
                'DimissionSupply' => $DimissionSupply,
                'HandoverTimely' => $comment ['HandoverTimely'],
                'HandoverOverall' => $comment ['HandoverOverall'],
                'HandoverSupport' => $comment ['HandoverSupport'],
                'WantRecall' => $comment ['WantRecall']
            ];

            // 评价两个字段为空
            $comment ['StageYear'] = '';
            $comment ['StageSection'] = '';
        } else {
            $Dimissiondate = [];
        }
        $Commentdate = [
            'PresenterId' => $comment ['PresenterId'],
            'CompanyId' => $comment ['CompanyId'],
            'WorkComment' => $comment ['WorkComment'],
            'StageYear' => $comment ['StageYear'],
            'StageSection' => $comment ['StageSection'],
            'WorkPerformance' => $comment ['WorkPerformance'],
            'ModifiedId' => $comment ['ModifiedId'],
            'ArchiveId' => $comment ['ArchiveId'],
            'HandoverOverall' => $comment ['HandoverOverall'],
            'WorkAbility' => $comment ['WorkAbility'],
            'WorkAttitude' => $comment ['WorkAttitude'],
            'HandoverSupport' => $comment ['HandoverSupport'],
            'HandoverTimely' => $comment ['HandoverTimely'],
            'CommentType' => $comment ['CommentType'],
            'AuditStatus' => 1,
            'AuditPersons' => implode(',', $comment ['AuditPersons'])
        ];

        // 合并评价和离职数组
        $Allcomment = array_merge($Commentdate, $Dimissiondate);
        unset ($Allcomment ['WantRecallText']);
        unset ($Allcomment ['DimissionReasonText']);
        unset ($Allcomment ['StageSectionText']);
        if (isset($Allcomment ['IsSendSms'])) {
            unset ($Allcomment ['IsSendSms']);
        }
        // 添加评价信息
        $savecomment = ArchiveComment::create($Allcomment);
        // 返回档案ID
        $CommentId = $savecomment ['CommentId'];
        // 发送审核信息
        NoticeByCommentService::ArchiveCommentToAuditPersonRemind($CommentId, $comment ['PresenterId']);
        // //////////////查看提交人是否为审核人//////////////
        $AuditPersons = explode(',', $savecomment ['AuditPersons']);
        if (in_array($savecomment ['PresenterId'], $AuditPersons)) {
            ArchiveComment::where('CommentId', $CommentId)->update([
                'AuditStatus' => 2,
                'OperatePassportId' => $savecomment ['PresenterId']
            ]);
            // 发送通过信息
            NoticeByCommentService::ArchiveCommentToAuditPersonPass($CommentId, $comment ['PresenterId']);
            //个人发送信息
            if (isset($comment ["IsSendSms"]) == false) {
                $comment ["IsSendSms"] = true;
            }
            NoticeByCommentService::ArchiveCommentToAuditPersonal($CommentId, $comment ['PresenterId'], $comment ["IsSendSms"]);

            // 评论数加+1
            EmployeArchive::where('ArchiveId', $comment ['ArchiveId'])->setInc('CommentsNum');

            // 如果是离职报告
            if ($comment ['CommentType'] == CommentType::DepartureReport) {

                //更新离职报告code
                $CommentCode ['CommentCode'] = CommentCode($comment ['CompanyId'], $comment ['ArchiveId'], $CommentId);
                ArchiveComment::where('CommentId', $CommentId)->update($CommentCode);


                //公司离职报告数+1
                CompanyService::Statistics($comment ['CompanyId'], CompanyService::DepartureReportNum, CompanyService::increase);

                //查看档案是否在职
                $CurrentArchive = EmployeArchive::where('ArchiveId', $comment ['ArchiveId'])->find();

                // 更新档案为离职,和离职时间
                EmployeArchive::where('ArchiveId', $comment ['ArchiveId'])->update(['DimissionTime' => $Dimissiondate ['DimissionTime'], 'IsDimission' => 1]);
                $DeptId = $CurrentArchive['DeptId'];
                // 更新档案职务大于当前的（也就是至今）更新成离任时间，
                WorkItem::where('PostEndTime', '>', date("Y-m-d H:i:s"))->where(['ArchiveId' => $Allcomment ['ArchiveId'], 'DeptId' => $DeptId])->update([
                    'PostEndTime' => $Dimissiondate ['DimissionTime'], 'Salary' => $comment ['DimissionSalary']]);

            } else {
                //公司阶段评价数+1
                CompanyService::Statistics($comment ['CompanyId'], CompanyService::DepartureReportNum, CompanyService::increase);
            }
            DepartmentService::CalculateDepartmentStaffNumber($comment ["CompanyId"]);
            CompanyService::CalculateCompanyArchive($comment ["CompanyId"]);
        }
        // ////////////更新评价图片和音频/////////////
        // 图片
        if (isset ($comment ['WorkCommentImages']) && !empty ($comment ['WorkCommentImages'])) {
            foreach ($comment ['WorkCommentImages'] as $value) {
                $WorkCommentImages [] = ResourceHelper::SaveArchiveCommentImage($CommentId, $value);
            }
            $CommentImagesVoice ['WorkCommentImages'] = '[' . implode(',', $WorkCommentImages) . ']';
        }
        // 声音
        if (isset ($comment ['WorkCommentVoice']) && !empty ($comment ['WorkCommentVoice'])) {
            $CommentImagesVoice ['WorkCommentVoice'] = ResourceHelper::SaveArchiveCommentVoice($CommentId, $comment ['WorkCommentVoice']);
            $CommentImagesVoice ['WorkCommentVoiceSecond'] = $comment ['WorkCommentVoiceSecond'];
        }

        if ((isset ($comment ['WorkCommentImages']) && !empty ($comment ['WorkCommentImages'])) || (isset ($comment ['WorkCommentVoice']) && !empty ($comment ['WorkCommentVoice']))) {
            ArchiveComment::where('CommentId', $CommentId)->update($CommentImagesVoice);
        }

        return $CommentId;
    }

    /**
     * 修改评价
     *
     * @access public
     * @param string $Comment
     *            数据JSON
     * @return boolean
     */
    public static function CommentUpdate($Comment)
    {
        if (empty ($Comment) || empty ($Comment ["CommentId"]) || empty ($Comment ["CompanyId"])) {
            exception('非法请求-0', 412);
        }
        $CommentBeInfo = ArchiveComment::where([
            'CommentId' => $Comment ["CommentId"],
            'CompanyId' => $Comment ["CompanyId"]
        ])->find();
        $CommentBeInfo ['WorkCommentImages'] = explode(",", str_replace(array(
            "[",
            "]"
        ), "", $CommentBeInfo ['WorkCommentImages']));

        // 评价图片
        if (isset ($Comment ['WorkCommentImages'])) {
            if (count($Comment ['WorkCommentImages']) > 0) {
                foreach ($Comment ['WorkCommentImages'] as $keys => $value) {
                    if (strstr($value, Config('resources_site_root')) == false) {
                        $WorkCommentImages [] = ResourceHelper::SaveArchiveCommentImage($Comment ["CommentId"], $value);
                    } else {
                        $value = str_replace(Config('resources_site_root'), '', $value);
                        $WorkCommentImages [] = $value;
                    }
                    $CommentBeInfo ['WorkCommentImages'] = '';
                }
                $Comment ['WorkCommentImages'] = '[' . implode(',', $WorkCommentImages) . ']';
            }
        } else {
            $Comment ['WorkCommentImages'] = ''; // 置为空
        }

        // 评价录音
        if (isset ($Comment ['WorkCommentVoice'])) {
            if (strstr($Comment ['WorkCommentVoice'], Config('resources_site_root')) == false) {
                $Comment ['WorkCommentVoice'] = ResourceHelper::SaveArchiveCommentVoice($Comment ["CommentId"], $Comment ['WorkCommentVoice']);
            } else {
                $Comment ['WorkCommentVoice'] = str_replace(Config("resources_site_root"), '', $Comment ['WorkCommentVoice']);
            }
            $Comment ['WorkCommentVoiceSecond'] = $Comment ['WorkCommentVoiceSecond'];
        } else {
            $Comment ['WorkCommentVoice'] = ''; // 置为空
        }

        // //////////////查看修改人是否为审核人//////////////
        $AuditPersonsArray = $Comment ['AuditPersons'];
        if (in_array($Comment ['PresenterId'], $AuditPersonsArray)) {
            $Comment ['AuditStatus'] = 2;
            $Comment ['OperatePassportId'] = $Comment ['PresenterId'];

            //添加评论修改记录，条件：上线时间不为空添加
            if ($CommentBeInfo ['OnlineTime']) {
                $CommentLog = new ArchiveCommentLog([
                    'CompanyId' => $Comment ['CompanyId'],
                    'PresenterId' => $Comment ['PresenterId'],
                    'CommentId' => $Comment ['CommentId']
                ]);
                $CommentLog->save();
            }

        } else {
            $Comment ['AuditStatus'] = 1;
        }
        $Comment ['AuditPersons'] = implode(',', $Comment ['AuditPersons']);

        // 删掉其他类型
        unset ($Comment ['AuditPersonList']);
        unset ($Comment ['EmployeArchive']);
        unset ($Comment ['OperateRealName']);
        unset ($Comment ['WantRecallText']);
        unset ($Comment ['DimissionReasonText']);
        unset ($Comment ['StageSectionText']);
        if (isset($Comment ['IsSendSms'])) {
            unset ($Comment ['IsSendSms']);
        }
        // 修改档案信息
        $Comment ['OnlineTime'] = DbHelper::toLocalDateTime(date("Y-m-d H:i:s"));
        $CommentUpdate = ArchiveComment::update($Comment);

        if ($CommentUpdate) {
            // 如果是离职报告，更新离职时间
            if ($Comment ['CommentType'] == CommentType::DepartureReport) {
                $UpdateEmployeArchive = EmployeArchive::where([
                    'ArchiveId' => $Comment ['ArchiveId']
                ])->update([
                    'DimissionTime' => DbHelper::toLocalDateTime($Comment ['DimissionTime']),
                    'IsDimission' => 1
                ]);

                // 更新档案职务的离任时间
                $DeptId = EmployeArchive::where('ArchiveId', $Comment ['ArchiveId'])->value('DeptId');
                $UpdateWorkItem = WorkItem::where([
                    'ArchiveId' => $Comment ['ArchiveId'],
                    'DeptId' => $DeptId
                ])->update([
                    'PostEndTime' => DbHelper::toLocalDateTime($Comment ['DimissionTime']),
                    'Salary' => $Comment ['DimissionSalary']
                ]);
            }

            // 发送信息
            NoticeByCommentService::ArchiveCommentToAuditPersonRemind($Comment ["CommentId"], $Comment ['PresenterId']);
            if (in_array($Comment ['PresenterId'], $AuditPersonsArray)) {
                NoticeByCommentService::ArchiveCommentToAuditPersonPass($Comment ["CommentId"], $Comment ['PresenterId']);
            }
            DepartmentService::CalculateDepartmentStaffNumber($Comment ["CompanyId"]);
            CompanyService::CalculateCompanyArchive($Comment ["CompanyId"]);
            ArchiveService::CalculateCompanyArchiveCommentNumber($Comment ['CompanyId']);
            return true;
        } else {
            return false;
        }
    }

    /**评价列表
     * @param $Comment
     * @return false|static[]
     */
    public static function CommentSearch($Comment)
    {
        if (empty ($Comment) || empty ($Comment ["CompanyId"])) {
            exception('非法请求-0', 412);
        }
        if ($Comment ['RealName'] == '(null)') {
            $Comment ['RealName'] = '';
        }
        $CommentList = ArchiveComment::all(function ($query) use ($Comment) {
            $query->where('employe_archive.CompanyId', $Comment ['CompanyId'])->where('AuditStatus', 2)->where('CommentType', $Comment ['CommentType'])->where(function ($query) use ($Comment) {
                $query->whereor('RealName', 'like', $Comment ['RealName'] . '%');
            })->order('CommentType desc , StageYear desc, StageSection desc, archive_comment.CreatedTime desc')->page($Comment ['Page'], $Comment ['Size']);
        }, [
            'EmployeArchive'
        ]);
        if ($CommentList) {
            //评价區間字典
            $biz_periods = DictionaryPool::getDictionaries('period')['period'];
            //当前职务信息
            foreach ($CommentList as $keys => $value) {
                $ArchiveId[] = $value['ArchiveId'];
            }
            //档案IDS
            $ArchiveIds = implode(',', $ArchiveId);
            $work_items = WorkItem::where('ArchiveId', 'in', $ArchiveIds)->select();
            foreach ($CommentList as $key => $val) {
                $CommentList [$key] ['WorkCommentImages'] = [];
                $CommentList [$key] ['AuditPersons'] = [];
                $CommentList [$key] ['StageSectionText'] = $val['StageSection'];
                foreach ($biz_periods as $k => $value) {
                    if ($val['StageSection'] == $value['Code']) {
                        $CommentList[$key]['StageSectionText'] = $value['Name'];
                    }
                }
                foreach ($work_items as $value) {
                    if ($val['ArchiveId'] == $value['ArchiveId']) {
                        $CommentList [$key] ['EmployeArchive'] ['WorkItem'] = $value;
                    }
                }
            }
        }
        return $CommentList;
    }

    /**档案评价列表
     * @param $Comment
     * @return false|static[]
     */
    public static function CommentAll($Comment)
    {
        if (empty ($Comment) || empty ($Comment ["CompanyId"]) || empty ($Comment ["ArchiveId"])) {
            exception('非法请求-0', 412);
        }
        $CommentList = ArchiveComment::all(function ($query) use ($Comment) {
            $query->where([
                'ArchiveId' => $Comment ['ArchiveId'],
                'CompanyId' => $Comment ['CompanyId']
            ])->order('CommentType asc, StageYear desc, StageSection desc,CreatedTime desc');
        });
        if ($CommentList) {
            //评价區間字典
            $biz_periods = DictionaryPool::getDictionaries('period')['period'];
            foreach ($CommentList as $key => $val) {
                $CommentList [$key] ['WorkCommentImages'] = [];
                $CommentList [$key] ['AuditPersons'] = [];
                $CommentList [$key] ['StageSectionText'] = $val['StageSection'];
                foreach ($biz_periods as $k => $value) {
                    if ($val['StageSection'] == $value['Code']) {
                        $CommentList[$key]['StageSectionText'] = $value['Name'];
                    }
                }
            }
        }
        return $CommentList;
    }

    /**
     * 查找档案评价已添加年龄区间
     *
     * @access public
     * @param array $existsStageSection
     * @return boolean
     */
    public static function existsStageSection($existsStageSection)
    {
        if (empty ($existsStageSection) || empty ($existsStageSection ["CompanyId"]) || empty ($existsStageSection ["ArchiveId"])) {
            exception('非法请求-0', 412);
        }
        $StageYear = ArchiveComment::where([
            'CompanyId' => $existsStageSection ["CompanyId"],
            'ArchiveId' => $existsStageSection ["ArchiveId"],
            'CommentType' => CommentType::StageEvaluation
        ])->group('StageYear')->order('StageYear desc')->column('StageYear');
        if ($StageYear) {
            foreach ($StageYear as $key => $value) {
                $StageSection = ArchiveComment::where([
                    'CompanyId' => $existsStageSection ["CompanyId"],
                    'ArchiveId' => $existsStageSection ["ArchiveId"],
                    'StageYear' => $value,
                    'CommentType' => CommentType::StageEvaluation
                ])->column('StageSection');
                if ($StageSection) {
                    $ArrayStageYear [$key] ['StageSection'] = $StageSection;
                }
                $ArrayStageYear [$key] ['StageYear'] = $value;
            }
            return $ArrayStageYear;
        } else {
            return [];
        }
    }

    /**审核通过
     * @param $CommentId
     * @param $PassportId
     * @return bool
     */
    public static function AuditPass($CommentId, $PassportId, $IsSendSms = null)
    {
        if ($CommentId) {
            $AuditPass = ArchiveComment::get($CommentId);
            if ($AuditPass ['AuditStatus'] == 1) {

                //添加评论修改记录，条件：上线时间不为空添加
                if ($AuditPass ['OnlineTime']) {
                    $CommentLog = new ArchiveCommentLog([
                        'CompanyId' => $AuditPass ['CompanyId'],
                        'PresenterId' => $AuditPass ['PresenterId'],
                        'CommentId' => $CommentId
                    ]);
                    $CommentLog->save();
                } else {
                    // 档案评论数+1
                    EmployeArchive::where('ArchiveId', $AuditPass ['ArchiveId'])->setInc('CommentsNum');
                }

                ArchiveComment::update([
                    'CommentId' => $CommentId,
                    'AuditStatus' => 2,
                    'OnlineTime' => DbHelper::toLocalDateTime(date("Y-m-d H:i:s")),
                    'OperatePassportId' => $PassportId
                ]);


                // 如果是离职报告，查看档案是否在职
                if ($AuditPass ['CommentType'] == CommentType::DepartureReport) {
                    $IsDimissionArchive = EmployeArchive::where('ArchiveId', $AuditPass ['ArchiveId'])->value('IsDimission');
                    if ($IsDimissionArchive == 0) {
                        //更新档案为离职,和离职时间
                        $UpdateEmployeArchive = EmployeArchive::where([
                            'ArchiveId' => $AuditPass ['ArchiveId']
                        ])->update([
                            'DimissionTime' => DbHelper::toLocalDateTime($AuditPass ['DimissionTime']),
                            'IsDimission' => 1
                        ]);

                        $DeptId = EmployeArchive::where('ArchiveId', $AuditPass ['ArchiveId'])->value('DeptId');
                        //更新档案职务大于当前的（也就是至今）更新成离任时间，
                        $UpdateWorkItem = WorkItem::where('PostEndTime', '>', date("Y-m-d H:i:s"))
                            ->where([
                                'ArchiveId' => $AuditPass ['ArchiveId'],
                                'DeptId' => $DeptId
                            ])->update([
                                'PostEndTime' => DbHelper::toLocalDateTime($AuditPass ['DimissionTime']),
                                'Salary' => $AuditPass ['DimissionSalary']
                            ]);


                    }
                }
                DepartmentService::CalculateDepartmentStaffNumber($AuditPass ["CompanyId"]);
                CompanyService::CalculateCompanyArchive($AuditPass ["CompanyId"]);
                ArchiveService::CalculateCompanyArchiveCommentNumber($AuditPass ['CompanyId']);
                //通过消息
                NoticeByCommentService::ArchiveCommentToAuditPersonPass($CommentId, $PassportId);
                //个人发送信息
                NoticeByCommentService::ArchiveCommentToAuditPersonal($CommentId, $PassportId, $IsSendSms);
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }


    public static function CurrentCompanyCommentCalculate($companyId)
    {

    }

}