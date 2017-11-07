<?php
namespace app\workplace\models;
use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 * name="Dictionary",
 * description="业务字典",
 * )
 */
/**
 * @SWG\Definition(required={"BizDictId"})
 */

class BizDict extends BaseModel
{

    /**
     * @SWG\Property(type="integer", description="字典id")
     */
    public $DictionaryId;

    /**
     * @SWG\Property(type="string", description="Code代码")
     */
    public $Code;

    /**
     * @SWG\Property(ref="#/definitions/DictCategoryCode", description="分类code")
     */
    public $CategoryCode;


    /**
     * @SWG\Property(type="string", description="名称")
     */
    public $Name;

    /**
     * @SWG\Property(type="integer", description="层级")
     */
    public $Level;


    /**
     * @SWG\Property(type="integer", description="父id")
     */
    public $ParentId;


    /**
     * @SWG\Property(type="string", description="别名，索引名？")
     */
    public $RelativeKeys;


    /**
     * @SWG\Property(type="integer", description="是否热门")
     */
    public $IsHotspot;




}
