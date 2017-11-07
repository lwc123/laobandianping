<?php

namespace app\workplace\services;

use app\workplace\models\PrivatenessServiceContract;
use think\Db;
use think\Request;
use think\Config;
use app\common\models\Result;
use app\common\models\ErrorCode;
use app\common\modules\ResourceHelper;
use app\common\modules\PaymentEngine;
use app\common\modules\DbHelper;
use app\workplace\models\EmployeArchive;
use app\workplace\models\ArchiveComment;
use app\workplace\models\Company;
use app\workplace\models\WorkItem;
use app\workplace\models\PrivatenessViewCommentRecord;
use app\common\modules\DictionaryPool;

class PrivatenessService
{
    /**
     * 查找填写身份证号个人合同表是否存在
     *
     * @access public
     * @param int $fundidcard
     * @return Result
     */
    public static function Fundidcard($fundidcard)
    {

        if (empty ($fundidcard) || empty ($fundidcard ["IDCard"])) {
            exception('非法请求-1', 412);
        }
        $idcard = PrivatenessServiceContract::where([
            'IDCard' => $fundidcard ["IDCard"]
        ])->find();
        if ($idcard) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 绑定身份证号
     *
     * @access public
     * @param int $BindingIDCard
     * @return Result
     */
    public static function BindingIDCard($BindingIDCard)
    {
        if (empty ($BindingIDCard) || empty ($BindingIDCard ["PassportId"]) || empty ($BindingIDCard ["IDCard"])) {
            exception('非法请求-0', 412);
        }
        $Fundidcard = PrivatenessService::Fundidcard($BindingIDCard);

        if ($Fundidcard == true) {
            return Result::error(ErrorCode::Privateness_IDCard, '此身份证号已绑定，不能重复绑定');
        }
        // 查询此用户是否存在合同
        $isContract = PrivatenessServiceContract::where('PassportId', $BindingIDCard ["PassportId"])->find();
        if (empty ($isContract)) {
            $ServiceContract = [
                'PassportId' => $BindingIDCard ["PassportId"],
                'ContractStatus' => 1,
                'IDCard' => $BindingIDCard ["IDCard"],
                'ServiceBeginTime' => DbHelper::getZeroDbDate(),
                'ServiceEndTime' => DbHelper::getZeroDbDate(),
                'TotalFee' => PaymentEngine::GetOpenPrivatenessServicePrice()
            ];
            $createcontract = PrivatenessServiceContract::create($ServiceContract);
            return Result::success($createcontract ['ContractId'], $createcontract);
        } else {
            $ServiceContract = [
                'IDCard' => $BindingIDCard ["IDCard"],
                'TotalFee' => PaymentEngine::GetOpenPrivatenessServicePrice()
            ];
            $updatecontract = PrivatenessServiceContract::where('PassportId', $BindingIDCard ["PassportId"])->update($ServiceContract);
            return Result::success($isContract ['ContractId'], NULL);
        }

    }

    /**
     * 档案详情
     *
     * @access public
     * @param int $BindingIDCard
     * @return Result
     */
    public static function Detail($DetailItem)
    {
        if (empty ($DetailItem) || empty ($DetailItem['ArchiveId']) || empty ($DetailItem['PassportId'])) {
            exception('非法请求-0', 412);
        }

        //档案详情
        $Detail = EmployeArchive::where('ArchiveId', $DetailItem['ArchiveId'])->find();

        if ($Detail) {

            //检查：没有新建个人查看评价记录+7天，存在则判断是否还在有效期内
            $checkdata = PrivatenessViewCommentRecord::where(['PassportId' => $DetailItem['PassportId'], 'ArchiveId' => $DetailItem['ArchiveId']])->find();

            if (empty($checkdata)) {
                $CreateRecord = PrivatenessViewCommentRecord::create([
                    'PassportId' => $DetailItem['PassportId'],
                    'ArchiveId' => $DetailItem['ArchiveId'],
                    'ViewBeginTime' => DbHelper::toLocalDateTime(date("Y-m-d H:i:s")),
                    'ViewEndTime' => DbHelper::toLocalDateTime(date("Y-m-d H:i:s", strtotime("+1 week")))
                ]);
                $Detail['ViewBeginTime'] = $CreateRecord['ViewBeginTime'];
                $Detail['IsView'] = 1;
            } else {
                $Detail['ViewBeginTime'] = $checkdata['ViewBeginTime'];
                if ((strtotime(date("Y-m-d H:i:s")) - strtotime($checkdata['ViewEndTime'])) >= 0) {
                    $Detail['IsView'] = 0;
                } else {
                    $Detail['IsView'] = 1;
                }
            }

            $Detail['Age'] = countage($Detail['Birthday']) . '岁';
            $Detail['CompanyName'] = Company::where('CompanyId', $Detail['CompanyId'])->value('CompanyName');
            $Detail['PostTitle'] = WorkItem::where('DeptId', $Detail['DeptId'])->value('PostTitle');
            $Detail['Education'] = DictionaryPool::getEntryNames('academic', $Detail['Education']);

            $Comments = ArchiveComment::where(['ArchiveId' => $DetailItem['ArchiveId'], 'AuditStatus' => 2])->order('CommentType', 'desc')->select();
            if ($Comments) {
                foreach ($Comments as $k => $value) {

                    $Comments[$k]['DimissionReason'] = DictionaryPool::getEntryNames('leaving', $value['DimissionReason']);
                    $Comments[$k]['WantRecall'] = DictionaryPool::getEntryNames('panicked', $value['WantRecall']);
                    $Comments[$k]['StageSection'] = DictionaryPool::getEntryNames('period', $value['StageSection']);

                    if ($value['WorkCommentImages']) {
                        //图片数组处理
                        $Comments[$k]['WorkCommentImages'] = explode(",", str_replace(array("[", "]"), "", $value['WorkCommentImages']));
                        $Images = [];
                        foreach ($Comments[$k]['WorkCommentImages'] as $WorkCommentImages) {
                            $Images[] = Config('resources_site_root') . $WorkCommentImages;
                        }
                        $Comments[$k]['WorkCommentImages'] = $Images;
                        if ($Comments[$k]['WorkCommentVoice'] == Config('resources_site_root')) {
                            $Comments[$k]['WorkCommentVoice'] = '';
                        }
                    }
                }
            }
            $Detail['Commests'] = $Comments;
            return $Detail;
        }
    }
}