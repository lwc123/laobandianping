<?php
namespace app\www\controller;

use app\workplace\models\CompanyMember;
use app\common\controllers\AuthenticatedController;
use app\workplace\models\Company;
use app\workplace\models\MemberRole;
use app\workplace\services\ConsoleService;
use think\Request;
use app\common\modules\DbHelper;

class CompanyBaseController extends AuthenticatedController
{
    static function assignConsoleSummary($controller, $passportId)
    {
        $request = Request::instance();
        $CompanyId = $request->param('CompanyId');
        $Console = ConsoleService::Console($CompanyId, $passportId);
        $controller->view->assign('MyCompanyRole', $Console ['MyInformation']['Role']);
        if ($Console ['MyInformation']) {
            switch ($Console ['MyInformation']['Role']) {
                case (MemberRole::Boss):
                    $Console ['MyInformation']['Role'] = '老板';
                    break;
                case (MemberRole::Manager):
                    $Console ['MyInformation']['Role'] = '管理员';
                    break;
                case (MemberRole::Executives):
                    $Console ['MyInformation']['Role'] = '高管';
                    break;
                case (MemberRole::FilingClerk):
                    $Console ['MyInformation']['Role'] = '建档员';
                    break;
            }

        }

        if(!empty($Console['ServiceEndTime'])){
            $Company =Company::where('CompanyId',$CompanyId)->find();
            if($Console['ServiceEndTime'] != $Company['ServiceEndTime']){
                $Console['ServiceEndTime'] = $Company['ServiceEndTime'];
            }
            //$Console['ServiceEndTime']  = '2016-12-12';
            $nowTime = time();
            if(substr($Console['ServiceEndTime'],0,4)=='3000'){
                $Console['days']  = 3000;
            }else{
                $days = ceil((strtotime(DbHelper::toLocalDateTime($Console['ServiceEndTime']))-$nowTime)/86400);
                $Console['days']  = $days;
            }
        }

        $myCompanys = CompanyMember::where(['PassportId' =>$passportId])->count();
        $controller->view->assign('myCompanys', $myCompanys);
        $controller->view->assign('CompanySummary', $Console);
        $controller->view->assign('CompanyId', $CompanyId);
        $controller->view->assign('PassportId', $passportId);
    }

    protected $CurrentCompanyId;
    protected $CurrentCompanyRole;

    /**构造，工作台左侧
     * @param Request $request
     * @return mixed|null
     */
    public function __construct(Request $request)
    {
        parent::__construct();
        $this->CurrentCompanyId = $this->GetCurrentCompanyRole()['CompanyId'];
        self::assignConsoleSummary($this, $this->PassportId);

    }

    protected function GetCurrentCompanyRole()
    {
        $request = Request::instance();
        $key = "CompanyId";
        $companyId = $request->get($key);
        if (empty($companyId) && $request->isPOST()) {
            $data = $request->put();
            if (!empty($data) && is_array($data) && array_key_exists($key, $data)) {
                $companyId = $data[$key];
            }
        }
        if (empty($companyId)) {
            $this->error(412, "没有找到参数 " . $key);
        }
        $this->CurrentCompanyRole = CompanyMember::getPassportRoleByCompanyId($companyId, $this->PassportId);
        if (empty($this->CurrentCompanyRole)) {
            $this->error(401, '没有指定资源的操作权限');
        }
        return $this->CurrentCompanyRole;

    }
}


