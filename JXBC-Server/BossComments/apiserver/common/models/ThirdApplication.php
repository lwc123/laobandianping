<?php
/**
 * Created by PhpStorm.
 * User: Kevin
 * Date: 2017/1/7
 * Time: 21:08
 */

namespace app\common\models;
use think\Config;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={"AppId","AppName","AppSecret"})
 */
class ThirdApplication extends BaseModel
{
    protected function initialize()
    {
        $this->connection = Config::get('db_admin');
    }

    /**
     * @SWG\Property(description="APP唯一ID", type="string")
     */
    public $AppId;

    /**
     * @SWG\Property(description="APP名称", type="string")
     */
    public $AppName;

    /**
     * @SWG\Property(description="APP秘钥", type="string")
     */
    public $AppSecret;
}