<?php
/**
 * 雇员IO
 */
namespace app\io\providers;
use app\io\models\EmployeeEntity;
use app\io\models\EmployerEntity;
use app\io\models\PersonEntity;
use think\Db;
use think\Log;

Class EmployeeIOProvider
{
    public static function queryPerson($query, $pagination) {
        $buildQueryFunc = function() use ($query) {
            $dbQuery = PersonEntity::where('PersonId','>',0);
            if (!empty($query['MobilePhone'])) {
                $dbQuery = $dbQuery->where('MobilePhone', $query['MobilePhone']);
            }
            if (!empty($query['RealName'])) {
                $dbQuery = $dbQuery->where('RealName', 'like',  $query['RealName'].'%');
            }

            return $dbQuery;
        };

        $pagination->TotalCount =  $buildQueryFunc($query)->count();

        $list = $buildQueryFunc()->order ( 'PersonId asc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
        return $list;
    }

    public static function queryEmployer($query, $pagination) {
        $buildQueryFunc = function() use ($query) {
            $dbQuery = EmployerEntity::where('EmployerId','>',0);
            if (!empty($query['CompanyName'])) {
                $dbQuery = $dbQuery->where('CompanyName', 'like', '%'.$query['CompanyName'].'%');
            }
            return $dbQuery;
        };

        $pagination->TotalCount =  $buildQueryFunc($query)->count();

        $list = $buildQueryFunc()->order ( 'EmployeeCount desc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
        return $list;
    }

    public static function queryEmployee($query, $pagination) {
        $buildQueryFunc = function() use ($query) {
            $dbQuery = PersonEntity::where("Employee.PersonId", ">", 0);
            $dbQuery = $dbQuery->where('EmployerId', $query['EmployerId']);
            
            return $dbQuery;
        };
        $pagination->TotalCount =  $buildQueryFunc($query)->count();

        $list = $buildQueryFunc()->order ( 'Employee.PersonId asc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
        return $list;
    }

    public static function queryColleague($query, $pagination) {
        if (empty($query['EmployerId'])) {
            $query['EmployerIds'] = EmployeeEntity::where('PersonId', $query['PersonId'])->column("EmployerId");
        }
        
        $subQuery = EmployeeEntity::field('PersonId');
        if (empty($query['EmployerId']) && !empty($query['EmployerIds'] )) {
            $subQuery = $subQuery->where('EmployerId', 'in', $query['EmployerIds']);
        } else if(!empty($query['EmployerId'])) {
            $subQuery = $subQuery->where('EmployerId', $query['EmployerId']);
        }
        $subQuery = $subQuery->group('PersonId')->select(false);
  
        $list = null;
        $countData = Db::connect(config('db_io'))->query("select count(*) from ($subQuery) a");
        if(!empty($countData)) {
            $pagination->TotalCount = $countData[0]["count(*)"];
            if($pagination->TotalCount > 0) {
                $ids = Db::connect(config('db_io'))->query("$subQuery order by PersonId limit ".($pagination->PageIndex-1)*$pagination->PageSize.",".$pagination->PageSize);
                $ids = array_column($ids, 'PersonId');
                $list = PersonEntity::where("PersonId", "in", $ids)->select();
            }
        }
        return $list;
    }
}