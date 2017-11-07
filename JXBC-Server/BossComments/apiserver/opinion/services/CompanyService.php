<?php
namespace app\opinion\services;

use app\common\models\Result;
use app\common\modules\ServerVisitManager;
use app\opinion\models\Company;
use app\opinion\models\CompanyBrowseRecord;
use app\opinion\models\Concerned;
use app\opinion\models\Liked;
use app\opinion\models\Opinion;
use app\opinion\models\OpinionReply;
use think\Db;
use think\Cookie;

class CompanyService
{


    /**
     * 公司详情
     * @param $CompanyId
     * @return null|static
     */
    public static function Detail($param)
    {
        if (empty ($param) || empty ($param['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        $Detail = Company::get($param['CompanyId']);
        if (empty($Detail)) {
            return null;
        }
        Company::where('CompanyId', $Detail['CompanyId'])->setInc('ReadCount');
        $Detail['ShareLink'] = $Detail['ShareLink'];
        $list = $Detail->Opinions()->where(['AuditStatus' => 1, 'CompanyId' => $param['CompanyId']])->page($param ['Page'], $param ['Size'])->order('CreatedTime desc,OpinionId desc')->select();
        if (!empty($param['PassportId'])) {
            $liked = Liked::where(['Status' => 1, 'PassportId' => $param['PassportId']])->select();
            foreach ($list as $key => $val) {
                $list[$key]['IsLiked'] = false;
                foreach ($liked as $k => $v) {
                    if ($list[$key]['OpinionId'] == $v['OpinionId']) {
                        $list[$key]['IsLiked'] = true;
                    }
                }
            }
        } else {
            foreach ($list as $key => $val) {
                $list[$key]['IsLiked'] = false;

                if (Cookie::has('TouristMark') ) {
                    $new =Cookie::get('TouristMark').'_'.$val['OpinionId'];
                    if(Cookie::has($new)){
                    $Status = Cookie::get($new);
                    if ($Status == 1) {
                        $list[$key]['IsLiked'] = true;
                    }
                }
            }
        }
        }


        $Detail['Opinions'] = $list;
        //更新用户查看此公司时间
        if (!empty($param['PassportId']) && isset($param['PassportId'])) {
            CompanyBrowseRecord::BrowseRecord($param);
            $Status = Concerned::where(['CompanyId' => $param['CompanyId'], 'PassportId' => $param['PassportId']])->value('Status');
            if (empty($Status)) {
                $Detail['IsConcerned'] = false;
            }
            if ($Status == 1) {
                $Detail['IsConcerned'] = true;
            } else {
                $Detail['IsConcerned'] = false;
            }
        } else {
            $Detail['IsConcerned'] = false;
        }

        return $Detail;
    }

    /**
     * 口碑首页（专题+所有口碑）
     * @param $param
     * @return false|\PDOStatement|string|\think\Collection
     */
    public static function CompanyList($param)
    {
        if (empty ($param)) {
            exception('非法请求-0', 412);
        }
        $list = Company::all(function ($query) use ($param) {
            $query->page($param ['Page'], $param ['Size'])->order('CreatedTime desc,CompanyId desc');
        });
        return $list;
    }

    /**
     * 默认查找老东家，搜索匹配关键字。
     * @param $param
     * @return array
     */
    public static function SearchList($param)
    {
        if (empty($param['Keyword'])) {
            $list = Concerned::all(function ($query) use ($param) {
                $query->where(['Status' => 1, 'ConcernedType' => 2, 'PassportId' => $param['PassportId']])->order('CreatedTime desc,ConcernedId desc');
            }, 'company');
            $company_list = [];
            if ($list) {
                foreach ($list as $key => $val) {
                    $company_list[] = $val['company'];
                    $company_list[$key]['IsFormerClub'] = $val['ConcernedType'];
                    $company_list[$key]['IsConcerned'] = true;
                }
            }
            return $company_list;
        } else {
            $list = Company::where('CompanyName', 'like', '%' . $param['Keyword'] . '%')->whereOr('CompanyAbbr', 'like', '%' . $param['Keyword'] . '%')->order('CreatedTime desc,CompanyId desc')->limit(15)->select();
            return $list;
        }
    }

    /**
     * 开启关闭口碑公司评论
     * @param $param
     * @return bool
     */
    public static function Settings($param)
    {
        if (empty ($param) || empty ($param['OpinionCompanyId']) || empty ($param['IsCloseComment'])) {
            exception('非法请求-0', 412);
        }

        if ($param['IsCloseComment'] === 'true' || $param['IsCloseComment'] === true) {
            $param['IsCloseComment'] = 1;
        } else {
            $param['IsCloseComment'] = 2;
        }
        Company::update(['CompanyId' => $param['OpinionCompanyId'], 'IsCloseComment' => $param['IsCloseComment']]);
        return true;
    }

    /**
     * 企业管理口碑公司标签
     * @param $param
     * @return bool
     */
    public static function Labels($param)
    {
        if (empty ($param) || empty ($param['OpinionCompanyId'])) {
            exception('非法请求-0', 412);
        }
        if (is_array($param['Labels'])==false){
            exception('非法请求-labels', 412);
        }
        $labels= json_encode($param['Labels'],JSON_UNESCAPED_UNICODE);
        Company::update(['CompanyId' => $param['OpinionCompanyId'], 'LabelType' => 2, 'Labels' => $labels]);
        return true;
    }
}