package com.helpdesk.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import java.io.File;

@Configuration
public class FileConfig {

    @Value("${file.upload-path}")
    private String uploadPath;

    @PostConstruct
    public void init() {
        // 업로드 디렉토리 생성
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            if (created) {
                System.out.println("파일 업로드 디렉토리 생성: " + uploadPath);
            } else {
                System.err.println("파일 업로드 디렉토리 생성 실패: " + uploadPath);
            }
        } else {
            System.out.println("파일 업로드 디렉토리 확인: " + uploadPath);
        }
    }
}