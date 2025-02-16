package org.ssssssss.magicboot.enums;

/**
 * 租户数据库类型
 */
public enum TenantDbType {

    MYSQL("MySQL", "MYSQL", "com.mysql.cj.jdbc.Driver")
    , SQLSERVER("SQLServer", "SQLSERVER", "com.microsoft.sqlserver.jdbc.SQLServerDriver")
    , ORACLE("Oracle", "ORACLE", "oracle.jdbc.driver.OracleDriver")
    , POSTGRESQL("PostgreSQL", "POSTGRESQL", "org.postgresql.Driver")
    , DB2("DB2", "DB2", "com.ibm.db2.jcc.DB2Driver")
    , H2("H2", "H2", "org.h2.Driver");

    private final String name;

    private final String code;

    private final String driverClassName;

    public String getName() {
        return name;
    }

    public String getCode() {
        return code;
    }

    public String getDriverClassName() {
        return driverClassName;
    }

    TenantDbType(String name, String code, String driverClassName) {
        this.name = name;
        this.code = code;
        this.driverClassName = driverClassName;
    }

    public static TenantDbType getByCode(String code) {
        for (TenantDbType type : TenantDbType.values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        return null;
    }
}
