<?php
namespace app\www\controller;

use app\workplace\models\AuditStatus;
use app\workplace\models\CommentType;
use app\workplace\models\CompanyMember;
use app\workplace\services\DepartmentService;
use app\workplace\services\NoticeByCommentService;
use think\Config;
use think\Request;
use think\Controller;
use app\common\modules\DbHelper;
use app\workplace\models\ArchiveComment;
use app\workplace\models\EmployeArchive;
use app\workplace\models\WorkItem;
use app\workplace\models\MemberRole;
use app\workplace\models\Department;
use app\workplace\services\ArchiveService;
use app\workplace\services\MessageService;
use app\www\services\PaginationServices;
use app\common\modules\DictionaryPool;
use app\workplace\services\CommentService;

class ArchiveCommentController extends CompanyBaseController
{
    /**
     * 阶段评价,离职报告列表(搜索:离职，在职，部门, 姓名).
     * @param Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        $search_param = $request->param();
        if (empty($search_param)) {
            $this->error(401, '没有指定资源的操作权限');
        }
        $Departments = DepartmentService::getDepartmentListByCompanyId($search_param['CompanyId']);
        //搜索条件
        $where = [];
        //公司id，必须
        $seachvalue = 'CompanyId=' . $search_param['CompanyId'];
        $where['archive_comment.CompanyId'] = $search_param['CompanyId'];
        //部门
        if (isset($search_param['DeptId']) && $search_param['DeptId'] != 0) {
            $where['DeptId'] = $search_param['DeptId'];
            $seachvalue .= '&DeptId=' . $search_param['DeptId'];
        }
        //员工姓名
        if (isset($search_param['RealName']) && !empty($search_param['RealName'])) {
            $like = $search_param['RealName'];
            $seachvalue .= '&RealName=' . $search_param['RealName'];
            $where['RealName'] = ['like', '%' . $like . '%'];
        }
        //类型  阶段评价或者离职报告  必须
        $where['AuditStatus'] = AuditStatus::AuditPassed;
        $where['CommentType'] = $search_param ['CommentType'];
        $seachvalue .= '&CommentType=' . $search_param['CommentType'];

        $pagination = DbHelper::BuildPagination($request->get("Page"), 40);
        $pagination->PageSize = 5;

        // 取出评价列表
        $search_list = ArchiveComment::with('EmployeArchive')->where($where)->order('CommentType desc , StageYear desc, StageSection desc, archive_comment.CreatedTime desc')->page($pagination->PageIndex, $pagination->PageSize)->select();
        //评价區間字典
        $biz_periods = DictionaryPool::getDictionaries('period', null)['period'];
        //当前职务信息
        if ($search_list) {
            foreach ($search_list as $keys => $value) {
                $ArchiveId[] = $value['ArchiveId'];
            }
            //档案IDS
            $ArchiveIds = implode(',', $ArchiveId);
            $work_items = WorkItem::field('ArchiveId,PostTitle')->where('ArchiveId', 'in', $ArchiveIds)->select();
            foreach ($search_list as $key => $val) {
                $search_list[$key]['StageSection'] = $val['StageSection'];
                foreach ($biz_periods as $k => $value) {
                    if ($val['StageSection'] == $value['Code']) {
                        $search_list[$key]['StageSection'] = $value['Name'];
                    }
                }
                foreach ($work_items as $value) {
                    if ($val['ArchiveId'] == $value['ArchiveId']) {
                        $search_list[$key]['PostTitle'] = $value['PostTitle'];
                    }
                }
            }
        }
        $pagination->TotalCount = ArchiveComment::with('EmployeArchive')->where($where)->count();
        $page = PaginationServices::getPagination($pagination, $seachvalue, $request->action());
        $this->view->assign('list', $search_list);
        $this->view->assign('Departments', $Departments);
        $this->view->assign('page', $page);
        return $this->fetch();
    }

    /**阶段评价详情
     * @param Request $request
     * @return mixed
     */
    public function comment(Request $request)
    {
        $oid = $request->param('oid');
        $CompanyId = $request->param('CompanyId');
        if (empty ($oid) && empty ($CompanyId)) {
            return '非法请求';
        }
        $comment = ArchiveComment::where([
            'CommentId' => $oid,
            'CompanyId' => $CompanyId
        ])->find();
        if (empty ($comment)) {
            return '暂无数据';
        }

        // 档案详情
        $ArchiveId = $comment ['ArchiveId'];
        $archivedetail = EmployeArchive::get($comment ['ArchiveId']);
        if (empty ($archivedetail)) {
            return '暂无数据';
        }
        // 把int类型改为string
        if ($archivedetail['IsDimission'] == 0) {
            $archivedetail['IsDimission'] = '入职';
        }

        //字典转换
        $comment['StageSection'] = DictionaryPool::getEntryNames('period', $comment['StageSection']);
        $comment['WantRecall'] = DictionaryPool::getEntryNames('panicked', $comment['WantRecall']);
        $comment['DimissionReason'] = DictionaryPool::getEntryNames('leaving', $comment['DimissionReason']);
        //  echo json_encode($comment);die;

        //入职时间和离职时间，格式处理开始
        $EntryTime = date('Y年m月d日', strtotime($archivedetail['EntryTime']));
        $this->view->assign('EntryTime', $EntryTime);
        $DimissionTime = date('Y年m月d日', strtotime($archivedetail['DimissionTime']));
        $this->view->assign('DimissionTime', $DimissionTime);

        //入职时间和离职时间，格式处理结束
        $archivePostTitle = WorkItem::where([
            'DeptId' => $archivedetail ['DeptId'],
            'ArchiveId' => $ArchiveId
        ])->value('PostTitle');
        $archiveDepartment = Department::where([
            'DeptId' => $archivedetail ['DeptId'],
            'CompanyId' => $archivedetail ['CompanyId']
        ])->value('DeptName');

        // 评价详情
        $comment ['WorkAbilityText'] = achievement($comment ['WorkAbility']);
        $comment ['WorkAttitudeText'] = achievement($comment ['WorkAttitude']);
        $comment ['WorkPerformanceText'] = achievement($comment ['WorkPerformance']);

        $comment ['HandoverTimelyText'] = achievement($comment ['HandoverTimely']);
        $comment ['HandoverOverallText'] = achievement($comment ['HandoverOverall']);
        $comment ['HandoverSupportText'] = achievement($comment ['HandoverSupport']);

        // 拆分评价图片字符串为数组

        if ($comment ['WorkCommentImages']) {
            $comment ['WorkCommentImages'] = explode(",", str_replace(array(
                "[",
                "]"
            ), "", $comment ['WorkCommentImages']));
            foreach ($comment ['WorkCommentImages'] as $val) {
                $WorkCommentImages [] = Config('resources_site_root') . $val;
            }
            $comment ['WorkCommentImages'] = $WorkCommentImages;
        } else {
            $comment ['WorkCommentImages'] = '';
        }
        if ($comment ['WorkCommentVoice']) {
            $comment ['WorkCommentVoice'] = str_replace(Config('resources_site_root'), "", $comment ['WorkCommentVoice']);
        } else {
            $comment ['WorkCommentVoice'] = '';
        }
        // 拆分审核人字符串为数组
        $Persons = explode(",", $comment ['AuditPersons']);
        // return json($comment);
        //前台显示吸底判断

        if (in_array($this->PassportId, $Persons)) {
            $this->view->assign('bottomdisplay', 1);
        } else {
            $this->view->assign('bottomdisplay', 0);
        }
        foreach ($Persons as $value) {
            $Person [] = CompanyMember::where([
                'CompanyId' => $comment ['CompanyId'],
                'PassportId' => $value
            ])->value('RealName');
        }
        $comment ['AuditPersons'] = implode(' , ', $Person);
        $comment ['Presenter'] = $comment ['PresenterId'];
        $comment ['PresenterId'] = CompanyMember::where([
            'CompanyId' => $comment ['CompanyId'],
            'PassportId' => $comment ['PresenterId']
        ])->value('RealName');
        $comment ['OperatePassportId'] = CompanyMember::where([
            'CompanyId' => $comment ['CompanyId'],
            'PassportId' => $comment ['OperatePassportId']
        ])->value('RealName');
        //判断是否是消息传过来的
        if(!empty($request->param('MessageId'))){
            $comment ['IsMessage'] = MessageService::readMsg($request->param('MessageId'),$this->PassportId);
        }
        $this->view->assign('model', $comment);
        $this->view->assign('ArchivePostTitle', $archivePostTitle);
        $this->view->assign('ArchiveDepartment', $archiveDepartment);
        $this->view->assign('archivedetail', $archivedetail);
        if ($request->param('CommentType') == 1) {
            return $this->fetch('report');
        } else {
            return $this->fetch('comment');
        }
    }

    /**阶段评价  离任报告 添加
     * @param Request $request
     * @return mixed
     */
    public function commentcreate(Request $request)
    {
        $search_param = $request->param();
        if (empty($search_param)) {
            $this->error(401, '没有指定资源的操作权限');
        }


        $Departments = DepartmentService::getDepartmentListByCompanyId($search_param['CompanyId']);

        //评价审核人
        $AuditPerson = CompanyMember::where('CompanyId', $search_param['CompanyId'])->where("Role", MemberRole::Executives)->field('RealName,Role,PassportId')->select();

        //时间段列表
        $StageSection = DictionaryPool::getDictionaries('period');
        $this->view->assign('StageSection', $StageSection['period']);

        $this->assign('AuditPerson', $AuditPerson);
        $this->assign('Departments', $Departments);
        $leaving = DictionaryPool::getDictionaries('leaving');
        $panicked = DictionaryPool::getDictionaries('panicked');
        if ($search_param['CommentType'] == 1) {
            $this->view->assign('leaving', $leaving['leaving']);
            $this->view->assign('panicked', $panicked['panicked']);
            return $this->fetch('reportcreate');
        } else {
            return $this->fetch('commentcreate');
        }
    }

    /**阶段评价添加方法
     * @param Request $request
     * @return mixed
     */
    public function add(Request $request)
    {
        $request = $request->post();
        for ($i = 1; $i <= $request['ImageIndex']; $i++) {
            if (!empty($_FILES["ImagesP" . $i]['tmp_name'])) {
                $request['WorkCommentImages'][] = base64EncodeImage($_FILES["ImagesP" . $i]);
            }
        }
        if ($request) {
            // 添加评价
            $request ['PresenterId'] = $this->PassportId;
            if (empty($request ['AuditPersons'])) {
                $request['AuditPersons'] = [];
                array_push($request['AuditPersons'], $request ['BossPassportId']);
            } else {
                $AarrayPersons = $request ['AuditPersons'] . "," . $request ['BossPassportId'];
                $request['AuditPersons'] = explode(",", $AarrayPersons);
            }
            //是否发送短信处理
            if(isset($request['IsSendSms'])){
                if($request['IsSendSms']==='true'){
                    $request['IsSendSms']=true;
                }
                if($request['IsSendSms']==='false'){
                    $request['IsSendSms']=false;
                }
            }else{
                $request['IsSendSms']=true;
            }

            $CommentId = CommentService::CommentCreate($request);
            if ($CommentId) {
                return true;
            } else {
                return false;
            }

        }
    }

    /**阶段评价修改界面
     * @param Request $request
     * @return mixed
     */
    public function commentupdate(Request $request)
    {
        $CommentId = $request->param('CommentId');
        if (empty($CommentId)) {

        }

        // TODO:附加档案信息
        $Detail = ArchiveComment::get($CommentId, 'EmployeArchive');
        $Detail['WorkComment'] = str_replace("<br />", '', $Detail['WorkComment']);
        // $Detail['WorkComment'] = str_replace("<br />", "\n",  $Detail['WorkComment']);
        // return json($Detail['WorkComment'] );
        //处理字典信息
//        $Detail['DimissionReasonText'] = DictionaryPool::getEntryNames('leaving', $Detail['DimissionReason']);
//        $Detail['WantRecallText'] = DictionaryPool::getEntryNames('panicked', $Detail['WantRecall']);
//        $Detail['StageSectionText'] = DictionaryPool::getEntryNames('period', $Detail['StageSection']);
        //处理评分
        $proportion = 5.39;
        $Detail ['WorkAbilityText'] = achievementPc($Detail ['WorkAbility']);
        $Detail ['WorkAttitudeText'] = achievementPc($Detail ['WorkAttitude']);
        $Detail ['WorkPerformanceText'] = achievementPc($Detail ['WorkPerformance']);
        $Detail ['WorkAbilityWidth'] = $Detail ['WorkAbility'] * $proportion;
        $Detail ['WorkAttitudeWidth'] = $Detail ['WorkAttitude'] * $proportion;
        $Detail ['WorkPerformanceWidth'] = $Detail ['WorkPerformance'] * $proportion;

        $Detail ['HandoverTimelyText'] = achievementPc($Detail ['HandoverTimely']);
        $Detail ['HandoverOverallText'] = achievementPc($Detail ['HandoverOverall']);
        $Detail ['HandoverSupportText'] = achievementPc($Detail ['HandoverSupport']);
        $Detail ['HandoverTimelyWidth'] = $Detail ['HandoverTimely'] * $proportion;
        $Detail ['HandoverOverallWidth'] = $Detail ['HandoverOverall'] * $proportion;
        $Detail ['WHandoverSupportWidth'] = $Detail ['HandoverSupport'] * $proportion;

        if ($Detail ['WorkCommentImages']) {
            $WorkCommentImages = explode(",", str_replace(array("[", "]"), "", $Detail ['WorkCommentImages']));
            foreach ($WorkCommentImages as $keys => $value) {
                $CommentImages [] = Config('resources_site_root') . $value;
            }
            $Detail ['WorkCommentImages'] = $CommentImages;
        } else {
            $Detail ['WorkCommentImages'] = [];
        }
        if ($Detail ['WorkCommentVoice']) {
            $Detail ['WorkCommentVoice'] = Config('resources_site_root') . $Detail ['WorkCommentVoice'];
        }
        $CompanyId = EmployeArchive::where('ArchiveId', $Detail ['ArchiveId'])->value("CompanyId");
        $Detail ['AuditPersons'] = explode(",", $Detail ['AuditPersons']);
        $Detail ['OperateRealName'] = CompanyMember::where(['PassportId' => $Detail['OperatePassportId'], 'CompanyId' => $CompanyId])->value('RealName');
        $WorkItem = WorkItem::get([
            'DeptId' => $Detail ['EmployeArchive'] ['DeptId'],
            'ArchiveId' => $Detail ['EmployeArchive'] ['ArchiveId']
        ]);
        if ($WorkItem) {
            $WorkItem ['Department'] = Department::where('DeptId', $WorkItem ['DeptId'])->value('DeptName');
            $Detail ['EmployeArchive'] ['WorkItem'] = $WorkItem;
        }
        foreach ($Detail ['AuditPersons'] as $keys => $value) {
            $CompanyMember = CompanyMember::where('PassportId', $value)->where('CompanyId', $CompanyId)->find();
            if ($CompanyMember) {
                $CompanyMember['UnreadMessageNum'] = 0;
                $Member [] = $CompanyMember;
            } else {
                $Member = [];
            }
        }
        //审核人 删除老板Id
        $CompanyBossId = CompanyMember::where('Role', MemberRole::Boss)->where('CompanyId', $CompanyId)->value('PassportId');
        $AuditPersonString = $Detail ['AuditPersons'];
        foreach ($AuditPersonString as $key => $val) {
            if ($val == $CompanyBossId) {
                unset($AuditPersonString[$key]);
            }
        }
        $Detail ['AuditPersonString'] = implode(',', $AuditPersonString);

        if ($Detail['EmployeArchive']['IsDimission'] == 0) {
            $Detail['EmployeArchive']['IsDimission'] = "在职";
        }
        //图片处理
        $str = '';
        if ($Detail['WorkCommentImages']) {
            foreach ($Detail['WorkCommentImages'] as $key => $val) {
                $i = $key + 1;
                $str .= ' <div><div class="iden-rec iden2-rec" id="previewImagesP' . $i . '" style="width: 140px;height: 80px;display: block">';
                $str .= '<img src="' . $val . '" alt="" style="width:100%;height:100%; position: relative" /><div class="pics_close">×</div><input type="hidden" name="Images' . $i . '" value="' . $val . '"/></div>';
                $str .= '<input class="em-btn" type="file"  name="ImagesP' . $i . '" accept="image/jpeg,image/x-png,image/png"/></div>';


            }
            $count = count($Detail['WorkCommentImages']);
            $num = $count + 1;
            $str .= '<div><div class="iden-rec iden2-rec" id="previewImagesP' . $num . '"></div><input class="em-btn" type="file" name="ImagesP' . $num . '" accept="image/jpeg,image/x-png,image/png"></div>';
            if ($count < 9) {
                $str .= '<div class="iden-rec iden2-rec" id="previewImagesBtn"><i class="iconfont pic pic2">&#xe651;</i></div>';
            } else {
                $str .= '<div class="iden-rec iden2-rec" id="previewImagesBtn" style="display:none"><i class="iconfont pic pic2">&#xe651;</i></div>';
            }
            $str .= '<input type="hidden" value="' . $num . '" name="ImageIndex" id="ImageIndex">';
        } else {
            $str .= '<div id="iden-pics"><div><div class="iden-rec iden2-rec" id="previewImagesP1"></div><input class="em-btn" type="file"  name="ImagesP1" accept="image/jpeg,image/x-png,image/png"/></div>
                  <div class="iden-rec iden2-rec" id="previewImagesBtn"><i class="iconfont pic pic2">&#xe651;</i></div><input type="hidden" value="1" name="ImageIndex" id="ImageIndex"></div>';
        }

        $this->view->assign('photo', $str);
        //评价审核
        $AuditPerson = CompanyMember::where('CompanyId', $Detail['CompanyId'])->where("Role", MemberRole::Executives)->field('RealName,Role,PassportId')->select();
        unset ($Detail ['AuditPersons']);
        $Detail ['AuditPersonList'] = $Member;
        $this->view->assign('Detail', $Detail);
        //学历字典列表
        $StageSection = DictionaryPool::getDictionaries('period', null);
        $this->view->assign('StageSection', $StageSection['period']);
        $this->view->assign('AuditPerson', $AuditPerson);

        //判断是离职报告还是阶段评价
        $leaving = DictionaryPool::getDictionaries('leaving', null);
        $panicked = DictionaryPool::getDictionaries('panicked', null);
        //print_r($leaving['leaving']);die;
        if ($request->param('CommentType') == 1) {
            $this->view->assign('leaving', $leaving['leaving']);
            $this->view->assign('panicked', $panicked['panicked']);
            return $this->fetch('reportupdate');
        } else {
            return $this->fetch('commentupdate');
        }
    }


    /**阶段评价  离任报告  修改方法
     * @param Request $request
     * @return mixed
     */
    public function update(Request $request)
    {
        $request = $request->param();
        // 修改评价，获取修改用户ID
        $request ['PresenterId'] = $this->PassportId;

        if (empty($request ['AuditPersons'])) {
            $request['AuditPersons'] = [];
            array_push($request['AuditPersons'], $request ['BossPassportId']);
        } else {
            $AarrayPersons = $request ['AuditPersons'] . "," . $request ['BossPassportId'];
            $request['AuditPersons'] = explode(",", $AarrayPersons);
        }
        unset($request ['BossPassportId']);

        for ($i = 1; $i <= $request['ImageIndex']; $i++) {
            if (!empty($_FILES["ImagesP" . $i]['tmp_name'])) {
                $request['WorkCommentImages'][] = base64EncodeImage($_FILES["ImagesP" . $i]);
            } else {
                if (!empty($request['Images' . $i])) {
                    $request['WorkCommentImages'][] = $request['Images' . $i];
                }
                unset($request['Images' . $i]);
            }
        }
        unset($request['ImageIndex']);
        // return json($request['WorkCommentImages']);
        $update = CommentService::CommentUpdate($request);
        if ($update) {
            return true;
        } else {
            return false;
        }
    }

    /**审核通过
     * @param Request $request
     * @return bool
     */
    public function AuditPass(Request $request)
    {
        $CommentId = $request->param('CommentId');
        $IsSendSms = $request->param('IsSendSms');
        if ($CommentId) {
            //是否发送短信处理
            if(isset($IsSendSms)){
                if($IsSendSms==='true'){
                    $IsSendSms=true;
                }
                if($IsSendSms==='false'){
                    $IsSendSms=false;
                }
            }else{
                $IsSendSms=true;
            }
            CommentService::AuditPass($request->param('CommentId'), $this->PassportId,$IsSendSms);
            $post = "/ArchiveComment/comment?MessageId=1&CompanyId=" . $request->param('CompanyId') . '&oid=' . $CommentId . '&CommentType=' . $request->param ['CommentType'];
            header("location:$post");
        }

    }

    /**审核拒绝
     * @param Request $request
     */
    public function AuditReject(Request $request)
    {
        $CommentId = $request->param('CommentId');
        $RejectReason = $request->param('RejectReason');

        if ($CommentId && $RejectReason) {
            $AuditReject = ArchiveComment::get($CommentId);
            if ($AuditReject ['AuditStatus'] == 1) {
                ArchiveComment::update([
                    'CommentId' => $CommentId,
                    'AuditStatus' => 9,
                    'OperatePassportId' => $this->PassportId,
                    'RejectReason' => $RejectReason
                ]);
                // 发送拒绝信息
                NoticeByCommentService::ArchiveCommentToAuditPersonReject($CommentId, $this->PassportId);

            }
            $post = "/ArchiveComment/comment?MessageId=1&CompanyId=" . $AuditReject ['CompanyId'] . '&oid=' . $CommentId . '&CommentType=' . $AuditReject ['CommentType'];
            header("location:$post");
        }
    }

    /**
     * 档案列表
     */
    public function searchArchive(Request $request)
    {
        $Comment = $request->param();
        //搜索查询
        $queryBuilder = function () use ($Comment) {
            $query = null;
            $query = EmployeArchive::with('WorkItem');
            if (!empty($Comment['RealName'])) {
                $query->where('RealName', 'like', $Comment ['RealName'] . '%');
            }
            if (!empty($Comment['DeptId'])) {
                $query->where('DeptId', $Comment ['DeptId']);
            }
            if (!empty($Comment['IsDimission']) || strlen($Comment['IsDimission']) !=0) {
                $query->where('IsDimission', $Comment ['IsDimission']);
            }
            $query->where('employe_archive.CompanyId', $Comment ['CompanyId'])->group('employe_archive.archiveId');
            return $query;
        };
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $pagination->TotalCount = count($queryBuilder()->select());
        $pagination->Pages = ceil($pagination->TotalCount / $pagination->PageSize);
        $CommentList = $queryBuilder()->order('employe_archive.CreatedTime desc')->page($pagination->PageIndex, $pagination->PageSize)->select();
        //公司部门列表
        $DepartmentList = Department::where(['CompanyId' => $Comment ['CompanyId']])->select();
        if ($CommentList) {
            foreach ($CommentList as $key => $val) {
                foreach ($DepartmentList as $value) {
                    if ($val['DeptId'] == $value['DeptId']) {
                        $CommentList [$key] ['DepartName'] = $value['DeptName'];
                    }
                }
            }
        }
        $data = array('CommentList' => $CommentList, 'pagination' => $pagination);
        return json($data);
    }

    /**
     * 选择员工档案 阶段评价
     */
    public function EmployeArchive(Request $request)
    {
        $existsStageSection = $request->param();
        if ($existsStageSection) {
            $StageYear = ArchiveComment::where([
                'CompanyId' => $existsStageSection ["CompanyId"],
                'ArchiveId' => $existsStageSection ["ArchiveId"],
                'CommentType' => CommentType::StageEvaluation
            ])->group('StageYear')->order('StageYear desc')->column('StageYear');
            $result['exists'] = CommentService::existsStageSection($existsStageSection);
            //评价區間字典
            $result['periods'] = DictionaryPool::getDictionaries('period')['period'];
            return $result;
        }
    }

    /**
     * 选择员工档案  离职报告
     */
    public function EmployeReport(Request $request)
    {
        $existsStageSection = $request->param();
        $existsReport = ArchiveComment::where([
            'CompanyId' => $existsStageSection ["CompanyId"],
            'ArchiveId' => $existsStageSection ["ArchiveId"],
            'CommentType' => CommentType::DepartureReport
        ])->find();
        if ($existsReport) {
            return true;
        } else {
            return false;
        }
    }

}