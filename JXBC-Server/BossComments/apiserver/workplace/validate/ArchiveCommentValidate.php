<?php

namespace app\workplace\validate;

use think\Validate;

class ArchiveCommentValidate extends Validate {
	
	// 新建评价验证规则
	protected $rule = [ 
			 
			[ 
					'ArchiveId',
					'require',
					'请选择档案' 
			]
			 
	];
}