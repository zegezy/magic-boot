package org.ssssssss.magicboot.model;

import cn.hutool.core.util.StrUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.ssssssss.magicboot.utils.WebUtils;

@Component
public class Global {

    /**
     * 文件上的根目录
     */
    public static String dir;

    public final static String USER_FILES_BASE_URL = "/userfiles/";

    public static String getDir() {
        return dir;
    }

    @Value("${upload.dir:D:/mb/}")
    public void setDir(String dir) {
        this.dir = dir;
    }

    /**
     * 获取上传文件的根目录
     *
     * @return
     */
    public static String getUserFilesBaseDir() {
        String dir = getDir();
        if (StrUtil.isBlank(dir)) {
            try {
                dir = WebUtils.getHttpServletRequest().getSession().getServletContext().getRealPath("/");
            } catch (Exception e) {
                return "";
            }
        }
        if (!dir.endsWith("/")) {
            dir += "/";
        }
        return dir;
    }

    public static String OSS_ENDPOINT;

    public static String OSS_ACCESS_KEY_ID;

    public static String OSS_ACCESS_KEY_SECRET;

    public static String OSS_BUCKET_NAME;

    public static String OSS_TRANSPORT_PROTOCOL;

    @Value("${upload.oss.endpoint}")
    public void setOssEndpoint(String ossEndpoint) {
        OSS_ENDPOINT = ossEndpoint;
    }

    @Value("${upload.oss.access-key-id}")
    public void setOssAccessKeyId(String ossAccessKeyId) {
        OSS_ACCESS_KEY_ID = ossAccessKeyId;
    }

    @Value("${upload.oss.access-key-secret}")
    public void setOssAccessKeySecret(String ossAccessKeySecret) {
        OSS_ACCESS_KEY_SECRET = ossAccessKeySecret;
    }

    @Value("${upload.oss.bucket-name}")
    public void setOssBucketName(String ossBucketName) {
        OSS_BUCKET_NAME = ossBucketName;
    }

    @Value("${upload.oss.transport-protocol:https}")
    public void setOssTransportProtocol(String ossTransportProtocol) {
        OSS_TRANSPORT_PROTOCOL = ossTransportProtocol;
    }

    public static String UPLOAD_TYPE;

    @Value("${upload.type}")
    public void setUploadType(String uploadType) {
        UPLOAD_TYPE = uploadType;
    }

}
