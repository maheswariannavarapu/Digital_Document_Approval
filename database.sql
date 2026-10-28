CREATE DATABASE IF NOT EXISTS docflow_db;
USE docflow_db;

CREATE TABLE `approvals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `document_id` int NOT NULL,
  `user_id` int NOT NULL,
  `stage` enum('reviewer','manager','final_admin') NOT NULL,
  `decision` enum('approved','rejected','changes_requested') NOT NULL,
  `remarks` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `approvals_ibfk_1` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `approvals_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('1', '1', '9', 'reviewer', 'approved', 'Reviewer', '2026-10-28 16:52:49');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('2', '1', '14', 'manager', 'approved', '"Verified and found all required details in order. Forwarding to Manager for stage-two approval."', '2026-10-28 17:03:22');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('3', '1', '9', 'final_admin', 'approved', 'Reviwer One', '2026-10-28 17:05:34');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('4', '1', '13', 'reviewer', 'rejected', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '2026-10-28 17:12:05');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('5', '1', '14', 'manager', 'approved', '"Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:14:50');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('6', '1', '1', 'final_admin', 'approved', 'Final executive sign-off completed. Verified for platform release.', '2026-10-28 17:18:19');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('7', '2', '13', 'reviewer', 'approved', '"Reviewed scope, compliance, and department requirements. Approved for Admin final sign-off and archiving."', '2026-10-28 17:27:41');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('8', '2', '14', 'manager', 'approved', '"Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:28:44');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('9', '2', '1', 'final_admin', 'approved', 'Final executive sign-off completed. Verified for platform release.', '2026-10-28 17:29:08');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('10', '1', '14', 'manager', 'approved', 'Document rejected due to missing execution dates and unclear scope in Section 3. Please revise and upload version 1.1."', '2026-10-28 17:34:46');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('11', '1', '14', 'manager', 'rejected', 'Document rejected due to missing execution dates and unclear scope in Section 3. Please revise and upload version 1.1."', '2026-10-28 17:34:59');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('12', '5', '13', 'reviewer', 'approved', '"Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:36:16');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('13', '4', '13', 'reviewer', 'approved', '"Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:36:26');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('14', '3', '13', 'reviewer', 'rejected', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '2026-10-28 17:36:43');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('15', '6', '1', 'final_admin', 'rejected', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '2026-10-28 17:37:56');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('16', '6', '14', 'manager', 'approved', 'Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:41:10');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('17', '5', '14', 'manager', 'approved', 'Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:41:23');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('18', '4', '14', 'manager', 'approved', '"Terms and alignment confirmed. Approved to proceed to final administrator clearance."', '2026-10-28 17:41:50');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('19', '3', '14', 'manager', 'rejected', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '2026-10-28 17:42:27');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('20', '4', '1', 'final_admin', 'approved', 'Final executive sign-off completed. Verified for platform release.', '2026-10-28 17:43:45');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('21', '5', '1', 'final_admin', 'approved', 'Final executive sign-off completed. Verified for platform release.', '2026-10-28 17:43:48');
INSERT INTO approvals (id, document_id, user_id, stage, decision, remarks, created_at) VALUES ('22', '6', '1', 'final_admin', 'approved', 'Final executive sign-off completed. Verified for platform release.', '2026-10-28 17:43:51');

CREATE TABLE `audit_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `document_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `details` text,
  `ip_address` varchar(45) DEFAULT '127.0.0.1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE SET NULL,
  CONSTRAINT `audit_logs_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('1', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 12:43:37');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('2', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 12:43:56');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('3', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 12:46:19');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('4', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 12:55:41');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('5', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 12:55:54');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('6', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 12:55:58');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('7', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 13:10:49');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('8', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 13:11:06');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('9', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 13:11:20');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('10', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 13:11:32');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('11', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 13:11:44');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('12', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 13:14:19');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('13', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 13:17:10');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('14', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 13:26:48');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('15', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 13:27:16');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('16', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 13:28:38');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('17', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 13:39:52');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('18', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 13:40:39');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('19', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 13:41:01');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('20', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 13:41:11');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('21', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 13:41:28');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('22', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 13:41:38');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('23', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 13:41:49');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('24', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 13:41:53');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('25', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 13:42:07');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('26', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 14:11:42');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('27', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 14:11:56');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('28', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 14:12:05');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('29', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 14:12:11');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('30', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 14:12:22');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('31', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 14:12:31');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('32', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 14:12:35');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('33', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 14:38:15');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('34', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 14:42:24');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('35', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 14:42:30');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('36', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 14:42:38');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('37', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 14:42:42');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('38', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 14:42:54');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('39', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 14:43:00');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('40', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 14:43:03');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('41', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 14:44:27');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('42', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 14:44:50');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('43', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 14:44:55');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('44', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 14:45:02');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('45', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 14:45:06');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('46', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 14:45:16');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('47', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 14:45:24');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('48', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 14:45:27');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('49', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 15:36:59');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('50', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 15:38:32');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('51', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 15:38:41');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('52', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 15:38:48');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('53', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 15:39:02');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('54', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 15:39:14');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('55', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 15:39:18');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('56', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 15:43:18');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('57', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 15:43:38');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('58', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 15:46:06');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('59', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 15:51:08');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('60', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 15:51:23');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('61', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 15:52:18');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('62', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 15:52:33');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('63', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 15:53:09');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('64', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 15:53:14');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('65', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 15:53:22');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('66', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 15:56:46');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('67', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 15:56:52');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('68', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 16:31:55');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('69', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 16:32:25');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('70', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 16:33:13');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('71', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 16:33:16');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('72', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 16:33:47');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('73', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 16:33:51');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('74', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 16:34:06');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('75', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 16:34:10');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('76', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 16:34:14');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('77', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 16:51:28');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('78', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 16:51:46');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('79', '1', '9', 'Document Uploaded', 'Uploaded MSA_3c7d18f7-25f8-466b-adf61694603255182_managerprocurement1.pdf as policy', '127.0.0.1', '2026-10-28 16:52:27');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('80', '1', '9', 'Reviewer Decision: approved', 'Reviewer', '127.0.0.1', '2026-10-28 16:52:49');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('81', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 16:52:56');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('82', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 16:53:14');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('83', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 16:54:42');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('84', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 16:55:00');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('85', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 16:58:21');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('86', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 16:58:36');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('87', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 17:02:23');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('88', '1', '14', 'Manager Decision: approved', '"Verified and found all required details in order. Forwarding to Manager for stage-two approval."', '127.0.0.1', '2026-10-28 17:03:22');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('89', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 17:03:42');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('90', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 17:04:26');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('91', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 17:04:37');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('92', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 17:04:54');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('93', '1', '9', 'Final_admin Decision: approved', 'Reviwer One', '127.0.0.1', '2026-10-28 17:05:34');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('94', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 17:10:22');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('95', '1', '9', 'Reviewer Assigned', 'Reviewer ID: 13, Manager ID: 14', '127.0.0.1', '2026-10-28 17:10:40');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('96', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 17:10:43');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('97', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 17:11:09');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('98', '1', '13', 'Reviewer Decision: rejected', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '127.0.0.1', '2026-10-28 17:12:05');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('99', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 17:12:41');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('100', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 17:12:57');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('101', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 17:13:14');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('102', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 17:13:30');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('103', '1', '9', 'Reviewer Assigned', 'Reviewer ID: 13, Manager ID: 14', '127.0.0.1', '2026-10-28 17:14:02');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('104', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 17:14:12');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('105', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 17:14:27');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('106', '1', '14', 'Manager Decision: approved', '"Final audit checks completed. Approved and officially published to system records."', '127.0.0.1', '2026-10-28 17:14:50');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('107', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 17:14:55');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('108', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 17:15:15');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('109', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 17:15:20');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('110', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 17:15:25');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('111', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 17:18:10');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('112', '1', '1', 'Final Approval Executed', 'Status set to archived. Remarks: Final executive sign-off completed. Verified for platform release.', '127.0.0.1', '2026-10-28 17:18:19');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('113', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 17:19:12');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('114', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 17:19:31');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('115', '2', '9', 'Document Uploaded', 'Uploaded Independent-Contractor_Freelancer.pdf as service', '127.0.0.1', '2026-10-28 17:20:39');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('116', '2', '9', 'Reviewer Assigned', 'Reviewer ID: 13, Manager ID: 14', '127.0.0.1', '2026-10-28 17:21:02');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('117', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 17:26:38');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('118', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 17:27:03');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('119', '2', '13', 'Reviewer Decision: approved', '"Reviewed scope, compliance, and department requirements. Approved for Admin final sign-off and archiving."', '127.0.0.1', '2026-10-28 17:27:41');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('120', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 17:27:46');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('121', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 17:28:02');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('122', '2', '14', 'Manager Decision: approved', '"Final audit checks completed. Approved and officially published to system records."', '127.0.0.1', '2026-10-28 17:28:44');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('123', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 17:28:53');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('124', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 17:28:57');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('125', '2', '1', 'Final Approval Executed', 'Status set to approved. Remarks: Final executive sign-off completed. Verified for platform release.', '127.0.0.1', '2026-10-28 17:29:08');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('126', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 17:29:15');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('127', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 17:30:39');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('128', '3', '9', 'Document Uploaded', 'Uploaded W3B-PR-02-Jordan-Technical_Proposal.pdf as project', '127.0.0.1', '2026-10-28 17:31:14');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('129', '4', '9', 'Document Uploaded', 'Uploaded W3B-PR-02-Jordan-Technical_Proposal.pdf as serivce', '127.0.0.1', '2026-10-28 17:31:48');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('130', '5', '9', 'Document Uploaded', 'Uploaded Financial-Reporting-FR-FAQ-Revised-Final.pdf as financial', '127.0.0.1', '2026-10-28 17:32:44');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('131', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 17:33:55');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('132', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 17:34:10');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('133', '1', '14', 'Manager Decision: approved', 'Document rejected due to missing execution dates and unclear scope in Section 3. Please revise and upload version 1.1."', '127.0.0.1', '2026-10-28 17:34:46');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('134', '1', '14', 'Manager Decision: rejected', 'Document rejected due to missing execution dates and unclear scope in Section 3. Please revise and upload version 1.1."', '127.0.0.1', '2026-10-28 17:34:59');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('135', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 17:35:09');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('136', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 17:35:23');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('137', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 17:35:27');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('138', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 17:35:48');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('139', '5', '13', 'Reviewer Decision: approved', '"Final audit checks completed. Approved and officially published to system records."', '127.0.0.1', '2026-10-28 17:36:16');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('140', '4', '13', 'Reviewer Decision: approved', '"Final audit checks completed. Approved and officially published to system records."', '127.0.0.1', '2026-10-28 17:36:26');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('141', '3', '13', 'Reviewer Decision: rejected', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '127.0.0.1', '2026-10-28 17:36:44');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('142', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 17:36:48');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('143', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 17:36:53');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('144', '6', '1', 'Document Uploaded', 'Uploaded MSA_3c7d18f7-25f8-466b-adf61694603255182_managerprocurement1.pdf as project', '127.0.0.1', '2026-10-28 17:37:45');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('145', '6', '1', 'Final_admin Decision: rejected', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '127.0.0.1', '2026-10-28 17:37:56');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('146', '6', '1', 'Reviewer Assigned', 'Reviewer ID: 13, Manager ID: 14', '127.0.0.1', '2026-10-28 17:38:11');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('147', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 17:38:28');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('148', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 17:38:32');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('149', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 17:38:55');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('150', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 17:39:13');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('151', '3', '9', 'Reviewer Assigned', 'Reviewer ID: 13, Manager ID: 14', '127.0.0.1', '2026-10-28 17:39:33');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('152', '4', '9', 'Reviewer Assigned', 'Reviewer ID: 13, Manager ID: 14', '127.0.0.1', '2026-10-28 17:39:58');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('153', '5', '9', 'Reviewer Assigned', 'Reviewer ID: 13, Manager ID: 14', '127.0.0.1', '2026-10-28 17:40:15');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('154', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 17:40:27');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('155', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 17:40:45');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('156', '6', '14', 'Manager Decision: approved', 'Final audit checks completed. Approved and officially published to system records."', '127.0.0.1', '2026-10-28 17:41:10');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('157', '5', '14', 'Manager Decision: approved', 'Final audit checks completed. Approved and officially published to system records."', '127.0.0.1', '2026-10-28 17:41:23');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('158', '4', '14', 'Manager Decision: approved', '"Terms and alignment confirmed. Approved to proceed to final administrator clearance."', '127.0.0.1', '2026-10-28 17:41:50');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('159', '3', '14', 'Manager Decision: rejected', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '127.0.0.1', '2026-10-28 17:42:27');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('160', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 17:42:53');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('161', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 17:43:14');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('162', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 17:43:32');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('163', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 17:43:37');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('164', '4', '1', 'Final Approval Executed', 'Status set to approved. Remarks: Final executive sign-off completed. Verified for platform release.', '127.0.0.1', '2026-10-28 17:43:45');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('165', '5', '1', 'Final Approval Executed', 'Status set to approved. Remarks: Final executive sign-off completed. Verified for platform release.', '127.0.0.1', '2026-10-28 17:43:48');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('166', '6', '1', 'Final Approval Executed', 'Status set to approved. Remarks: Final executive sign-off completed. Verified for platform release.', '127.0.0.1', '2026-10-28 17:43:51');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('167', NULL, '1', 'User Logout', 'admin logged out.', '127.0.0.1', '2026-10-28 17:43:57');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('168', NULL, '9', 'User Login', 'Maheswari logged into platform.', '127.0.0.1', '2026-10-28 17:44:28');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('169', NULL, '9', 'User Logout', 'Maheswari logged out.', '127.0.0.1', '2026-10-28 17:44:50');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('170', NULL, '13', 'User Login', 'Reviewer One logged into platform.', '127.0.0.1', '2026-10-28 17:45:10');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('171', NULL, '13', 'User Logout', 'Reviewer One logged out.', '127.0.0.1', '2026-10-28 17:45:20');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('172', NULL, '14', 'User Login', 'Manager logged into platform.', '127.0.0.1', '2026-10-28 17:45:51');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('173', NULL, '14', 'User Logout', 'Manager logged out.', '127.0.0.1', '2026-10-28 17:45:56');
INSERT INTO audit_logs (id, document_id, user_id, action, details, ip_address, created_at) VALUES ('174', NULL, '1', 'Admin Login', 'Admin session authenticated.', '127.0.0.1', '2026-10-28 17:46:00');

CREATE TABLE `comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `document_id` int NOT NULL,
  `user_id` int NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('1', '1', '9', 'Reviewer', '2026-10-28 16:52:49');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('2', '1', '14', '"Verified and found all required details in order. Forwarding to Manager for stage-two approval."', '2026-10-28 17:03:22');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('3', '1', '9', 'Reviwer One', '2026-10-28 17:05:34');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('4', '1', '13', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '2026-10-28 17:12:05');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('5', '1', '14', '"Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:14:50');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('6', '2', '13', '"Reviewed scope, compliance, and department requirements. Approved for Admin final sign-off and archiving."', '2026-10-28 17:27:41');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('7', '2', '14', '"Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:28:44');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('8', '1', '14', 'Document rejected due to missing execution dates and unclear scope in Section 3. Please revise and upload version 1.1."', '2026-10-28 17:34:46');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('9', '1', '14', 'Document rejected due to missing execution dates and unclear scope in Section 3. Please revise and upload version 1.1."', '2026-10-28 17:34:59');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('10', '5', '13', '"Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:36:16');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('11', '4', '13', '"Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:36:26');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('12', '3', '13', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '2026-10-28 17:36:43');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('13', '6', '1', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '2026-10-28 17:37:56');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('14', '6', '14', 'Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:41:10');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('15', '5', '14', 'Final audit checks completed. Approved and officially published to system records."', '2026-10-28 17:41:23');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('16', '4', '14', '"Terms and alignment confirmed. Approved to proceed to final administrator clearance."', '2026-10-28 17:41:50');
INSERT INTO comments (id, document_id, user_id, comment, created_at) VALUES ('17', '3', '14', '"Signatures and departmental authorization details are incomplete. Please update the file and resubmit."', '2026-10-28 17:42:27');

CREATE TABLE `document_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO document_types (id, name, description, created_at) VALUES ('1', 'Project Proposal', 'Client, RFP and technical project proposals', '2026-10-28 12:08:05');
INSERT INTO document_types (id, name, description, created_at) VALUES ('2', 'Policy & Compliance', 'Corporate standards and internal guidelines', '2026-10-28 12:08:05');
INSERT INTO document_types (id, name, description, created_at) VALUES ('3', 'Financial Report', 'Budgets, audits and balance sheets', '2026-10-28 12:08:05');
INSERT INTO document_types (id, name, description, created_at) VALUES ('4', 'Service Agreement', 'Vendor and partner service contracts', '2026-10-28 12:08:05');

CREATE TABLE `document_versions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `document_id` int NOT NULL,
  `version_number` varchar(20) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `uploaded_by` int NOT NULL,
  `change_summary` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`),
  KEY `uploaded_by` (`uploaded_by`),
  CONSTRAINT `document_versions_ibfk_1` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `document_versions_ibfk_2` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO document_versions (id, document_id, version_number, file_path, file_name, uploaded_by, change_summary, created_at) VALUES ('1', '1', 'v1.0', '1793186547_MSA_3c7d18f7-25f8-466b-adf61694603255182_managerprocurement1.pdf', 'MSA_3c7d18f7-25f8-466b-adf61694603255182_managerprocurement1.pdf', '9', 'Initial document submission', '2026-10-28 16:52:27');
INSERT INTO document_versions (id, document_id, version_number, file_path, file_name, uploaded_by, change_summary, created_at) VALUES ('2', '2', 'v1.0', '1793188239_Independent-Contractor_Freelancer.pdf', 'Independent-Contractor_Freelancer.pdf', '9', 'Initial document submission', '2026-10-28 17:20:39');
INSERT INTO document_versions (id, document_id, version_number, file_path, file_name, uploaded_by, change_summary, created_at) VALUES ('3', '3', 'v1.0', '1793188874_W3B-PR-02-Jordan-Technical_Proposal.pdf', 'W3B-PR-02-Jordan-Technical_Proposal.pdf', '9', 'Initial document submission', '2026-10-28 17:31:14');
INSERT INTO document_versions (id, document_id, version_number, file_path, file_name, uploaded_by, change_summary, created_at) VALUES ('4', '4', 'v1.0', '1793188908_W3B-PR-02-Jordan-Technical_Proposal.pdf', 'W3B-PR-02-Jordan-Technical_Proposal.pdf', '9', 'Initial document submission', '2026-10-28 17:31:48');
INSERT INTO document_versions (id, document_id, version_number, file_path, file_name, uploaded_by, change_summary, created_at) VALUES ('5', '5', 'v1.0', '1793188964_Financial-Reporting-FR-FAQ-Revised-Final.pdf', 'Financial-Reporting-FR-FAQ-Revised-Final.pdf', '9', 'Initial document submission', '2026-10-28 17:32:44');
INSERT INTO document_versions (id, document_id, version_number, file_path, file_name, uploaded_by, change_summary, created_at) VALUES ('6', '6', 'v1.0', '1793189265_MSA_3c7d18f7-25f8-466b-adf61694603255182_managerprocurement1.pdf', 'MSA_3c7d18f7-25f8-466b-adf61694603255182_managerprocurement1.pdf', '1', 'Initial document submission', '2026-10-28 17:37:45');

CREATE TABLE `documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `current_version` varchar(20) DEFAULT 'v1.0',
  `type_id` int DEFAULT NULL,
  `uploaded_by` int NOT NULL,
  `status` enum('submitted','in_review','manager_review','final_review','approved','rejected','archived') NOT NULL DEFAULT 'submitted',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `type_id` (`type_id`),
  KEY `uploaded_by` (`uploaded_by`),
  CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`type_id`) REFERENCES `document_types` (`id`) ON DELETE SET NULL,
  CONSTRAINT `documents_ibfk_2` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO documents (id, title, description, file_path, file_name, current_version, type_id, uploaded_by, status, created_at, updated_at) VALUES ('1', 'policy', '', '1793186547_MSA_3c7d18f7-25f8-466b-adf61694603255182_managerprocurement1.pdf', 'MSA_3c7d18f7-25f8-466b-adf61694603255182_managerprocurement1.pdf', 'v1.0', '2', '9', 'rejected', '2026-10-28 16:52:27', '2026-10-28 17:34:59');
INSERT INTO documents (id, title, description, file_path, file_name, current_version, type_id, uploaded_by, status, created_at, updated_at) VALUES ('2', 'service', '', '1793188239_Independent-Contractor_Freelancer.pdf', 'Independent-Contractor_Freelancer.pdf', 'v1.0', '4', '9', 'approved', '2026-10-28 17:20:39', '2026-10-28 17:29:08');
INSERT INTO documents (id, title, description, file_path, file_name, current_version, type_id, uploaded_by, status, created_at, updated_at) VALUES ('3', 'project', '', '1793188874_W3B-PR-02-Jordan-Technical_Proposal.pdf', 'W3B-PR-02-Jordan-Technical_Proposal.pdf', 'v1.0', '1', '9', 'rejected', '2026-10-28 17:31:14', '2026-10-28 17:42:27');
INSERT INTO documents (id, title, description, file_path, file_name, current_version, type_id, uploaded_by, status, created_at, updated_at) VALUES ('4', 'serivce', '', '1793188908_W3B-PR-02-Jordan-Technical_Proposal.pdf', 'W3B-PR-02-Jordan-Technical_Proposal.pdf', 'v1.0', '4', '9', 'approved', '2026-10-28 17:31:48', '2026-10-28 17:43:45');
INSERT INTO documents (id, title, description, file_path, file_name, current_version, type_id, uploaded_by, status, created_at, updated_at) VALUES ('5', 'financial', '', '1793188964_Financial-Reporting-FR-FAQ-Revised-Final.pdf', 'Financial-Reporting-FR-FAQ-Revised-Final.pdf', 'v1.0', '3', '9', 'approved', '2026-10-28 17:32:44', '2026-10-28 17:43:48');
INSERT INTO documents (id, title, description, file_path, file_name, current_version, type_id, uploaded_by, status, created_at, updated_at) VALUES ('6', 'project', '', '1793189265_MSA_3c7d18f7-25f8-466b-adf61694603255182_managerprocurement1.pdf', 'MSA_3c7d18f7-25f8-466b-adf61694603255182_managerprocurement1.pdf', 'v1.0', '1', '1', 'approved', '2026-10-28 17:37:45', '2026-10-28 17:43:51');

CREATE TABLE `review_assignments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `document_id` int NOT NULL,
  `reviewer_id` int NOT NULL,
  `manager_id` int DEFAULT NULL,
  `deadline` date DEFAULT NULL,
  `assigned_by` int NOT NULL,
  `status` enum('pending','completed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`),
  KEY `reviewer_id` (`reviewer_id`),
  KEY `manager_id` (`manager_id`),
  KEY `assigned_by` (`assigned_by`),
  CONSTRAINT `review_assignments_ibfk_1` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `review_assignments_ibfk_2` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `review_assignments_ibfk_3` FOREIGN KEY (`manager_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `review_assignments_ibfk_4` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO review_assignments (id, document_id, reviewer_id, manager_id, deadline, assigned_by, status, created_at) VALUES ('1', '1', '13', '14', '2026-10-28', '9', 'pending', '2026-10-28 17:10:40');
INSERT INTO review_assignments (id, document_id, reviewer_id, manager_id, deadline, assigned_by, status, created_at) VALUES ('2', '2', '13', '14', '2026-10-20', '9', 'pending', '2026-10-28 17:21:02');
INSERT INTO review_assignments (id, document_id, reviewer_id, manager_id, deadline, assigned_by, status, created_at) VALUES ('3', '6', '13', '14', '2026-10-05', '1', 'pending', '2026-10-28 17:38:11');
INSERT INTO review_assignments (id, document_id, reviewer_id, manager_id, deadline, assigned_by, status, created_at) VALUES ('4', '3', '13', '14', '2026-10-20', '9', 'pending', '2026-10-28 17:39:33');
INSERT INTO review_assignments (id, document_id, reviewer_id, manager_id, deadline, assigned_by, status, created_at) VALUES ('5', '4', '13', '14', '2026-10-14', '9', 'pending', '2026-10-28 17:39:58');
INSERT INTO review_assignments (id, document_id, reviewer_id, manager_id, deadline, assigned_by, status, created_at) VALUES ('6', '5', '13', '14', '2026-09-27', '9', 'pending', '2026-10-28 17:40:15');

CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(80) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(120) NOT NULL,
  `role` enum('user','reviewer','manager','admin') NOT NULL DEFAULT 'user',
  `designation` varchar(100) DEFAULT 'Team Member',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO users (id, username, email, password, full_name, role, designation, created_at) VALUES ('1', 'admin', 'admin@docflow.com', 'scrypt:32768:8:1$2XcD0H2KhhrRyy9p$94f95c1a133de7dbb9a42e25a0afde5ad47cd04d4e9187e44735765dbaaa2ab5265106bada90c0e3bddbd7801085516774529b40a9cc649ff546f5fc53fc3f68', 'Admin Controller', 'admin', 'Platform Executive', '2026-10-28 12:08:07');
INSERT INTO users (id, username, email, password, full_name, role, designation, created_at) VALUES ('2', 'anita', 'anita@docflow.com', 'scrypt:32768:8:1$2XcD0H2KhhrRyy9p$94f95c1a133de7dbb9a42e25a0afde5ad47cd04d4e9187e44735765dbaaa2ab5265106bada90c0e3bddbd7801085516774529b40a9cc649ff546f5fc53fc3f68', 'Reviewer Anita', 'reviewer', 'Technical Lead', '2026-10-28 12:08:07');
INSERT INTO users (id, username, email, password, full_name, role, designation, created_at) VALUES ('3', 'suresh', 'suresh@docflow.com', 'scrypt:32768:8:1$2XcD0H2KhhrRyy9p$94f95c1a133de7dbb9a42e25a0afde5ad47cd04d4e9187e44735765dbaaa2ab5265106bada90c0e3bddbd7801085516774529b40a9cc649ff546f5fc53fc3f68', 'Manager Suresh', 'manager', 'Operations Director', '2026-10-28 12:08:07');
INSERT INTO users (id, username, email, password, full_name, role, designation, created_at) VALUES ('4', 'johndoe', 'john@docflow.com', 'scrypt:32768:8:1$2XcD0H2KhhrRyy9p$94f95c1a133de7dbb9a42e25a0afde5ad47cd04d4e9187e44735765dbaaa2ab5265106bada90c0e3bddbd7801085516774529b40a9cc649ff546f5fc53fc3f68', 'User John Doe', 'user', 'Project Sign-off Author', '2026-10-28 12:08:07');
INSERT INTO users (id, username, email, password, full_name, role, designation, created_at) VALUES ('9', 'Maheswari', 'maheswariannavarapu@gmail.com', 'scrypt:32768:8:1$2XcD0H2KhhrRyy9p$94f95c1a133de7dbb9a42e25a0afde5ad47cd04d4e9187e44735765dbaaa2ab5265106bada90c0e3bddbd7801085516774529b40a9cc649ff546f5fc53fc3f68', 'Maheswari', 'user', 'Team Member', '2026-10-28 12:43:23');
INSERT INTO users (id, username, email, password, full_name, role, designation, created_at) VALUES ('13', 'Reviewer One', 'Reviewer@gmail.com', 'scrypt:32768:8:1$TGt90Z3TwDpPdLbg$4825430c8c7449a57b8ea8cadff59fe1d6dbd2629c513f693af5145bdfeeb2bd2455a82af469f6f7534fa9b8f29e5fda539d63d526386978e24642b66bcbe577', 'Reviewer One', 'reviewer', 'Team Member', '2026-10-28 13:26:24');
INSERT INTO users (id, username, email, password, full_name, role, designation, created_at) VALUES ('14', 'Manager', 'Manager@gmail.com', 'scrypt:32768:8:1$dsQokSo9pwe6bs13$01fe7b6b427d02d875018025c6fc8ae99aa15618f9f457168cc102355ee9b0f08d0e447bc25219ba2f18eb0c8f496f1eb75b22ab612003ee225f83e053e57a8d', 'Manager', 'manager', 'Team Member', '2026-10-28 13:28:27');

