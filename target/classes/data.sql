-- Insert Initial Users
INSERT INTO APP_USERS (username, password, full_name, email, phone, role) VALUES
                                                                              ('teacher1', 'password', 'Professor Smith', 'teacher@school.edu', '1234567890', 'TEACHER'),
                                                                              ('student1', 'password', 'Alice Johnson', 'alice@student.edu', '0987654321', 'STUDENT');

-- Insert Course Materials
-- Insert sample data without IDs
INSERT INTO COURSE_MATERIALS (title, description, file_path) VALUES
                                                                 ('Introduction to Spring', 'Spring Framework basics', '/files/lecture1.pdf'),
                                                                 ('Database Design', 'Database principles and patterns', '/files/lecture2.pdf');

-- Insert Polls
INSERT INTO POLLS (question) VALUES
                                 ('Which topic was most challenging?'),
                                 ('How would you rate this course?');

-- Insert Poll Options
INSERT INTO POLL_OPTIONS (text, vote_count, poll_id) VALUES
                                                         ('Spring MVC', 3, 1),
                                                         ('JPA Relationships', 5, 1),
                                                         ('Thymeleaf', 2, 1),
                                                         ('Security', 8, 1),
                                                         ('Excellent', 0, 2),
                                                         ('Good', 0, 2),
                                                         ('Average', 0, 2),
                                                         ('Poor', 0, 2);

-- Insert Comments
INSERT INTO COMMENTS (content, user_username, course_material_id) VALUES
                                                                      ('Great introduction lecture!', 'student1', 1),
                                                                      ('When is the next assignment due?', 'student1', 2);