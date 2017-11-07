<?php
/**
 * Created by PhpStorm.
 * User: Soce
 * Date: 2017/1/16
 * Time: 15:23
 */
namespace app\www\controller;
//ini_set('memory_limit','1024M');

use app\common\models\ErrorCode;
use app\common\models\Result;
use app\common\modules\DbHelper;
use app\workplace\models\ArchiveComment;
use app\workplace\models\CompanyMember;
use app\workplace\models\Department;
use app\workplace\models\EmployeArchive;
use app\workplace\models\WorkItem;
use app\workplace\services\ArchiveService;
use app\common\modules\DictionaryPool;
use app\workplace\services\DepartmentService;
use app\workplace\validate\IDCard;
use app\www\services\PaginationServices;
use think\Request;
use think\Config;
use think\Log;
use app\common\modules\ResourceHelper;
use app\workplace\models\EmployeArchiveErrorLog;

class EmployeArchiveController extends CompanyBaseController
{
    /**
     * 档案列表(搜索:离职，在职，部门, 姓名).
     * User: Soce.
     * Date: 2017/1/16
     * Time: 15:23
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
        $where['CompanyId'] = $search_param['CompanyId'];
        $view['IsDimissionText'] = '在职';
        if (isset($search_param['IsDimission'])) {
            $where['IsDimission'] = $search_param['IsDimission'];
            $seachvalue .= '&IsDimission=' . $search_param['IsDimission'];
            if ($search_param['IsDimission'] == 1) {
                $view['IsDimissionText'] = '离任';
            }
        }
        if (isset($search_param['DeptId']) && $search_param['DeptId'] != 0) {
            $where['employe_archive.DeptId'] = $search_param['DeptId'];
            $seachvalue .= '&DeptId=' . $search_param['DeptId'];
        }
        if (isset($search_param['RealName']) && !empty($search_param['RealName'])) {
            $like = $search_param['RealName'];
            $seachvalue .= '&RealName=' . $search_param['RealName'];
            $where['RealName'] = ['like', '%' . $like . '%'];
        }

        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $pagination->PageSize = 5;
        // 取出档案列表
        $search_list = EmployeArchive::where($where)->order('CreatedTime desc,DeptId desc')->page($pagination->PageIndex, $pagination->PageSize)->select();
        //当前职务信息
        if ($search_list) {
            foreach ($search_list as $keys => $value) {
                $ArchiveId[] = $value['ArchiveId'];
            }
            //档案IDS
            $ArchiveIds = implode(',', $ArchiveId);
            $work_items = WorkItem::where('ArchiveId', 'in', $ArchiveIds)->select();
            foreach ($search_list as $key => $val) {
                foreach ($work_items as $value) {
                    if ($val['ArchiveId'] == $value['ArchiveId']&&$val['DeptId'] == $value['DeptId']) {
                        $search_list [$key]   ['WorkItem'] = $value;
                    }
                }
            }
        }
        $pagination->TotalCount = EmployeArchive::where($where)->count();
        $page = PaginationServices::getPagination($pagination, $seachvalue, $request->action());
        $view['url'] = $request->url();
        $this->view->assign('list', $search_list);
        $this->view->assign('Departments', $Departments);
        $this->view->assign('page', $page);
        $this->view->assign('view', $view);
        return $this->fetch();
    }

    /**档案添加页面
     * @param Request $request
     * @return mixed
     */
    public function create(Request $request)
    {
        Log::info(sprintf("EXCEL ---- size : %s", memory_get_usage()));

        $CompanyId = $request->param('CompanyId');
        //学历字典列表
        $Education = DictionaryPool::getDictionaries('academic', null);
        $this->view->assign('Education', $Education['academic']);
        //所有部门
        $Departments = $Departments = DepartmentService::getDepartmentListByCompanyId($CompanyId);
        $this->view->assign('Departments', $Departments);
        return $this->fetch();
    }

    /**excel页面
     */
    public function excel(Request $request)
    {
        return $this->fetch();
    }

    /**档案添加页面方法
     * @param Request $request
     * @return \think\response\Json
     */

    public function add(Request $request)
    {
        // 获取员工档案JSON数据
        $request = $request->post();
        $Picture = empty($_FILES["Picture"]['tmp_name']) ? '' : base64EncodeImage($_FILES["Picture"]);

        if ($request) {
            for ($x=1; $x<=$request['deptCount']; $x++) {
                $PostTitles[]=$request['PostTitle'.$x];
                unset($request['PostTitle'.$x]);
                $PostStartTimes[]=$request['PostStartTime'.$x];
                unset($request['PostStartTime'.$x]);
                $PostEndTimes[]=$request['PostEndTime'.$x];
                unset($request['PostEndTime'.$x]);
                $Salarys[]=$request['Salary'.$x];
                unset($request['Salary'.$x]);
                $Departments[]=$request['Department'.$x];
                unset($request['Department'.$x]);
                unset($request[$x]);
            }
            unset($request['deptCount']);
            foreach ($PostTitles as $keys => $value) {
                $request['WorkItems'][$keys]['PostTitle'] = $value;
            }
            foreach ($PostStartTimes as $keys => $value) {
                $request['WorkItems'][$keys]['PostStartTime'] = $value;
            }
            foreach ($PostEndTimes as $keys => $value) {
                if ($value == '至今') {
                    $value = DbHelper::getMaxDbDate();
                }
                $request['WorkItems'][$keys]['PostEndTime'] = $value;
            }
            foreach ($Salarys as $keys => $value) {
                $request['WorkItems'][$keys]['Salary'] = $value;
            }
            foreach ($Departments as $keys => $value) {
                $request['WorkItems'][$keys]['Department'] = $value;
            }
            $IDCard = $request['IDCard'];
            if (empty($Picture)) {
                unset($request['Picture']);
            } else {
                $request['Picture'] = $Picture;
            }
            if ($IDCard) {
                $checkIDCard = IDCard::validateIDCard($IDCard);
                if ($checkIDCard == false) {
                    return json(Result::error(ErrorCode::Wrongful_IDCard, '请检查身份证号填写是否正确'));
                }
            } else {
                return json(Result::error(ErrorCode::Empty_IDCard, '请填写身份证信息'));
            }
            $request ['PresenterId'] = $this->PassportId;

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
            // return json($request);
            $addarchive = ArchiveService::ArchiveCreate($request);
            return json($addarchive);
        }
    }

    /**档案修改页面
     * @param Request $request
     * @return mixed
     */
    public function update(Request $request)
    {
        $Archive = $request->param();
        if (empty($Archive['CompanyId']) && empty($Archive['ArchiveId'])) {

        }
        $Detail = ArchiveService::Detail($Archive);
        $this->view->assign('Detail', $Detail);
        //学历字典
        $Education = DictionaryPool::getDictionaries('academic', null);
        $this->view->assign('Education', $Education['academic']);
        //所有部门
        $Departments = DepartmentService::all([
            'CompanyId' => $Archive['CompanyId']
        ]);
        $this->view->assign('Departments', $Departments);
        return $this->fetch();
    }

    /**档案修改方法
     * @param Request $request
     */

    public function replace(Request $request)
    {
        // 获取员工档案JSON数据
        $request = $request->post();
        //return json($request);
        $Picture = empty($_FILES["Picture"]['tmp_name']) ? '' : base64EncodeImage($_FILES["Picture"]);
        if ($request) {

            for ($x=1; $x<=$request['deptCount']; $x++) {
                if (empty($request['ItemId'.$x])){
                    $ItemIds[]=0;
                }else{
                    $ItemIds[]=$request['ItemId'.$x];
                }
                unset($request['ItemId'.$x]);
                $PostTitles[]=$request['PostTitle'.$x];
                unset($request['PostTitle'.$x]);
                $PostStartTimes[]=$request['PostStartTime'.$x];
                unset($request['PostStartTime'.$x]);
                $PostEndTimes[]=$request['PostEndTime'.$x];
                unset($request['PostEndTime'.$x]);
                $Salarys[]=$request['Salary'.$x];
                unset($request['Salary'.$x]);
                $Departments[]=$request['Department'.$x];
                unset($request['Department'.$x]);
                unset($request[$x]);
            }
            unset($request['deptCount']);
            foreach ($PostTitles as $keys => $value) {
                $request['WorkItems'][$keys]['PostTitle'] = $value;
            }
            foreach ($PostStartTimes as $keys => $value) {
                $request['WorkItems'][$keys]['PostStartTime'] = $value;
            }
            foreach ($PostEndTimes as $keys => $value) {
                if ($value == '至今') {
                    $value = DbHelper::getMaxDbDate();
                }
                $request['WorkItems'][$keys]['PostEndTime'] = $value;
            }
            foreach ($Salarys as $keys => $value) {
                $request['WorkItems'][$keys]['Salary'] = $value;
            }
            foreach ($Departments as $keys => $value) {
                $request['WorkItems'][$keys]['Department'] = $value;
            }

            foreach ($ItemIds as $keys => $value) {
                $request['WorkItems'][$keys]['ItemId'] = $value;
            }


            $request ['ModifiedId'] = $this->PassportId;

            if (empty($Picture)) {
                unset($request['Picture']);
            } else {
                $request['Picture'] = $Picture;
            }
            $request ['PresenterId'] = $this->PassportId;
            $addarchive = ArchiveService::ArchiveUpdate($request);
            return json($addarchive);
        }
    }

    /**档案详情
     * @param Request $request
     * @return mixed
     */

    public function detail(Request $request)
    {
        $ArchiveId = $request->param('ArchiveId');
        $CompanyId = $request->param('CompanyId');
        if (empty ($ArchiveId) && empty ($CompanyId)) {
            return '非法请求';
        }

        // 档案详情
        $archivedetail = EmployeArchive::where(['CompanyId' => $CompanyId, 'ArchiveId' => $ArchiveId])->find();
        if (empty ($archivedetail)) {
            return '暂无数据';
        }
        //字典转换
        $archivedetail['Education'] = DictionaryPool::getEntryNames('academic', $archivedetail['Education']);

        //当前职务和部门
        $archivePostTitle = WorkItem::where([
            'DeptId' => $archivedetail ['DeptId'],
            'ArchiveId' => $ArchiveId
        ])->find();
        $archiveDepartment = Department::where([
            'DeptId' => $archivedetail ['DeptId'],
            'CompanyId' => $archivedetail ['CompanyId']
        ])->value('DeptName');

        $archivedetail ['IsDimission'] = EmployeArchive::getStatusAttr($archivedetail ['IsDimission']);
        $archivedetail ['age'] = countage($archivedetail ['Birthday']);

        // 职务列表
        $workitemlist = WorkItem::all([
            'ArchiveId' => $ArchiveId
        ], [
            'Department'
        ]);

        // 离职报告
        $Report = ArchiveComment::where([
            'ArchiveId' => $ArchiveId,
            'CommentType' => 1,
            'AuditStatus' => 2
        ])->find();
        if ($Report) {
            //字典转换
            $Report['DimissionReason'] = DictionaryPool::getEntryNames('leaving', $Report['DimissionReason']);
            $Report['WantRecall'] = DictionaryPool::getEntryNames('panicked', $Report['WantRecall']);
            // 评价详情
            $Report ['WorkAbilityText'] = achievement($Report ['WorkAbility']);
            $Report ['WorkAttitudeText'] = achievement($Report ['WorkAttitude']);
            $Report ['WorkPerformanceText'] = achievement($Report ['WorkPerformance']);
            $Report ['HandoverTimelyText'] = achievement($Report ['HandoverTimely']);
            $Report ['HandoverOverallText'] = achievement($Report ['HandoverOverall']);
            $Report ['HandoverSupportText'] = achievement($Report ['HandoverSupport']);

            // 拆分评价图片字符串为数组
            if ($Report ['WorkCommentImages']) {
                $Report ['WorkCommentImages'] = explode(",", str_replace(array(
                    "[",
                    "]"
                ), "", $Report ['WorkCommentImages']));
                foreach ($Report ['WorkCommentImages'] as $val) {
                    $WorkCommentImages [] = Config('resources_site_root') . $val;
                }
                $Report ['WorkCommentImages'] = $WorkCommentImages;
            } else {
                $Report ['WorkCommentImages'] = '';
            }
            if ($Report ['WorkCommentVoice']) {
                $Report ['WorkCommentVoice'] = str_replace(Config('resources_site_root'), "", $Report ['WorkCommentVoice']);
            } else {
                $Report ['WorkCommentVoice'] = '';
            }

            // 提交人，审核人列表，通过人

            // 拆分审核人字符串为数组
            $Persons = explode(",", $Report ['AuditPersons']);
            foreach ($Persons as $value) {
                $Person [] = CompanyMember::getPassportRoleByCompanyId($Report ['CompanyId'],$value)['RealName'];
            }
            $Report ['AuditPersons'] = implode(' , ', $Person);
            $Report ['PresenterId'] = CompanyMember::getPassportRoleByCompanyId($Report ['CompanyId'],$Report ['PresenterId'])['RealName'];
            $Report ['OperatePassportId'] = CompanyMember::getPassportRoleByCompanyId($Report ['CompanyId'],$Report ['OperatePassportId'])['RealName'];
        } else {
            $Report = '';
        }

        // 阶段评价年份
        $StageYearlist = ArchiveComment::where('ArchiveId', $ArchiveId)->where('CommentType', 0)->where('AuditStatus', 2)->group('StageYear')->order('StageYear desc')->column('StageYear');

        if ($StageYearlist) {
            foreach ($StageYearlist as $k => $v) {

                $StageYear [$v] ['Commentlist'] = ArchiveComment::where('ArchiveId', $ArchiveId)->where('CommentType', 0)->where('AuditStatus', 2)->where('StageYear', $v)->order('StageSection desc,CommentId desc')->select();
                foreach ($StageYear [$v] ['Commentlist'] as $key => $val) {
                    // 评分等级文字
                    $StageYear [$v] ['Commentlist'] [$key] ['WorkAbilityText'] = achievement($val ['WorkAbility']);
                    $StageYear [$v] ['Commentlist'] [$key] ['WorkAttitudeText'] = achievement($val ['WorkAttitude']);
                    $StageYear [$v] ['Commentlist'] [$key] ['WorkPerformanceText'] = achievement($val ['WorkPerformance']);

                    $StageYear [$v] ['Commentlist'] [$key]['StageSection'] = DictionaryPool::getEntryNames('period', $val['StageSection']);

                    // 拆分评价图片字符串为数组
                    if ($StageYear [$v] ['Commentlist'] [$key]  ['WorkCommentImages']) {
                        $StageYear [$v] ['Commentlist'] [$key]  ['WorkCommentImages'] = explode(",", str_replace(array("[", "]"), "", $val ['WorkCommentImages']));
                        $WorkCommentImages = [];
                        foreach ($StageYear [$v] ['Commentlist'] [$key] ['WorkCommentImages'] as $val) {
                            $WorkCommentImages [] = Config('resources_site_root') . $val;
                        }
                        $StageYear [$v] ['Commentlist'] [$key] ['WorkCommentImages'] = $WorkCommentImages;
                    } else {
                        $StageYear [$v] ['Commentlist'] [$key] ['WorkCommentImages'] = '';
                    }

                    if ($StageYear [$v] ['Commentlist'] [$key] ['WorkCommentVoice']) {
                        $StageYear [$v] ['Commentlist'] [$key] ['WorkCommentVoice'] = str_replace(Config('resources_site_root'), "", $StageYear [$v] ['Commentlist'] [$key] ['WorkCommentVoice']);
                    } else {
                        $StageYear [$v] ['Commentlist'] [$key] ['WorkCommentVoice'] = '';
                    }

                    // 拆分审核人字符串为数组
                    $Persons = explode(",", $StageYear [$v] ['Commentlist'] [$key] ['AuditPersons']);
                    $Person = [];
                    foreach ($Persons as $value) {
                        $Person [] = CompanyMember::getPassportRoleByCompanyId($StageYear [$v] ['Commentlist'] [$key] ['CompanyId'],$value)['RealName'];
                    }
                    $StageYear [$v] ['Commentlist'] [$key] ['AuditPersons'] = implode(' , ', $Person);
                    $StageYear [$v] ['Commentlist'] [$key] ['PresenterId'] = CompanyMember::getPassportRoleByCompanyId($StageYear [$v] ['Commentlist'] [$key] ['CompanyId'],$StageYear [$v] ['Commentlist'] [$key] ['PresenterId'])['RealName'];
                }
            }
        } else {
            $StageYearlist = '';
            $StageYear = '';
        }
        $this->view->assign('StageYearlist', $StageYearlist);
        $this->view->assign('StageYear', $StageYear);
        $this->view->assign('workitemlist', $workitemlist);
        $this->view->assign('ArchivePostTitle', $archivePostTitle);
        $this->view->assign('ArchiveDepartment', $archiveDepartment);
        $this->view->assign('archivedetail', $archivedetail);
        $this->view->assign('Report', $Report);
        return $this->fetch();
    }

    /**
     *下载档案模板
     */
    public function downLoadModel(Request $request)
    {
        $filename = Config::get("resources_site_root").'/-common/员工档案批量导入模板.xlsx';
        header('Location:'.$filename);
    }


    /**
     * 上传档案
     * @param Request $request
     * @return mixed
     */
    public function upLoadArchive(Request $request)
    {
        return $this->fetch();

    }

    /**
     * [readFromExcel description]   读取excel
     * @param  [type]  $excelFile [description]
     * @param  [type]  $excelType [description]
     * @param  integer $startRow  [description]
     * @param  [type]  $endRow    [description]
     * @return [type]             [description]
     */
    function readFromExcel($excelFile, $excelType = null, $startRow = 1, $endRow = null) {
        include_once '/../../vendor/PHPExcel.php';
        $excelReader = \PHPExcel_IOFactory::createReader("Excel2007");
        $excelReader->setReadDataOnly(true);


        $phpexcel    = $excelReader->load($excelFile);
        $activeSheet = $phpexcel->getActiveSheet();
        if (!$endRow) {
            $endRow = $activeSheet->getHighestRow(); //总行数
        }

        $highestColumn      = $activeSheet->getHighestColumn(); //最后列数所对应的字母，例如第2行就是B
        $highestColumnIndex = \PHPExcel_Cell::columnIndexFromString($highestColumn); //总列数

        $data = array();
        for ($row = $startRow; $row <= $endRow; $row++) {
            $IsDimission=(string)$activeSheet->getCellByColumnAndRow(0, $row)->getValue();
            $RealName=(string)$activeSheet->getCellByColumnAndRow(1, $row)->getValue();
            $IDCard=trim((string)$activeSheet->getCellByColumnAndRow(2, $row)->getValue());
            $MobilePhone=(string)$activeSheet->getCellByColumnAndRow(3, $row)->getValue();
            $EntryTime=(string)$activeSheet->getCellByColumnAndRow(4, $row)->getValue();
            $IsDateTime=(string)$activeSheet->getCellByColumnAndRow(5, $row)->getValue();
            $PostStartTime=(string)$activeSheet->getCellByColumnAndRow(9, $row)->getValue();
            $PostEndTime=(string)$activeSheet->getCellByColumnAndRow(10, $row)->getValue();


            Log::info(sprintf("EXCEL rows[%s] size : %s", $row, memory_get_usage()));
            if(empty($IsDimission) && empty($RealName)  && empty($IDCard)  && empty($MobilePhone) ) {
                break;
            }
            if(empty($IsDimission) || empty($RealName)  || empty($IDCard)  || empty($MobilePhone) ||  $IDCard =='320700197205252813'){
                continue;
            }

            for ($col = 0; $col < $highestColumnIndex; $col++) {
                if(($col==4 && is_numeric($EntryTime)) || ($col==9 &&  is_numeric($PostStartTime))  || ($col==5 && !empty($IsDateTime)  &&  is_numeric($IsDateTime))  || ($col==10   &&  is_numeric($PostEndTime))){
                    $excelData[$row][]=gmdate("Y-m-d", \PHPExcel_Shared_Date::ExcelToPHP($activeSheet->getCellByColumnAndRow($col, $row)->getValue()));
                }else{
                    $excelData[$row][]=(string)$activeSheet->getCellByColumnAndRow($col, $row)->getValue();
                }
            }
        }
        return $excelData;
    }

    /**
     * 上传请求
     * @param Request $request
     * @return mixed
     */
    public function upLoadArchiveRequest(Request $request)
    {

        $info = empty($_FILES["archive"]['tmp_name']) ? '' : base64EncodeImage($_FILES["archive"]);
        if (isset ($info)) {
            if (strstr($info, 'employe-archive') == true) {
                $Archive = str_replace(Config('resources_site_root'), '', $info);
            } else {
                $Archive  = ResourceHelper::SaveEmployeArchiveExcel(date('Ymd'), $info);
            }

            $filePath =Config::get("resources_site_root").$Archive;
            $filenametwo="upload/".rand(1,10000).'.xlsx';
            file_put_contents($filenametwo,file_get_contents($filePath));
            $filename= $filenametwo;
            //调用读取excel
            $excelData = $this->readFromExcel($filename, null, 2, null);
            unlink($filenametwo);
            Log::info(sprintf("EXCEL end0 size : %s", memory_get_usage()));
            $objWorksheet = null;
            $objPHPExcel = null;
            $objReader = null;
            Log::info(sprintf("EXCEL end size : %s", memory_get_usage()));
            //调用验证
            return  $this->addBatchArchive($excelData,$request);

        }
    }
    /**
     * 批量添加档案验证
     * [addBatchArchive description]
     * @param [type] $excelData [description]
     */
    function addBatchArchive($excelData,$request){

        $data = [];

        $resultSuccess =[];
        $num =0;
        //总的档案数 不为空的
        $resultSuccess['totalArchive'] = count($excelData);
        $errorLog = [];
        //学历
        $Education = DictionaryPool::getDictionaries('academic', null);
        foreach ($excelData as $key => $val) {
            $errorMsg = [];

            //手否离职
            if ($val[0] == "在职") {
                $data['IsDimission'] = 0;
            } else if ($val[0] == "离任" || $val[0] == "离职") {
                $data['IsDimission'] = 1;
            } else {
                $errorMsg[] = '请选择是在职或者离任';
            }
            //姓名
            $pattern1 = "/^[\x{4e00}-\x{9fa5}]{2,5}$/u";
            if (preg_match($pattern1, $val[1])) {
                $data['RealName'] = $val[1];
            } else {
                $errorMsg[] = '请填写正确的姓名格式2-5个汉字';
            }

            //身份证号
            $checkIDCard = IDCard::validateIDCard(trim($val[2]));
            if ($checkIDCard == false) {
                $errorMsg[] = '请检查身份证号填写是否正确';
            }else{
                $data['IDCard'] = $val[2];
            }
            //手机号
            $pattern3 = "/^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/";
            if (preg_match($pattern3, $val[3])) {
                $data['MobilePhone'] =  $val[3];
            } else {
                $errorMsg[] =  '请填写正确的手机号码格式';
            }
            //入职日期
            $pattern = "/^[1-2][0-9][0-9][0-9]-[0-1]{0,1}[0-9]-[0-3]{0,1}[0-9]$/";
            if(empty($val[4])){
                $errorMsg[] = '请填写入职日期';
            }else{
                if (preg_match($pattern, $val[4])) {
                    $data['EntryTime'] = DbHelper::toUtcDateTime($val[4]);
                } else {
                    $errorMsg[] = '请填写正确的入职日期格式';
                }
            }
            //离职日期
            if($val[0] == "在职"){
                $data['DimissionTime'] = DbHelper::getMaxDbDate();
            }else{
                if (preg_match($pattern, $val[5]) && !empty($val[5]) ) {
                    if (strtotime($val[5]) >= strtotime($val[4]) && (strtotime($val[5]) <=  strtotime(date("Y-m-d H:i:s")))) {
                        $data['DimissionTime'] = DbHelper::toUtcDateTime($val[5]);
                    }else{
                        $errorMsg[] = '离任时间大于入职日期小于当前时间';
                    }
                } else {
                    $errorMsg[] = '请填写正确的离职日期格式';
                }
            }

            //毕业学校
            if(empty($val[6])){
                $errorMsg[] ='请填写毕业学校';
            }else{
                $pattern6 = "/^([A-Za-z]|[\x{4e00}-\x{9fa5}]){4,20}$/u";
                if (preg_match($pattern6, $val[6])) {
                    $data['GraduateSchool'] = $val[6];
                } else {
                    $errorMsg[] ='请填写正确的毕业学校格式4-20汉字';
                }
            }

            //学历
            if (empty($val[7])) {
                $errorMsg[] = '请选择学历';
            } else {
                foreach ($Education['academic'] as $keys => $values) {
                    if ($values['Name'] == $val[7]) {
                        $data['Education'] = $values['Code'];
                    }
                }
                if(!is_numeric($data['Education'])){
                    $errorMsg[] = '请填写正确的学历格式';
                }
            }

            $data['PresenterId'] = $this->PassportId;
            $data['CompanyId'] = $request->post('CompanyId');

            //是否发送短信处理
            if (isset($val[13])) {
                if ($val[13]== '是') {
                    $data['IsSendSms'] = true;
                }else if ($val[13]== '否') {
                    $data['IsSendSms'] = false;
                }else{
                    $errorMsg[] = '请填写正确的发送短信格式';
                }
            } else {
                $data['IsSendSms'] = true;
            }
            //职务
            $WorkItem = [];
            $pattern8 = "/^([A-Za-z]|[\x{4e00}-\x{9fa5}]){2,30}$/u";
            if(empty($val[8])){
                $errorMsg[] ='请填写职位名称';
            }else{
                if (preg_match($pattern8, $val[8])) {
                    $WorkItem ['PostTitle'] = $val[8];
                } else {
                    $errorMsg[] ='请填写正确的职位名称格式2-30汉字';
                }
            }

            //职位开始时间
            if(empty($val[9])){
                $errorMsg[] ='请填写职位开始时间';
            }else{
                if (preg_match($pattern, $val[9]) ) {
                    if($val[0] == "在职"){
                        if(strtotime($val[9]) >= strtotime($val[4]) && (strtotime($val[9]) <=  strtotime(date("Y-m-d H:i:s")))){
                            $WorkItem['PostStartTime'] = DbHelper::toUtcDateTime($val[9]);
                        }else{
                            $errorMsg[] = '在职员工职位开始时间大于入职时间小于当前时间';
                        }
                    }else{
                        if ( strtotime($val[9]) >= strtotime($val[4]) && (strtotime($val[9]) <=  strtotime($val[5]))) {
                            $WorkItem['PostStartTime'] = DbHelper::toUtcDateTime($val[9]);
                        }else{
                            $errorMsg[] = '离任员工职位开始时间大于入职时间小于离职时间';
                        }
                    }

                } else {
                    $errorMsg[] = '请填写正确的职位开始时间格式';
                }
            }

            //职位结束时间
            if($val[0] == "在职"){
                if ($val[10] == '至今' || empty($val[10])) {
                    $WorkItem['PostEndTime'] = DbHelper::getMaxDbDate();
                }else{
                    if (preg_match($pattern, $val[10])   ) {
                        if (strtotime($val[10]) > strtotime($val[9]) && (strtotime($val[10]) <= strtotime(date("Y-m-d H:i:s")))) {
                            $WorkItem['PostEndTime'] = DbHelper::toUtcDateTime($val[10]);;
                        }else{
                            $errorMsg[] = '在职员工职位结束时间大于开始时间小于当前时间';
                        }
                    } else {
                        $errorMsg[] = '请填写正确的职位结束时间格式';
                    }
                }

            }else{
                if (preg_match($pattern, $val[10])   ) {
                    if (strtotime($val[10]) > strtotime($val[9]) && (strtotime($val[10]) <= strtotime($val[5]))) {
                        $WorkItem['PostEndTime'] = DbHelper::toUtcDateTime($val[10]);;
                    }else{
                        $errorMsg[] = '离任员工职位结束时间大于开始时间小于离职时间';
                    }
                } else {
                    $errorMsg[] = '请填写正确的职位结束时间格式';
                }
            }


            //薪资
            if(empty( $val[11])){
                $WorkItem ['Salary'] ='';
            }else{
                if(is_numeric($val[11])){
                    if(3<=$val[11] && $val[11] <=999 ){
                        if(is_float($val[11] )){
                            $WorkItem['Salary'] =number_format($val[11],2);;
                        }else{
                            $WorkItem['Salary'] =$val[11];
                        }

                    }else{
                        $errorMsg[] ='请填写正确薪资格式3-999';
                    }
                }else{
                    $errorMsg[] ='请填写正确薪资格式3-999';
                }
            }

            //部门
            $pattern12 = "/^[\x{4e00}-\x{9fa5}]{2,20}$/u";
            if(empty($val[12])){
                $errorMsg[] = '请填写员工所在的部门';
            }else{
                if (preg_match($pattern12, $val[12])) {
                    $WorkItem ['Department'] = $val[12];
                } else {
                    $errorMsg[] ='请填写员工所在部门格式2-20汉字';
                }
            }

            $data['WorkItems']= array($WorkItem) ;

            //判断正确的个数 是否全部正确
            if(  $errorMsg==[]){
                $returnReault  = ArchiveService::ArchiveCreate($data);

                if($returnReault->Success==true){
                    $num++;
                }else{
                    $errorMsg[] = $returnReault->ErrorMessage;
                }
            }else{
                $WorkItem =[];
            }
            if(!empty($errorMsg)){
                $errorLog[]=['name'=>$val[1],'ErrorMsg'=>$errorMsg];
            }

        }
        $ErrorData= [];
        $ErrorData['PresenterId'] = $this->PassportId;
        $ErrorData['CompanyId'] = $request->post('CompanyId');
        $ErrorData['ErrorCode'] = $request->post('CompanyId').$this->PassportId.rand(1000,9999);
        $ErrorData['ErrorMsg'] =json_encode($errorLog);
        //return   $ErrorData;

        $ErrorLog = EmployeArchiveErrorLog::create($ErrorData);
        if($ErrorLog){
            $resultSuccess['SuccessState'] = true;
        }else{
            $resultSuccess['SuccessState'] = false;
        }
        $resultSuccess['SuccessNum'] = $num;
        $resultSuccess['FailNum'] =  intval($resultSuccess['totalArchive'] - $num);
        $resultSuccess['ErrorCode'] = $ErrorData['ErrorCode'];
        $resultSuccess['ErrorMsg'] = $errorLog;
        return  json( $resultSuccess);
    }
}