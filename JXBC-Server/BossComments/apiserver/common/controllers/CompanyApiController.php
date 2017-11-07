<?php

namespace app\common\controllers;

use think\Cache;
use think\Request;
use app\workplace\models\CompanyMember;

class CompanyApiController extends AuthenticatedApiController
{

    protected $CurrentCompanyId;
    protected $CurrentCompanyRole;

    public function __construct()
    {
        parent::__construct();
        $this->CurrentCompanyId = $this->GetCurrentCompanyRole()['CompanyId'];
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
        $this->CurrentCompanyRole=CompanyMember::getPassportRoleByCompanyId($companyId,$this->PassportId);
        if (empty($this->CurrentCompanyRole)){
            $this->error(401, '没有指定资源的操作权限');
        }
        return $this->CurrentCompanyRole;
    }
}