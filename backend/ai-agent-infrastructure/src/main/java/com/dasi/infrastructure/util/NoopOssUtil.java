package com.dasi.infrastructure.util;

import com.dasi.domain.util.oss.IOssUtil;
import com.dasi.types.exception.WorkException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.multipart.MultipartFile;

import static com.dasi.types.constant.ExceptionMessage.AVATAR_UPLOAD_FAIL;

@Slf4j
public class NoopOssUtil implements IOssUtil {

    @Override
    public void deleteObject(String objectUrl) {
        // OSS is disabled in local mode, so there is nothing to delete.
    }

    @Override
    public String uploadObject(MultipartFile file) {
        log.warn("Avatar upload was requested while OSS is disabled");
        throw new WorkException(AVATAR_UPLOAD_FAIL);
    }

    @Override
    public String getObjectUrl(String objectName) {
        return objectName == null ? "" : objectName;
    }
}
