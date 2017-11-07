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

// 应用公共函数文件

/**
 * 模拟post进行url请求
 *
 * @param string $url
 * @param array $post_data
 */
use think\config;
use app\appbase\models\PayWays;
use app\appbase\models\BizSources;
use app\common\modules\DbHelper;

function base64EncodeImage ($image_file) {
    $image = $image_file["tmp_name"];
    $fp = fopen($image, "r");
    $file = fread($fp, $image_file["size"]); //二进制数据流
    $Picture =base64_encode($file) ;
    return $Picture;
}


function exist_file($url)
{
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    //不下载
    curl_setopt($ch, CURLOPT_NOBODY, 1);
    //设置超时
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 3);
    curl_setopt($ch, CURLOPT_TIMEOUT, 3);
    curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    if ($http_code == 200) {
        //$size = getimagesize($url);
        return myGetImageSize($url,'curl',false);
    }
    return false;
}

/**
 * 获取远程图片的宽高和体积大小
 *
 * @param string $url 远程图片的链接
 * @param string $type 获取远程图片资源的方式, 默认为 curl 可选 fread
 * @param boolean $isGetFilesize 是否获取远程图片的体积大小, 默认false不获取, 设置为 true 时 $type 将强制为 fread
 * @return false|array
 */
function myGetImageSize($url, $type = 'curl', $isGetFilesize = false)
{
    // 若需要获取图片体积大小则默认使用 fread 方式
    $type = $isGetFilesize ? 'fread' : $type;

    if ($type == 'fread') {
        // 或者使用 socket 二进制方式读取, 需要获取图片体积大小最好使用此方法
        $handle = fopen($url, 'rb');

        if (! $handle) return false;

        // 只取头部固定长度168字节数据
        $dataBlock = fread($handle, 168);
    }
    else {
        // 据说 CURL 能缓存DNS 效率比 socket 高
        $ch = curl_init($url);
        // 超时设置
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);
        // 取前面 168 个字符 通过四张测试图读取宽高结果都没有问题,若获取不到数据可适当加大数值
        curl_setopt($ch, CURLOPT_RANGE, '0-10000');
        // 跟踪301跳转
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
        // 返回结果
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

        $dataBlock = curl_exec($ch);

        curl_close($ch);

        if (! $dataBlock) return false;
    }

    // 将读取的图片信息转化为图片路径并获取图片信息,经测试,这里的转化设置 jpeg 对获取png,gif的信息没有影响,无须分别设置
    // 有些图片虽然可以在浏览器查看但实际已被损坏可能无法解析信息
    $size = getimagesize('data://image/jpeg;base64,'. base64_encode($dataBlock));
    if (empty($size)) {
        return false;
    }

    $result = $size[0].'x'.$size[1];

    // 是否获取图片体积大小
    if ($isGetFilesize) {
        // 获取文件数据流信息
        $meta = stream_get_meta_data($handle);
        // nginx 的信息保存在 headers 里，apache 则直接在 wrapper_data
        $dataInfo = isset($meta['wrapper_data']['headers']) ? $meta['wrapper_data']['headers'] : $meta['wrapper_data'];

        foreach ($dataInfo as $va) {
            if ( preg_match('/length/iU', $va)) {
                $ts = explode(':', $va);
                $result['size'] = trim(array_pop($ts));
                break;
            }
        }
    }

    if ($type == 'fread') fclose($handle);

    return $result;
}

//随机数
function randomkeys($length){
    $output='';
    for ($a = 0; $a<$length; $a++) {
        $output .= chr(mt_rand(33, 126));    //生成php随机数
    }
    return $output;
}

// 评价分值区间显示不同内容
function achievement($number) {
	if ($number > 89 && $number <= 100) {
		return "非常<br/>优秀";
	} elseif ($number > 79 && $number <= 89) {
		return "良好";
	} elseif ($number > 59 && $number <= 79) {
		return "一般";
	} elseif ($number > 29 && $number <= 59) {
		return "差";
	} elseif ($number >= 0 && $number <= 29) {
		return "极差";
	}
}

// 评价分值区间显示不同内容-PC端
function achievementPc($number) {
    if ($number > 89 && $number <= 100) {
        return "很优秀";
    } elseif ($number > 79 && $number <= 89) {
        return "良好";
    } elseif ($number > 59 && $number <= 79) {
        return "一般";
    } elseif ($number > 29 && $number <= 59) {
        return "差";
    } elseif ($number >= 0 && $number <= 29) {
        return "极差";
    }
}

//PHP stdClass Object转array  
/**
 * 对象数组转为普通数组
 *
 * AJAX提交到后台的JSON字串经decode解码后为一个对象数组，
 * 为此必须转为普通数组后才能进行后续处理，
 * 此函数支持多维数组处理。
 *
 * @param array
 * @return array
 */
function objarray_to_array($obj) {
    $ret = array();
    foreach ($obj as $key => $value) {
    if (gettype($value) == "array" || gettype($value) == "object"){
            $ret[$key] =  objarray_to_array($value);
    }else{
        $ret[$key] = $value;
    }
    }
    return $ret;
}

// 邀请CODE生成
function createCode($PasspostId, $CompanyId=null) {
	$currentTime = time ();
	$code = "C{$CompanyId}P{$PasspostId}T{$currentTime}";
	$code=md5($code);
	return $code;
}

// 解析企业邀请CODE生成
function matchCode($code) {
	$b = preg_match_all ( '/\d+/', $code, $codearr );
	if ($b) {
		print_r ( $codearr [0] );
	}
}

// 离职报告CODE生成
function CommentCode($CompanyId,$ArchiveId,$CommentId) {
	$code = "BG{$CompanyId}{$ArchiveId}{$CommentId}". rand ( 10, 1000 );
	return $code;
}

// 解析BASE图片保存在业务文件夹
function AppFile($base64_url, $business) {
	$new_file = '../'. $business . '/' . date ( 'Ymd', time () ) . '/';
	if (! file_exists ( $new_file )) {
		// 检查是否有该文件夹，如果没有就创建，并给予最高权限
		mkdir ( $new_file, 0700, true );
	}
	$file_name = $new_file . date ( 'Ymdhms', time () ) . rand ( 10, 100 ) . '.jpg';
	if (file_put_contents ( $file_name, base64_decode ( $base64_url ) )) {
		$image = str_replace ( "../", "/", $file_name );
		return $image;
	}
}

// 计算年龄
function countage($birthday) {
	$age = strtotime ( $birthday );
	if ($age === false) {
		return false;
	}
	list ( $y1, $m1, $d1 ) = explode ( "-", date ( "Y-m-d", $age ) );
	$now = strtotime ( "now" );
	list ( $y2, $m2, $d2 ) = explode ( "-", date ( "Y-m-d", $now ) );
	$age = $y2 - $y1;
	if (( int ) ($m2 . $d2) < ( int ) ($m1 . $d1))
		$age -= 1;
	return $age;
}

// 解析BASEMP3保存在业务文件夹
function VoiceFile($base64_url, $business) {
	$new_file = '../' . $business . '/' . date ( 'Ymd', time () ) . '/';
	if (! file_exists ( $new_file )) {
		// 检查是否有该文件夹，如果没有就创建，并给予最高权限
		mkdir ( $new_file, 0700, true );
	}
	$file_name = $new_file . date ( 'Ymdhms', time () ) . rand ( 10, 100 ) . '.mp3';
	if (file_put_contents ( $file_name, base64_decode ( $base64_url ) )) {
		$image = str_replace ( "../", "/", $file_name );
		return $image;
	}
}

// 根据身份证号，自动返回性别
function get_xingbie($cid) {
	$sexint = ( int ) substr ( $cid, 16, 1 );
	if (($sexint % 2) == 0) {
		$sexint = '女';
	} else {
		$sexint = '男';
	}
	return ($sexint);
}

// 检查是否是身份证号
function isIdCard($number) {
	// 转化为大写，如出现x
	$number = strtoupper ( $number );
	// 加权因子
	$wi = array (
			7,
			9,
			10,
			5,
			8,
			4,
			2,
			1,
			6,
			3,
			7,
			9,
			10,
			5,
			8,
			4,
			2
	);
	// 校验码串
	$ai = array (
			'1',
			'0',
			'X',
			'9',
			'8',
			'7',
			'6',
			'5',
			'4',
			'3',
			'2'
	);
	// 按顺序循环处理前17位
	$sigma = 0;
	for($i = 0; $i < 17; $i ++) {
		// 提取前17位的其中一位，并将变量类型转为实数
		$b = ( int ) $number {$i};

		// 提取相应的加权因子
		$w = $wi [$i];

		// 把从身份证号码中提取的一位数字和加权因子相乘，并累加
		$sigma += $b * $w;
	}
	// 计算序号
	$snumber = $sigma % 11;

	// 按照序号从校验码串中提取相应的字符。
	$check_number = $ai [$snumber];

	if ($number {17} == $check_number) {
		return true;
	} else {
		return false;
	}
}

// 用php从身份证中提取生日,包括位和位身份证
function getIDCardInfo($IDCard, $format = 1) {
	$result ['error'] = 0; // 0：未知错误，1：身份证格式错误，2：无错误
	$result ['flag'] = ''; // 0标示成年，1标示未成年
	$result ['tdate'] = ''; // 生日，格式如：2012-11-15
	if (! preg_match ( "/^(\d{15}$|^\d{18}$|^\d{17}(\d|X|x))$/", $IDCard )) {
		$result ['error'] = 1;
		return $result;
	} else {
		if (strlen ( $IDCard ) == 18) {
			$tyear = intval ( substr ( $IDCard, 6, 4 ) );
			$tmonth = intval ( substr ( $IDCard, 10, 2 ) );
			$tday = intval ( substr ( $IDCard, 12, 2 ) );
		} elseif (strlen ( $IDCard ) == 15) {
			$tyear = intval ( "19" . substr ( $IDCard, 6, 2 ) );
			$tmonth = intval ( substr ( $IDCard, 8, 2 ) );
			$tday = intval ( substr ( $IDCard, 10, 2 ) );
		}

		if ($tyear > date ( "Y" ) || $tyear < (date ( "Y" ) - 100)) {
			$flag = 0;
		} elseif ($tmonth < 0 || $tmonth > 12) {
			$flag = 0;
		} elseif ($tday < 0 || $tday > 31) {
			$flag = 0;
		} else {
			if ($format) {
				$tdate = $tyear . "-" . $tmonth . "-" . $tday;
			} else {
				$tdate = $tmonth . "-" . $tday;
			}

			if ((time () - mktime ( 0, 0, 0, $tmonth, $tday, $tyear )) > 18 * 365 * 24 * 60 * 60) {
				$flag = 0;
			} else {
				$flag = 1;
			}
		}
	}
	$result ['error'] = 2; // 0：未知错误，1：身份证格式错误，2：无错误
	$result ['isAdult'] = $flag; // 0标示成年，1标示未成年
	$result ['birthday'] = $tdate; // 生日日期
	return $result;
}
// 用php从身份证中提取籍贯
function getIDCardarea($IDCard){
	//截取前两位数
	$index = substr($IDCard,0,2);
	$area = array(
			11 => "北京",
			12 => "天津",
			13 => "河北",
			14 => "山西",
			15 => "内蒙古",
			21 => "辽宁",
			22 => "吉林",
			23 => "黑龙江",
			31 => "上海",
			32 => "江苏",
			33 => "浙江",
			34 => "安徽",
			35 => "福建",
			36 => "江西",
			37 => "山东",
			41 => "河南",
			42 => "湖北",
			43 => "湖南",
			44 => "广东",
			45 => "广西",
			46 => "海南",
			50 => "重庆",
			51 => "四川",
			52 => "贵州",
			53 => "云南",
			54 => "西藏",
			61 => "陕西",
			62 => "甘肃",
			63 => "青海",
			64 => "宁夏",
			65 => "新疆",
			71 => "台湾",
			81 => "香港",
			82 => "澳门",
			91 => "国外"
	);
	return $area[$index];
}


function toLocalDateTime($date, $format=null) {
    if(empty($format)) {
        $format = "Y年m月d日";
    }

    if(is_string($date) && strrchr($date,'Z')=="Z") {
        return (new \DateTime($date, timezone_open('UTC')))->setTimezone(timezone_open(Config::get('default_timezone')))->format( $format);
    }
    return $date;
}

function formatBossNickname($realName) {
    return $realName;
}

function getPayWayName($payWay, $payRoute){
    $name = "11";
    switch ($payWay){
        case PayWays::Alipay :
            $name = "支付宝";
            break;
        case PayWays::Wechat :
            $name = "微信";
            break;
        case PayWays::Wallet :
            $name = "金库";
            break;
        case PayWays::System :
            $name = "系统";
            break;
        default:
            $name = "微信方式";
            break;
    }

    if(!empty($payRoute)){
        $name = $name."：".($payRoute == PayWays::Route_QRCODE?"二维码":$payRoute);
    }
    return $name;
}
function getBizSource($bizSource){
    switch ($bizSource){
        case BizSources::Deposit :
            return "充值";
        case BizSources::Withdraw :
            return "提现";
        case BizSources::WithdrawRefund :
            return "提现退款";
        case BizSources::OpenEnterpriseService :
            return "开通企业服务";
        case BizSources::ShareIncomeForOpenEnterpriseService :
            return "【分成】开通企业服务";
        case BizSources::OpenEnterpriseGift :
            return "开通企业时赠送";
        case BizSources::BuyBackgroundSurvey :
            return "购买背景调查";
        case BizSources::SellBackgroundSurvey :
            return "【分成】销售背景调查";
        case BizSources::OpenPersonalService :
            return "开通个人服务";
        default:
            return "未知数据";
    }
}
//时间转换
function getDealTime($CreatedTime)
{
    $zero1 = strtotime(date("Y-m-d H:i:s"));
    $zero2 = strtotime(DbHelper::toLocalDateTime($CreatedTime));
    $date = floor(($zero1 - $zero2) / 86400);
    if ($date < 1) {
        $hour = floor(($zero1 - $zero2) % 86400 / 3600);
        if ($hour < 1) {
            $minute = floor(($zero1 - $zero2) % 86400 / 60);
            if ($minute > 1) {
                $Time = $minute . '分钟前';
            } else {
                $Time = '刚刚';
            }
        } else {
            $Time = $hour . '小时前';
        }
    } elseif ($date == 1) {
        $Time = $date . '天前';
    } else {
        $Time = toLocalDateTime($CreatedTime,'Y-m-d');
    }
    return $Time;
}


//正则匹配时间
function preg_match_Time($CreatedTime)
{
    $pattern = "/^[1-2][0-9][0-9][0-9]-[0-1]{0,1}[0-9]-[0-3]{0,1}[0-9]$/";
    if (preg_match($pattern, $CreatedTime)) {
        return  true;
    }else{
        return  false;
    }

}
