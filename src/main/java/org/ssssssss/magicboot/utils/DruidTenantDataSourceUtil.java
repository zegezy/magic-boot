package org.ssssssss.magicboot.utils;

import com.alibaba.druid.pool.DruidDataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class DruidTenantDataSourceUtil {

    /**
     * 创建租户数据源
     *
     * @param driverClassName 数据库驱动类名
     * @param url            数据库连接URL
     * @param username       用户名
     * @param password       密码
     * @return DruidDataSource实例
     */
    public DruidDataSource createTenantDataSource(String driverClassName, String url, String username, String password) throws Exception {
        DruidDataSource tenantDataSource = new DruidDataSource();
        
        // 设置基本连接信息
        tenantDataSource.setDriverClassName(driverClassName);
        tenantDataSource.setUrl(url);
        tenantDataSource.setUsername(username);
        tenantDataSource.setPassword(password);
        
        // 设置连接池配置
        tenantDataSource.setInitialSize(1);
        tenantDataSource.setMinIdle(1);
        tenantDataSource.setMaxActive(20);
        tenantDataSource.setMaxWait(60000);
        tenantDataSource.setTimeBetweenEvictionRunsMillis(60000);
        tenantDataSource.setMinEvictableIdleTimeMillis(300000);
        tenantDataSource.setValidationQuery("SELECT 1");
        tenantDataSource.setTestWhileIdle(true);
        tenantDataSource.setTestOnBorrow(false);
        tenantDataSource.setTestOnReturn(false);
        tenantDataSource.setPoolPreparedStatements(true);
        tenantDataSource.setMaxPoolPreparedStatementPerConnectionSize(20);
        
        // 初始化数据源
        tenantDataSource.init();
        
        return tenantDataSource;
    }
    
    /**
     * 创建租户JdbcTemplate
     *
     * @param driverClassName 数据库驱动类名
     * @param url            数据库连接URL
     * @param username       用户名
     * @param password       密码
     * @return JdbcTemplate实例
     */
    public JdbcTemplate createTenantJdbcTemplate(String driverClassName, String url, String username, String password) throws Exception {
        DruidDataSource dataSource = createTenantDataSource(driverClassName, url, username, password);
        return new JdbcTemplate(dataSource);
    }
    
    /**
     * 安全关闭数据源
     *
     * @param dataSource 要关闭的数据源
     */
    public void closeDataSource(DruidDataSource dataSource) {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
} 