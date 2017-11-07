<?php
namespace app\workplace\models;
/**
 * @SWG\Definition(description="APP更新策略枚举")
 */
class UpgradeType
{
    /**
     * @SWG\Property(type="int",description="当前版本号为最新，不提示<b>[ 1 ]</b>")
     */
    public $CurrentNewest;
    const CurrentNewest = 1;

    /**
     * @SWG\Property(type="int",description="建议更新，提示可取消 <b>[ 2 ]</b>")
     */
    public $RecommendedUpdate;
    const RecommendedUpdate = 2;
    /**
     * @SWG\Property(type="int",description="强制更新，提示不可取消 <b>[ 3 ]</b>")
     */
    public $ForcedUpdate;
    const ForcedUpdate =3;
}
