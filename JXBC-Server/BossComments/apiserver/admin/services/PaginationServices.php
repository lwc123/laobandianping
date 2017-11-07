<?php

namespace app\admin\services;

use think\db;

class PaginationServices {

    public static function getPagination($pagination,$seachvalue,$action ){
        //获取总页数
        $pages = ceil($pagination->TotalCount / $pagination->PageSize);
        $PageIndex = $pagination->PageIndex;
        //获取上下页
        $PreviousPpage = $PageIndex - 1 <= 1 ? 1 : $PageIndex - 1;
        $nextPpage = $PageIndex + 1 >= $pages ? $pages : $PageIndex + 1;

        if ($PageIndex < 6) {
            $count = 1;
        } else {
            $count = $PageIndex - 5;
        }

        $disabledPrevious = $PageIndex==1?"disabled":"";
        $disabledNext = $PageIndex>=$nextPpage?"disabled":"";
        $pageHtml = "";
        $pageHtml .= "<li class='paginate_button previous $disabledPrevious'><a href='$action?page=1&$seachvalue'>Previous</a></li>";
        for ($i = $count; $i <= $pages; $i++) {
            if ($i < $count + 8) {
                if ($i == $PageIndex) {
                    $pageHtml .= "<li class='paginate_button active disabled'><a href=$action?page=$i&$seachvalue'>$PageIndex</a></li>";
                } else {
                    $pageHtml .= "<li class='paginate_button'><a href='$action?page=$i&$seachvalue'>$i</a></li>";
                }
            }
        }
        $pageHtml .= "<li class='paginate_button next $disabledNext'><a href='$action?page=$nextPpage&$seachvalue'>Next</a></li>";
        return $pageHtml;
    }
}