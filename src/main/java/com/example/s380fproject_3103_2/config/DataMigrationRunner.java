package com.example.s380fproject_3103_2.config;

import com.example.s380fproject_3103_2.model.CourseFile;
import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.repository.CourseFileRepository;
import com.example.s380fproject_3103_2.repository.CourseMaterialRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Component
@Order(1)
public class DataMigrationRunner implements ApplicationRunner {

    @Autowired
    private CourseMaterialRepository courseMaterialRepository;

    @Autowired
    private CourseFileRepository courseFileRepository;

    @Override
    @Transactional
    public void run(ApplicationArguments args) throws Exception {
        // 將舊的單檔案結構遷移至新的多檔案結構
        List<CourseMaterial> courseMaterials = courseMaterialRepository.findAll();
        
        for (CourseMaterial course : courseMaterials) {
            // 檢查是否有舊的 filePath，且沒有對應的 CourseFile 記錄
            if (course.getFilePath() != null && !course.getFilePath().isEmpty() 
                    && (course.getCourseFiles() == null || course.getCourseFiles().isEmpty())) {
                
                // 創建新的 CourseFile 記錄
                CourseFile file = new CourseFile();
                file.setFileName(course.getFilePath().substring(course.getFilePath().indexOf("_") + 1));
                file.setFilePath(course.getFilePath());
                file.setFileType("application/pdf"); // 假設是 PDF
                file.setFileSize(0L); // 修正: 使用 0L 明確指定為 Long 類型
                file.setCourseMaterial(course);
                
                courseFileRepository.save(file);
                
                System.out.println("已遷移課程檔案: " + course.getTitle());
            }
        }
    }
}