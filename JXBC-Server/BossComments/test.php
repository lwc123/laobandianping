<?php
header("content-Type: text/html; charset=utf-8");
$cookie_file = tempnam('./temp','cookie');
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
    curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);

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
function getImg($url){ //图片地址 生成图片的名字
    //判断图片的url是否为空，如果为空停止函数
    if($url == '')
    {
        return 1;
    }

    //取得图片的扩展名，存入变量$ext中
    $pathinfo = pathinfo($url);           //最后一次出现的位置到字符结尾的字符串 $ext = strrchr($url,'.');
    $ext = $pathinfo['extension'];
    $filename = time().rand(1,10).'.'.$ext;
    //判断是否是合法的图片文件
    if($ext!='gif' && $ext!='jpg' && $ext!='png'){
        return 2;
    }

    //读取图片
    $img=file_get_contents($url);
    //写入图片
    file_put_contents($filename,$img);

    /*返回图片的新文件名*/
    return $filename;
}
//模拟登陆
//设置post的数据
/*$post = array (
    'account' => '17710879104',
    'password' => 'LWC17710879104',
    'randomKey'=>'r98Qbtd7YHeUVqoHMk3ECufGUDJq07Mp',
    'redirect'=>'http://www.kanzhun.com/'
);
$a=curl('http://www.kanzhun.com/login.json',"POST",$post,$setcookie=false,$cookie_file=false);*/
//echo $a;
//die;
$CompanyAll=[];
//for($i=61661;$i<61664;$i++){

    $Company = array();
      $html=file_get_contents("http://www.kanzhun.com/gsr61661.html");
   // $html=curl("http://www.kanzhun.com/gsr61661.html?ka=com-blocker1-review#co_tab");
     //$html=curl("http://www.kanzhun.com/gsr".$i.".html?ka=com-blocker1-review#co_tab");
    //$html=curl("http://www.kanzhun.com/gsr7113400html?ka=left-review-list#co_tab");
   // print_r($html);die;
    //评分和关注数
    $ScoreRule='#<section class="com_header".*</section>#isU';
preg_match($ScoreRule,$html,$result);
//print_r($result);die;
    if(preg_match($ScoreRule,$html,$result)){
        $ScoreRule2 = '#<em>(.*)<div class="star_box">.*<span>(.*)</span>.*<span>(.*)</span>.*<span>(.*)</span>.*<div class="bw_brief" .*>(.*)<span class="more">.*<a ka="companyHeader-pk" href=".*" class="js-pk" data-id="(.*)">.*<em class="follow_num" .*>(.*)</em>#isU';
        if (preg_match_all($ScoreRule2, $result[0], $result2)) {
            //print_r($result2);die;
            $Company['CompanyScore'] = $result2[1][0];
            $Company['Industry'] = $result2[2][0];
            $Company['Location'] = $result2[3][0];
            $Company['CompanySize'] = $result2[4][0];
            $Company['AWordIntroduce'] = $result2[5][0];
            $Company['CompanyId'] = $result2[6][0];
            $Company['AttentionMum'] = $result2[7][0];
        }

        //公司基本信息
        $rule1 = '#<div class="co_profile">.*<div class="list_l clearfix">#isU';
        preg_match($rule1, $html, $result);
        $rule2 = '#<div class="logo t_center">.*<img src="(.*)" alt="logo">.*<div class="co_name t_center">(.*)</div>.* <div class="co_base">(.*) </div>.*成立时间(.*)</em>.*<em>(.*)</em>.*&nbsp;(.*)</em>.*公司地址(.*)</div>.*<div class="all_big_photos">(.*)</div>.*<div class="photo_num">.*<div class="co_info">(.*)</div>.*<div class="co_intro co_product_intro t_center">.*<li>(.*)</ul>#isU';
        if (preg_match_all($rule2, $result[0], $result2)) {
           // print_r($result2[3]);die;
            $Company['CompanyLog'] = $result2[1][0];
            $Company['CompanyAbbr'] = $result2[2][0];
            $Company['CompanyCreatedTime'] = $result2[4][0];
            $Company['Region'] = $result2[5][0];
            $Company['CEO'] = $result2[6][0];
            $Company['Companyaddr'] = $result2[7][0];
            $CommentRule3 = '#<img .* src="(.*)" alt="">.*#isU';
            foreach ($result2[8] as $key => $val) {
                if (preg_match_all($CommentRule3, $val, $result3)) {
                    foreach ($result3[1] as $key => $val) {
                        $Company['CompanyPhoto'][] = $val;
                    }
                }
            }
            $Company['CompanyInfo'] = $result2[9][0];
            //$Company['Companyproduct']= $result2[12][0];
            $CommentRule3 = '#<p class="mt30 t_center f_bold">(.*)</p>.*<p>(.*)</p>#isU';
            foreach ($result2[10] as $key => $val) {
                if (preg_match_all($CommentRule3, $val, $result4)) {
                    foreach ($result4[1] as $key => $val) {
                        $Company['Companyproduct'][] = array($result4[1][$key], $result4[2][$key]);
                    }
                }
            }
        //$CompanyAll[] = $Company;
        //print_r($result2);die;
    }
}
/*   }else{
       continue;
   }*/
print_r($Company);die;


  /*  //员工评价
    $Comment = array();
  // $html=file_get_contents("4.html");
  $html=curl("http://www.kanzhun.com/pl209494.html?ka=comsumreview-blocker3-reviewname6",$method='GET',$data=array(),$setcookie=true,$cookie_file=true);
    $CommentRule='#<section class="qa_item review_item wrap_style">.*</section>#isU';
    preg_match($CommentRule,$html,$result);
//print_r($result);die;
    $CommentRule2='# <p class="f_14 grey_99 dd_bot">(.*)-(.*)-(.*)</p>.*<span class="desc">(.*)</h1>.*</p>(.*)</article>.*<em>(.*)</em>.*<div class="rdrc_center">.*我(.*)推荐.*我(.*)公司.*我(.*)持#isU';

if( preg_match_all($CommentRule2,$result[0],$result2)){
   print_r($result2);die;
    $Comment['CommentIdentity']=$result2[1][0];
    $Comment['JobYears']=$result2[2][0];
    $Comment['JobCity']=$result2[3][0];
    $Comment['CommentTitle']=$result2[4][0];
   // $Comment['CommentContent']=$result2[5][0];
    $Comment['CommentScore']=$result2[6][0];
    $CommentRule4='#</em>(.*)</div>.*<div class="question_content">(.*)</div>#isU';
    $CommentRule5='#<div class="question_content">(.*)</div>#isU';
    foreach($result2[5] as $key => $val){
       if(preg_match_all($CommentRule4,$val,$result4)){

            foreach($result4[1] as $key => $val) {
                ///print_r($val);die;
                $Comment['CommentContent'][]= array($result4[1][$key],$result4[2][$key]);
            }
           $Comment['CommentTemplate']= 1;
        }

        if(preg_match_all($CommentRule5,$val,$result5)){
            //print_r($result5);die;
            foreach($result5[1] as $key => $val) {
              //  print_r($val);die;
                $Comment['CommentContent'][]= $val;
            }
            $Comment['CommentTemplate']= 2;
        }

    }
 //   print_r(   $Comment['CommentContent']);die;

    if($result2[7][0] == "愿意"){
        $Comment['RecommendFriends']=1;
    }else{
        $Comment['RecommendFriends']=0;
    }
    if($result2[8][0] == "看好"){
        $Comment['GoodProspects']=1;
    }else{
        $Comment['GoodProspects']=0;
    }
    if($result2[9][0] == "支"){
        $Comment['SupportCEO']=1;
    }else{
        $Comment['SupportCEO']=0;
    }
}

  //评论回复

    //$html=file_get_contents("http://www.kanzhun.com/pl209494.html?ka=comsumreview-blocker3-reviewname6");
    $CommentRule='#<section class="detail_comment mt15">.*</section>#isU';
    preg_match($CommentRule,$html,$result);
    //print_r($result);die;
    $CommentRule2='#<div class="wrap_style detail_comments_con">.*<input type="hidden" name="companyId" value="(.*)" />.*<input type="hidden" name="originId" value="(.*)" />.*<ul class="comment_list" id="reviewsWrapper">(.*)</ul>#isU';

     preg_match_all($CommentRule2,$result[0],$result3);
    //print_r($result3);die;
    $Comment['CompanyId']=$result3[1][0];
    $Comment['OriginId']=$result3[2][0];
    print_r($Comment);
    $CommentRule3='#<li>.*<em>(.*)</em>.*<time>(.*)</time>.*<p class="user_c_content">(.*)</p>#isU';
    $ReplyContent=[];
    $ReplyContent['OriginId']=$result3[2][0];
    foreach($result2[3] as $key => $val) {
        if (preg_match_all($CommentRule3, $val, $result2)){
        foreach ($result2[1] as $key => $val) {
            $ReplyContent[$key]["ReplyName"] = $result2[1][$key];
            $ReplyContent[$key]["ReplyTime"] = $result2[2][$key];
            $ReplyContent[$key]["ReplyContent"] = $result2[3][$key];
        }
    }
    }
    print_r($ReplyContent);*/







//print_r($Company);
echo '哈哈';

?>