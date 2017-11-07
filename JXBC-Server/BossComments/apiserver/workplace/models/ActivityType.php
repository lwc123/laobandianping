<?php
namespace app\workplace\models;
/**
 * @SWG\Definition(description="活动类型")
 */
class ActivityType
{
    /**
     * @SWG\Property(type="int",description="公司开户费 <b>[ 1 ]</b>")
     */
    public $CompanyOpen;
    const CompanyOpen = 1;

    /**
     * @SWG\Property(type="int",description="个人开户费 <b>[ 2 ]</b>")
     */
    public $PrivateOpen;
    const PrivateOpen = 2;
    /**
     * @SWG\Property(type="int",description="购买档案 <b>[ 3 ]</b>")
     */
    public $BoughtComment;
    const BoughtComment =3;

    /**
     * @SWG\Property(type="int",description="公司续费 <b>[ 4 ]</b>")
     */
    public $CompanyRenewal;
    const CompanyRenewal =4;

}
