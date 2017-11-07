<?php

/**
 * @SWG\Swagger(
 *     basePath="/v-test",
 *     host="",
 *     schemes={"http"},
 *     produces={"application/json"},
 *     consumes={"application/json"},
 *     @SWG\Info(
 *         version="1.0.0",
 *         title="APP接口",
 *         description="APP接口包括基础类库接口和业务类库接口；<br/><br/>基础类库接口：/appbase/****** 包括字典、账号和交易系统；当前服务端实现语言为.Net(C#)。 <br/><br/>业务类库接口: /workplace/****** 包括公司、档案、评价等"
 *     ),
 *     @SWG\Definition(
 *         definition="errorModel",
 *         required={"code", "message"},
 *         @SWG\Property(
 *             property="code",
 *             type="integer",
 *             format="int32"
 *         ),
 *         @SWG\Property(
 *             property="message",
 *             type="string"
 *         )
 *     )
 * )
 */
/**
 * @SWG\Tag(
 *   name="const",
 *   description="相关常量定义(包含枚举)",
 *   @SWG\ExternalDocumentation(
 *     description="Find out more",
 *     url="http : //swagger.io"
 *   )
 * )
 * @SWG\Tag(
 *   name="struct",
 *   description="扩展数据结构定义",
 *   @SWG\ExternalDocumentation(
 *     description="Find out more",
 *     url="http : //swagger.io"
 *   )
 * ) 
 */