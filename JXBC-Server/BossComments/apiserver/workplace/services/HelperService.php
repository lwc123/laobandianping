<?php

namespace app\workplace\services;


class HelperService {

    public static function page($page,$size){

        empty($size) ? $size = 10 : $size = intval($size);
        empty($page) ? $page = 1 : $page = intval($page);
        $start = ($page * $size) - $size;

        return array('start'=>$start,'size'=>$size);
    }

    public static function validateCompanyId($company_id){

        if (empty($company_id)) {

            exception ( 'CompanyId is null', 412 );
        }
    }


    public static function validateBaseImg($img){

        if (empty($img)) {

            exception ( 'Img is null', 412 );
        }
    }
}