<?php

namespace app\common\models;

/**
 * @SWG\Definition()
 */
class Pagination { 
	
	/**
	 * @SWG\Property(type="integer")
	 */
	public $PageIndex;
	
	/**
	 * @SWG\Property(type="integer")
	 * 
	 * @var string
	 */
	public $PageSize;
	
	/**
	 * @SWG\Property(type="integer")
	 *
	 * @var string
	 */
	public $TotalCount;
}
