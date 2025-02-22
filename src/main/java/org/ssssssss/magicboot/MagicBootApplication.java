package org.ssssssss.magicboot;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("org.ssssssss.magicboot.data.mapper")
public class MagicBootApplication {

    public static void main(String[] args) {
        SpringApplication.run(MagicBootApplication.class, args);
    }

}
