<?php

namespace app\appbase\models;
use think\Config;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={"OwnerId","TradeType","TradeMode","PayWay","BizSource","TotalFee","BizSource","BuyerId"})
 */
class Wallet extends BaseModel
{ 

    public static function GetPrivatenessWallet($ownerId) {
        $wallet = Wallet::get(['OwnerId' => $ownerId, "WalletType"=>WalletType::Privateness]);
        return $wallet;
    }
    
    public static function GetOrganizationWallet($orgId) {
        $wallet = Wallet::get(['OwnerId' => $orgId, "WalletType"=>WalletType::Organization]);
        return $wallet;
    }    

    protected function initialize()
    {
        $this->connection = Config::get('db_tradesystem');
    }

    /**
     * @SWG\Property(description="钱包Id", type="long")
     */    
    public $WalletId; 
    
   /**
     * @SWG\Property(description="钱包类型，参见枚举[WalletType]", type="integer")
     */
    public $WalletType;    
    
    /**
     * @SWG\Property(description="钱包所有人(个人钱包：用户PassportId；<br/>机构钱包：所属机构的机构Id)", type="integer", format="int64")
     */
    public $OwnerId;
    
    /**
     * @SWG\Property(description="可用余额", type="number")
     */
    public $AvailableBalance;
    
    /**
     * @SWG\Property(description="可提现余额", type="number")
     */
    public $CanWithdrawBalance; 

    /**
     * @SWG\Property(description="已冻结金额", type="string")
     */    
    public $FreezeFee;
    
	/**
	 * @SWG\Property(type="string", description="添加时间")
*/
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
	public $ModifiedTime;

    public function getAvailableBalanceAttr($value)
    {
        return parent::getMoneyWithDBUnit($value);
    }
    public function setAvailableBalanceAttr($value)
    {
        return parent::setMoneyWithDBUnit($value);
    }

    public function getCanWithdrawBalanceAttr($value)
    {
        return parent::getMoneyWithDBUnit($value);
    }
    public function setCanWithdrawBalanceAttr($value)
    {
        return parent::setMoneyWithDBUnit($value);
    }

    public function getFreezeFeeAttr($value)
    {
        return parent::getMoneyWithDBUnit($value);
    }
    public function setFreezeFeeAttr($value)
    {
        return parent::setMoneyWithDBUnit($value);
    }


}