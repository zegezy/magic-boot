package test;

import cn.dev33.satoken.secure.SaSecureUtil;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.ssssssss.magicboot.MagicBootApplication;

@SpringBootTest(classes = MagicBootApplication.class)
public class MagicBootTest {

    @Test
    public void test(){
        System.out.println(SaSecureUtil.sha256("1"));
    }

}
