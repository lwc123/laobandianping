<?php

namespace app\appbase\controller;

/**
 * @SWG\Tag(
 *   name="Account",
 *   description="账号相关API，包括注册登录，重置密码等",
 *   @SWG\ExternalDocumentation(
 *     description="Find out more",
 *     url="http://swagger.io"
 *   )
 * )
 */ 
class AccountController
{
    /**
     * @SWG\POST(
     *     path="/appbase/Account/createNew",
     *     summary="创建APP匿名账号",
     *     description="使用客户端设备信息，创建匿名账号；<br/>浏览器首次访问网站时(服务器端自动写入cookie)<br/>客户端调用时机：<br/>1.APP首次启动;<br/>2.APP退出账号后;",     
     *     tags={"Account"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="客户端设备信息",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/ClientDevice"),
     *     ),       
     *     @SWG\Response(
     *         response=200,
     *         description="账号信息",
     *         @SWG\Schema(
     *             ref="#/definitions/AccountSignResult"
     *         )
     *     ),
     *     @SWG\Response(
     *         response="412",
     *         description="不符合预期的输入参数",
     *         @SWG\Schema(   
     *             ref="#/definitions/Error"
     *         )
     *     )
     * )
     */
    public function createNew($entity)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI"); 
    }
    
    /**
     * @SWG\Definition(
     *   definition="AccountSign:signUp",
     *   allOf={
     *     @SWG\Schema(ref="#/definitions/AccountSign"),
     *     @SWG\Schema(required={"ValidationCode","SelectedProfileType"})
     *   },
     * )    
     * @SWG\Post(
     *     path="/appbase/Account/signUp",
     *     summary="注册账号",
     *     tags={"Account"},
     *     description="asd",
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="账号注册信息",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/AccountSign:signUp"),
     *     ),     
     *     @SWG\Response(
     *         response=200,
     *         description="账号信息",
     *         @SWG\Schema(
     *             ref="#/definitions/AccountSignResult"
     *         )
     *     ),
     *     @SWG\Response(
     *         response="412",
     *         description="不符合预期的输入参数",
     *         @SWG\Schema(   
     *             ref="#/definitions/Error"
     *         )
     *     )
     * )
     */
    public function signUp($entity)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI"); 
    }
    
    /**
     * @SWG\Post(
     *     path="/appbase/Account/signIn",
     *     summary="登录（用户名+密码）",
     *     tags={"Account"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="登录信息",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/AccountSign"),
     *     ),     
     *     @SWG\Response(
     *         response=200,
     *         description="账号信息",
     *         @SWG\Schema(
     *             ref="#/definitions/AccountSignResult"
     *         )
     *     ),
     *     @SWG\Response(
     *         response="412",
     *         description="不符合预期的输入参数",
     *         @SWG\Schema(   
     *             ref="#/definitions/Error"
     *         )
     *     )
     * )
     */
    public function signIn($entity)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI"); 
    }

    /**
     * @SWG\Post(
     *     path="/appbase/Account/signInByToken",
     *     summary="登录（TOKEN）",
     *     tags={"Account"},
     *     @SWG\Response(
     *         response=200,
     *         description="账号信息",
     *         @SWG\Schema(
     *             ref="#/definitions/AccountSignResult"
     *         )
     *     ),
     *     @SWG\Response(
     *         response="412",
     *         description="不符合预期的输入参数",
     *         @SWG\Schema(
     *             ref="#/definitions/Error"
     *         )
     *     )
     * )
     */
    public function signInByToken()
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }
    
    /**
     * @SWG\Post(
     *     path="/appbase/Account/sendValidationCode",
     *     summary="发送手机验证码",
     *     tags={"Account"},
     *     consumes={"text/plain"},
     *     @SWG\Parameter(
     *         name="phone",
     *         in="query",
     *         description="手机号",
     *         required=true,
     *         type="string"
     *     ),     
     *     @SWG\Response(
     *         response=200,
     *         description="发送是否成功",
     *         @SWG\Schema(type="boolean")     
     *     )
     * )
     */
    public function sendValidationCode($phone)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI"); 
    }  

    /**
     * @SWG\Get(
     *     path="/appbase/Account/checkValidationCode",
     *     summary="验证手机验证码是否正确",
     *     tags={"Account"},
     *     consumes={"text/plain"},
     *     @SWG\Parameter(
     *         name="phone",
     *         in="query",
     *         description="手机号",
     *         required=true,
     *         type="string"
     *     ), 
     *     @SWG\Parameter(
     *         name="code",
     *         in="query",
     *         description="验证码",
     *         required=true,
     *         type="string"
     *     ), 
     *     @SWG\Response(
     *         response=200,
     *         description="",
     *         @SWG\Schema(type="boolean")     
     *     )
     * )
     */
    public function checkValidationCode($phone, $code)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI"); 
    } 
    
    /**
     * @SWG\Get(
     *     path="/appbase/Account/existsMobilePhone",
     *     summary="验证手机号是否注册",
     *     tags={"Account"},
     *     consumes={"text/plain"},
     *     @SWG\Parameter(
     *         name="phone",
     *         in="query",
     *         description="手机号",
     *         required=true,
     *         type="string"
     *     ),     
     *     @SWG\Response(
     *         response=200,
     *         description="",
     *         @SWG\Schema(type="boolean")     
     *     )
     * )
     */
    public function existsMobilePhone($phone)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI"); 
    }

    /**
     * @SWG\Definition(
     *   definition="AccountSign:reset",
     *   allOf={
     *     @SWG\Schema(ref="#/definitions/AccountSign"),
     *     @SWG\Schema(required={"ValidationCode"})
     *   },
     * )
     * @SWG\Post(
     *     path="/appbase/Account/resetPassword",
     *     summary="重置密码",
     *     tags={"Account"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="用户名+密码+手机验证码",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/AccountSign:reset"),
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="中直接过",
     *         @SWG\Schema(
     *             ref="#/definitions/AccountSignResult"
     *         )
     *     )
     * )
     */
    public function resetPassword($entity)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }
}
