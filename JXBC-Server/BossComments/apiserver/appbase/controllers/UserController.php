<?php

namespace app\appbase\controller;


class UserController
{
    /**
     * @SWG\Post(
     *     path="/appbase/User/ChangePassword",
     *     summary="修改密码（新密码）",
     *     tags={"Account"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="新密码",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/AccountSign"),
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="修改是否成功",
     *         @SWG\Schema(type="boolean")
     *     )
     * )
     */
    public function ChangePassword($entity)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI"); 
    }
    /**
     * @SWG\Post(
     *     path="/appbase/User/ChangeProfile",
     *     summary="修改用户信息",
     *     tags={"Account"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="用户信息 ",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/UserProfile"),
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="修改是否成功",
     *         @SWG\Schema(type="boolean")
     *     )
     * )
     */
    public function ChangeProfile($entity)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }

    /**
     * @SWG\Post(
     *     path="/appbase/User/ChangeAvatar",
     *     summary="修改用户头像",
     *     tags={"Account"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="用户信息 ",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/AvatarEntity"),
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="修改是否成功",
     *         @SWG\Schema(type="boolean")
     *     )
     * )
     */
    public function ChangeAvatar($entity)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }


    /**
     * @SWG\Post(
     *     path="/appbase/User/ChangeCurrentToUserProfile",
     *     summary="切换用户身份到个人",
     *     tags={"Account"},
     *     @SWG\Response(
     *         response=200,
     *         description="修改是否成功",
     *         @SWG\Schema(ref="#/definitions/AccountEntity")
     *     )
     * )
     */
    public function ChangeCurrentToUserProfile()
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }


    /**
     * @SWG\Post(
     *     path="/appbase/User/ChangeCurrentToOrganizationProfile",
     *     summary="切换用户身份到企业身份",
     *     tags={"Account"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="企业身份信息 ",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/OrganizationProfile"),
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="修改是否成功",
     *         @SWG\Schema(ref="#/definitions/AccountEntity")
     *     )
     * )
     */
    public function ChangeCurrentToOrganizationProfile($entity)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }
}
