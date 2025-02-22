package org.ssssssss.magicboot.data.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 租户表
 * @TableName sys_tenant
 */
@TableName(value ="sys_tenant")
@Data
public class SysTenant {
    /**
     * 租户ID
     */
    @TableId(value = "id")
    private String id;

    /**
     * 租户编码
     */
    @TableField(value = "code")
    private String code;

    /**
     * 租户名称
     */
    @TableField(value = "name")
    private String name;

    /**
     * 租户Logo
     */
    @TableField(value = "logo")
    private String logo;

    /**
     * 网站图标
     */
    @TableField(value = "favicon")
    private String favicon;

    /**
     * 登录页背景图
     */
    @TableField(value = "login_background")
    private String loginBackground;

    /**
     * 系统名称
     */
    @TableField(value = "system_name")
    private String systemName;

    /**
     * 版权信息
     */
    @TableField(value = "copyright")
    private String copyright;

    /**
     * 状态：0禁用，1启用
     */
    @TableField(value = "status")
    private Integer status;

    /**
     * 到期时间
     */
    @TableField(value = "expire_time")
    private Date expireTime;

    /**
     * 最大用户数
     */
    @TableField(value = "max_user")
    private Integer maxUser;

    /**
     * 联系人姓名
     */
    @TableField(value = "contact_name")
    private String contactName;

    /**
     * 联系人电话
     */
    @TableField(value = "contact_phone")
    private String contactPhone;

    /**
     * 联系人邮箱
     */
    @TableField(value = "contact_email")
    private String contactEmail;

    /**
     * 备注信息
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

    /**
     * 删除标识
     */
    @TableField(value = "is_del")
    private Integer isDel;

    /**
     * 创建人ID
     */
    @TableField(value = "create_by")
    private String createBy;

    /**
     * 更新人ID
     */
    @TableField(value = "update_by")
    private String updateBy;

    /**
     * 数据库类型(MYSQL/MARIADB/SQLSERVER/ORACLE)
     */
    @TableField(value = "db_type")
    private String dbType;

    /**
     * 租户JDBC连接字符串
     */
    @TableField(value = "db_jdbc_url")
    private String dbJdbcUrl;

    /**
     * 数据库IP
     */
    @TableField(value = "db_host")
    private String dbHost;

    /**
     * 数据库端口号
     */
    @TableField(value = "db_port")
    private Integer dbPort;

    /**
     * 数据库用户名
     */
    @TableField(value = "db_user")
    private String dbUser;

    /**
     * 数据库密码
     */
    @TableField(value = "db_password")
    private String dbPassword;

    /**
     * 数据库名称
     */
    @TableField(value = "db_name")
    private String dbName;
}