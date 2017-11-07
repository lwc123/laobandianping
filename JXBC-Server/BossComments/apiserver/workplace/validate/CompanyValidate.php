<?php
namespace app\workplace\validate;

use think\Validate;

class CompanyValidate extends Validate
{
	 
	// 开户验证必填项规则
	protected $rule = [
			['CompanyName', 'require|min:6|max:90', '请输入您的企业名称|企业名称不能短于5个字符|企业名称不能超过30个字符'],
			['RealName', 'require|max:15', '请输入您的姓名|姓名不能超过5个字符'],
			['JobTitle', 'require|max:60', '请输入您的职务|职务不能超过20个字符'],
	];
 
	
}
 