<?php
namespace app\web\controller;
use think\Controller;
use think\Request;
use app\workplace\models\EmployeArchive;
use app\workplace\models\WorkItem;
use app\workplace\models\Department;
use app\workplace\models\ArchiveComment;
use app\workplace\models\CompanyMember;
use app\common\modules\DictionaryPool;

class EmployeArchiveController extends Controller {
	public function Archive(Request $request) {
		$ArchiveId = $request->param ( 'ArchiveId' );
		
		if (empty ( $ArchiveId )) {
			return '非法请求';
		}
		
		// 档案详情
		$archivedetail = EmployeArchive::get ( $ArchiveId );
		if (empty ( $archivedetail )) {
			return '暂无数据';
		}
        //字典转换
        $archivedetail['Education']=DictionaryPool::getEntryNames('academic',$archivedetail['Education']);

		//入职时间和离职时间，格式处理开始
		$EntryTime= date('Y年m月d日',strtotime($archivedetail['EntryTime']));
		$this->view->assign ( 'EntryTime', $EntryTime );
		$DimissionTime= date('Y年m月d日',strtotime($archivedetail['DimissionTime']));
		$this->view->assign ( 'DimissionTime', $DimissionTime ); 
		//入职时间和离职时间，格式处理结束
		$archivePostTitle = WorkItem::where ( [ 
				'DeptId' => $archivedetail ['DeptId'],
				'ArchiveId' => $ArchiveId 
		] )->value ( 'PostTitle' );
		$archiveDepartment = Department::where ( [ 
				'DeptId' => $archivedetail ['DeptId'],
				'CompanyId' => $archivedetail ['CompanyId'] 
		] )->value ( 'DeptName' );
		
		$archivedetail ['IsDimission'] = EmployeArchive::getStatusAttr ( $archivedetail ['IsDimission'] );
		$archivedetail ['age'] = countage ( $archivedetail ['Birthday'] );
		
		// 职务列表
		$workitemlist = WorkItem::all ( [ 
				'ArchiveId' => $ArchiveId 
		], [ 
				'Department' 
		] );
		
		// 离职报告
		$Report = ArchiveComment::where ( [ 
				'ArchiveId' => $ArchiveId,
				'CommentType' => 1,
				'AuditStatus' => 2 
		] )->find ();
		if ($Report) {
            //字典转换
            $Report['DimissionReason']=DictionaryPool::getEntryNames('leaving',$Report['DimissionReason']);
            $Report['WantRecall']=DictionaryPool::getEntryNames('panicked',$Report['WantRecall']);
			// 评价详情
			$Report ['WorkAbilityText'] = achievement ( $Report ['WorkAbility'] );
			$Report ['WorkAttitudeText'] = achievement ( $Report ['WorkAttitude'] );
			$Report ['WorkPerformanceText'] = achievement ( $Report ['WorkPerformance'] );
			$Report ['HandoverTimelyText'] = achievement ( $Report ['HandoverTimely'] );
			$Report ['HandoverOverallText'] = achievement ( $Report ['HandoverOverall'] );
			$Report ['HandoverSupportText'] = achievement ( $Report ['HandoverSupport'] );
			
			// 拆分评价图片字符串为数组
			if ($Report ['WorkCommentImages']) {
				$Report ['WorkCommentImages'] = explode ( ",", str_replace ( array (
						"[",
						"]" 
				), "", $Report ['WorkCommentImages'] ) );
				foreach ( $Report ['WorkCommentImages'] as $val ) {
					$WorkCommentImages [] = Config ( 'resources_site_root' ) . $val;
				}
				$Report ['WorkCommentImages'] = $WorkCommentImages;
			} else {
				$Report ['WorkCommentImages'] = '';
			}
			if ($Report ['WorkCommentVoice']) {
				$Report ['WorkCommentVoice'] = str_replace ( Config ( 'resources_site_root' ), "", $Report ['WorkCommentVoice'] );
			} else {
				$Report ['WorkCommentVoice'] = '';
			}
			
			// 提交人，审核人列表，通过人
			
			// 拆分审核人字符串为数组
			$Persons = explode ( ",", $Report ['AuditPersons'] );
			foreach ( $Persons as $value ) {
				$Person [] = CompanyMember::where ( [ 
						'CompanyId' => $Report ['CompanyId'],
						'PassportId' => $value 
				] )->value ( 'RealName' );
			}
			$Report ['AuditPersons'] = implode ( ' , ', $Person );
			$Report ['PresenterId'] = CompanyMember::where ( [ 
					'CompanyId' => $Report ['CompanyId'],
					'PassportId' => $Report ['PresenterId'] 
			] )->value ( 'RealName' );
			$Report ['OperatePassportId'] = CompanyMember::where ( [ 
					'CompanyId' => $Report ['CompanyId'],
					'PassportId' => $Report ['OperatePassportId'] 
			] )->value ( 'RealName' );
		} else {
			$Report = '';
		}
		
		// 阶段评价年份
		$StageYearlist = ArchiveComment::where ( 'ArchiveId', $ArchiveId )->where ( 'CommentType', 0 )->where ( 'AuditStatus', 2 )->group ( 'StageYear' )->order ( 'StageYear desc' )->column ( 'StageYear' );
		
		if ($StageYearlist) {
			foreach ( $StageYearlist as $k => $v ) {
				
				$StageYear [$v] ['Commentlist'] = ArchiveComment::where ( 'ArchiveId', $ArchiveId )->where ( 'CommentType', 0 )->where ( 'AuditStatus', 2 )->where ( 'StageYear', $v )->order ( 'StageSection desc,CommentId desc' )->select ();
				foreach ( $StageYear [$v] ['Commentlist'] as $key => $val ) {
					// 评分等级文字
					$StageYear [$v] ['Commentlist'] [$key] ['WorkAbilityText'] = achievement ( $val ['WorkAbility'] );
					$StageYear [$v] ['Commentlist'] [$key] ['WorkAttitudeText'] = achievement ( $val ['WorkAttitude'] );
					$StageYear [$v] ['Commentlist'] [$key] ['WorkPerformanceText'] = achievement ( $val ['WorkPerformance'] );

                    $StageYear [$v] ['Commentlist'] [$key]['StageSection']=DictionaryPool::getEntryNames('period',$val['StageSection']);
					
					// 拆分评价图片字符串为数组
					if ($StageYear [$v] ['Commentlist'] [$key]  ['WorkCommentImages']) {
						$StageYear [$v] ['Commentlist'] [$key]  ['WorkCommentImages'] = explode ( ",", str_replace ( array (								"[","]"), "", $val ['WorkCommentImages'] ) );
						$WorkCommentImages=[];
						foreach ( $StageYear [$v] ['Commentlist'] [$key] ['WorkCommentImages'] as $val ) {
							$WorkCommentImages [] = Config ( 'resources_site_root' ) . $val;
						}
						$StageYear [$v] ['Commentlist'] [$key] ['WorkCommentImages'] = $WorkCommentImages;
					} else {
						$StageYear [$v] ['Commentlist'] [$key] ['WorkCommentImages'] = '';
					}
					
					if ($StageYear [$v] ['Commentlist'] [$key] ['WorkCommentVoice']) {
						$StageYear [$v] ['Commentlist'] [$key] ['WorkCommentVoice'] = str_replace ( Config ( 'resources_site_root' ), "", $StageYear [$v] ['Commentlist'] [$key] ['WorkCommentVoice'] );
					} else {
						$StageYear [$v] ['Commentlist'] [$key] ['WorkCommentVoice'] = '';
					}
					 
					// 拆分审核人字符串为数组
					$Persons = explode ( ",", $StageYear [$v] ['Commentlist'] [$key] ['AuditPersons'] );
					$Person=[];
					foreach ( $Persons as $value ) {
						$Person [] = CompanyMember::where ( ['CompanyId' => $StageYear [$v] ['Commentlist'] [$key] ['CompanyId'],'PassportId' => $value] )->value ( 'RealName' );
					}
					$StageYear [$v] ['Commentlist'] [$key] ['AuditPersons'] = implode ( ' , ', $Person );
					$StageYear [$v] ['Commentlist'] [$key] ['PresenterId'] = CompanyMember::where ( ['CompanyId' => $StageYear [$v] ['Commentlist'] [$key] ['CompanyId'],	'PassportId' => $StageYear [$v] ['Commentlist'] [$key] ['PresenterId']	] )->value ( 'RealName' ); 
				}
			}
		} else {
			$StageYearlist = '';
			$StageYear = '';
		}
		$this->view->assign ( 'StageYearlist', $StageYearlist );
		$this->view->assign ( 'StageYear', $StageYear );
		$this->view->assign ( 'workitemlist', $workitemlist );
		$this->view->assign ( 'ArchivePostTitle', $archivePostTitle );
		$this->view->assign ( 'ArchiveDepartment', $archiveDepartment );
		$this->view->assign ( 'archivedetail', $archivedetail );
		$this->view->assign ( 'Report', $Report );
		return $this->fetch ();
	}
	public function Comment(Request $request) {
		$oid = $request->param ( 'oid' );
		if (empty ( $oid )) {
			return '非法请求';
		}
		
		$comment = ArchiveComment::where ( [ 
				'CommentId' => $oid 
		] )->find ();
		if (empty ( $comment )) {
			return '非法请求';
		}

        // 档案详情
		$ArchiveId = $comment ['ArchiveId'];
		$archivedetail = EmployeArchive::get ( $comment ['ArchiveId'] );
		if (empty ( $archivedetail )) {
			return '暂无数据';
		}
         if($archivedetail['IsDimission'] ==0){
             $archivedetail['IsDimission'] = '入职';
         }
        //字典转换
        $comment['StageSection']=DictionaryPool::getEntryNames('period',$comment['StageSection']);

        //入职时间和离职时间，格式处理开始
		$EntryTime= date('Y年m月d日',strtotime($archivedetail['EntryTime']));
		$this->view->assign ( 'EntryTime', $EntryTime );
		$DimissionTime= date('Y年m月d日',strtotime($archivedetail['DimissionTime']));
		$this->view->assign ( 'DimissionTime', $DimissionTime );

		//入职时间和离职时间，格式处理结束
		$archivePostTitle = WorkItem::where ( [ 
				'DeptId' => $archivedetail ['DeptId'],
				'ArchiveId' => $ArchiveId 
		] )->value ( 'PostTitle' );
		$archiveDepartment = Department::where ( [ 
				'DeptId' => $archivedetail ['DeptId'],
				'CompanyId' => $archivedetail ['CompanyId'] 
		] )->value ( 'DeptName' );
		
		// 评价详情
		$comment ['WorkAbilityText'] = achievement ( $comment ['WorkAbility'] );
		$comment ['WorkAttitudeText'] = achievement ( $comment ['WorkAttitude'] );
		$comment ['WorkPerformanceText'] = achievement ( $comment ['WorkPerformance'] );
		
		// 拆分评价图片字符串为数组
		
		if ($comment ['WorkCommentImages']) {
			$comment ['WorkCommentImages'] = explode ( ",", str_replace ( array (
					"[",
					"]" 
			), "", $comment ['WorkCommentImages'] ) );
			foreach ( $comment ['WorkCommentImages'] as $val ) {
				$WorkCommentImages [] = Config ( 'resources_site_root' ) . $val;
			}
			$comment ['WorkCommentImages'] = $WorkCommentImages;
		} else {
			$comment ['WorkCommentImages'] = '';
		}
		if ($comment ['WorkCommentVoice']) {
			$comment ['WorkCommentVoice'] = str_replace ( Config ( 'resources_site_root' ), "", $comment ['WorkCommentVoice'] );
		} else {
			$comment ['WorkCommentVoice'] = '';
		}
		
		// 提交人，审核人列表，通过人
		
		// 拆分审核人字符串为数组
		$Persons = explode ( ",", $comment ['AuditPersons'] );
		foreach ( $Persons as $value ) {
			$Person [] = CompanyMember::where ( [ 
					'CompanyId' => $comment ['CompanyId'],
					'PassportId' => $value 
			] )->value ( 'RealName' );
		}
		$comment ['AuditPersons'] = implode ( ' , ', $Person );
		$comment ['PresenterId'] = CompanyMember::where ( [ 
				'CompanyId' => $comment ['CompanyId'],
				'PassportId' => $comment ['PresenterId'] 
		] )->value ( 'RealName' );
		$comment ['OperatePassportId'] = CompanyMember::where ( [ 
				'CompanyId' => $comment ['CompanyId'],
				'PassportId' => $comment ['OperatePassportId'] 
		] )->value ( 'RealName' );
		$this->view->assign ( 'model', $comment );
		$this->view->assign ( 'ArchivePostTitle', $archivePostTitle );
		$this->view->assign ( 'ArchiveDepartment', $archiveDepartment );
		$this->view->assign ( 'archivedetail', $archivedetail );
		return $this->fetch ();
	}
	
	
	public function Report(Request $request) {
		$oid = $request->param ( 'oid' );
		if (empty ( $oid )) {
			return '非法请求';
		}
		
		$comment = ArchiveComment::where ( [ 
				'CommentId' => $oid 
		] )->find ();
		if (empty ( $comment )) {
			return '非法请求';
		}
		
		// 档案详情
		$ArchiveId = $comment ['ArchiveId'];
		$archivedetail = EmployeArchive::get ( $comment ['ArchiveId'] );
		if (empty ( $archivedetail )) {
			return '暂无数据';
		}
        //字典转换
        $comment['DimissionReason']=DictionaryPool::getEntryNames('leaving',$comment['DimissionReason']);
        $comment['WantRecall']=DictionaryPool::getEntryNames('panicked',$comment['WantRecall']);
		//入职时间和离职时间，格式处理开始
		$EntryTime= date('Y年m月d日',strtotime($archivedetail['EntryTime']));
		$this->view->assign ( 'EntryTime', $EntryTime );
		$DimissionTime= date('Y年m月d日',strtotime($archivedetail['DimissionTime']));
		$this->view->assign ( 'DimissionTime', $DimissionTime );
		//入职时间和离职时间，格式处理结束
		$archivePostTitle = WorkItem::where ( [ 
				'DeptId' => $archivedetail ['DeptId'],
				'ArchiveId' => $ArchiveId 
		] )->value ( 'PostTitle' );
		$archiveDepartment = Department::where ( [ 
				'DeptId' => $archivedetail ['DeptId'],
				'CompanyId' => $archivedetail ['CompanyId'] 
		] )->value ( 'DeptName' );
		
		// 评价详情
		$comment ['WorkAbilityText'] = achievement ( $comment ['WorkAbility'] );
		$comment ['WorkAttitudeText'] = achievement ( $comment ['WorkAttitude'] );
		$comment ['WorkPerformanceText'] = achievement ( $comment ['WorkPerformance'] );
		$comment ['HandoverTimelyText'] = achievement ( $comment ['HandoverTimely'] );
		$comment ['HandoverOverallText'] = achievement ( $comment ['HandoverOverall'] );
		$comment ['HandoverSupportText'] = achievement ( $comment ['HandoverSupport'] );
		
		// 拆分评价图片字符串为数组
		if ($comment ['WorkCommentImages']) {
			$comment ['WorkCommentImages'] = explode ( ",", str_replace ( array (
					"[",
					"]" 
			), "", $comment ['WorkCommentImages'] ) );
			foreach ( $comment ['WorkCommentImages'] as $val ) {
				$WorkCommentImages [] = Config ( 'resources_site_root' ) . $val;
			}
			$comment ['WorkCommentImages'] = $WorkCommentImages;
		} else {
			$comment ['WorkCommentImages'] = '';
		}
		if ($comment ['WorkCommentVoice']) {
			$comment ['WorkCommentVoice'] = str_replace ( Config ( 'resources_site_root' ), "", $comment ['WorkCommentVoice'] );
		} else {
			$comment ['WorkCommentVoice'] = '';
		}
		
		// 提交人，审核人列表，通过人
		
		// 拆分审核人字符串为数组
		$Persons = explode ( ",", $comment ['AuditPersons'] );
		foreach ( $Persons as $value ) {
			$Person [] = CompanyMember::where ( [ 
					'CompanyId' => $comment ['CompanyId'],
					'PassportId' => $value 
			] )->value ( 'RealName' );
		}
		$comment ['AuditPersons'] = implode ( ' , ', $Person );
		$comment ['PresenterId'] = CompanyMember::where ( [ 
				'CompanyId' => $comment ['CompanyId'],
				'PassportId' => $comment ['PresenterId'] 
		] )->value ( 'RealName' );
		$comment ['OperatePassportId'] = CompanyMember::where ( [ 
				'CompanyId' => $comment ['CompanyId'],
				'PassportId' => $comment ['OperatePassportId'] 
		] )->value ( 'RealName' );
		$this->view->assign ( 'model', $comment );
		$this->view->assign ( 'ArchivePostTitle', $archivePostTitle );
		$this->view->assign ( 'ArchiveDepartment', $archiveDepartment );
		$this->view->assign ( 'archivedetail', $archivedetail );
		return $this->fetch ();
	}
	public function BackgroundSurvey(Request $request) {
		return $this->fetch ();
	}
}


