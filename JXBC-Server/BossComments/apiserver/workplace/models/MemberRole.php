<?php
namespace app\workplace\models;

/**
 * @SWG\Definition()
 */

class MemberRole
{ 
	
	
	/**
	 * @SWG\Property(type="int",description="老板 <b>[ 1 ]</b>")
	 */
	public $Boss;
	const Boss = 1;
	
	
	/**
	 * @SWG\Property(type="int",description="管理员 <b>[ 2 ]</b>")
	 */
	public $Manager;
	const Manager = 2;

	 
	/**
	 * @SWG\Property(type="int",description="高管 <b>[ 3 ]</b>")
	 */
	public $Executives;
	const Executives = 3;

	/**
	 * @SWG\Property(type="int",description="建档员 <b>[ 4 ]</b>")
	 */
	public $FilingClerk	;
	const FilingClerk = 4;
}
