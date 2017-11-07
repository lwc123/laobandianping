<?php

namespace app\workplace\models;

use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 *   name="CompanyAsset",
 *   description="企业资产相关API"
 * )
 */
/**
 * @SWG\Definition(required={"CompanyId"})
 */
class  CompanyAsset extends BaseModel {
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $AssetId;
	
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $CompanyId;
 
	
	/**
	 * @SWG\Property(type="integer", description="资产类型，1建档个数，2查看评价")
	 */
	public $AssetType;
	
	/**
	 * @SWG\Property(type="integer", description="资产数字")
	 */
	public $AssetNum;
	
 
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $ModifiedTime;
}