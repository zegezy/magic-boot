package org.ssssssss.magicboot.data.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 租户接入配置表
 * @TableName sys_tenant_platform
 */
@TableName(value ="sys_tenant_platform")
@Data
public class SysTenantPlatform {
    /**
     * 主键
     */
    @TableId(value = "id")
    private String id;

    /**
     * 租户ID
     */
    @TableField(value = "tenant_id")
    private String tenantId;

    /**
     * 平台类型：DOMAIN域名,PATH路径,WX_MINI微信小程序,WX_MP微信公众号,WX_WORK企业微信,DINGTALK钉钉,FEISHU飞书
     */
    @TableField(value = "platform_type")
    private String platformType;

    /**
     * 标识符(域名/路径/AppID)
     */
    @TableField(value = "identifier")
    private String identifier;

    /**
     * 应用密钥
     */
    @TableField(value = "app_secret")
    private String appSecret;

    /**
     * 是否默认(用于域名)
     */
    @TableField(value = "is_default")
    private Integer isDefault;

    /**
     * 其他配置JSON
     */
    @TableField(value = "other_config")
    private String otherConfig;

    /**
     * 状态：0禁用，1启用
     */
    @TableField(value = "status")
    private Integer status;

    /**
     * 备注
     */
    @TableField(value = "remark")
    private String remark;

    /**
     * 创建时间
     */
    @TableField(value = "create_date")
    private Date createDate;

    /**
     * 更新时间
     */
    @TableField(value = "update_date")
    private Date updateDate;
}