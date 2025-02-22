package org.ssssssss.magicboot.data.mapper;

import org.apache.ibatis.annotations.Param;
import org.ssssssss.magicboot.data.entity.SysTenant;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

/**
* @author yean
* @description 针对表【sys_tenant(租户表)】的数据库操作Mapper
* @Entity org.ssssssss.magicboot.data.entity.SysTenant
*/
public interface SysTenantMapper extends BaseMapper<SysTenant> {

    /**
     * 根据域名查询租户信息
     * @param domain
     * @return
     */
    SysTenant getTenantByDomain(@Param("domain") String domain);
}




