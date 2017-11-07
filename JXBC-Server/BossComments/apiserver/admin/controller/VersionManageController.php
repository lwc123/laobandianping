<?php

namespace app\admin\controller;

use app\admin\controller\AuthenticatedController;
use app\workplace\models\Version;
use think\Request;


class VersionManageController extends AuthenticatedController
{
	public function versionList()
    {
        $VersionList = Version::select();
        $this->view->assign('VersionList', $VersionList);
        return $this->fetch();
    }
    public function versionUpdate(Request $request)
    {
        $queryParams = $request->get();
        $Version = Version::where('VersionId',$queryParams['VersionId'])->find();
        $this->view->assign('Version', $Version);
        return $this->fetch();
    }

    public function update(Request $request)
    {
        $queryParams = $request->post();
        $Version = Version::update($queryParams,['VersionId'=>$queryParams['VersionId']]);
        if ($Version) {
            $post = "/VersionManage/versionList";
            header("location:$post");
        }
    }
}

