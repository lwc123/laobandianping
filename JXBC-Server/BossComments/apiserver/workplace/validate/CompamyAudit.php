<?php
namespace app\workplace\validate;

use think\Validate;

 
 
 class CompamyAudit extends Validate
{
	 
	// 开户验证必填项规则
	protected $rule = [
// 			['CompanyName', 'require|min:6|max:90', '请输入您的企业名称|企业名称不能短于5个字符|企业名称不能超过30个字符'],
// 			['CompanyAbbr', 'require|max:20', '请输入企业简称|姓名不能超过5个字符'],
// 			['Industry', 'require|max:20', '请选择企业行业|职务不能超过20个字符'],
// 			['CompanySize', 'require|max:20', '请选择企业规模|职务不能超过20个字符'],
// 			['Region', 'require|max:20', '请选择所在城市|职务不能超过20个字符'],
// 			//['Licence', 'require|max:20', '请上传企业营业执照|职务不能超过20个字符'],
// 			['LegalName', 'require|max:20', '请输入法人姓名|职务不能超过20个字符'],
// 			//['MobilePhone', 'require|max:20', '请输入法人手机号|职务不能超过20个字符'],
// 			//['Images', 'require|max:20', '请上传身份证照片|职务不能超过20个字符'], 
	];
	
  
	
}