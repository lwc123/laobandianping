<?php

namespace app\workplace\services;

use think\Request;
use think\db;
use app\workplace\models\WorkItem;
use app\workplace\models\EmployeArchive;
use app\common\models\Result;
use app\common\models\ErrorCode;


class WorkItemService {
	public static function Create($WorkItem) {
		if (empty ( $WorkItem ) || empty ( $WorkItem ['ArchiveId'] ) ) {
			exception ( '非法请求-0', 412 );
		}
		
		$saveWorkItem=WorkItem::create($WorkItem);
		EmployeArchive::where ( 'ArchiveId', $WorkItem ['ArchiveId'] )->update ( [
		'DeptId' => $saveWorkItem ['DeptId']
		]); 
		return Result::success($saveWorkItem['ItemId'],$saveWorkItem);
	 
	}	
}