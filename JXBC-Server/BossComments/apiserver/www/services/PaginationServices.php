<?php

namespace app\www\services;

class PaginationServices {
    /**
     * @param $pagination
     * @param $seachvalue
     * @param $action
     * @return string
     */
    public static function getPagination($pagination,$seachvalue,$action ){
        //获取总页数
        $pages = ceil($pagination->TotalCount / $pagination->PageSize);
        $PageIndex = $pagination->PageIndex;
        $url=$action.'?'.$seachvalue;
        $pageHtml=PaginationServices::getPageHtml($PageIndex,$pages,$url);
        return $pageHtml;
    }

    /**
     * 获取分页的HTML内容
     * @param integer $page 当前页
     * @param integer $pages 总页数
     * @param string $url 跳转url地址    最后的页数以 '&page=x' 追加在url后面
     *
     * @return string HTML内容;
     */
    public static function getPageHtml($page, $pages, $url){
        //最多显示多少个页码
        $_pageNum = 5;
        //当前页面小于1 则为1
        $page = $page<1?1:$page;
        //当前页大于总页数 则为总页数
        $page = $page > $pages ? $pages : $page;
        //页数小当前页 则为当前页
        $pages = $pages < $page ? $page : $pages;

        //计算开始页
        $_start = $page - floor($_pageNum/2);
        $_start = $_start<1 ? 1 : $_start;
        //计算结束页
        $_end = $page + floor($_pageNum/2);
        $_end = $_end>$pages? $pages : $_end;

        //当前显示的页码个数不够最大页码数，在进行左右调整
        $_curPageNum = $_end-$_start+1;
        //左调整
        if($_curPageNum<$_pageNum && $_start>1){
            $_start = $_start - ($_pageNum-$_curPageNum);
            $_start = $_start<1 ? 1 : $_start;
            $_curPageNum = $_end-$_start+1;
        }
        //右边调整
        if($_curPageNum<$_pageNum && $_end<$pages){
            $_end = $_end + ($_pageNum-$_curPageNum);
            $_end = $_end>$pages? $pages : $_end;
        }

        $_pageHtml = '';
        if($_start == 1){

        }else{
         $_pageHtml .= '<a  title="第一页" href="'.$url.'&page=1">首页</a>';
        }
        if($page>1){
            $_pageHtml .= '<a class="up" title="上一页" href="'.$url.'&page='.($page-1).'">«</a>';
        }
        for ($i = $_start; $i <= $_end; $i++) {
            if($i == $page){
                $_pageHtml .= '<a class="bg">'.$i.'</a>';
            }else{
                $_pageHtml .= '<a class="up" href="'.$url.'&page='.$i.'">'.$i.'</a>';
            }
        }
        if($page<$_end){
            $_pageHtml .= '<a  title="下一页" href="'.$url.'&page='.($page+1).'">»</a>';
        }
        if($_end == $pages){
            $_pageHtml .= '';
        }else{
            $_pageHtml .= '<a  title="最后一页" href="'.$url.'&page='.$pages.'">末页</a>';
        }
        $_pageHtml .= '';
        return $_pageHtml;

    }
}


