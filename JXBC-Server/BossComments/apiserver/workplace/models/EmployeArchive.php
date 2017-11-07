<?php

namespace app\workplace\models;

use app\appbase\models\UserPassport;
use app\appbase\models\UserPassportToken;
use app\common\controllers\ApiController;
use app\common\models\BaseModel;
use app\common\modules\DbHelper;
use app\common\modules\DictionaryPool;
use think\Request;

/**
 * @SWG\Tag(
 * name="EmployeArchive",
 * description="企业员工档案API"
 * )
 */

/**
 * @SWG\Definition(required={"CompanyId"})
 */
class EmployeArchive extends BaseModel
{

    //*

    public static function load($Id)
    {
        $model = EmployeArchive::get($Id);
        return self::loadChildren($model, [["attr" => "WorkItems", "model" => "WorkItem", "order" => "ModifiedTime desc"]]);
    }

    public static function loadList($idList)
    {
        $list = EmployeArchive::all($idList);
        return self::loadChildren($list, [["attr" => "WorkItems", "model" => "WorkItem", "order" => "ModifiedTime desc"]]);
    }

    public static function loadArchiveComment($Id)
    {
        $model = EmployeArchive::get($Id);
        return self::loadChildren($model, [["attr" => "ArchiveComments", "model" => "ArchiveComment", "order" => "ModifiedTime desc"]]);
    }

    public static function loadArchiveCommentList($idList)
    {
        $list = EmployeArchive::all($idList);
        return self::loadChildren($list, [["attr" => "ArchiveComments", "model" => "ArchiveComment", "order" => "ModifiedTime desc"]]);
    }

    /* */
    protected $readonly = [
        'DepartureReportNum',
        'StageEvaluationNum',
        'CompanyName',
        'IDCard'
    ];

    /**
     * @SWG\Property(type="integer", description="档案ID")
     */
    public $ArchiveId;

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="提交人")
     */
    public $PresenterId;

    /**
     * @SWG\Property(type="integer", description="修改人")
     */
    public $ModifiedId;

    /**
     * @SWG\Property(type="integer", description="部门ID")
     */
    public $DeptId;

    /**
     * @SWG\Property(type="integer", description="评价数")
     */
    public $CommentsNum;

    /**
     * @SWG\Property(type="integer", description="阶段评价个数")
     */
    public $StageEvaluationNum;

    /**
     * @SWG\Property(type="integer", description="离职报告个数")
     */
    public $DepartureReportNum;

    /**
     * @SWG\Property(type="integer", description="是否离职，0在职，1离职")
     */
    public $IsDimission;

    /**
     * @SWG\Property(type="string", description="真实姓名")
     */
    public $RealName;

    /**
     * @SWG\Property(type="string", description="身份证号")
     */
    public $IDCard;

    /**
     * @SWG\Property(type="string", description="性别")
     */
    public $Gender;

    /**
     * @SWG\Property(type="string", description="出生年月")
     */
    public $Birthday;

    /**
     * @SWG\Property(type="string", description="头像")
     */
    public $Picture;

    /**
     * @SWG\Property(type="string", description="手机号")
     */
    public $MobilePhone;

    /**
     * @SWG\Property(type="string", description="入职日期")
     */
    public $EntryTime;

    /**
     * @SWG\Property(type="string", description="离职日期")
     */
    public $DimissionTime;

    /**
     * @SWG\Property(type="string", description="毕业学校")
     */
    public $GraduateSchool;

    /**
     * @SWG\Property(type="string", description="学历")
     */
    public $Education;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $ModifiedTime;

    /**
     * @SWG\Property(ref="#/definitions/WorkItem")
     */
    public $WorkItems;

    /**
     * @SWG\Property(ref="#/definitions/WorkItem")
     */
    public $ArchiveComments;

    /**
     * @SWG\Property(ref="#/definitions/WorkItem")
     */
    public $WorkItem;

    protected $type = [
        'CreatedTime' => 'datetime',
        'ModifiedTime' => 'datetime',
        'EntryTime' => 'datetime',
        'DimissionTime' => 'datetime',
        'Birthday' => 'datetime'
    ];

    // 档案一对多关联职务

    public function BelongCompany()
    {
        return $this->belongsTo('Company', 'CompanyId');
    }

    public static function getStatusAttr($value)
    {
        $IsDimission = [
            0 => '在职',
            1 => '离任'
        ];
        return $IsDimission [$value];
    }

    public function getPictureAttr($value)
    {
        if ($value) {
            return parent::getResourcesSiteRoot($value);
        } else {
            return parent::getResourcesSiteRoot('/default/EmployePicture.png');
        }
    }

    public function setPictureAttr($value)
    {
        return parent::setResourcesSiteRoot($value);
    }

    public function WorkItem()
    {
        return $this->hasOne('WorkItem', 'ArchiveId');
    }

    /**获取身份证号时显示处理,公司法人全部显示，其他成员显示前三后四位
     * @param $value
     * @param $data
     * @return mixed
     */
    public function getIDCardAttr($value, $data)
    {
        $token = Request::instance()->header("JX-TOKEN");
        if (empty($token)) {
            $token = Request::instance()->cookie("JX-TOKEN");
        }
        if ($token) {
            $PassportId = UserPassportToken::FindIdByToken($token);
            $role = CompanyMember::getPassportRoleByCompanyId($data['CompanyId'], $PassportId)['Role'];
            if ($role == 1) {
                return $value;
            }
        }
        return substr_replace($value, str_repeat('*', 11), 3, 11);
    }

}
