<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
use think\Route;

// 定义工作目录常量
define("APPLICATION",config("default_module"));

// Index控制器的All操作
Route::rule('Index/[:name]',APPLICATION.'/Index/:name');

// EnterpriseService控制器的All操作
Route::rule('EnterpriseService/[:name]',APPLICATION.'/EnterpriseService/:name');

// base控制器的All操作
Route::rule('base/[:name]',APPLICATION.'/base/:name');

// Test控制器的All操作
Route::rule('Test/[:name]',APPLICATION.'/Test/:name');

// Member控制器的All操作
Route::rule('CompanyMember/[:name]',APPLICATION.'/CompanyMember/:name');
 
// CompanyAuditRequest控制器的All操作
Route::rule('CompanyAuditRequest/[:name]',APPLICATION.'/CompanyAuditRequest/:name');

// company控制器的All操作
Route::rule('company/[:name]',APPLICATION.'/company/:name');

// EmployeArchive控制器的All操作
Route::rule('EmployeArchive/[:name]',APPLICATION.'/EmployeArchive/:name');

// ArchiveComment控制器的All操作
Route::rule('ArchiveComment/[:name]',APPLICATION.'/ArchiveComment/:name');

// Department控制器的All操作
Route::rule('Department/[:name]',APPLICATION.'/Department/:name');

// Memcached控制器的All操作
Route::rule('Memcached/[:name]',APPLICATION.'/Memcached/:name');

// EmployeArchive控制器的All操作
Route::rule('EmployeArchive/[:name]',APPLICATION.'/EmployeArchive/:name');

// EnterpriseService控制器的All操作
Route::rule('dbkey',APPLICATION.'/dbkey');

//  BoughtCommentRecord控制器的All操作
Route::rule('BackgroundSurvey/[:name]',APPLICATION.'/BackgroundSurvey/:name');

//  UserController控制器的All操作
Route::rule('User/[:name]',APPLICATION.'/User/:name');

//  DrawMoneyRequest控制器的All操作
Route::rule('DrawMoneyRequest/[:name]',APPLICATION.'/DrawMoneyRequest/:name');
 
//  MessageController控制器的All操作
Route::rule('Message/[:name]',APPLICATION.'/Message/:name');

//  Job控制器的All操作
Route::rule('Job/[:name]',APPLICATION.'/Job/:name');

//  JobQuery控制器的All操作
Route::rule('JobQuery/[:name]',APPLICATION.'/JobQuery/:name');

//  BossDynamicController控制器的All操作
Route::rule('BossDynamic/[:name]',APPLICATION.'/BossDynamic/:name');

//  BizDictController控制器的All操作
Route::rule('BizDict/[:name]',APPLICATION.'/BizDict/:name');

//  Privateness控制器的All操作
Route::rule('Privateness/[:name]',APPLICATION.'/Privateness/:name');


//  PriceStrategy控制器的All操作
Route::rule('PriceStrategy/[:name]',APPLICATION.'/PriceStrategy/:name');

//  ThirdOpenService控制器的All操作
Route::rule('ThirdOpenService/[:name]',APPLICATION.'/ThirdOpenService/:name');

