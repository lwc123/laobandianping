<?php
// +----------------------------------------------------------------------
// | （线上）生产环境
// +----------------------------------------------------------------------

return [

    // 错误处理
    'show_error_msg'    => false,

    //资源文件根目录
    'resources_site_root'  => 'http://res.laobandianping.com',
    'resources_physical_root'  => 'E:/wwwroot/res.laobandianping.com_upload',

    //站点配置
    'site_root_www' =>  'http://www.laobandianping.com',
    'site_root_api' =>  'http://api.laobandianping.com:8120/v-test',

    'cache'             =>[
        'type'  => 'Memcache',
        'host'  => '127.0.0.1',
        'port'  => '11211',
    ],

    'dictionary_expires'    => 60*60*2,  //字典客户端缓存时间，单位:秒
];