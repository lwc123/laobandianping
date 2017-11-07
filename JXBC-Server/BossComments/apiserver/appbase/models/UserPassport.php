<?php
namespace app\appbase\models;
use think\Config;
use think\db\Query;
use app\common\models\BaseModel;
use app\appbase\models\UserProfile;
use app\appbase\models\SignedUpInfo;

/**
 * @SWG\Definition(required={"PassportId"})
 */
class UserPassport extends BaseModel
{  
    public static function load($passportId) {
        return UserPassport::with('UserProfile')->find([$passportId]);
    }
    public static function loadWithSignUpInfo($passportId) {
        return UserPassport::with('SignedUpInfo')->find([$passportId]);
    }
    public static function loadList($idList) {
        return UserPassport::with('UserProfile')->where('UserProfile.PassportId', 'in', $idList)->select();
    }    
    
    public static function findByQuery($userQuery, $pagination) {
        //$pagination = Pagination::Create($userQuery['Page'], $userQuery['Size']);
        $buildQueryFunc = function() use ($userQuery) {
            $query = null;
            if (!isset($userQuery['Invited']) || strlen($userQuery['Invited'])==0) {
                $query = UserPassport::with('UserProfile');
            } else {
                $query = UserPassport::with('UserProfile,SignedUpInfo');
                if($userQuery['Invited'] == '1') {
                    $query = $query->where('isnull(InviteCode)');
                } else {
                    $query = $query->where('LENGTH(InviteCode)>1');
                }
            }
            if (isset($userQuery['ProfileType']) &&  strlen($userQuery['ProfileType']) !=0) {
                $query = $query->where('ProfileType',$userQuery['ProfileType']);
            }
            
            if (!empty($userQuery['MobilePhone'])) {
                $query = $query->where('MobilePhone', $userQuery['MobilePhone']);
            }

            if( !empty($userQuery['MaxSignedUpTime'])){
                $userQuery['MaxSignedUpTime'] = date('Y-m-d',strtotime('+1 day',strtotime($userQuery['MaxSignedUpTime'])));
            }else{
                $userQuery['MaxSignedUpTime'] =   date('Y-m-d',strtotime('+1 day'));
            }
            if( !empty($userQuery['MinSignedUpTime'])){
                $query = $query->where('UserProfile.CreatedTime', 'between time', [$userQuery['MinSignedUpTime'],$userQuery['MaxSignedUpTime']]);
            }
            return $query;
        };
        $pagination->TotalCount =  $buildQueryFunc($userQuery)->count();
            
        return $buildQueryFunc()->order ( 'UserProfile.CreatedTime desc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
    }    
    
    protected function initialize()
    {
        $this->connection = Config::get('db_passports');
    }
    
    
    /**
     * @SWG\Property(type="long")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="string")
     */
    public $MobilePhone;
    
    /**
     * @SWG\Property(description="交易类型，参见枚举[ProfileType]", type="integer")
     */
    public $MultipleProfiles;
    
    // 关联UserProfile
    public function UserProfile()
    {
        return $this->hasOne('UserProfile','PassportId');
    }
    
    // 关联SignedUpInfo
    public function SignedUpInfo()
    {
        return $this->hasOne('SignedUpInfo','PassportId');
    }    
}