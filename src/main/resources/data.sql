-- Insert Initial Users
INSERT INTO APP_USERS (username, password, full_name, email, phone, role) VALUES
    ('prof_wong', 'secure123', 'Dr. Chris Wong', 'wong.chris@hkmu.edu.hk', '8529876-5432', 'TEACHER'),
    ('prof_chan', 'secure456', 'Dr. Emily Chan', 'chan.emily@hkmu.edu.hk', '8529876-1234', 'TEACHER'),
    ('student001', 'stud2023', 'Chen Yat Sum', 's001234@live.hkmu.edu.hk', '8526543-7890', 'STUDENT'),
    ('student002', 'stud2023', 'Wong Mei Ling', 's002345@live.hkmu.edu.hk', '8526543-8901', 'STUDENT'),
    ('student003', 'stud2023', 'Lam Ka Ming', 's003456@live.hkmu.edu.hk', '8526543-9012', 'STUDENT'),
    ('admin001', 'admin$2023', 'System Administrator', 'sysadmin@hkmu.edu.hk', '8525555-0000', 'TEACHER');

-- Insert Course Materials
INSERT INTO COURSE_MATERIALS (title, description, file_path) VALUES
    ('Introduction to Web Development', 'Fundamentals of web architecture, HTTP protocol, and client-server model', 'web-intro.pdf'),
    ('HTML5 and CSS3 Essentials', 'Core concepts of modern HTML and CSS with responsive design principles', '/files/html-css.pdf'),
    ('JavaScript Programming', 'Client-side scripting, DOM manipulation, and event handling', '/files/javascript-basics.pdf'),
    ('Server-Side Development', 'Introduction to backend development with Spring Framework', '/files/server-side.pdf'),
    ('Database Integration', 'Working with relational databases and JPA', '/files/database-integration.pdf'),
    ('Security Best Practices', 'Authentication, authorization, and common security threats', '/files/security-practices.pdf');

-- Insert Course Files for each course material
INSERT INTO COURSE_FILES (file_name, file_path, file_type, course_material_id) VALUES
    ('web-intro.pdf', 'web-intro.pdf', 'application/pdf', 1),
    ('html-css.pdf', '/files/html-css.pdf', 'application/pdf', 2),
    ('javascript-basics.pdf', '/files/javascript-basics.pdf', 'application/pdf', 3),
    ('server-side.pdf', '/files/server-side.pdf', 'application/pdf', 4),
    ('database-integration.pdf', '/files/database-integration.pdf', 'application/pdf', 5),
    ('security-practices.pdf', '/files/security-practices.pdf', 'application/pdf', 6);

-- Insert Polls
INSERT INTO POLLS (question) VALUES
    ('Which technology would you like to learn more about?'),
    ('How satisfied are you with the course materials?'),
    ('What format do you prefer for additional learning resources?'),
    ('Which project topic interests you most?');

-- Insert Poll Options
INSERT INTO POLL_OPTIONS (text, vote_count, poll_id) VALUES
    -- Technology preferences poll
    ('Frontend frameworks (React/Angular/Vue)', 12, 1),
    ('Backend technologies (Spring/Node.js)', 8, 1),
    ('Database systems (SQL/NoSQL)', 5, 1),
    ('DevOps and deployment', 7, 1),
    
    -- Course satisfaction poll
    ('Very satisfied', 15, 2),
    ('Satisfied', 8, 2),
    ('Neutral', 4, 2),
    ('Needs improvement', 2, 2),
    
    -- Learning format poll
    ('Video tutorials', 18, 3),
    ('Interactive coding exercises', 14, 3),
    ('Text-based documentation', 5, 3),
    ('Live workshop sessions', 11, 3),
    
    -- Project topics poll
    ('E-commerce platform', 9, 4),
    ('Social media dashboard', 7, 4),
    ('Learning management system', 12, 4),
    ('Data visualization tool', 6, 4);

-- Insert Comments
INSERT INTO COMMENTS (content, user_username, course_material_id) VALUES
    ('This introduction really helped clarify the overall architecture. Thank you!', 'student001', 1),
    ('Are there any recommended resources for learning more about HTTP/2?', 'student002', 1),
    ('The responsive design examples were particularly helpful for my project.', 'student003', 2),
    ('Will we be covering CSS Grid in more detail in future sessions?', 'student001', 2),
    ('The event bubbling concept was confusing at first, but the examples helped.', 'student002', 3),
    ('Could you provide more examples of REST API implementations?', 'student003', 4),
    ('The JPA relationship mappings section was exactly what I needed for my project!', 'student001', 5),
    ('Are there plans to cover NoSQL databases in future materials?', 'student002', 5);