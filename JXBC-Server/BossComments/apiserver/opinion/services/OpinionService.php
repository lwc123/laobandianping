<?php
namespace app\opinion\services;

use app\common\models\Result;
use app\common\modules\ServerVisitManager;
use app\opinion\models\Company;
use app\opinion\models\LabelLibrary;
use app\opinion\models\Liked;
use app\opinion\models\Opinion;
use app\opinion\models\OpinionReply;
use app\opinion\models\CompanyClaimRecord;
use app\opinion\models\TotalScore;
use app\workplace\services\NoticeByOpinionService;
use think\Db;
use think\Cookie;
class OpinionService
{
    /**
     * 查找手机号关联用户
     * 不存在创建个人用户，返回用户ID
     * @param $MobilePhone
     * @return mixed
     */
    public static function ExistPassportId($MobilePhone)
    {
        if (empty ($MobilePhone)) {
            exception('非法请求-0', 412);
        }
        $PassportId = Db::connect('db_passports')->table('user_passport')->where('MobilePhone', $MobilePhone)->value('PassportId');
        if ($PassportId) {
            return $PassportId;
        } else {
            $post_url = Config('site_root_api') . '/appbase/Account/signup';
            $post_data ['MobilePhone'] = $MobilePhone;
            $post_data ['Password'] = rand('100000', '999999');
            $post_data ['ValidationCode'] = '112233';
            $post_data ['SelectedProfileType'] = 1;
            $result = ServerVisitManager::ServerVisitPost($post_url, $post_data, 1);
            $NewsPassportId = $result ['Account'] ['PassportId'];
            return $NewsPassportId;
        }
    }

    /**
     * 添加公司口碑
     * 返回口碑
     * @param $Opinion
     * @return mixed
     */
    public static function OpinionCreate($Opinion)
    {
        if (empty ($Opinion) || empty ($Opinion ['CompanyId']) || empty ($Opinion ['Content'])) {
            exception('非法请求-0', 412);
        }

        //入职时间，前员工和现员工逻辑
        if ($Opinion['DimissionTime'] && substr($Opinion['DimissionTime'], 0, 4) == '3000') {
            $Opinion['WorkingYears'] = -(1 + date('Y', time()) - date('Y', strtotime($Opinion['EntryTime'])));
        } else {
            $Opinion['WorkingYears'] = 1 + date('Y', strtotime($Opinion['DimissionTime'])) - date('Y', strtotime($Opinion['EntryTime']));
        }

        //提取前18个字保存Title
        $Opinion['Title'] = mb_substr($Opinion ['Content'], 0, 18, 'utf-8');

        //处理标签数组为json，组成新数组
        if (!empty($Opinion['Labels'])) {
            $Labels=[];
            $Labels['Labels']=$Opinion['Labels'];
            $Labels['CompanyId']=$Opinion['CompanyId'];
            $Opinion['Labels']= json_encode($Opinion['Labels'],JSON_UNESCAPED_UNICODE);
        }

        $reputation = new Opinion($Opinion);
        $reputation->allowField(true)->save();

        /**
         * 后续一些操作
         */
        $Company=Company::get($Opinion ['CompanyId']);

        //标签热度计算和保存
        LabelLibrary::Labels($Labels,$Company['LabelType']);

        //给关联B端企业所有用户发送通知消息
        if ($Company['IsClaim']==2&&$Company['ClaimCompanyId']>0){
            NoticeByOpinionService::AddOpinion($Company['ClaimCompanyId']);
        }

        //打分计算
        TotalScore::Score($Opinion);

        return Result::success($reputation['OpinionId']);

    }


    /**
     * 发布评论
     * @param $Reply
     * @return Result
     */
    public static function ReplyCreate($Reply)
    {
        if (empty ($Reply) || empty ($Reply ['Content'])) {
            exception('非法请求-1', 412);
        }

        $reply = new OpinionReply($Reply);
        $reply->allowField(true)->save();

        return Result::success($reply['ReplyId']);
    }


    /**口碑详情
     * @param $param
     * @return null|static
     */
    public static function OpinionDetail($param)
    {
        if (empty ($param)) {
            exception('非法请求-1', 412);
        }
        $Detail = Opinion::get($param['OpinionId']);
        if (empty($Detail)) {
            return null;
        }
        //更新点击操作
        Opinion::where('OpinionId', $param['OpinionId'])->setInc('ReadCount');
        Company::where('CompanyId', $Detail['CompanyId'])->setInc('ReadCount');
        $Detail['Company'] = Company::get($Detail['CompanyId']);
        $Detail['Replies'] = $Detail->replies()->where(['AuditStatus' => 1, 'OpinionId' => $param['OpinionId']])->order('LeadingTime desc')->select();
        if (!empty($param['PassportId'])) {
            $liked = Liked::where(['PassportId' => $param['PassportId'], 'OpinionId' => $param['OpinionId']])->value('Status');
            if ($liked) {
                if ($liked == 1) {
                    $Detail['IsLiked'] = true;
                } else {
                    $Detail['IsLiked'] = false;
                }
            } else {
                $Detail['IsLiked'] = false;
            }
        } else {
                if (Cookie::has('IsLiked_'.$param['OpinionId'])) {
                    $Status =  Cookie::get('IsLiked_'.$param['OpinionId']);
                    if ($Status == 1) {
                        $Detail['IsLiked'] = true;
                    }else{
                        $Detail['IsLiked'] = false;
                    }

                }else{
                    $Detail['IsLiked'] = false;
                }

        }

        return $Detail;
    }

    /**
     * 口碑首页
     * @param $param
     * @return false|\PDOStatement|string|\think\Collection
     */
    public static function OpinionList($param)
    {
        if (empty ($param)) {
            exception('非法请求-0', 412);
        }
        $myList = [];
        if (!empty($param['OpinionCompanyId'])) {
            if (!empty($param['AuditStatus'])) {
                $param['AuditStatus'] = $param['AuditStatus'];
            } else {
                $param['AuditStatus'] = 1;
            }
            $list = Opinion::all(function ($query) use ($param) {
                $query->where(['AuditStatus' => $param['AuditStatus'], 'opinion.CompanyId' => $param['OpinionCompanyId']])->page($param ['Page'], $param ['Size'])->order('CreatedTime desc,OpinionId desc');
            }, 'Company');
            $myList['OpinionTotal'] = Opinion::where(['AuditStatus' => $param['AuditStatus'], 'opinion.CompanyId' => $param['OpinionCompanyId']])->count();
        } else {
            $list = Opinion::all(function ($query) use ($param) {
                $query->where('AuditStatus', 1)->page($param ['Page'], $param ['Size'])->order('CreatedTime desc,OpinionId desc');
            }, 'Company');
            $myList['OpinionTotal'] = 0;
        }

        $liked = Liked::where(['Status' => 1, 'PassportId' => $param['PassportId']])->select();
        foreach ($list as $key => $val) {
            $list[$key]['IsLiked'] = false;
            foreach ($liked as $k => $v) {
                if ($list[$key]['OpinionId'] == $v['OpinionId']) {
                    $list[$key]['IsLiked'] = true;
                }
            }
        }

        $myList['IsRedDot'] = true;
        $myList['Opinions'] = $list;
        return $myList;
    }


    public static function myOpinionList($param)
    {
        if (empty ($param)) {
            exception('非法请求-0', 412);
        }
        $list = Opinion::all(function ($query) use ($param) {
            $query->where(['PassportId' => $param['PassportId']])->page($param ['Page'], $param ['Size'])->order('CreatedTime desc,OpinionId desc');
        }, 'Company');
        $liked = Liked::where(['Status' => 1, 'PassportId' => $param['PassportId']])->select();
        foreach ($list as $key => $val) {
            $list[$key]['IsLiked'] = false;
            foreach ($liked as $k => $v) {
                if ($list[$key]['OpinionId'] == $v['OpinionId']) {
                    $list[$key]['IsLiked'] = true;
                }
            }
        }
        $myList = [];
        $myList['OpinionTotal'] = Opinion::where(['PassportId' => $param['PassportId']])->count();
        $myList['Opinions'] = $list;
        $myList['IsRedDot'] = false;
        return $myList;
    }

    /**
     * 认领 关联  认证 （包括认领添加）
     * @param $param
     * @return false|\PDOStatement|string|\think\Collection
     */
    public static function ClaimAuditStatus($param)
    {
        if (empty ($param) || empty ($param['CompanyId']) || empty ($param['OpinionCompanyId'])) {
            exception('非法请求-0', 412);
        }
        if (empty ($param['RecordId'])) {
            unset($param['RecordId']);
            $Record = new CompanyClaimRecord($param);
            $Record->allowField(true)->save();
        } else {
            $Record = new CompanyClaimRecord;
            $Record->allowField(true)->save(['AuditStatus' => $param['AuditStatus']], ['RecordId' => $param['RecordId']]);
            //成功修改口碑已认领
            if ($param['AuditStatus'] == 2) {
                Company::where("CompanyId", $param['OpinionCompanyId'])->update(['IsClaim' => 2]);
            }
            //发送短信
            NoticeByOpinionClaimService::OpinionClaimSuccess($param);
        }
        return Result::success($Record);

    }

    /**
     * 隐藏选中的点评
     * @param $param
     * @return bool
     */
    public static function hideOpinions($param){
        if (empty ($param) || empty ($param['CompanyId']) || empty ($param['OpinionIds'])) {
            exception('非法请求-0', 412);
        }
        if(is_array($param['OpinionIds'])==false){
            return false;
        }
        $Opinions=[];
        foreach ($param['OpinionIds'] as $key=>$val){
            $Opinions[$key]['OpinionId']=$val;
            $Opinions[$key]['AuditStatus']=2;
        }
        $saveAll = new Opinion();
        $saveAll->saveAll($Opinions);
        return true;
    }

    /**
     * 恢复显示选中的点评
     * @param $param
     * @return bool
     */
    public static function restoreOpinions($param){
        if (empty ($param) || empty ($param['CompanyId']) || empty ($param['OpinionIds'])) {
            exception('非法请求-0', 412);
        }
        if(is_array($param['OpinionIds'])==false){
            return false;
        }
        $Opinions=[];
        foreach ($param['OpinionIds'] as $key=>$val){
            $Opinions[$key]['OpinionId']=$val;
            $Opinions[$key]['AuditStatus']=1;
        }
        $saveAll = new Opinion();
        $saveAll->saveAll($Opinions);
        return true;
    }
}