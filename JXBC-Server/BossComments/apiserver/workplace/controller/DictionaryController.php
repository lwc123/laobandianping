<?php

namespace app\workplace\controller;
use Think\Request;
use app\common\modules\DictionaryPool;
use app\common\controllers\ApiController;

class DictionaryController extends ApiController {
    /**
     * @SWG\GET(
     *     path="/workplace/Dictionary/getDictionaries",
     *     summary="获取字典列表的条目",
     *     tags={"Dictionary"},
     *     @SWG\Parameter(
     *         name="codes",
     *         in="query",
     *         description="类别Code， 多个类别用','连接后传入",
     *         required=true,
     *         type="string",
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="类别下的条目列表",
     *         @SWG\Schema(type="string")
     *     )
     * )
     */
	public function getDictionaries(Request $request) {
        header("Expires: ".gmdate("D, d M Y H:i:s", time() + config("dictionary_expires"))." GMT");

		$codes = $request->get("codes");
		if(empty($codes)) {
		    return null;
        }
        return DictionaryPool::getDictionaries($codes);;
	}
}	

 