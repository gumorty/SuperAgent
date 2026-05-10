package com.dasi.config;

import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.dasi.domain.util.jwt.UserContext;
import com.dasi.domain.util.oss.IOssUtil;
import com.dasi.domain.util.oss.OssProperties;
import com.dasi.infrastructure.util.NoopOssUtil;
import com.dasi.infrastructure.util.OssUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.StringUtils;

@Configuration
@Slf4j
public class OssClientConfig {

    @Bean
    public IOssUtil ossUtil(OssProperties ossProperties, UserContext userContext) {
        if (!isConfigured(ossProperties)) {
            log.warn("OSS is not configured. Falling back to local no-op mode; avatar upload is disabled.");
            return new NoopOssUtil();
        }

        log.info("Initializing OSS client");
        OSS ossClient = new OSSClientBuilder().build(
                ossProperties.getEndpoint(),
                ossProperties.getAccessKeyId(),
                ossProperties.getAccessKeySecret()
        );
        return new OssUtil(ossProperties, ossClient, userContext);
    }

    private boolean isConfigured(OssProperties ossProperties) {
        return StringUtils.hasText(ossProperties.getEndpoint())
                && StringUtils.hasText(ossProperties.getBucket())
                && StringUtils.hasText(ossProperties.getAccessKeyId())
                && StringUtils.hasText(ossProperties.getAccessKeySecret());
    }

}
