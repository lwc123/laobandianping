<?php

namespace app\workplace;

class workplaceExtensionContainer
{
    /**
     * @SWG\Get(
     *     path="/workplace/Extension/AuditStatus",
     *     summary="认证状态类型",
     *     tags={"const"},
     *     description="",
     *     @SWG\Response(
     *         response=200,
     *         description="认证状态类型",     
     *         @SWG\Schema(ref="#/definitions/AuditStatus")
     *     )
     * )
     */
    public function AuditStatus()
    {
    }

    /**
     * @SWG\Get(
     *     path="/workplace/Extension/ContractStatus",
     *     summary="认证状态类型",
     *     tags={"const"},
     *     description="",
     *     @SWG\Response(
     *         response=200,
     *         description="认证状态类型",
     *         @SWG\Schema(ref="#/definitions/ContractStatus")
     *     )
     * )
     */
    public function ContractStatus()
    {
    }
    
    /**
     * @SWG\Get(
     *     path="/workplace/Extension/CommentType",
     *     summary="评价类型",
     *     tags={"const"},
     *     description="",
     *     @SWG\Response(
     *         response=200,
     *         description="",
     *         @SWG\Schema(ref="#/definitions/CommentType")
     *     )
     * )
     */
    public function CommentType()
    {
    }
    
    /**
     * @SWG\Get(
     *     path="/workplace/Extension/MemberRole",
     *     summary="授权人角色权限枚举",
     *     tags={"const"},
     *     description="",
     *     @SWG\Response(
     *         response=200,
     *         description="授权人角色权限枚举",
     *         @SWG\Schema(ref="#/definitions/MemberRole")
     *     )
     * )
     */
    public function MemberRole()
    {
    }
    /**
     * @SWG\Get(
     *     path="/workplace/Extension/PriceStrategyAuditStatus",
     *     summary="价格策略(活动)状态枚举",
     *     tags={"const"},
     *     description="",
     *     @SWG\Response(
     *         response=200,
     *         description="",
     *         @SWG\Schema(ref="#/definitions/PriceStrategyAuditStatus")
     *     )
     * )
     */
    public function PriceStrategyAuditStatus()
    {
    }

    /**
     * @SWG\Get(
     *     path="/workplace/Extension/ActivityType",
     *     summary="价格策略(活动)类型枚举",
     *     tags={"const"},
     *     description="",
     *     @SWG\Response(
     *         response=200,
     *         description="",
     *         @SWG\Schema(ref="#/definitions/ActivityType")
     *     )
     * )
     */
    public function ActivityType()
    {
    }

    /**
     * @SWG\Get(
     *     path="/workplace/Extension/JobDisplayState",
     *     summary="职位显示枚举",
     *     tags={"const"},
     *     description="",
     *     @SWG\Response(
     *         response=200,
     *         description="",
     *         @SWG\Schema(ref="#/definitions/JobDisplayState")
     *     )
     * )
     */
    public function JobDisplayState()
    {
    }

    /**
     * @SWG\Get(
     *     path="/workplace/Extension/DrawMoneyAuditStatus",
     *     summary="提现状态枚举",
     *     tags={"const"},
     *     description="",
     *     @SWG\Response(
     *         response=200,
     *         description="",
     *         @SWG\Schema(ref="#/definitions/DrawMoneyAuditStatus")
     *     )
     * )
     */
    public function DrawMoneyAuditStatus()
    {
    }

    /**
     * @SWG\Get(
     *     path="/workplace/Extension/UpgradeType",
     *     summary="APP更新策略枚举",
     *     tags={"const"},
     *     description="",
     *     @SWG\Response(
     *         response=200,
     *         description="",
     *         @SWG\Schema(ref="#/definitions/UpgradeType")
     *     )
     * )
     */
    public function UpgradeType()
    {
    }
}



