<?php

namespace app\workplace\services;

use app\appbase\models\BizSources;
use app\appbase\models\PayWays;
use app\appbase\models\TradeType;
use app\common\modules\ServerVisitManager;
use app\workplace\models\BoughtCommentRecord;
use app\workplace\models\NoticeArgs;
use app\appbase\models\UserPassport;
use think\Log;
use think\Request;
use app\workplace\models\ArchiveComment;
use app\workplace\models\CompanyMember;
use app\workplace\models\EventCode;
use app\workplace\models\EmployeArchive;
use app\workplace\models\CommentType;
use app\workplace\models\NoticeContacts;
use app\workplace\services\NoticeService;
use app\workplace\models\MemberRole;
use app\workplace\models\Company;
/**
 * 评价发消息具体实现调用
 */
class NoticeByCommentService {
	
	/**
	 * 添加/修改员工评价（阶段评价或者离职报告），给审核人发送审核通知信息
	 *
	 * @access public
	 * @param        	
	 *
	 * @return
	 *
	 */
	public static function ArchiveCommentToAuditPersonRemind($CommentId, $CurrentOperatorId) {
		if (empty ( $CommentId ) && empty ( $CurrentOperatorId )) {
			exception ( '非法请求-0', 412 );
		}
		
		$CommentInfo = ArchiveComment::where ( 'CommentId', $CommentId )->find ();
		if (empty ( $CommentInfo )) {
			exception ( '非法请求-0', 412 );
		}
		// 收信人
		$MemberList = CompanyMember::where ( [ 
				'CompanyId' => $CommentInfo ['CompanyId'] 
		] )->where ( 'PassportId', 'in', $CommentInfo ['AuditPersons'] )->select ();
		$ToContactsList = [ ];
		foreach ( $MemberList as $passport ) {
			if ($passport ['PassportId'] != $CurrentOperatorId) {
				$item = new NoticeContacts ();
				$item->CompanyId = $passport ['CompanyId'];
				$item->PassportId = $passport ['PassportId'];
				$item->MobilePhone = $passport ['MobilePhone'];
				$item->DisplayName = $passport ['RealName'];
				array_push ( $ToContactsList, $item );
			}
		}
		
		// 发信人
		$FromContactpassport = CompanyMember::where ( [ 
				'CompanyId' => $CommentInfo ['CompanyId'] 
		] )->where ( 'PassportId', $CurrentOperatorId )->find ();

		// 根据评价类型：CommentType，调用事件
		if ($CommentInfo ['CommentType'] == CommentType::DepartureReport) {
			$eventCode = EventCode::Outgoingeport;
			$BizType=2;
		} else {
			$eventCode = EventCode::Commitvaluation;
            $BizType=3;
		}
		
		// 发送实体 
		$noticeArgs = new NoticeArgs();
		$noticeArgs->ToContactsList = $ToContactsList;
		$noticeArgs->FromContacts =$FromContactpassport;
		$noticeArgs->BizType = $BizType;
		$noticeArgs->BizId=$CommentId;
		$noticeArgs->EventModel=array (
						'RealName' => EmployeArchive::where ( 'ArchiveId', $CommentInfo ['ArchiveId'] )->value ( 'RealName' ) 
				);
		NoticeService::sendNotice($eventCode, $noticeArgs);
	}
	
	/**
	 * 审核通过（阶段评价或者离职报告），给审核人发送已审核通过信息
	 *
	 * @access public
	 * @param        	
	 *
	 * @return
	 *
	 */
	public static function ArchiveCommentToAuditPersonPass($CommentId, $CurrentOperatorId) {
		if (empty ( $CommentId ) && empty ( $CurrentOperatorId )) {
			exception ( '非法请求-0', 412 );
		}
		
		$CommentInfo = ArchiveComment::where ( 'CommentId', $CommentId )->find ();
		if (empty ( $CommentInfo )) {
			exception ( '非法请求-0', 412 );
		}
		//提取提交人
		$PresenterId=$CommentInfo['PresenterId'];
		// 收信人
		$MemberList = CompanyMember::where ( [ 
				'CompanyId' => $CommentInfo ['CompanyId'] 
		] )->where ( 'PassportId', 'in', $CommentInfo ['AuditPersons'] )->select ();
		$ToContactsList = [ ];
		foreach ( $MemberList as $passport ) {
			$item = new NoticeContacts ();
			$item->CompanyId = $passport ['CompanyId'];
			$item->PassportId = $passport ['PassportId'];
			$item->MobilePhone = $passport ['MobilePhone'];
			$item->DisplayName = $passport ['RealName'];
			array_push ( $ToContactsList, $item );
		}
		
		// 提交人是否为审核人，如果不是，添加到收信人array中
		$AuditPersons = explode ( ',', $CommentInfo ['AuditPersons'] );
		if (in_array ( $PresenterId, $AuditPersons )) {
			$ToPresenter = [ ];
		} else {
			// 提交人
			$Member = CompanyMember::where ( [ 
					'CompanyId' => $CommentInfo ['CompanyId'] 
			] )->where ( 'PassportId', $PresenterId )->select ();
			$ToPresenter = [ ];
			foreach ( $Member as $passport ) {
				$item = new NoticeContacts ();
				$item->CompanyId = $passport ['CompanyId'];
				$item->PassportId = $passport ['PassportId'];
				$item->MobilePhone = $passport ['MobilePhone'];
				$item->DisplayName = $passport ['RealName'];
				array_push ( $ToPresenter, $item );
			}
		}
		
		// 合并收件人列表数组
		$ToPresenterContactsList = array_merge ( $ToPresenter, $ToContactsList );
		
		// 发信人
		$FromContactpassport = CompanyMember::where ( [
				'CompanyId' => $CommentInfo ['CompanyId'] 
		] )->where ( 'PassportId', $CurrentOperatorId )->find ();
	 
		// 根据评价类型：CommentType，调用事件
		if ($CommentInfo ['CommentType'] == CommentType::DepartureReport) {
            $eventCode = EventCode::DepartureReportpproval;
            $BizType=2;
		} else {
            $eventCode = EventCode::StageEvaluationApproval;
            $BizType=3;
		}

      	$noticeArgs = new NoticeArgs(); 
        $noticeArgs->ToContactsList = $ToPresenterContactsList;
        $noticeArgs->FromContacts =$FromContactpassport;
        $noticeArgs->BizType = $BizType;
        $noticeArgs->BizId=$CommentId;
        $noticeArgs->EventModel=array (
            'RealName' => EmployeArchive::where ( 'ArchiveId', $CommentInfo ['ArchiveId'] )->value ( 'RealName' ),
            'reviewers' => $FromContactpassport ['RealName']
        );  
		NoticeService::sendNotice($eventCode, $noticeArgs);
	}
	
	/**
	 * 审核拒绝（阶段评价或者离职报告），给审核人发送未审核通过信息
	 *
	 * @access public
	 * @param
	 *
	 * @return
	 *
	 */
	public static function ArchiveCommentToAuditPersonReject($CommentId, $CurrentOperatorId) {
		if (empty ( $CommentId ) && empty ( $CurrentOperatorId )) {
			exception ( '非法请求-0', 412 );
		}
	
		$CommentInfo = ArchiveComment::where ( 'CommentId', $CommentId )->find ();
		if (empty ( $CommentInfo )) {
			exception ( '非法请求-0', 412 );
		}
        //提取提交人
        $PresenterId=$CommentInfo['PresenterId'];
		// 收信人
		$MemberList = CompanyMember::where ( [
				'CompanyId' => $CommentInfo ['CompanyId']
		] )->where ( 'PassportId', 'in', $CommentInfo ['AuditPersons'] )->select ();
		$ToContactsList = [ ];
		foreach ( $MemberList as $passport ) {
			$item = new NoticeContacts ();
			$item->CompanyId = $passport ['CompanyId'];
			$item->PassportId = $passport ['PassportId'];
			$item->MobilePhone = $passport ['MobilePhone'];
			$item->DisplayName = $passport ['RealName'];
			array_push ( $ToContactsList, $item );
		}
	
		// 提交人是否为审核人，如果不是，添加到收信人array中
		$AuditPersons = explode ( ',', $CommentInfo ['AuditPersons'] );
		if (in_array ( $PresenterId, $AuditPersons )) {
			$ToPresenter = [ ];
		} else {
			// 提交人
			$Member = CompanyMember::where ( [
					'CompanyId' => $CommentInfo ['CompanyId']
			] )->where ( 'PassportId', $PresenterId )->select ();
			$ToPresenter = [ ];
			foreach ( $Member as $passport ) {
				$item = new NoticeContacts ();
				$item->CompanyId = $passport ['CompanyId'];
				$item->PassportId = $passport ['PassportId'];
				$item->MobilePhone = $passport ['MobilePhone'];
				$item->DisplayName = $passport ['RealName'];
				array_push ( $ToPresenter, $item );
			}
		}
	
		// 合并收件人列表数组
		$ToPresenterContactsList = array_merge ( $ToPresenter, $ToContactsList );
	
		// 发信人
		$FromContactpassport = CompanyMember::where ( [
				'CompanyId' => $CommentInfo ['CompanyId']
		] )->where ( 'PassportId', $CurrentOperatorId )->find ();
		$FromContact = new NoticeContacts ();
		$FromContact->CompanyId = $FromContactpassport ['CompanyId'];
		$FromContact->PassportId = $FromContactpassport ['PassportId'];
		$FromContact->MobilePhone = $FromContactpassport ['MobilePhone'];
		$FromContact->DisplayName = $FromContactpassport ['RealName'];
	
		// 根据评价类型：CommentType，调用事件
		if ($CommentInfo ['CommentType'] == CommentType::DepartureReport) {
            $eventCode = EventCode::DepartureReportAuditFailed;
            $BizType=2;
		} else {
            $eventCode = EventCode::StageEvaluationAuditFailed;
            $BizType=3;
		}

        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToPresenterContactsList;
        $noticeArgs->FromContacts =$FromContactpassport;
        $noticeArgs->BizType = $BizType;
        $noticeArgs->BizId=$CommentId;
        $noticeArgs->EventModel=array (
            'RealName' => EmployeArchive::where ( 'ArchiveId', $CommentInfo ['ArchiveId'] )->value ( 'RealName' ),
            'reviewers' => $FromContactpassport ['RealName']
        );
       // return $noticeArgs;
        NoticeService::sendNotice ( $eventCode, $noticeArgs );
	}


    /**
     * 审核通过（阶段评价或者离职报告），给员工（个人）发送已审核通过信息
     *
     * @access public
     * @param
     *
     * @return
     *
     */
    public static function ArchiveCommentToAuditPersonal($CommentId, $CurrentOperatorId,$IsSendSms) {
        if (empty ( $CommentId )  &&  empty ( $CurrentOperatorId )) {
            exception ( '非法请求-0', 412 );
        }

        $CommentInfo = ArchiveComment::where ( 'CommentId', $CommentId )->find ();
        if (empty ( $CommentInfo )) {
            exception ( '非法请求-0', 412 );
        }
       $ArchiveMan =  EmployeArchive::where ( 'ArchiveId', $CommentInfo['ArchiveId'] )->find ();
        if (empty ( $ArchiveMan )) {
            exception ( '非法请求-0', 412 );
        }
        //判断用户是否注册
        $PassportId = UserPassport::where('MobilePhone',$ArchiveMan ['MobilePhone'])->value('PassportId');
        if (empty ( $PassportId )) {
            $PassportId = 0;
        }
       // 收信人
        $ToContactsList = [ ];
            $item = new NoticeContacts ();
            $item->CompanyId = $ArchiveMan ['CompanyId'];
            $item->PassportId = $PassportId;
            $item->MobilePhone = $ArchiveMan ['MobilePhone'];
            $item->DisplayName = $ArchiveMan ['RealName'];
            array_push ( $ToContactsList, $item );
        // 发信人
        $FromContactpassport = CompanyMember::where ( [
            'CompanyId' => $CommentInfo ['CompanyId']
        ] )->where ( 'PassportId', $CurrentOperatorId )->find ();
        $FromContact = new NoticeContacts ();
        $FromContact->CompanyId = $FromContactpassport ['CompanyId'];
        $FromContact->PassportId = $FromContactpassport ['PassportId'];
        $FromContact->MobilePhone = $FromContactpassport ['MobilePhone'];
        $FromContact->DisplayName = $FromContactpassport ['RealName'];


        // 根据评价类型：CommentType，调用事件
        if ($CommentInfo ['CommentType'] == CommentType::DepartureReport) {
            $eventCode = EventCode::DepartureReportpprovalPersonal;
            $BizType=0;
        } else {
            $eventCode = EventCode::StageEvaluationApprovalPersonal;
            $BizType=0;
        }
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts =$FromContactpassport;
        $noticeArgs->BizType = $BizType;
        $noticeArgs->BizId=$CommentId;
        $noticeArgs->EventModel=array (
            'CompanyName' => Company::where ( 'CompanyId', $CommentInfo ['CompanyId'] )->value ( 'CompanyName' )
        );
        NoticeService::sendNotice($eventCode, $noticeArgs,$IsSendSms);
    }

    /**
     *  背景调查，企业法人获得收益信息
     *
     * @access public
     * @param
     *
     * @return
     *
     */
    public static function BuyBackgroundSurvey($ids,$TradeCode)
    {
        if (empty ($ids) ) {
            exception('非法请求-0', 412);
        }
        //老板的信息
        $Records= BoughtCommentRecord::where ('RecordId' ,'in', $ids  )->group('ArchiveCompanyId')->select();
        //发送给企业老板
        $ToContactsList = [];
        foreach($Records as $Record )
        {
                    $BossInfor = CompanyMember::where (['CompanyId' => $Record ['ArchiveCompanyId']])->where (['Role' => MemberRole::Boss])->find();
                    //查询购买评价类型
                    $comment_type= BoughtCommentRecord::where ('RecordId' ,'in', $ids  )->where('ArchiveCompanyId',$BossInfor ['CompanyId'])->select();
                    $priceNum=0;
                    foreach($comment_type as $keys =>$val){
                        if($val['BoughtStageEvaluation']==1){
                            $priceNum += 10;
                        }
                        if($val['BoughtDepartureReport']==1){
                            $priceNum += 15;
                         }
                    }
            $ArchiveRealName =  EmployeArchive::where('ArchiveId',$Record['ArchiveId'])->value('RealName');
            $item = new NoticeContacts ();
            $item->CompanyId = $BossInfor ['CompanyId'];
            $item->PassportId = $BossInfor ['PassportId'];
            $item->MobilePhone = $BossInfor ['MobilePhone'];
            $item->DisplayName = $ArchiveRealName;
            $item->Money =  $priceNum;
            array_push($ToContactsList, $item);

            //分成给企业，添加企业收入记录
            $post_url = Config('site_root_api').'/appbase/PaymentService/ShareIncome';
            $post_data ['ParentTradeCode'] =  $TradeCode;
            $post_data ['OwnerId'] =  $BossInfor ['CompanyId'];
            $post_data ['TradeType'] =  TradeType::OrganizationToOrganization;
            $post_data ['PayWay'] =  PayWays::System;
            $post_data ['TotalFee'] = $priceNum;
            $post_data ['CommoditySubject'] =  '其他企业购买背景调查分成';
            $post_data ['CommoditySummary'] =  '购买企业：'.Company::where('CompanyId',$Record ['CompanyId'])->value('CompanyName');
            $post_data ['BizSource']=BizSources::SellBackgroundSurvey;
            $post_data ['BuyerId'] =  $Record ['PassportId'];
            $reponse =ServerVisitManager::ServerVisitPost($post_url, $post_data, 1);
            if(empty($reponse) || is_array($reponse)==false || false == array_key_exists('Success', $reponse)){
                Log::error("/////分成失败 ".json_encode($post_data));//分成失败， 任务重试
                Log::error($reponse);
            }

        }
        $eventCode = EventCode::BuyBackgroundSurvey;
        // 发信人
        $FromContactpassport = ['CompanyId' => 0, 'PassportId' => 0, 'MobilePhone' => 0, 'DisplayName' => 0];

        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts = $FromContactpassport;
        $noticeArgs->BizType = "";
        $noticeArgs->BizId = $Records[0]['CompanyId'];
        $noticeArgs->EventModel = array(
            'RealName' => EmployeArchive::where ( 'ArchiveId', $Records[0]['ArchiveId'] )->value ( 'RealName' ),
        );
          NoticeService::sendNotice($eventCode, $noticeArgs);
    }
}