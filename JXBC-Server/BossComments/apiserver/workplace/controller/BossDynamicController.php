<?php
namespace app\workplace\controller;

use app\common\controllers\CompanyApiController;
use app\common\modules\ResourceHelper;
use app\workplace\models\BossDynamic;
use app\workplace\models\BossDynamicComment;
use app\workplace\models\Company;
use app\workplace\models\Liked;
use app\workplace\services\HelperService;
use app\workplace\services\LikedService;
use think\Request;
use app\appbase\models\Enums;

class BossDynamicController extends CompanyApiController
{
    protected $boss_dynamic_comment_model;

    protected $boss_dynamic_model;

    protected $is_boss;

    public function __construct()
    {

        parent::__construct();
        $this->boss_dynamic_comment_model = new BossDynamicComment();
        $this->boss_dynamic_model = new BossDynamic();
    }


    /**
     * @SWG\GET(
     * path="/workplace/BossDynamic/home",
     * summary="获取老板圈动态",
     * description="分页获取老板圈动态",
     * tags={"BossDynamic"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司id",
     * required=false,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="Size",
     * in="query",
     * description="每页大小",
     * required=true,
     * type="integer"
     * ),
     *
     * @SWG\Parameter(
     * name="Page",
     * in="query",
     * description="页码",
     * required=true,
     * type="integer"
     * ),
     *
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/BossDynamic"
     * )
     * ),
     * @SWG\Response(
     * response="412",
     * description="错误提示",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function home(Request $request)
    {

        $page = HelperService::page($request->param('Page'), $request->param('Size'));
        $dynamic_data = $this->boss_dynamic_model->getDynamicList($page['start'], $page['size']);

        $likes = Liked::where('PassportId', $this->PassportId)->select();

        foreach ($dynamic_data as $k => &$v) {
            $v['IsLiked']=false;
            foreach ($likes as $key => $val) {

                if($v['DynamicId']==$val['ResId']){
                    $v['IsLiked']=true;
                }
            }
            $v['Company'] = $dynamic_data[$k]['Company'];
            $v['Comment'] = $dynamic_data[$k]['Comment'];

            if (!empty($v['Img'])) {

                $v['Img'] = str_replace('[', '', $v['Img']);
                $v['Img'] = str_replace(']', '', $v['Img']);
                $v['Img'] = explode(',', $v['Img']);

                $images = array();

                foreach ($v['Img'] as $key => $value) {

                    $images[] = ResourceHelper::ToAbsoluteUri($value);
                }

                $v['Img'] = $images;

            } else {

                $v['Img'] = null;
            }

        }

        return $dynamic_data;
    }

    /**
     * @SWG\GET(
     * path="/workplace/BossDynamic/myDynamic",
     * summary="获取某个老板动态",
     * description="分页获取某个老板动态",
     * tags={"BossDynamic"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司id",
     * required=false,
     * type="integer"
     * ),
     *
     * @SWG\Parameter(
     * name="Size",
     * in="query",
     * description="每页大小",
     * required=false,
     * type="integer"
     * ),
     *
     * @SWG\Parameter(
     * name="Page",
     * in="query",
     * description="页码",
     * required=false,
     * type="integer"
     * ),
     *
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/BossDynamic"
     * )
     * ),
     * @SWG\Response(
     * response="412",
     * description="错误提示",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function myDynamic(Request $request)
    {

        $page = HelperService::page($request->param('Page'), $request->param('Size'));
        HelperService::validateCompanyId($request->param('CompanyId'));
        $dynamic_data = $this->boss_dynamic_model->getDynamicListByPassportId($this->PassportId, $page['start'], $page['size']);
        foreach ($dynamic_data as $k => &$v) {

            $v['Company'] = Company::where('CompanyId', $request->param('CompanyId'))->find();
            $v['IsLiked'] = LikedService::isLikedDynamicById($v['DynamicId'], $this->PassportId);
            $v['Comment'] = $this->boss_dynamic_comment_model->getCommentByDynamicId($v['DynamicId']);

            if (!empty($v['Img'])) {

                $v['Img'] = str_replace('[', '', $v['Img']);
                $v['Img'] = str_replace(']', '', $v['Img']);
                $v['Img'] = explode(',', $v['Img']);

                $images = array();

                foreach ($v['Img'] as $key => $value) {

                    $images[] = ResourceHelper::ToAbsoluteUri($value);
                }

                $v['Img'] = $images;

            } else {


                $v['Img'] = null;
            }
        }

        return $dynamic_data;
    }

    /**
     * @SWG\POST(
     * path="/workplace/BossDynamic/add",
     * summary="发布动态",
     * description="",
     * tags={"BossDynamic"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/BossDynamic")
     * ),
     *
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(type="integer",format="int64")
     * ),
     * @SWG\Response(
     * response="412",
     * description="错误提示",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function add(Request $request)
    {

        if (empty($content = $request->put('Content'))) {

            exception('Content is null', 412);
        }

        $dyanmic_data['PassportId'] = $this->PassportId;
        $dyanmic_data['Content'] = $content;
        $company_id = $request->put('CompanyId.CompanyId');
        empty(intval($company_id)) ? $dyanmic_data['CompanyId'] = $request->put('CompanyId') : $dyanmic_data['CompanyId'] = intval($company_id);

        $this->boss_dynamic_model->data($dyanmic_data)->isUpdate(false)->save();
        $dyanmic_id = $this->boss_dynamic_model['DynamicId'];

        if (empty($dyanmic_id)) {

            exception('system is error', 500);
        }

        $data = Request::instance()->put();

        if (!empty($data['Img'])) {

            foreach ($data['Img'] as $k => $value) {

                $img_base[] = ResourceHelper::SaveBossDynamicImage($dyanmic_id, $value);
            }

            $img_base = '[' . implode(',', $img_base) . ']';
            $status = $this->boss_dynamic_model->where('DynamicId', $dyanmic_id)->update(['Img' => $img_base]);

            if ($status) {

                return $dyanmic_id;

            } else {

                return 0;
            }

        } else {

            return $dyanmic_id;
        }


    }

    /**
     * @SWG\POST(
     * path="/workplace/BossDynamic/del",
     * summary="删除动态",
     * description="",
     * tags={"BossDynamic"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司id",
     * required=false,
     * type="integer"
     * ),
     *
     * @SWG\Parameter(
     * name="DynamicId",
     * in="query",
     * description="动态id",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(type="boolean")
     * ),
     * @SWG\Response(
     * response="412",
     * description="错误提示",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function del(Request $request)
    {

        $boss_dynamic = $request->param();

        if (empty($boss_dynamic['DynamicId'])) {

            exception('DynamicId is null', 412);
        }

        $status = BossDynamic::where('DynamicId', $boss_dynamic['DynamicId'])->where('PassportId', $this->PassportId)->update(['Status' => 0]);

        if (empty($status)) {

            return false;

        } else {

            return true;
        }
    }

    /**
     * @SWG\POST(
     * path="/workplace/BossDynamic/comment",
     * summary="评论动态",
     * description="评论动态",
     * tags={"BossDynamic"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="评论内容",
     * required=true,
     * @SWG\Schema(ref="#/definitions/BossDynamicComment")
     * ),
     *
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(type="integer")
     * ),
     * @SWG\Response(
     * response="412",
     * description="错误提示",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function comment(Request $request)
    {

        $data = $request->put();

        if (empty($data['Content'])) {

            exception('Content is null', 412);

        } elseif (empty($data['DynamicId'])) {

            exception('DynamicId is null', 412);
        }

        $comment['Type'] = 1;
        $comment['Content'] = $data['Content'];
        $comment['PassportId'] = $this->PassportId;
        $comment['DynamicId'] = $data['DynamicId'];
        $comment['CompanyId'] = $data['CompanyId'];


        $add_status = $this->boss_dynamic_comment_model->addComment($comment);

        if ( $add_status) {
            BossDynamic::where('DynamicId', intval($data['DynamicId']))->setInc('CommentCount', 1);
            return 1;

        } else {
            return 0;
        }
    }


    /**
     * @SWG\POST(
     * path="/workplace/BossDynamic/liked",
     * summary="点赞/取消赞",
     * description="点赞和取消赞，一个接口",
     * tags={"BossDynamic"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司id",
     * required=false,
     * type="integer"
     * ),
     *
     * @SWG\Parameter(
     * name="DynamicId",
     * in="query",
     * description="动态id",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(type="boolean")
     * ),
     * @SWG\Response(
     * response="412",
     * description="错误提示",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */

    public function liked(Request $request)
    {

        $opt_data = $request->param();

        if (empty($opt_data['DynamicId'])) {

            exception('DynamicId is null', 412);
        }

        return LikedService::likedAction($this->PassportId, $opt_data['DynamicId']);

    }

}