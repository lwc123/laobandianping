<?php
namespace app\opinion\models;

use app\common\models\BaseModel;
use think\Db;
use think\Cookie;

/**
 * @SWG\Tag(
 * name="Liked",
 * description="口碑点评 点赞"
 * )
 */

/**
 * @SWG\Definition(required={"LikedId"})
 */
class Liked extends OpinionBase
{

    /**
     * @SWG\Property(type="integer", description="点赞 ID")
     */
    public $LikedId;

    /**
     * @SWG\Property(type="integer", description="点赞者")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="string", description="游客标识")
     */
    public $TouristMark;


    /**
     * @SWG\Property(type="integer", description="口碑点评的Id")
     */
    public $OpinionId;

    /**
     * @SWG\Property(type="integer", description="点赞或取消(1正常，2取消)")
     */
    public $Status;


    /**
     * @SWG\Property(type="string", description="点赞时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="点赞时间")
     */
    public $ModifiedTime;


    public static function Liked($Liked)
    {
        if (empty ($Liked)) {
            exception('非法请求-0', 412);
        }
            $Status = Liked::where(['OpinionId' => $Liked['OpinionId'], 'PassportId' => $Liked['PassportId']])->value('Status');
        if ($Status) {
            if ($Status == 1) {
                $update = Liked::where(['OpinionId' => $Liked['OpinionId'], 'PassportId' => $Liked['PassportId']])->setInc('Status');
                if (empty($update)) {
                    return false;
                }
                $setDec = Opinion::where('OpinionId', $Liked['OpinionId'])->setDec('LikedCount');
                if (empty($setDec)) {
                    return false;
                }
                return true;

            } else {
                $update = Liked::where(['OpinionId' => $Liked['OpinionId'], 'PassportId' => $Liked['PassportId']])->setDec('Status');
                if (empty($update)) {
                    return false;
                }
                $setInc = Opinion::where('OpinionId', $Liked['OpinionId'])->setInc('LikedCount');
                if (empty($setInc)) {
                    return false;
                }
                return true;
            }
        } else {
                $create = new Liked($Liked);
                $create->allowField(true)->save();
                if (empty($create)) {
                    return false;
                }
            $setInc = Opinion::where('OpinionId', $Liked['OpinionId'])->setInc('LikedCount');
            if (empty($setInc)) {
                return false;
            }
            return true;
        }
    }

        //游客点赞
        public static function TouristMarkLiked($Liked)
        {
        if (empty ($Liked)) {
            exception('非法请求-0', 412);
        }


        if (Cookie::has('TouristMark') ) {
            $new =Cookie::get('TouristMark').'_'.$Liked['OpinionId'];
            if(Cookie::has($new)){
                $Status =  Cookie::get($new);
                if ($Status == 1) {
                    Cookie::set($new,2,24 * 60 * 60);
                    $setDec = Opinion::where('OpinionId', $Liked['OpinionId'])->setDec('LikedCount');
                    if (empty($setDec)) {
                        return false;
                    }
                    return true;

                } else {
                    Cookie::set($new,1,24 * 60 * 60);
                    $setInc = Opinion::where('OpinionId', $Liked['OpinionId'])->setInc('LikedCount');
                    if (empty($setInc)) {
                        return false;
                    }
                    return true;
                }
            }else{
                Cookie::set($new, 1, 24 * 60 * 60);
                $setInc = Opinion::where('OpinionId', $Liked['OpinionId'])->setInc('LikedCount');
                if (empty($setInc)) {
                    return false;
                }
                return true;
            };

        } else {

                $chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                $username = "";
                for ($i = 0; $i < 6; $i++) {
                    $username .= $chars[mt_rand(0, (strlen($chars))-1)];
                }
                $TouristMark = strtoupper(base_convert(time() - 1420070400, 10, 36)) . $username;
                Cookie::set('TouristMark', $TouristMark, 24 * 60 * 60);
                Cookie::set($TouristMark."_".$Liked['OpinionId'], 1, 24 * 60 * 60);
            $setInc = Opinion::where('OpinionId', $Liked['OpinionId'])->setInc('LikedCount');
            if (empty($setInc)) {
                return false;
            }
            return true;
        }



    }


}
