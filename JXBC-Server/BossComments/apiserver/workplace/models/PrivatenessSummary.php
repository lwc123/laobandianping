<?php
namespace app\workplace\models;
/**
 * @SWG\Definition(required={"ArchiveCount"})
 */
class PrivatenessSummary{
	
	/**
	 * @SWG\Property(type="integer", description="未读消息个数")
	 */
	public $UnreadMessageNum;
	
	/**
	 * @SWG\Property(type="boolean", description="是否存在银行卡")
	 */
	public $ExistBankCard;
  
	/**
	 * @SWG\Property(ref="#/definitions/PrivatenessServiceContract",description="个人开通服务合同信息")
	 */
	public $PrivatenessServiceContract;
	 
}