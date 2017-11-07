<?php

namespace app\opinion\models;

/**
 * @SWG\Definition(required={""})
 */
class ConcernedTotal extends OpinionBase {


    /**
     * @SWG\Property(type="integer", description="关注企业总数")
     */
    public $ConcernedTotal;

    /**
     * @SWG\Property(ref="#/definitions/Company")
     */
    public $Companies;

}
