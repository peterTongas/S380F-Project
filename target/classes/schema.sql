-- Drop tables in reverse order of creation
DROP TABLE IF EXISTS COMMENTS;
DROP TABLE IF EXISTS POLL_OPTIONS;
DROP TABLE IF EXISTS POLLS;
DROP TABLE IF EXISTS COURSE_MATERIALS;
DROP TABLE IF EXISTS APP_USERS;

-- User Table (renamed from USER)
CREATE TABLE IF NOT EXISTS APP_USERS (
                                         username VARCHAR(50) PRIMARY KEY,
                                         password VARCHAR(100) NOT NULL,
                                         full_name VARCHAR(100) NOT NULL,
                                         email VARCHAR(100) NOT NULL,
                                         phone VARCHAR(20) NOT NULL,
                                         role VARCHAR(10) NOT NULL
);

-- Course Material Table (renamed for consistency)
CREATE TABLE IF NOT EXISTS COURSE_MATERIALS (
                                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                  title VARCHAR(200) NOT NULL,
                                  description TEXT,
                                  file_path VARCHAR(500) NOT NULL
);

-- Poll Table (pluralized)
CREATE TABLE IF NOT EXISTS POLLS (
                                     id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                     question VARCHAR(500) NOT NULL
);

-- Poll Option Table (pluralized)
CREATE TABLE IF NOT EXISTS POLL_OPTIONS (
                                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                            text VARCHAR(200) NOT NULL,
                                            vote_count INT DEFAULT 0,
                                            poll_id BIGINT,
                                            FOREIGN KEY (poll_id) REFERENCES POLLS(id) ON DELETE CASCADE
);

-- Comment Table (pluralized)
CREATE TABLE IF NOT EXISTS COMMENTS (
                                        id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                        content VARCHAR(1000) NOT NULL,
                                        user_username VARCHAR(50),
                                        course_material_id BIGINT,
                                        poll_id BIGINT,
                                        FOREIGN KEY (user_username) REFERENCES APP_USERS(username) ON DELETE CASCADE,
                                        FOREIGN KEY (course_material_id) REFERENCES COURSE_MATERIALS(id) ON DELETE CASCADE,
                                        FOREIGN KEY (poll_id) REFERENCES POLLS(id) ON DELETE CASCADE
);