drop table if exists APP_USERS;
drop table if exists COURSE_MATERIALS;
drop table if exists POLLS;
drop table if exists POLL_OPTIONS;
drop table if exists COMMENTS;
drop table if exists USER_VOTES;
drop table if exists COURSE_FILES;

-- Users Table
CREATE TABLE IF NOT EXISTS APP_USERS (
                                         username VARCHAR(50) PRIMARY KEY,
                                         password VARCHAR(100) NOT NULL,
                                         full_name VARCHAR(100) NOT NULL,
                                         email VARCHAR(100) NOT NULL,
                                         phone VARCHAR(20) NOT NULL,
                                         role VARCHAR(10) NOT NULL
);

-- Course Materials Table
CREATE TABLE IF NOT EXISTS COURSE_MATERIALS (
                                                id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                                title VARCHAR(200) NOT NULL,
                                                description TEXT,
                                                file_path VARCHAR(500),
                                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Course Files Table
CREATE TABLE IF NOT EXISTS COURSE_FILES (
                                           id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                           file_name VARCHAR(255) NOT NULL,
                                           file_path VARCHAR(500) NOT NULL,
                                           file_type VARCHAR(100),
                                           file_size BIGINT,
                                           course_material_id BIGINT,
                                           FOREIGN KEY (course_material_id) REFERENCES COURSE_MATERIALS(id) ON DELETE CASCADE
);

-- Polls Table
CREATE TABLE IF NOT EXISTS POLLS (
                                     id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                     question VARCHAR(500) NOT NULL,
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Poll Options Table
CREATE TABLE IF NOT EXISTS POLL_OPTIONS (
                                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                            text VARCHAR(200) NOT NULL,
                                            vote_count INT,
                                            poll_id BIGINT,
                                            FOREIGN KEY (poll_id) REFERENCES POLLS(id) ON DELETE CASCADE
);

-- Comments Table
CREATE TABLE IF NOT EXISTS COMMENTS (
                                        id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                        content VARCHAR(1000) NOT NULL,
                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        user_username VARCHAR(50),
                                        course_material_id BIGINT,
                                        poll_id BIGINT,
                                        FOREIGN KEY (user_username) REFERENCES APP_USERS(username) ON DELETE CASCADE,
                                        FOREIGN KEY (course_material_id) REFERENCES COURSE_MATERIALS(id) ON DELETE CASCADE,
                                        FOREIGN KEY (poll_id) REFERENCES POLLS(id) ON DELETE CASCADE
);

-- User Votes Table
CREATE TABLE IF NOT EXISTS USER_VOTES (
                                           id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                           user_username VARCHAR(50),
                                           poll_option_id BIGINT,
                                           FOREIGN KEY (user_username) REFERENCES APP_USERS(username) ON DELETE CASCADE,
                                           FOREIGN KEY (poll_option_id) REFERENCES POLL_OPTIONS(id) ON DELETE CASCADE
);
