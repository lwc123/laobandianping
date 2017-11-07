<?php
function  curl($url,$method='GET',$data=array(),$setcookie=false,$cookie_file=false){
    //1.初始化
    $ch = curl_init();
    //2.请求地址
    curl_setopt($ch, CURLOPT_URL, $url);
    //3.请求方式
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    if($method=="POST")//post方式的时候添加数据
    {
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    }
    //4.如果设置要请求的cookie，那么把cookie值保存在指定的文件中
    if($setcookie==true)
    {
        curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file);
    }
    else//就从文件中读取cookie的信息
    {
        curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file);
    }
    //5.模拟浏览器利用$_SERVER['HTTP_USER_AGENT'],可以获取
    //Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36  谷歌
    //Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.104 Safari/537.36 Core/1.53.2372.400 QQBrowser/9.5.10548.400   QQ
    //Mozilla/5.0 (Windows NT 6.1; WOW64; rv:51.0) Gecko/20100101 Firefox/51.0  火狐
    //Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html）  ni
    curl_setopt($ch, CURLOPT_USERAGENT,'Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html）');

    //6.在curl后面加上Accept-Encoding: gzip，再用gzip解压缩，则基本上可以保存数据不乱码。
    //设置 HTTP 头字段的数组。格式： array('Content-type: text/plain', 'Content-length: 100')
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Accept-Encoding:gzip'));
    //HTTP请求头中"Accept-Encoding: "的值。 这使得能够解码响应的内容。 支持的编码有"identity"，"deflate"和"gzip"。如果为空字符串""，会发送所有支持的编码类型。
    curl_setopt($ch, CURLOPT_ENCODING, "gzip");

    //7.把一个头包含在输出中，设置这个选项为一个非零值。
    curl_setopt($ch, CURLOPT_HEADER, 0);
    //8.TRUE 将curl_exec()获取的信息以字符串返回，而不是直接输出。
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

    //参数如下禁止服务器端的验证
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
    //伪装请求来源，绕过防盗
    //curl_setopt($ch,CURLOPT_REFERER,"http://wthrcdn.etouch.cn/");
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($ch, CURLOPT_AUTOREFERER, 1);

    $tmpInfo = curl_exec($ch);//获取html内容
    if (curl_errno($ch))
    {
        return curl_error($ch);
    }
    curl_close($ch);
    return $tmpInfo;
}


$a=  date('Y-m-d H:i:s');
$num=53;
for($i=61747;$i<61847;$i++ ){
    $url="http://www.kanzhun.com/gsr".$i.".html";
    echo $url;
    $html=curl($url);
    $ScoreRule='#<title>(.*)</title>#isU';
    preg_match_all($ScoreRule,$html,$result);
    print_r($result) ;
    die;
    if($result[1][0]!='404错误页'){

        file_put_contents("E://home/Company/gongsi-$num.html",$html);
        $num++;

    }
    $number = rand(20000,50000);
    usleep($number);
}
echo '<br>';
$b= date('Y-m-d H:i:s');
$array=$a."\n".$b;
file_put_contents("E://home/Company/time.txt",$array);


