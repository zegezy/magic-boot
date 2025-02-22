package org.ssssssss.magicboot.data.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.ssssssss.magicboot.data.entity.SysTenant;
import org.ssssssss.magicboot.data.service.SysTenantService;
import org.ssssssss.magicboot.data.mapper.SysTenantMapper;
import org.springframework.stereotype.Service;

/**
* @author yean
* @description 针对表【sys_tenant(租户表)】的数据库操作Service实现
* @createDate 2025-02-22 17:37:23
*/
@Service
public class SysTenantServiceImpl extends ServiceImpl<SysTenantMapper, SysTenant>
    implements SysTenantService{

    @Override
    public SysTenant getTenantByDomain(String domain) {
        return getBaseMapper().getTenantByDomain(domain);
    }
}




