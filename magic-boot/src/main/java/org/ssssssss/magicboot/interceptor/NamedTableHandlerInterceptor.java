package org.ssssssss.magicboot.interceptor;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.util.IdUtil;
import org.springframework.stereotype.Component;
import org.ssssssss.magicapi.interceptor.NamedTableInterceptor;
import org.ssssssss.magicapi.model.SqlMode;
import org.ssssssss.magicapi.modules.table.NamedTable;
import static org.ssssssss.magicboot.model.MagicBootConstants.*;

import java.util.Date;

@Component
public class NamedTableHandlerInterceptor implements NamedTableInterceptor {

    @Override
    public void preHandle(SqlMode sqlMode, NamedTable namedTable) {
        if(Boolean.TRUE == namedTable.getAttribute(COMMON_FIELD)){
            if(sqlMode == SqlMode.INSERT) {
                String id = IdUtil.simpleUUID();
                namedTable.setAttribute(namedTable.getPrimary(), id);
                namedTable.column(namedTable.getPrimary(), id);
                namedTable.column(CREATE_BY, StpUtil.getLoginId());
                namedTable.column(CREATE_DATE, new Date());
            }
            if(sqlMode == SqlMode.UPDATE){
                namedTable.setAttribute(namedTable.getPrimary(), namedTable.getColumns().get(namedTable.getPrimary()));
                namedTable.column(UPDATE_BY, StpUtil.getLoginId());
                namedTable.column(UPDATE_DATE, new Date());
            }
        }
    }

}
