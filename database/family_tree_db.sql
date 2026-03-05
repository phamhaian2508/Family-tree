CREATE DATABASE IF NOT EXISTS family_tree_db;
USE family_tree_db;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS activitylog;
DROP TABLE IF EXISTS livestream;
DROP TABLE IF EXISTS media;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS user_role;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `role`;
DROP TABLE IF EXISTS branch;

SET FOREIGN_KEY_CHECKS = 1;

-- ROLE
CREATE TABLE `role` (
                        `id` bigint(20) NOT NULL AUTO_INCREMENT,
                        `name` varchar(255) NOT NULL,
                        `code` varchar(255) NOT NULL,
                        `createddate` datetime DEFAULT NULL,
                        `modifieddate` datetime DEFAULT NULL,
                        `createdby` varchar(255) DEFAULT NULL,
                        `modifiedby` varchar(255) DEFAULT NULL,
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `role` (`id`, `name`, `code`, `createddate`, `modifieddate`, `createdby`, `modifiedby`) VALUES
                                                                                                        (1, 'Quan ly', 'MANAGER', NULL, NULL, NULL, NULL),
                                                                                                        (2, 'Editor', 'EDITOR', NULL, NULL, NULL, NULL),
                                                                                                        (3, 'Nguoi dung', 'USER', NULL, NULL, NULL, NULL);

-- USER
CREATE TABLE `user` (
                        `id` bigint(20) NOT NULL AUTO_INCREMENT,
                        `username` varchar(255) NOT NULL,
                        `password` varchar(255) NOT NULL,
                        `fullname` varchar(255) DEFAULT NULL,
                        `phone` varchar(255) DEFAULT NULL,
                        `email` varchar(255) DEFAULT NULL,
                        `status` int(11) NOT NULL,
                        `createddate` datetime DEFAULT NULL,
                        `modifieddate` datetime DEFAULT NULL,
                        `createdby` varchar(255) DEFAULT NULL,
                        `modifiedby` varchar(255) DEFAULT NULL,
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `uk_user_username` (`username`),
                        UNIQUE KEY `uk_user_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `user` (`id`, `username`, `password`, `fullname`, `phone`, `email`, `status`, `createddate`, `modifieddate`, `createdby`, `modifiedby`) VALUES
                                                                                                                                                        (1, 'nguyenvana', '$2a$10$/RUbuT9KIqk6f8enaTQiLOXzhnUkiwEJRdtzdrMXXwU7dgnLKTCYG', 'nguyen van a', NULL, NULL, 1, NULL, NULL, NULL, NULL),
                                                                                                                                                        (2, 'nguyenvanb', '$2a$10$/RUbuT9KIqk6f8enaTQiLOXzhnUkiwEJRdtzdrMXXwU7dgnLKTCYG', 'nguyen van b', NULL, NULL, 1, NULL, NULL, NULL, NULL),
                                                                                                                                                        (3, 'nguyenvanc', '$2a$10$/RUbuT9KIqk6f8enaTQiLOXzhnUkiwEJRdtzdrMXXwU7dgnLKTCYG', 'nguyen van c', NULL, NULL, 1, NULL, NULL, NULL, NULL),
                                                                                                                                                        (4, 'nguyenvand', '$2a$10$/RUbuT9KIqk6f8enaTQiLOXzhnUkiwEJRdtzdrMXXwU7dgnLKTCYG', 'nguyen van d', NULL, NULL, 1, NULL, NULL, NULL, NULL);

-- USER_ROLE
CREATE TABLE `user_role` (
                             `id` bigint(20) NOT NULL AUTO_INCREMENT,
                             `role_id` bigint(20) NOT NULL,
                             `user_id` bigint(20) NOT NULL,
                             `createddate` datetime DEFAULT NULL,
                             `modifieddate` datetime DEFAULT NULL,
                             `createdby` varchar(255) DEFAULT NULL,
                             `modifiedby` varchar(255) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             KEY `fk_user_role_user` (`user_id`),
                             KEY `fk_user_role_role` (`role_id`),
                             CONSTRAINT `fk_user_role_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
                             CONSTRAINT `fk_user_role_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `user_role` (`id`, `role_id`, `user_id`, `createddate`, `modifieddate`, `createdby`, `modifiedby`) VALUES
                                                                                                                   (1, 1, 1, NULL, NULL, NULL, NULL),
                                                                                                                   (2, 2, 2, NULL, NULL, NULL, NULL),
                                                                                                                   (3, 2, 3, NULL, NULL, NULL, NULL),
                                                                                                                   (4, 2, 4, NULL, NULL, NULL, NULL);

-- BRANCH
CREATE TABLE `branch` (
                          `id` bigint(20) NOT NULL AUTO_INCREMENT,
                          `name` varchar(255) NOT NULL,
                          `description` text DEFAULT NULL,
                          `createddate` datetime DEFAULT NULL,
                          `modifieddate` datetime DEFAULT NULL,
                          `createdby` varchar(255) DEFAULT NULL,
                          `modifiedby` varchar(255) DEFAULT NULL,
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Main branch seed
INSERT INTO `branch` (`name`, `description`) VALUES
    ('Chinh', 'Chi goc mac dinh');

-- PERSON
CREATE TABLE `person` (
                          `id` bigint(20) NOT NULL AUTO_INCREMENT,
                          `branch_id` bigint(20) DEFAULT NULL,
                          `user_id` bigint(20) DEFAULT NULL,
                          `fullname` varchar(255) NOT NULL,
                          `gender` varchar(20) DEFAULT NULL,
                          `avatar` longtext DEFAULT NULL,
                          `dob` date DEFAULT NULL,
                          `dod` date DEFAULT NULL,
                          `generation` int(11) DEFAULT NULL,
                          `father_id` bigint(20) DEFAULT NULL,
                          `mother_id` bigint(20) DEFAULT NULL,
                          `spouse_id` bigint(20) DEFAULT NULL,
                          `createddate` datetime DEFAULT NULL,
                          `modifieddate` datetime DEFAULT NULL,
                          `createdby` varchar(255) DEFAULT NULL,
                          `modifiedby` varchar(255) DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          KEY `idx_person_branch` (`branch_id`),
                          KEY `idx_person_father` (`father_id`),
                          KEY `idx_person_mother` (`mother_id`),
                          KEY `idx_person_spouse` (`spouse_id`),
                          UNIQUE KEY `uk_person_user` (`user_id`),
                          UNIQUE KEY `uk_person_spouse` (`spouse_id`),
                          CONSTRAINT `fk_person_branch` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`id`),
                          CONSTRAINT `fk_person_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
                          CONSTRAINT `fk_person_father` FOREIGN KEY (`father_id`) REFERENCES `person` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
                          CONSTRAINT `fk_person_mother` FOREIGN KEY (`mother_id`) REFERENCES `person` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
                          CONSTRAINT `fk_person_spouse` FOREIGN KEY (`spouse_id`) REFERENCES `person` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Auto create person for existing users that do not have mapping yet
INSERT INTO `person`
(`branch_id`, `user_id`, `fullname`, `gender`, `avatar`, `dob`, `dod`, `generation`,
 `father_id`, `mother_id`, `spouse_id`, `createddate`, `modifieddate`, `createdby`, `modifiedby`)
SELECT
    NULL,
    u.`id`,
    COALESCE(NULLIF(TRIM(u.`fullname`), ''), u.`username`),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NOW(),
    NOW(),
    'system',
    'system'
FROM `user` u
         LEFT JOIN `person` p ON p.`user_id` = u.`id`
WHERE p.`id` IS NULL;

-- MEDIA
CREATE TABLE `media` (
                         `id` bigint(20) NOT NULL AUTO_INCREMENT,
                         `file_url` varchar(500) NOT NULL,
                         `media_type` varchar(50) NOT NULL,
                         `person_id` bigint(20) DEFAULT NULL,
                         `branch_id` bigint(20) DEFAULT NULL,
                         `uploader_id` bigint(20) NOT NULL,
                         `createddate` datetime DEFAULT NULL,
                         `modifieddate` datetime DEFAULT NULL,
                         `createdby` varchar(255) DEFAULT NULL,
                         `modifiedby` varchar(255) DEFAULT NULL,
                         PRIMARY KEY (`id`),
                         KEY `idx_media_person` (`person_id`),
                         KEY `idx_media_branch` (`branch_id`),
                         KEY `idx_media_uploader` (`uploader_id`),
                         CONSTRAINT `fk_media_person` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
                         CONSTRAINT `fk_media_branch` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
                         CONSTRAINT `fk_media_uploader` FOREIGN KEY (`uploader_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- LIVESTREAM
CREATE TABLE `livestream` (
                              `id` bigint(20) NOT NULL AUTO_INCREMENT,
                              `title` varchar(255) NOT NULL,
                              `stream_url` varchar(500) NOT NULL,
                              `status` int(11) NOT NULL,
                              `branch_id` bigint(20) NOT NULL,
                              `host_id` bigint(20) NOT NULL,
                              `createddate` datetime DEFAULT NULL,
                              `modifieddate` datetime DEFAULT NULL,
                              `createdby` varchar(255) DEFAULT NULL,
                              `modifiedby` varchar(255) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              KEY `idx_livestream_branch` (`branch_id`),
                              KEY `idx_livestream_host` (`host_id`),
                              CONSTRAINT `fk_livestream_branch` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
                              CONSTRAINT `fk_livestream_host` FOREIGN KEY (`host_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ACTIVITY LOG
CREATE TABLE `activitylog` (
                               `id` bigint(20) NOT NULL AUTO_INCREMENT,
                               `user_id` bigint(20) NOT NULL,
                               `action` varchar(255) NOT NULL,
                               `description` text DEFAULT NULL,
                               `timestamp` datetime NOT NULL,
                               `createddate` datetime DEFAULT NULL,
                               `modifieddate` datetime DEFAULT NULL,
                               `createdby` varchar(255) DEFAULT NULL,
                               `modifiedby` varchar(255) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               KEY `idx_activitylog_user` (`user_id`),
                               CONSTRAINT `fk_activitylog_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;