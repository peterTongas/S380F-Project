package com.example.s380fproject_3103_2;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class S380fProject31032Application {

    public static void main(String[] args) {

        SpringApplication.run(S380fProject31032Application.class, args);
        System.out.println("Server Vendor: " +
                org.apache.catalina.util.ServerInfo.getServerInfo());
    }

}
