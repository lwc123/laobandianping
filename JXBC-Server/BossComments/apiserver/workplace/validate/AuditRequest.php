<?php
namespace app\workplace\validate;

use think\Validate;

 
 
 class AuditRequest extends Validate
{
	 
	// 开户验证必填项规则
	protected $rule = [ 
			['Licence', 'require', '请上传企业营业执照'],
			['MobilePhone', 'require|max:20', '请输入法人手机号|法人手机号不能超过11个字符'],
			['Images', 'require', '请上传身份证照片'], 
	]; 
}