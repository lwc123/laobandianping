<?php

namespace app\opinion\models;

/**
 * @SWG\Definition(required={""})
 */
class OpinionTotal extends OpinionBase {

    /**
    /**
     * @SWG\Property(type="integer", description="点评总条数")
     */
    public $OpinionTotal;

    /**
     * @SWG\Property(type="boolean", description="是否显示红点,首页列表")
     */
    public $IsRedDot;

    /**
     * @SWG\Property(ref="#/definitions/Opinion")
     */
    public $Opinions;

}
