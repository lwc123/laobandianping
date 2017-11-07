<?php

namespace app\workplace\services;
use app\workplace\models\CompanyMember;
use think\Db;
use think\Request;
use app\common\models\MessageResult;
use app\workplace\services\NoticeByMemberService;
use app\common\models\Result;
use app\common\models\ErrorCode;
use app\workplace\models\MemberRole;
use app\common\modules\ServerVisitManager;
class MemberService   {
	public static function MemberAddService($member) {
		if (empty ( $member ) || empty ( $member ["MobilePhone"] )) {
			exception ( '非法请求-0', 412 );
		}
		//return $member['MobilePhone'];die;
		// 查询此手机号是否注册
		$ExistPassportId = Db::connect ( 'db_passports' )->table ( 'user_passport' )->where ( 'MobilePhone', $member ["MobilePhone"] )->value ( 'PassportId' );
		 
		if ($ExistPassportId) {
			$ExistMember=CompanyMember::where(['CompanyId' => $member ['CompanyId'],'PassportId' => $ExistPassportId])->find(); 
			if($ExistMember){ 
				return Result::error(ErrorCode::Member_existence, '公司已有该成员');
			}
			else{ 
				$Memberdate = [
                    'PassportId' => $ExistPassportId,
                    'PresenterId' => $member ['PresenterId'],
                    'CompanyId' => $member ['CompanyId'],
                    'RealName' => $member ['RealName'],
                    'JobTitle' => $member ['JobTitle'],
                    'MobilePhone' => $member ['MobilePhone'],
                    'Role' => $member ['Role']
                ]; 
				$savemember = CompanyMember::create ( $Memberdate );
				// 返回成员ID
				$MemberId = $savemember ['PassportId'];
               if($member['Role']==MemberRole::Boss){
                    //发信息给提交人，老板 站内信
                   NoticeByCompanyAuditService::EnterpriseCertificationDotAccount($Memberdate);
                   //发信息给老板 发短息
                   NoticeByCompanyAuditService::EnterpriseCertificationDotAccountBoss($Memberdate);
                }else{
                    //给授权人发送消息
                    NoticeByMemberService::AddAuthorizedAlready($Memberdate);
                    //给老板发送授权消息
                    NoticeByMemberService::AddAuthorizedBoss($Memberdate);
                }
				return Result::success($MemberId) ;
			}
 		}
		else{
			// 增加新用户
			$post_url = Config('site_root_api').'/appbase/Account/signup';
			$post_data ['MobilePhone'] = $member ['MobilePhone'];
			$post_data ['Password'] = rand('100000','999999');
			$post_data ['ValidationCode'] = '112233';
			$post_data ['SelectedProfileType'] = 2;
            $result = ServerVisitManager::ServerVisitPost($post_url, $post_data, 1);
			$NewsPassportId = $result ['Account'] ['PassportId']; 
			$Memberdate = [
					'PassportId' => $NewsPassportId,
					'PresenterId' => $member ['PresenterId'],
					'CompanyId' => $member ['CompanyId'],
					'RealName' => $member ['RealName'],
					'JobTitle' => $member ['JobTitle'],
					'MobilePhone' => $member ['MobilePhone'],
					'Role' => $member ['Role']
			];
 			$savemember = CompanyMember::create ( $Memberdate );
			// 返回成员ID
			$MemberId = $savemember ['MemberId'];
            if($member['Role'] == MemberRole::Boss){
                //创建老板账户
                NoticeByCompanyAuditService::EnterpriseCertificationCreateAccount($Memberdate,$post_data ['Password']);
            }else{
                //给授权人发送消息
                NoticeByMemberService::AddAuthorized($Memberdate,$post_data ['Password']);
                //给老板发送授权消息
                NoticeByMemberService::AddAuthorizedBoss($Memberdate);
            }
			return Result::success($MemberId);
			
		}
	}
}