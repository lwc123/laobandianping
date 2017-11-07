<?php

namespace app\apppage;
/**
 * @SWG\Tag(
 * name="apppage",
 * description="APP H5页面链接地址+参数API"
 * )
 *
 * @SWG\Tag(
 * name="m",
 * description="移动站页面， 使用主域名 http://bc.jux360.cn:8000"
 * )*
 */
/**
 * @SWG\Definition(required={"ArchiveId"})
 */
class apppage
{

    /**
     * @SWG\GET(
     * path="/apppage/domain",
     * summary="线上+线下域名地址",
     * description=" Url拼接方式：域名+以下链接+参数 <br/> 线下：http://bc-api.jux360.cn:8120/v-test <br/> 线上：http://api.laobandianping.com:8120/v-test ",
     * tags={"apppage"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function domain()
    {
    }

    /**
     * @SWG\GET(
     * path="/apppage/EmployeArchive/Archive",
     * summary="档案详情",
     * description=" ",
     * tags={"apppage"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="ArchiveId",
     * in="query",
     * description="档案ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function Archive()
    {
    }

    /**
     * @SWG\GET(
     * path="/apppage/EmployeArchive/Report",
     * summary="离职报告详情",
     * description=" ",
     * tags={"apppage"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="oid",
     * in="query",
     * description="离职报告ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function Report()
    {
    }

    /**
     * @SWG\GET(
     * path="/apppage/EmployeArchive/Comment",
     * summary="阶段评价详情",
     * description=" ",
     * tags={"apppage"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="oid",
     * in="query",
     * description="阶段评价ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function Comment()
    {
    }

    /**
     * @SWG\GET(
     * path="/apppage/BackgroundSurvey/index",
     * summary="背景调查首页+搜索",
     * description=" ",
     * tags={"apppage"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function search_index()
    {
    }

    /**
     * @SWG\GET(
     * path="/apppage/BackgroundSurvey/BoughtDetail",
     * summary="背景调查详情页（多个档案，购买成功跳转页）",
     * description="记录ID可以多个，例如1,2,3",
     * tags={"apppage"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="RecordId",
     * in="query",
     * description="记录ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function BoughtDetail()
    {
    }

    /**
     * @SWG\GET(
     * path="/apppage/BackgroundSurvey/BoughtPurchased",
     * summary="已经购买的背景调查记录",
     * description="",
     * tags={"apppage"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="Page",
     * in="query",
     * description="页码",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="Size",
     * in="query",
     * description="每页个数",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function BoughtPurchased()
    {
    }

    /**
     * @SWG\GET(
     * path="/apppage/BackgroundSurvey/SingleDetail",
     * summary="背景调查详情页（单个档案，列表点击跳转页）",
     * description="",
     * tags={"apppage"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="ArchiveId",
     * in="query",
     * description="档案ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function SingleDetail()
    {
    }

    /**
     * @SWG\GET(
     * path="/apppage/BackgroundSurvey/personal",
     * summary="个人背景调查详情页",
     * description="",
     * tags={"apppage"},
     * @SWG\Parameter(
     * name="ArchiveId",
     * in="query",
     * description="档案ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function personal()
    {
    }

    /**
     * @SWG\GET(
     * path="/apppage/JobDetail/Detail",
     * summary="职位详情页(企业+个人)",
     * description="企业需要传企业ID",
     * tags={"apppage"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=false,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="JobId",
     * in="query",
     * description="职位ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function Detail()
    {
    }


    /**
     * @SWG\GET(
     * path="/m/BossComments/AboutUs",
     * summary="关于我们",
     * description="",
     * tags={"m"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function AboutUs()
    {
    }

    /**
     * @SWG\GET(
     * path="/m/BossComments/ContactUs",
     * summary="联系我们",
     * description="",
     * tags={"m"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function ContactUs()
    {
    }

    /**
     * @SWG\GET(
     * path="/m/BossComments/CompanyAgreement",
     * summary="企业用户协议",
     * description="",
     * tags={"m"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function CompanyAgreement()
    {
    }

    /**
     * @SWG\GET(
     * path="/m/BossComments/CompanyPrivacy",
     * summary="企业用户隐私政策",
     * description="",
     * tags={"m"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function CompanyPrivacy()
    {
    }

    /**
     * @SWG\GET(
     * path="/m/BossComments/companyTransfer",
     * summary="对公账号",
     * description="",
     * tags={"m"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function companyTransfer()
    {
    }


    /**
     * @SWG\GET(
     * path="/m/BossComments/UserAgreement",
     * summary="个人用户协议",
     * description="",
     * tags={"m"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function UserAgreement()
    {
    }

    /**
     * @SWG\GET(
     * path="/m/BossComments/UserPrivacy",
     * summary="个人用户隐私政策",
     * description="",
     * tags={"m"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function UserPrivacy()
    {
    }

    /**
     * @SWG\GET(
     *  path="/apppage/Company/RenewalEnterpriseService?CompanyId=129&os=android&Version=2.0.1",
     *  summary="公司续费(开户)",
     *  description="",
     *  tags={"apppage"},
     *  @SWG\Parameter(
     *      name="CompanyId",
     *      in="query",
     *      description="公司Id",
     *      required=true,
     *      type="string"
     * ),
     *  @SWG\Parameter(
     *      name="os",
     *      in="query",
     *      description="系统： ios 或 android",
     *      required=true,
     *      type="string"
     * ),
     *  @SWG\Parameter(
     *      name="Version",
     *      in="query",
     *      description="APP的当前版本号",
     *      required=true,
     *      type="string"
     * ),
     *  @SWG\Response(
     *      response=200,
     *      description="",
     *      @SWG\Schema(type="string")
     *  )
     * )
     */
    public function RenewalEnterpriseService()
    {
    }

    /**
     * @SWG\GET(
     * path="/apppage/opinion/opinionDetail",
     * summary="点评详情",
     * description="",
     * tags={"apppage"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(type="string")
     * )
     * )
     */
    public function opinionDetail()
    {
    }
}



