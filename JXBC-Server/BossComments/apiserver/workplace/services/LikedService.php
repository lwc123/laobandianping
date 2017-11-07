<?php

namespace app\workplace\services;

use app\workplace\models\BossDynamic;
use app\workplace\models\Liked;

class LikedService {

    public static function likedAction($passport_id,$res_id){

        $is_liked = Liked::where('PassportId',$passport_id)->where('ResId',$res_id)->value('LikedId');

        if (empty($is_liked)){

            $liked_data = array('PassportId'=>$passport_id,'ResId'=>$res_id,'Type'=>1);
            $addliked = Liked::create($liked_data);

            if (!empty($addliked->LikedId)){

                $set_status = BossDynamic::where('DynamicId', intval($res_id))->setInc('LikedNum',1);

                if (empty($set_status)){

                    return false;

                }else{

                    return true;
                }

            }else{

                return false;
            }

        }else{

            $set_status = Liked::where('PassportId',$passport_id)->where('ResId',$res_id)->delete();

            if (empty($set_status)){

                return false;

            }else{

                BossDynamic::where('DynamicId', intval($res_id))->setDec('LikedNum',1);

                return true;
            }
        }

    }

    public static function isLikedDynamicById($dynamic_id,$passport){

        $liked_id = Liked::where('PassportId',$passport)->where('ResId',$dynamic_id)->value('LikedId');

        if (empty($liked_id)){

            return false;

        }else{

            return true;
        }
    }


}