<?php
namespace app\www\controller;


use think\Request;

class SampleController extends CompanyBaseController
{


    /**企业工作台
     * @param Request $request
     * @return mixed|null
     */
    public function console(Request $request)
    {
        return $this->fetch();
    }


    /**退出登录
     * @param Request $request
     * @return mixed|null
     */
    public function signout()
    {
        setcookie("JX-TOKEN", '');
        $post = "/Account/login";
        header ( "location:$post" );
    }

}


