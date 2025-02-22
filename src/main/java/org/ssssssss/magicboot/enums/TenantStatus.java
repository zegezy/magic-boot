package org.ssssssss.magicboot.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
public enum TenantStatus {

    NORMAL(1,"启用"),

    EXPIRED(0,"禁用"),
    ;

    /**
     * 状态码
     */
    @Getter
    private final Integer code;

    /**
     * 状态名称
     */
    @Getter
    private final String name;


}
