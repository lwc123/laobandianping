<?php

namespace app\workplace\models;
use app\common\models\BaseModel;
use app\common\modules\DictionaryPool;

/**
 * @SWG\Tag(
 *   name="DictionaryEntry",
 *   description="业务字典内容"
 * )
 */
/**
 * @SWG\Definition(required={"DeptName"})
 */
class  DictionaryEntry extends BaseModel {
    /**
     * @SWG\Property(type="integer", description="")
     */
    public $EntryId;

    /**
     * @SWG\Property(type="integer", description="字典分类ID")
     */
    public $DictionaryId;

    /**
     * @SWG\Property(type="string", description="字典code")
     */
    public $Code;

    /**
     * @SWG\Property(type="string", description="字典名称")
     */
    public $Name;

    /**
     * @SWG\Property(type="string", description="字典搜索关键字")
     */
    public $RelativeKeys;

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $Level;

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $ParentId;

    /**
     * @SWG\Property(type="integer", description="是否热门城市")
     */
    public $IsHotspot;

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $Sequence;

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $Forbidden;

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $CreateorId;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $ModifierId;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $tModifiedTime;

    public function save($data = [], $where = [], $sequence = null)
    {
        $result = parent::save($data, $where, $sequence);
        DictionaryPool::refreshEntryCache($this);
        return $result;
    }
}