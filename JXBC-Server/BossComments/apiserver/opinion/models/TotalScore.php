<?php

namespace app\opinion\models;

use think\Config;
use think\db\Query;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={""})
 */
class TotalScore extends OpinionBase
{

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $ScoreId;

    /**
     * @SWG\Property(type="integer", description="口碑公司Id")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="口碑总数")
     */
    public $OpinionTotal;

    /**
     * @SWG\Property(type="integer", description="星级总数")
     */

    public $ScoringTotal;
    /**
     * @SWG\Property(type="integer", description="推荐朋友统计总数")
     */

    public $RecommendTotal;

    /**
     * @SWG\Property(type="integer", description="看好公司前景统计总数")
     */
    public $OptimisticTotal;

    /**
     * @SWG\Property(type="integer", description="支持CEO统计总数")
     */
    public $SupportCEOTotal;

    /**
     * @SWG\Property(type="string", description="创建时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $ModifiedTime;


    public static function Score($Opinion)
    {
        if (empty ($Opinion) || empty ($Opinion ['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        $TotalScore = TotalScore::where('CompanyId',$Opinion ['CompanyId'])->find();
        if (empty($TotalScore)) {
            $save = new TotalScore([
                'CompanyId' => $Opinion ['CompanyId'],
                'OpinionTotal' => 1,
                'ScoringTotal' => $Opinion ['Scoring'],
                'RecommendTotal' => $Opinion ['Recommend'],
                'OptimisticTotal' => $Opinion ['Optimistic'],
                'SupportCEOTotal' => $Opinion ['SupportCEO'],
            ]);
            $save->save();
        } else {

            $update['OpinionTotal'] = $TotalScore['OpinionTotal'] + 1;
            $update['ScoringTotal'] = $TotalScore['ScoringTotal'] + $Opinion ['Scoring'];
            $update['RecommendTotal'] = $TotalScore['RecommendTotal'] + $Opinion ['Recommend'];
            $update['OptimisticTotal'] = $TotalScore['OptimisticTotal'] + $Opinion ['Optimistic'];
            $update['SupportCEOTotal'] = $TotalScore['SupportCEOTotal'] + $Opinion ['SupportCEO'];

            $user = new TotalScore();
            $user->save($update,['ScoreId' => $TotalScore ['ScoreId']]);

        }
        $CalculationScore = TotalScore::where('CompanyId',$Opinion ['CompanyId'])->find();
        $user = new Company();
        $user->save([
            'CommentCount' => $CalculationScore['OpinionTotal'],
            'StaffCount' => $CalculationScore['OpinionTotal'],
            'LastOpinionTime' => date('Y-m-d H:i:s', time()),
            'Score' => round(($CalculationScore['ScoringTotal'] / $CalculationScore['OpinionTotal']), 1),
            'Recommend' => round($CalculationScore['RecommendTotal'] / $CalculationScore['OpinionTotal'], 0),
            'Optimistic' => round($CalculationScore['OptimisticTotal'] / $CalculationScore['OpinionTotal'], 0),
            'SupportCEO' => round($CalculationScore['SupportCEOTotal'] / $CalculationScore['OpinionTotal'], 0)
        ], ['CompanyId' => $Opinion ['CompanyId']]);
    }

}
