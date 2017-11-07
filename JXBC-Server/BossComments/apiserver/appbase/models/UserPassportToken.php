<?php
namespace app\appbase\models;
use think\Config;
use think\Cache;
use app\common\models\BaseModel;

/**
 * @SWG\Definition()
 */
class UserPassportToken extends BaseModel
{
    const TokenCacheExpire = 72*60*60;

    public static function FindIdByToken($token) {
        $key = config('third:linked-cache-prefix').$token;
        $passportId = Cache::get($key);
        if(empty($passportId)) {
            $passport = UserPassportToken::get([
                'AccessToken' => $token
            ]);
            if($passport) {
                $passportId = $passport->PassportId;
                if($passportId > 0) {
                    Cache::set($key, $passportId, UserPassportToken::TokenCacheExpire );
                }
            }
        }
        return intval($passportId);
    }
    protected function initialize()
    {
        $this->connection = Config::get('db_passports');
    }
	
    // 设置当前模型对应的完整数据表名称
    protected $table = 'anonymous_account_token';    
}