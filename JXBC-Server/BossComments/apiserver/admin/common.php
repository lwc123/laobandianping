<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 流年 <liu21st@gmail.com>
// +----------------------------------------------------------------------

/** 企业审核中的个数
 * @return int
 */
function CompanyAuditCount(){
    $CompanyAuditCount = \app\workplace\models\Company::where('AuditStatus',1)->count();
    return  $CompanyAuditCount;
}

/** 待读的意见反馈 个数
 * @return int
 */
function feedBackCount(){
    $feedBackCount = \app\workplace\models\Feedback::where('IsProcess',0)->count();
    return  $feedBackCount;
}