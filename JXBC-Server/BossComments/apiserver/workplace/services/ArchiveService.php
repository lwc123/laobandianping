<?php

namespace app\workplace\services;

use app\workplace\models\ArchiveComment;
use app\workplace\models\AuditStatus;
use app\workplace\models\Department;
use app\workplace\models\EmployeArchive;
use app\workplace\models\WorkItem;
use think\Cache;
use think\Db;
use think\Request;
use think\Config;
use app\common\models\Result;
use app\common\models\ErrorCode;
use app\common\modules\ResourceHelper;
use app\workplace\models\Company;
use app\workplace\models\EventCode;
use app\workplace\models\NoticeContacts;
use app\workplace\models\CompanyMember;
use app\workplace\models\NoticeArgs;

class ArchiveService
{
    /**
     * 查找填写身份证号在此公司是否存在
     *
     * @access public
     * @param array $fundidcard
     * @return boolean
     */
    public static function Fundidcard($fundidcard)
    {
        if (empty ($fundidcard) || empty ($fundidcard ["CompanyId"]) || empty ($fundidcard ["IDCard"])) {
            exception('非法请求-0', 412);
        }
        $idcard = EmployeArchive::where([
            'CompanyId' => $fundidcard ["CompanyId"],
            'IDCard' => $fundidcard ["IDCard"]
        ])->find();
        if ($idcard) {
            return Result::error(ErrorCode::EmployeArchive_IDCard, '此身份证号已在公司创建档案，不能重复创建');
        } else {
            return Result::success();
        }
    }

    /**
     * 添加员工档案
     *
     * @access public
     * @param string $Archive
     *            数据JSON
     * @return integer
     */
    public static function ArchiveCreate($Archive)
    {
        if (empty ($Archive) || empty ($Archive ["CompanyId"]) || empty ($Archive ["IDCard"])) {
            exception('非法请求-0', 412);
        }

        $idcard = EmployeArchive::where([
            'CompanyId' => $Archive ["CompanyId"],
            'IDCard' => $Archive ["IDCard"]
        ])->find();
        if ($idcard) {
            return Result::error(ErrorCode::EmployeArchive_IDCard, '此身份证号已在公司创建档案，不能重复创建');
        }

        // 提取性别和出生日期
        $Archive ['Gender'] = get_xingbie($Archive ['IDCard']);
        $Archive ['Birthday'] = getIDCardInfo($Archive ['IDCard'])['birthday'];

        // $Archive中提取档案表信息
        $addarchive = $Archive;
        unset ($addarchive ['WorkItems']);
        unset ($addarchive ['Picture']);
        unset ($addarchive ['DepartureReportNum']);
        unset ($addarchive ['StageEvaluationNum']);
        unset ($addarchive ['CompanyName']);
        if (isset($addarchive ['IsSendSms'])) {
            unset ($addarchive ['IsSendSms']);
        }

        // 添加档案信息
        $SaveEmployeArchive = EmployeArchive::create($addarchive);
        // 返回档案ID
        $ArchiveId = $SaveEmployeArchive ['ArchiveId'];
        if (isset ($Archive ['Picture'])) {
            $Picture = ResourceHelper::SaveEmployeArchiveImage($ArchiveId, $Archive ['Picture']);
            EmployeArchive::where('ArchiveId', $ArchiveId)->update([
                'Picture' => $Picture
            ]);
        }
        // 返回档案是否离职
        $IsDimission = $SaveEmployeArchive ['IsDimission'];
        foreach ($Archive ['WorkItems'] as $key => $val) {
            $department = Department::where('DeptName', $val ['Department'])->where('CompanyId', $Archive ['CompanyId'])->find();
            if ($department) {
                $DeptId = $department ['DeptId'];
            } else {
                // 新增部门
                $adddepartment = Department::create([
                    'DeptName' => $val ['Department'],
                    'CompanyId' => $Archive ['CompanyId'],
                    'PresenterId' => $Archive ['PresenterId']
                ]);
                $department_key = DepartmentService::CacheName . '-' . $Archive ['CompanyId'];
                Cache::rm($department_key);
                $DeptId = $adddepartment ['DeptId'];
            }
            // 新增职务
            $WorkItemAdd = WorkItem::create([
                'ArchiveId' => $ArchiveId,
                'PostTitle' => $val ['PostTitle'],
                'Salary' => $val ['Salary'],
                'PostStartTime' => $val ['PostStartTime'],
                'PostEndTime' => $val ['PostEndTime'],
                'DeptId' => $DeptId
            ]);

            // 档案是在职，此公司部门人数+1，
            if ($IsDimission == 0) {
                Department::where('DeptId', $DeptId)->where('CompanyId', $Archive ['CompanyId'])->setInc('StaffNumber', 1);
                CompanyService::Statistics($Archive ['CompanyId'], CompanyService::EmployedNum, CompanyService::increase);
            } else {
                CompanyService::Statistics($Archive ['CompanyId'], CompanyService::DimissionNum, CompanyService::increase);
            }
        }

        // 更新档案当前所属部门，规则：结束时间/开始时间/ID desc,先查找最新职务所属部门
        $lateworkitem = WorkItem::where('ArchiveId', $ArchiveId)->order('PostEndTime desc,PostStartTime desc,ItemId desc')->find();

        EmployeArchive::where('ArchiveId', $ArchiveId)->update([
            'DeptId' => $lateworkitem ['DeptId']
        ]);
        $Summary = ArchiveService::Summary($SaveEmployeArchive);

        // 创建档案给员工发短信
        // 员工信息  收信人
        /*$ToContactsList = new NoticeContacts ();
        $ToContactsList->CompanyId = $SaveEmployeArchive ['CompanyId'];
        $ToContactsList->PassportId = 0;
        $ToContactsList->MobilePhone = $SaveEmployeArchive ['MobilePhone'];
        $ToContactsList->DisplayName = $SaveEmployeArchive ['RealName'];*/

        $ToContactsList = [];
        $item = new NoticeContacts ();
        $item->CompanyId = $SaveEmployeArchive ['CompanyId'];
        $item->PassportId = 0;
        $item->MobilePhone = $SaveEmployeArchive ['MobilePhone'];
        $item->DisplayName = $SaveEmployeArchive ['RealName'];
        array_push($ToContactsList, $item);

        // 发信人
        $FromContactpassport = CompanyMember::where([
            'CompanyId' => $SaveEmployeArchive ['CompanyId']
        ])->where('PassportId', $SaveEmployeArchive ['PresenterId'])->find();


        // 发送实体
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts = $FromContactpassport;
        $noticeArgs->BizType = 0;
        $noticeArgs->BizId = $ArchiveId;
        $noticeArgs->EventModel = array(
            'CompanyName' => Company::where('CompanyId', $SaveEmployeArchive ['CompanyId'])->value('CompanyName'),
            'RealName' => $SaveEmployeArchive['RealName']
        );
        $EventCode = EventCode::EmployeeFiles;
        if (isset($Archive ["IsSendSms"])) {
            $IsSendSms = $Archive ["IsSendSms"];
        } else {
            $IsSendSms = true;
        }
        NoticeService::sendNotice($EventCode, $noticeArgs, $IsSendSms);
        $creditQuery = array("IDCard" => $SaveEmployeArchive ["IDCard"], "RealName" => $SaveEmployeArchive ['RealName'], "MobilePhone" => $SaveEmployeArchive ['MobilePhone']);
        ThirdPersonalCreditService::querySinowayCredit($creditQuery);
        return Result::success($ArchiveId, $Summary);
    }

    /**
     * 修改员工档案
     *
     * @access public
     * @param string $Archive
     *            数据JSON
     * @return boolean
     */
    public static function ArchiveUpdate($Archive)
    {
        if (empty ($Archive) || empty ($Archive ["CompanyId"]) || empty ($Archive ["ArchiveId"])) {
            exception('非法请求-0', 412);
        }
        if (isset ($Archive ['Picture'])) {
            if (strstr($Archive ['Picture'], 'employe-archive') == true) {
                $Archive ['Picture'] = str_replace(Config('resources_site_root'), '', $Archive ['Picture']);
            } else {
                $Archive ['Picture'] = ResourceHelper::SaveEmployeArchiveImage($Archive ["ArchiveId"], $Archive ['Picture']);
            }
        }
        // $Archive中只提取档案表信息
        $updatearchive = $Archive;
        unset ($updatearchive ['WorkItems']);

        // 去掉不能修改的属性
        unset ($updatearchive ['DeptId']);
        unset ($updatearchive ['CommentsNum']);
        unset ($updatearchive ['PresenterId']);
        unset ($updatearchive ['EducationText']);
        if (isset($updatearchive ['IsSendSms'])) {
            unset ($updatearchive ['IsSendSms']);
        }

        foreach ($Archive ['WorkItems'] as $key => $val) {
            $department = Department::where('DeptName', $val ['Department'])->where('CompanyId', $Archive ['CompanyId'])->find();
            //查找档案职位情况
            if ($department) {
                $DeptId = $department ['DeptId'];
            } else {
                // 新增部门
                $adddepartment = Department::create([
                    'DeptName' => $val ['Department'],
                    'CompanyId' => $Archive ['CompanyId'],
                    'PresenterId' => $Archive ['PresenterId']
                ]);
                $department_key = DepartmentService::CacheName . '-' . $Archive ['CompanyId'];
                Cache::rm($department_key);
                $DeptId = $adddepartment ['DeptId'];
            }

            $WorkItem = WorkItem::where('ItemId', $val ['ItemId'])->find();

            // 职务存在，修改
            if ($WorkItem) {
                WorkItem::update([
                    'ItemId' => $val ['ItemId'],
                    'PostTitle' => $val ['PostTitle'],
                    'Salary' => $val ['Salary'],
                    'PostStartTime' => $val ['PostStartTime'],
                    'PostEndTime' => $val ['PostEndTime'],
                    'DeptId' => $DeptId
                ]);
            } else {
                // 新增职务
                $WorkItemAdd = WorkItem::create([
                    'ArchiveId' => $Archive ['ArchiveId'],
                    'PostTitle' => $val ['PostTitle'],
                    'Salary' => $val ['Salary'],
                    'PostEndTime' => $val ['PostEndTime'],
                    'PostStartTime' => $val ['PostStartTime'],
                    'DeptId' => $DeptId
                ]);
            }
        }


        // 修改档案信息
        $UpdateEmployeArchive = EmployeArchive::update($updatearchive);
        if ($UpdateEmployeArchive) {
            // 更新档案当前所属部门，规则：结束时间/开始时间/ID desc,先查找最新职务所属部门
            $lateworkitem = WorkItem::where('ArchiveId', $Archive ['ArchiveId'])->order('PostEndTime desc,PostStartTime desc,ItemId desc')->find();
            // var_dump($lateworkitem);die;
            EmployeArchive::where('ArchiveId', $Archive ['ArchiveId'])->update([
                'DeptId' => $lateworkitem ['DeptId']
            ]);

            $Summary = ArchiveService::Summary($Archive);
            DepartmentService::CalculateDepartmentStaffNumber($Archive ["CompanyId"]);
            CompanyService::CalculateCompanyArchive($Archive ["CompanyId"]);
            $creditQuery = array("IDCard" => $UpdateEmployeArchive ["IDCard"], "RealName" => $UpdateEmployeArchive ['RealName'], "MobilePhone" => $UpdateEmployeArchive ['MobilePhone']);
            ThirdPersonalCreditService::querySinowayCredit($creditQuery);
            return Result::success($Archive ['ArchiveId'], $Summary);
        } else {
            return Result::error(ErrorCode::EmployeArchive_Update, '档案修改失败');
        }
    }

    public static function ArchiveSearch($Archive)
    {
        if (empty ($Archive)) {
            exception('非法请求-0', 412);
        }
        if ($Archive ['RealName'] == '(null)') {
            $Archive ['RealName'] = '';
        } // IOS处理

        $ArchiveList = EmployeArchive::with('WorkItem')->where(function ($query) use ($Archive) {
            $query->where('CompanyId', $Archive ['CompanyId'])->where(function ($query) use ($Archive) {
                $query->whereor('RealName', 'like', $Archive ['RealName'] . '%');
            })->order('CreatedTime desc')->page($Archive ['Page'], $Archive ['Size']);
        })->group('employe_archive.ArchiveId')->having('employe_archive.DeptId=WorkItem.DeptId')->select();


        // 取出部门列表
        $Departments = DepartmentService::getDepartmentListByCompanyId($Archive ['CompanyId']);

        if ($ArchiveList) {
            foreach ($ArchiveList as $key => $value) {
                foreach ($Departments as $value) {
                    if ($ArchiveList [$key] ['DeptId'] == $value['DeptId']) {
                        $ArchiveList [$key] ['WorkItem'] ['Department'] = $value['DeptName'];
                    }
                }
            }
        }
        return $ArchiveList;
    }

    public static function Detail($Archive)
    {
        if (empty ($Archive) || empty ($Archive ["CompanyId"]) || empty ($Archive ["ArchiveId"])) {
            exception('非法请求-0', 412);
        }
        $Archive = EmployeArchive::where(['ArchiveId' => $Archive ["ArchiveId"], 'CompanyId' => $Archive ["CompanyId"]])->find();
        if (empty($Archive)) {
            exception('非法请求-0', 401);
        }

        $WorkItems = WorkItem::where('ArchiveId', $Archive ["ArchiveId"])->select();

        if ($WorkItems) {
            foreach ($WorkItems as $key => $value) {
                $WorkItems [$key] ['Department'] = Department::where('DeptId', $value ['DeptId'])->value('DeptName');
            }
            $Archive ['WorkItems'] = $WorkItems;
        }
        return $Archive;
    }

    public static function Summary($Archive)
    {
        if (empty ($Archive) || empty ($Archive ["CompanyId"]) || empty ($Archive ["ArchiveId"])) {
            exception('非法请求-0', 412);
        }
        $Archive = EmployeArchive::where(['ArchiveId' => $Archive ["ArchiveId"], 'CompanyId' => $Archive ["CompanyId"]])->find();
        if (empty($Archive)) {
            exception('非法请求-0', 401);
        }
        $Archive ['WorkItem'] = WorkItem::get([
            'DeptId' => $Archive ['DeptId'],
            'ArchiveId' => $Archive ['ArchiveId']
        ]);
        if ($Archive ['WorkItem']) {
            $Archive ['WorkItem'] ['Department'] = Department::where('DeptId', $Archive ['DeptId'])->value('DeptName');
        }
        return $Archive;
    }

    /**档案评价字数统计
     * @param $ArchiveId
     */
    public static function CalculateArchiveCommentNumber($ArchiveId)
    {
        if ($ArchiveId) {
            Db::startTrans();
            try {
                $comments = ArchiveComment::where(['ArchiveId' => $ArchiveId, 'AuditStatus' => AuditStatus::AuditPassed])->COUNT();
                $papms = [];
                $papms['ArchiveId'] = $ArchiveId;
                $papms['CommentsNum'] = $comments;
                EmployeArchive::update($papms);
                // 提交事务
                Db::commit();
            } catch (\Exception $e) {
                // 回滚事务
                Db::rollback();
                exception($e->getMessage(), $e->getCode());
            }
        }
    }

    public static function CalculateCompanyArchiveCommentNumber($CompanyId)
    {
        if ($CompanyId) {
            Db::startTrans();
            try {
                $EmployeArchive = new EmployeArchive();
                $comments = ArchiveComment::field('ArchiveId,COUNT(CommentId) as CommentsNum')->where('CompanyId', $CompanyId)->where('AuditStatus', AuditStatus::AuditPassed)->group('ArchiveId')->select();
                $archives=EmployeArchive::field('ArchiveId')->where('CompanyId', $CompanyId)->select();
                foreach ($archives as $key =>$val) {
                    $ArchiveComments[$key]['ArchiveId'] = $val['ArchiveId'];
                    $ArchiveComments[$key]['CommentsNum'] =0;
                    foreach ($comments as $k => $v) {
                        if ($v['ArchiveId'] == $val['ArchiveId']) {
                            $ArchiveComments[$key]['CommentsNum'] = $v['CommentsNum'];
                        }
                    }
                }
                $EmployeArchive->saveAll($ArchiveComments);
                // 提交事务
                Db::commit();
            } catch (\Exception $e) {
                // 回滚事务
                Db::rollback();
                exception($e->getMessage(), $e->getCode());
            }
        }
    }
}
