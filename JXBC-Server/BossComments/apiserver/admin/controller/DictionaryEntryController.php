<?php
/**
 * Created by PhpStorm.
 * User: 1
 * Date: 2017/3/1
 * Time: 10:16
 */
namespace app\Admin\controller;
use think\Controller;
use think\View;
use think\Db;
use think\Cache;
use think\Config;
use think\Request;
use app\Admin\controller\AdminBaseController;
use app\common\modules\DbHelper;
use app\workplace\models\DictionaryEntry;
use app\workplace\models\BizDict;
use app\common\modules\DictionaryPool;
use app\admin\services\PaginationServices;


class DictionaryEntryController extends AuthenticatedController
{

    /**
     * 字典列表
     * @param Request $request
     * @return mixed
     */
    public function dictionaryList(Request $request)
    {
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $dictionaryList = BizDict::page($pagination->PageIndex, $pagination->PageSize)->select();
        $pagination->TotalCount = BizDict::count('DictionaryId');
        //echo $pagination->TotalCount;die;
        //搜索条件
        $seachvalue = "";
        //方法名
        $action = 'dictionaryList';
        //分页
        $pageHtml = PaginationServices::getPagination($pagination, $seachvalue, $action);
        $this->assign('dictionaryList', $dictionaryList);
        $this->assign('pageHtml', $pageHtml);
        $this->assign('TotalCount', $pagination->TotalCount);
        return $this->fetch();
    }

    /**
     * 分类列表  查看详情
     * @param Request $request
     * @return mixed
     */
    public function categoryList(Request $request)
    {
        $Dictionary = DictionaryPool::getDictionaries($request->get('Code'));
        $this->assign('Dictionary', $Dictionary);
        $this->assign('Code', $request->get('Code'));
        $this->assign('parentName', $request->get('parentName'));
        $this->assign('DictionaryId', $request->get('DictionaryId'));
        return $this->fetch();
    }

    /**
     * 字典列表  字典添加
     * @param Request $request
     * @return mixed
     */
    public function addDictionary(Request $request)
    {
        return $this->fetch();
    }

    /**
     * 字典列表  字典添加 请求方法
     * @param Request $request
     * @return mixed
     */
    public function addDictionaryRequest(Request $request)
    {
        $data = $request->post();
        $IsExistenceCode = BizDict::where('Code', $data['Code'])->whereOr('Name', $data['Name'])->find();
        if ($IsExistenceCode) {
            echo "<script>alert('该名称或者code已存在');location.href='dictionaryList'</script>";
            die;
        }else{
            $result = BizDict::create($data);
            if ($result) {
                echo "<script>alert('新增成功');location.href='dictionaryList'</script>";
                die;
            }
        }

    }

    /**
     * 字典列表  字典修改
     * @param Request $request
     * @return mixed
     */
    public function updateDictionary(Request $request)
    {
        $data = $request->get();
        $Dictionary = BizDict::where('DictionaryId', $data['DictionaryId'])->find();
        $this->assign('Dictionary', $Dictionary);
        return $this->fetch();
    }

    /**
     * 字典列表  字典修改请求方法
     * @param Request $request
     * @return mixed
     */
    public function updateDictionaryRequest(Request $request)
    {
        $data = $request->post();
        $OldCode=$data['OldCode'];
        unset($data['OldCode']);
        $result = BizDict::update($data, $data['DictionaryId']);
        if ($result) {
            Cache::rm("Dic:Entries_".strtoupper($OldCode));
            echo "<script>alert('修改成功');location.href='dictionaryList'</script>";
            die;
        }
    }

    /**
     * 字典列表  分类添加
     * @param Request $request
     * @return mixed
     */
    public function addCategory(Request $request)
    {
        if(!empty($request->get('level'))){
            $this->assign('level', $request->get('level'));
        }
        return $this->fetch();
    }


    /**
     * 字典列表  分类添加 请求方法
     * @param Request $request
     * @return mixed
     */
    public function addCategoryRequest(Request $request)
    {
        $data = $request->post();
        /* $IsExistenceCode = DictionaryEntry::where('Name', $data['Name'])->find();
       if ($IsExistenceCode) {
            $url = $_SERVER['HTTP_REFERER'];
            echo "<script>alert('该名称已存在');location.href='".$url."'</script>";die;
        }else{*/
            $result = DictionaryEntry::create($data);
            if ($result) {
                $Dictionary = BizDict::where('DictionaryId', $data['DictionaryId'])->find();
                Cache::rm("Dic:Entries_".strtoupper($Dictionary['Code']));
                $param = "categoryList?Code=".$Dictionary['Code']."&parentName=".$Dictionary['Name']."&DictionaryId=".$data['DictionaryId'];
                echo "<script>alert('新增成功');location.href='".$param."'</script>";
            }
       // }
    }

    /**
     * 字典列表  字典修改
     * @param Request $request
     * @return mixed
     */
    public function updateCategory(Request $request)
    {
        $data = $request->get();
        $Dictionary = DictionaryEntry::where('EntryId', $data['EntryId'])->find();

        $Dictionary ['ParentCode'] = $data['ParentCode'];
        $this->assign('Dictionary', $Dictionary);
        return $this->fetch();
    }

    /**
     * 字典列表  字典修改请求方法
     * @param Request $request
     * @return mixed
     */
    public function updateCategoryRequest(Request $request)
    {
        $data = $request->post();
        $OldCode=$data['OldCode'];
        unset($data['OldCode']);
        $result = DictionaryEntry::update($data, $data['EntryId']);
        if ($result) {
            $Dictionary = BizDict::where('DictionaryId', $data['DictionaryId'])->find();
            Cache::rm("Dic:Entries_".strtoupper($OldCode));
            $param = "categoryList?Code=".$Dictionary['Code']."&parentName=".$Dictionary['Name']."&DictionaryId=".$Dictionary['DictionaryId'];
            echo "<script>alert('修改成功');location.href='".$param."'</script>";
        }
    }

    /**
     * 字典列表  字典删除
     * @param Request $request
     * @return mixed
     */
    public function deleteDictionary(Request $request)
    {
        $DictionaryId = $request->get('DictionaryId');
        $result = DictionaryEntry::where('DictionaryId', $DictionaryId)->select();
        if ($result) {
           return   1;
        }else{
            $Dictionary = BizDict::where('DictionaryId', $DictionaryId)->delete();
            Cache::rm("Dic:Entries_".strtoupper($result['Code']));
            return   2;
        }
    }

    /**
     * 字典列表  分类删除
     * @param Request $request
     * @return mixed
     */
    public function deleteCategory(Request $request)
    {
        $EntryId = $request->get('EntryId');
        $result = DictionaryEntry::where('ParentId', $EntryId)->select();
        if ($result) {
            return   1;
        }else{
            $Dictionary = DictionaryEntry::where('EntryId', $EntryId)->delete();
            Cache::rm("Dic:Entries_".strtoupper($request->get('Code')));
            return   2;
        }
    }

}
