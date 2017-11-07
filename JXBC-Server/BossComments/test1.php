<?php
header("content-Type: text/html; charset=utf-8");
    function getHTTPS($url) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
        curl_setopt($ch, CURLOPT_HEADER, false);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_REFERER, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
        $result = curl_exec($ch);
        curl_close($ch);
        return $result;
    }
       //$html=getHTTPS("1.html");
     $html=getHTTPS("https://www.lagou.com/gongsi/104085.html");
      //print_r($html);die;
    //公司名字
    $rule1="/<div class=\"company_main\">.*<\/div>/iUs";
    preg_match($rule1,$html,$result);

    $AuditStatusRule="/<span>(.*)<\/span>/iUs";
    preg_match_all($AuditStatusRule,$result[0],$AuditStatus);
//print_r($AuditStatus);die;
if($AuditStatus[1][0] == '拉勾认证'){
    $Companyrule2="/<a href=\"(.*)\" class=\"hovertips\" .* title=\"(.*)\">(.*)<\/a>/iUs";
    preg_match_all($Companyrule2,$result[0],$CompanyArr1);
    $Company=[];
    print_r($CompanyArr1);die;
    $Company['CompanyArr']=$CompanyArr1[3][0];
    $Company['CompanyName']=$CompanyArr1[2][0];
    $rule3="/div class=\"popular_recom hide-recom\">.*<div class=\"company_managers item_container\" .*>/iUs";
    preg_match($rule3,$html,$result2);
    //print_r($result);die;
    //公司基本信息
    $rule4="/<span>.*<\/span>/iUs";
    preg_match_all($rule4,$result2[0],$arr2);
    $Company['Industry']=$arr2[0][0];
    $Company['CompanySize']=$arr2[0][2];
    $Company['Region']=$arr2[0][3];
    print_r($Company);
}else{
    echo '未认证';
}






//print_r($Company);


?>  