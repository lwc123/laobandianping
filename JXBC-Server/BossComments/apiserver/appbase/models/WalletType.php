<?php
namespace app\appbase\models;

/**
 * @SWG\Definition()
 */
class WalletType
{  
    /**
     * @SWG\Property(type="int",description="未指定类型 <b>[ 0 ]</b>")
     */
    public $None;
    const None = 0;
    /**
     * @SWG\Property(type="int",description="私人钱包 <b>[ 1 ]</b>")
     */
    public $Privateness;
    const Privateness = 1;
    
    /**
     * @SWG\Property(type="int",description="机构钱包 <b>[ 2 ]</b>")
     */
    public $Organization; 
    const Organization = 2;
}     

