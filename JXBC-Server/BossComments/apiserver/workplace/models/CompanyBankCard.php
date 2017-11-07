<?php

namespace app\workplace\models;

use app\common\models\BaseModel;
use think\Cache;

/**
 * @SWG\Tag(
 *   name="CompanyBankCard",
 *   description="公司银行卡账号API"
 * )
 */

/**
 * @SWG\Definition(required={"BankCard","BankName","PresenterId","CompanyId"})
 */
class  CompanyBankCard extends BaseModel
{
    const CacheName = "CompanyBankCard";
    const CacheExpire = 24 * 60 * 60;
    /**
     * @SWG\Property(type="integer", description="")
     */
    public $AccountId;

    /**
     * @SWG\Property(type="integer", description="公司Id")
     */
    public $CompanyId;


    /**
     * @SWG\Property(type="string", description="公司名称")
     */
    public $CompanyName;

    /**
     * @SWG\Property(type="integer", description="提交人ID")
     */
    public $PresenterId;

    /**
     * @SWG\Property(type="string", description="银行账号")
     */
    public $BankCard;

    /**
     * @SWG\Property(type="string", description="开户银行")
     */
    public $BankName;

    /**
     * @SWG\Property(type="string", description="使用时间")
     */
    public $UseTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $ModifiedTime;

    protected $type = [
        'CreatedTime' => 'datetime',
        'ModifiedTime' => 'datetime',
        'UseTime' => 'datetime'
    ];


    /**
     * 查找公司或者个人是否填写过银行卡信息，加入缓存
     * @param $id:公司Id或个人Id
     * @param $type :1公司
     * @return bool|mixed
     */
    public static function ExistBankCard($id, $type)
    {
        if ($type==1){$postfix='Company';}else{$postfix='Personal';}
        $bankcard_key = CompanyBankCard::CacheName . '-' . $id . '-' . $postfix;

        $ExistBankCard = Cache::get($bankcard_key);
       // Cache::rm($bankcard_key);
        //echo $ExistBankCard;die;
        if (empty($ExistBankCard)) {
            if ($type == 1) {
                $BankCardListByCompanyId = CompanyBankCard::where(['CompanyId' => $id])->select();
            } else {
                $BankCardListByCompanyId = CompanyBankCard::where(['PresenterId' => $id])->select();
            }
            if ($BankCardListByCompanyId) {
                $ExistBankCard['ExistBankCard'] = true;
            } else {
                $ExistBankCard['ExistBankCard'] = false;
            }
            Cache::set($bankcard_key, $ExistBankCard, CompanyBankCard::CacheExpire);
        }
        return $ExistBankCard;
    }
}
