<?php
namespace app\opinion\services;


use app\opinion\models\Company;
use app\opinion\models\CompanyBrowseRecord;
use app\opinion\models\Concerned;

class ConcernedService
{


    public static function ConcernedList($param)
    {
        if (empty ($param)) {
            exception('非法请求-0', 412);
        }
        $list = Concerned::all(function ($query) use ($param) {
            $query->where(['Status' => 1, 'PassportId' => $param['PassportId']])->page($param ['Page'], $param ['Size'])->order('ConcernedType desc,CreatedTime desc,ConcernedId desc');
        }, 'company');
        $company_list = [];
        $Companies=[];
        if ($list) {
            foreach ($list as $keys => $value){
                $CompanyId[]=$value['CompanyId'];
                $Companies[]=$value['company'];
            }
            $CompanyIds=implode ( ',', array_unique($CompanyId) );
            $Record_list=CompanyBrowseRecord::where(['PassportId'=>$param['PassportId']])->where('CompanyId','in', $CompanyIds)->select();
             if (empty($Record_list)){
                 foreach ($list as $key => $val) {
                     $company_list[] = $val['company'];
                     $company_list[$key]['IsFormerClub'] = $val['ConcernedType'];
                     $company_list[$key]['IsConcerned'] = true;
                     $company_list[$key]['IsRedDot'] = true;
                 }
             }else{
                 foreach ($list as $key => $val) {
                     $company_list[] = $val['company'];
                     $company_list[$key]['IsFormerClub'] = $val['ConcernedType'];
                     $company_list[$key]['IsConcerned'] = true;
                     $company_list[$key]['IsRedDot'] = true;
                     $company_list[$key]['ShareLink']=$val['Company']['ShareLink'];
                 }
             }
        }
        $myList=[];
        $myList['ConcernedTotal']=Concerned::where(['Status' => 1, 'ConcernedType' => 1, 'PassportId' => $param['PassportId']])->count();
        $myList['Companies']=$Companies;
        return $myList;

    }

    public static function Concerned($Concerned)
    {
        if (empty ($Concerned)) {
            exception('非法请求-0', 412);
        }

        $Status = Concerned::where(['CompanyId' => $Concerned['CompanyId'], 'PassportId' => $Concerned['PassportId']])->value('Status');
        if ($Status) {
            if ($Status == 1) {
                $update = Concerned::where(['CompanyId' => $Concerned['CompanyId'], 'PassportId' => $Concerned['PassportId']])->setInc('Status');
                if (empty($update)) {
                    return false;
                }
                $setDec = Company::where('CompanyId', $Concerned['CompanyId'])->setDec('LikedCount');
                if (empty($setDec)) {
                    return false;
                }
                return true;

            } else {
                $update = Concerned::where(['CompanyId' => $Concerned['CompanyId'], 'PassportId' => $Concerned['PassportId']])->setDec('Status');
                if (empty($update)) {
                    return false;
                }
                $setInc = Company::where('CompanyId', $Concerned['CompanyId'])->setInc('LikedCount');
                if (empty($setInc)) {
                    return false;
                }
                return true;
            }
        } else {
            $create = new Concerned($Concerned);
            $create->allowField(true)->save();
            if (empty($create)) {
                return false;
            }
            $setInc = Company::where('CompanyId', $Concerned['CompanyId'])->setInc('LikedCount');
            if (empty($setInc)) {
                return false;
            }
            return true;
        }

    }


}