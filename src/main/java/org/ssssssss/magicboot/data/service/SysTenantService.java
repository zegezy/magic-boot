package org.ssssssss.magicboot.data.service;

import org.ssssssss.magicboot.data.entity.SysTenant;
import com.baomidou.mybatisplus.extension.service.IService;

/**
* @author yean
* @description 针对表【sys_tenant(租户表)】的数据库操作Service
* @createDate 2025-02-22 17:37:23
*/
public interface SysTenantService extends IService<SysTenant> {

    /**
     * 根据域名获取租户信息
     * @param domain
     * @return
     */
    SysTenant getTenantByDomain(String domain);
}
