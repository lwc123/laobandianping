<?php
namespace app\appbase\models;

/**
 * @SWG\Definition()
 */
class TradeType
{  
    /**
     * @SWG\Property(type="int",description="个人对个人交易 <b>[ 1 ]</b>")
     */
    public $PersonalToPersonal;
    const PersonalToPersonal = 1;
    /**
     * @SWG\Property(type="int",description="个人对公交易 <b>[ 2 ]</b>")
     */
    public $PersonalToOrganization;
    const PersonalToOrganization = 2;
    
    /**
     * @SWG\Property(type="int",description="公对私交易 <b>[ 3 ]</b>")
     */
    public $OrganizationToPersonal; 
    const OrganizationToPersonal = 3;
    
    /**
     * @SWG\Property(type="int",description="公对公交易 <b>[ 4 ]</b>")
     */
    public $OrganizationToOrganization;
    const OrganizationToOrganization = 4;    
}     

