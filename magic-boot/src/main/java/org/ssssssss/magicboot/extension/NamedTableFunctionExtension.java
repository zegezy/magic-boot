package org.ssssssss.magicboot.extension;

import org.springframework.stereotype.Component;
import org.ssssssss.magicapi.modules.table.NamedTable;
import org.ssssssss.magicboot.model.MagicBootConstants;
import org.ssssssss.script.annotation.Comment;
import org.ssssssss.script.functions.ExtensionMethod;

import java.util.Map;

@Component
public class NamedTableFunctionExtension implements ExtensionMethod {

    @Override
    public Class<?> support() {
        return NamedTable.class;
    }

    @Comment("保存到表中，当主键有值时则修改，否则插入")
    public static Object saveOrUpdate(NamedTable namedTable, @Comment("各项列和值") Map<String, Object> data){
        namedTable.setAttribute(MagicBootConstants.COMMON_FIELD, true);
        namedTable.save(data,true);
        return namedTable.getAttribute(MagicBootConstants.ID);
    }

    @Comment("保存到表中，当主键有值时则修改，否则插入")
    public static Object saveOrUpdate(NamedTable namedTable){
        return saveOrUpdate(namedTable, null);
    }

}