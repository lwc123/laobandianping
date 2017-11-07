<?php
namespace app\workplace\models;
use app\common\models\BaseModel;
use app\appbase\models\UserPassport;
use app\workplace\models\Company;

/**
 * @SWG\Tag(
 * name="NoticeArgs",
 * description="",
 * )
 */
/**
 * @SWG\Definition(required={"PassportId"})
 */
class NoticeContacts
{    
    public static function CreateContactsList($idList) {
        $list = UserPassport::loadList($idList);
        $result = [];
        foreach ($list as $passport) {
            $item = new NoticeContacts();
            $item->PassportId = $passport['PassportId'];
            $item->MobilePhone = $passport['MobilePhone'];
            $item->DisplayName = $passport['UserProfile']['RealName'];
            array_push($result,$item);
        }
        return $result;
    }
    
	/**
	 * @SWG\Property(type="integer", description="用户id")
	 */
	public $PassportId;
	
	/**
	 * @SWG\Property(type="integer", description="显示名称")
	 */
	public $DisplayName;
	
	/**
	 * @SWG\Property(type="integer")
	 */
	public $Email;

	/**
	 * @SWG\Property(type="integer")
	 */
	public $MobilePhone;
	
	/**
	 * @SWG\Property(type="string")
	 */
	public $WechatOpenId;

	/**
	 * @SWG\Property(type="integer", description="用户所属公司id")
	 */
	public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="企业分成的背景调查金额")
     */
    public $Money;

	public function formatBossNickname(){
	   return $this->DisplayName;
	}

    public function formatCompanyMoney(){
        return $this->Money;
    }
}