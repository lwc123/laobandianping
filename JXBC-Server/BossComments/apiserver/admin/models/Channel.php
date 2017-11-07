<?php

namespace app\admin\models;

use app\common\models\BaseModel;
use Think\Config;
/**
 * @SWG\Tag(
 * name="AdminUser",
 * description="后台渠道表"
 * )
 */
/**
 * @SWG\Definition(required={"AdminUserId"})
 */


class Channel extends BaseModel{

	protected function initialize()
	{
		$this->connection = Config::get('db_admin');
	}
    /**
     * @SWG\Property(type="integer", description="渠道id")
     */
    public $ChannelId;

    /**
     * @SWG\Property(type="string", description="渠道名称")
     */
    public $ChannelName;


    /**
     * @SWG\Property(type="string", description="渠道code")
     */
    public $ChannelCode;


    /**
     * @SWG\Property(type="string", description="创建时间")
     */
    public $ModifiedTime;


    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $CreatedTime; 
 
}

?>