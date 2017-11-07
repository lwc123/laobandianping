<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 流年 <liu21st@gmail.com>
// +----------------------------------------------------------------------

//解析BASE图片保存在业务文件夹
function ImageFile($base64_url,$id,$business) {

		$new_file = '../'.$business.'/' . date ( 'Ymd', time () ) . '/'.fmod($id,256).'/';
		if (! file_exists ( $new_file )) {
			// 检查是否有该文件夹，如果没有就创建，并给予最高权限
			mkdir ( $new_file, 0700, true );
		}
		$file_name = $new_file . date ( 'Ymdhms', time () )  . rand(10,100).'.jpg';
		if (file_put_contents ( $file_name, base64_decode ( $base64_url ) )) {
			$image =str_replace("../","/",$file_name) ;
			return $image;
		}
	 
}