<?php

namespace app\workplace\services;

use app\workplace\models\ArchiveComment;
use app\workplace\models\EmployeArchive;
use app\workplace\models\Company;
use app\workplace\models\WorkItem;
use app\common\models\Result;
use think\Request;
use think\db;
use app\workplace\models\BoughtCommentRecord;
use app\common\models\ErrorCode;
use app\workplace\models\CommentType;
use app\common\modules\PaymentEngine;
use app\common\modules\ResourceHelper;
use app\workplace\models\Department;
use app\common\modules\DictionaryPool;
 
class BackgroundSurveyService{
	public static function Search($Search) {
		if (empty ( $Search ) || empty ( $Search ['IDCard'] ) || empty ( $Search ['RealName'] ) || empty ( $Search ['CompanyId'] )) {
			exception ( '非法请求-0', 412 );
		}
		//验证身份证是否合法

		//////////背景调查详情参数////////////
		// 基本信息
		$Survey['Tags'] ['Gender'] = get_xingbie ( $Search ['IDCard'] );
		$Survey['Tags'] ['Birthday'] = getIDCardInfo ( $Search ['IDCard'] )['birthday'];
		$Survey['Tags'] ['Age']=countage($Survey ['Tags'] ['Birthday']).'岁';
		$Survey['Tags'] ['Area']= getIDCardarea ( $Search ['IDCard'] );
		$Survey['Tags'] ['Crime']='无犯罪记录';
		$Survey ['IDCard']=$Search ['IDCard'];
		$Survey ['RealName']=$Search ['RealName']; 
		if($Survey['Tags'] ['Gender']=="男"){$Survey ['HeOrShe']='他';}else{$Survey ['HeOrShe']='她';}
		//查询档案：身份证号匹配+入职时间最近的档案
		$RecentArchive = EmployeArchive::get ( function ($query) use($Search) {
			$query->where ( 'IDCard', $Search['IDCard'] ) 
			->order ('EntryTime desc,DimissionTime desc');
		},['BelongCompany']);
		if(empty($RecentArchive)){
			$Survey ['IsArchive']=false; 
			return $Survey;
		}

		//基本档案信息
		$Survey ['CompanyName'] =$RecentArchive['BelongCompany']['CompanyName'];
		$Survey ['Tags'] ['PostTitle'] =WorkItem::where ( 'ArchiveId', $RecentArchive['ArchiveId'] )->order ( 'PostEndTime desc,PostStartTime desc,ItemId desc' )->value('PostTitle');
		$Survey ['Picture'] =ResourceHelper::ToAbsoluteUri($RecentArchive['Picture']);
		$Survey['Tags'] ['GraduateSchool'] =$RecentArchive['GraduateSchool'];
		$Survey['Tags'] ['Education'] =DictionaryPool::getEntryNames('academic',$RecentArchive['Education']);
		//return $Survey;

		if($RecentArchive['RealName']!=$Search ['RealName']){
			return Result::error(ErrorCode::BackgroundSurvey_RealName, '发现身份证号匹配的员工档案姓名与您输入的姓名不一致');
		}else{
            if($RecentArchive['IsDimission']!=1){
                $Survey ['IsDimission']=false;
                return $Survey;
            }
            $Survey ['IsArchive']=true;
			$Survey ['IsDimission']=true;
 			//查询出所有公司存在此IDCard的档案
			$List= EmployeArchive::all (function ($query) use($Search) {
			$query->where ( 'IDCard', $Search['IDCard'] )->order ( 'DimissionTime desc' );
		});
 			if($List){
			    $RecentLists=[];
                $RecordList= BoughtCommentRecord::where(['CompanyId'=>$Search ['CompanyId']])->select();

                foreach ($List as $keys => $value){
                    $DeptId[]=$value['DeptId'];
                    $ArchiveId[]=$value['ArchiveId'];
                    $ArchiveCompanyId[]=$value['CompanyId'];
                }
                //档案IDS
                $DeptIds=implode ( ',', array_unique($DeptId) );
                $ArchiveCompanyId=implode ( ',', array_unique($ArchiveCompanyId) );
                //档案IDS
                $ArchiveIds=implode ( ',', array_unique($ArchiveId) );
                //评价列表
                $CommentList= ArchiveComment::where('ArchiveId','in', $ArchiveIds)->where(['AuditStatus'=>2])->select();
                //部门列表
                $DepartmentList=Department::where('DeptId','in', $DeptIds)->select();
                //公司列表
                $CompanyList=Company::where('CompanyId','in', $ArchiveCompanyId)->field('CompanyId,CompanyName')->select();
                //职务列表
                $WorkItemList=WorkItem::where('DeptId','in', $DeptIds)->order ( 'PostEndTime desc,PostStartTime desc,ItemId desc' )->group('ArchiveId')->select();
				foreach ($List as $key => $value){
                    $RecentList['CompanyName']='';
                    foreach ($CompanyList as $keys =>$values){
                        if ($value['CompanyId']==$values['CompanyId']){
                            $RecentList['CompanyName']=$values['CompanyName'];
                        }
                    }

					$RecentList['CompanyId']=$value['CompanyId'];
					$RecentList['ArchiveId']=$value['ArchiveId'];
                    $RecentList['StageEvaluationNum']=0;
                    $RecentList['DepartureReportNum']=0;
                    $RecentList['IsBoughtStageEvaluation']=false;
                    $RecentList['IsBoughtDepartureReport']=false;
					foreach ($RecordList as $k => $val){
                        if ($value['ArchiveId']==$val['ArchiveId']){
                            if ($val['BoughtStageEvaluation']==1){
                                $RecentList['IsBoughtStageEvaluation']=true;
                            }
                            if ($val['BoughtDepartureReport']==1){
                                $RecentList['IsBoughtDepartureReport']=true;
                            }
                        }
                    }
                    foreach ($CommentList as $keys =>$values){
                        if ($value['ArchiveId']==$values['ArchiveId']){
                            if($values['CommentType']==0){
                                $RecentList['StageEvaluationNum']=$RecentList['StageEvaluationNum']+1;
                            }else{
                                $RecentList['DepartureReportNum']=$RecentList['DepartureReportNum']+1;
                            }
                        }
                    }

                    foreach ($DepartmentList as $keys =>$values){
                        if ($value['DeptId']==$values['DeptId']){
                            $RecentList['DeptName']=$values['DeptName'];
                        }
                    }

                    foreach ($WorkItemList as $keys =>$values){
                        if ($value['ArchiveId']==$values['ArchiveId']&&$value['DeptId']==$values['DeptId']){
                            $RecentList['PostTitle']=$values['PostTitle'];
                        }
                    }

					$RecentList['StageEvaluationPrice']=PaymentEngine::GetStageEvaluationPrice($value['CompanyId'], $value['ArchiveId']);
					$RecentList['DepartureReportPrice']=PaymentEngine::GetDepartureReportPrice($value['CompanyId'], $value['ArchiveId']);
					$RecentList['EntryTime']=date('Y年m月',strtotime($value['EntryTime']));
					$RecentList['DimissionTime']=date('Y年m月',strtotime($value['DimissionTime']));

					//$RecentList['PostTitle']=WorkItem::where(['ArchiveId'=>$value['ArchiveId'],'DeptId'=>$value['DeptId']])->order ( 'PostEndTime desc,PostStartTime desc,ItemId desc' )->value('PostTitle');;
					array_push($RecentLists,$RecentList);
				}
				$Survey ['Archives']=$RecentLists;
			}
		}
		$Survey['Tags']=implode(',',$Survey['Tags']);
		$Survey['Tags']=explode(',',$Survey['Tags']);
		return $Survey;
	}
	
	
	public static function BoughtDetail($Detail){
		if (empty ($Detail )  || empty ( $Detail['CompanyId'] )|| empty ( $Detail['RecordId'] )) {
			exception ( '非法请求-0', 412 );
		} 
		//查出此公司购买档案的所有
		$BoughtArchive=BoughtCommentRecord::where(['CompanyId'=>$Detail['CompanyId']])->where('RecordId','in', $Detail['RecordId'])->select();
		if(empty($BoughtArchive)){
            exception ( '暂无数据', 412 );
        }
		foreach ($BoughtArchive as $keys => $value){
			$ArchiveId[]=$value['ArchiveId'];
		}
		//档案IDS
		$ArchiveIds=implode ( ',', $ArchiveId );

		//档案详情
    	$BoughtDetail['Archives']= EmployeArchive::where('ArchiveId','in', $ArchiveId)->order('DimissionTime','desc')->select();
    	
    	foreach ($BoughtDetail['Archives'] as $infor =>$mation){
    		$BoughtDetail['RealName']=$mation['RealName'];
    		$BoughtDetail['Gender']=$mation['Gender'];
    		$BoughtDetail['Birthday']=$mation['Birthday'];
    		$BoughtDetail['Age']=countage($mation['Birthday']).'岁';
    		$BoughtDetail['GraduateSchool']=$mation['GraduateSchool'];
    		$BoughtDetail['Education']=DictionaryPool::getEntryNames('academic',$mation['Education']);
    		$BoughtDetail['Picture']=$mation['Picture'];
    		$BoughtDetail['PostTitle']=WorkItem::where('DeptId',$mation['DeptId'])->value('PostTitle');
    		$BoughtDetail['DeptName']=Department::where('DeptId',$mation['DeptId'])->value('DeptName');
    		break;
    	}
    	
    	
		foreach ($BoughtArchive as $keys => $value){
			 
			//离职报告
			if($value['BoughtDepartureReport']==1&&$value['BoughtStageEvaluation']==1){
				$CommentType="0,1";
			} elseif ($value['BoughtDepartureReport']==0&&$value['BoughtStageEvaluation']==1){
				$CommentType="0";
			}
			elseif ($value['BoughtDepartureReport']==1&&$value['BoughtStageEvaluation']==0){
				$CommentType="1";
            }
            $Comments=ArchiveComment::where(['ArchiveId'=>$value ['ArchiveId'],'CompanyId'=>$value ['ArchiveCompanyId'],'AuditStatus'=>2])->where('CommentType','in', $CommentType)->order('CommentType','desc')->select();

            $CommentsList=[];
            foreach ($Comments as $k =>$v){
                $Comments[$k]['DimissionReason']=DictionaryPool::getEntryNames('leaving',$v['DimissionReason']);
                $Comments[$k]['WantRecall']=DictionaryPool::getEntryNames('panicked',$v['WantRecall']);
                $Comments[$k]['StageSection']=DictionaryPool::getEntryNames('period',$v['StageSection']);
                //图片数组处理
                if($Comments[$k]['WorkCommentImages']){
                    $Comments[$k]['WorkCommentImages']=explode(",",str_replace(array("[","]"),"",$v['WorkCommentImages']));
                    $Images=[];
                    foreach ($Comments[$k]['WorkCommentImages'] as $WorkCommentImages){
                        $Images[]=Config('resources_site_root').$WorkCommentImages;
                    }
                    $Comments[$k]['WorkCommentImages']=$Images;
                }
                if($value ['ArchiveId']==$v['ArchiveId']){
                    $CommentsList[]=$v;
                }
            }
			 $BoughtDetail['Archives'][$keys]['CompanyName']=Company::where('CompanyId',$value['ArchiveCompanyId'])->value('CompanyName');
             $DeptId=EmployeArchive::where('ArchiveId',$value['ArchiveId'])->value('DeptId');
             $BoughtDetail['Archives'][$keys]['PostTitle']=WorkItem::where('DeptId',$DeptId)->value('PostTitle');
             $BoughtDetail['Archives'][$keys]['DeptName']=Department::where('DeptId',$DeptId)->value('DeptName');
			 $BoughtDetail['Archives'][$keys]['Comments']=$CommentsList;
		}
		
        return $BoughtDetail;
	}
	
	//单个记录
	public static function SingleDetail($Detail){
		if (empty ($Detail )  || empty ( $Detail['CompanyId'] )|| empty ( $Detail['ArchiveId'] )) {
			exception ( '非法请求-0', 412 );
		}  
		//档案详情
    	$BoughtDetail= EmployeArchive::where('ArchiveId', $Detail['ArchiveId'])->find();
    	$BoughtDetail['Age']=countage($BoughtDetail['Birthday']).'岁'; 
    	$BoughtDetail['PostTitle']=WorkItem::where('DeptId',$BoughtDetail['DeptId'])->value('PostTitle'); 
    	$BoughtDetail['CompanyName']=Company::where('CompanyId',$BoughtDetail['CompanyId'])->value('CompanyName');
    	$BoughtDetail['DeptName']=Department::where('DeptId',$BoughtDetail['DeptId'])->value('DeptName');
        $BoughtDetail['Education']=DictionaryPool::getEntryNames('academic',$BoughtDetail['Education']);


    	//查询已购买评价类型 
    	$BoughtDepartureReport=BoughtCommentRecord::where(['CompanyId'=>$Detail['CompanyId'],'BoughtDepartureReport'=>1,'ArchiveId'=>$Detail['ArchiveId']])->find();
    	$BoughtStageEvaluation=BoughtCommentRecord::where(['CompanyId'=>$Detail['CompanyId'],'BoughtStageEvaluation'=>1,'ArchiveId'=>$Detail['ArchiveId']])->find();

    	if($BoughtDepartureReport&&$BoughtStageEvaluation){
    		$CommentType="0,1";
    		$BoughtDetail['BoughtCommentType']=2;
    	} elseif (empty($BoughtDepartureReport)&&$BoughtStageEvaluation){
    		$CommentType="0";
    		$BoughtDetail['BoughtCommentType']=0;
    	}
    	elseif ($BoughtDepartureReport&&empty($BoughtStageEvaluation)){
    		$CommentType="1";
    		$BoughtDetail['BoughtCommentType']=1;
    	}
    	//判断是否单独查看
    	if (isset($Detail['CommentType'])){
    		$CommentType= $Detail['CommentType'];
    	}  
    	$Comments=ArchiveComment::where(['ArchiveId'=>$Detail ['ArchiveId'],'AuditStatus'=>2])->where('CommentType','in', $CommentType)->order('CommentType','desc')->select();
    	foreach ($Comments as $k =>$v){
    		//图片数组处理
            $Comments[$k]['DimissionReason']=DictionaryPool::getEntryNames('leaving',$v['DimissionReason']);
            $Comments[$k]['WantRecall']=DictionaryPool::getEntryNames('panicked',$v['WantRecall']);
            $Comments[$k]['StageSection']=DictionaryPool::getEntryNames('period',$v['StageSection']);
    		if($Comments[$k]['WorkCommentImages']){ 
    			$Comments[$k]['WorkCommentImages']=explode(",",str_replace(array("[","]"),"",$v['WorkCommentImages']));
    			$Images=[];
    			foreach ($Comments[$k]['WorkCommentImages'] as $WorkCommentImages){
    				$Images[]=Config('resources_site_root').$WorkCommentImages;
    			}
    			$Comments[$k]['WorkCommentImages']=$Images;
    		} 
    		if($Detail ['ArchiveId']==$v['ArchiveId']){
    			$Commentslist[]=$v;
    		}
    	}
    	$BoughtDetail['Comments']=$Commentslist;
        return $BoughtDetail;
	}
	
	
}