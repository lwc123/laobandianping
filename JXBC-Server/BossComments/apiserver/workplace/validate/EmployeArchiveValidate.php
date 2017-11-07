<?php

namespace app\workplace\validate;

use think\Validate;

class EmployeArchiveValidate extends Validate {
	
	// 新建档案验证规则
	protected $rule = [ 
			 
			[ 
					'RealName',
					'require|max:20',
					'请输入真实姓名|真实姓名不能超过5个汉字' 
			],
			 
	];
}