-- Copied from MaHIS-Core db/structure.sql (dump of 2026-09-22) so the specs run
-- against the schema host apps use. DEFINER clauses removed for portability,
-- and this gem's migration versions added to schema_migrations because the
-- host already has their schema changes under its own migration versions.


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `active_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `active_list` (
  `active_list_id` int NOT NULL AUTO_INCREMENT,
  `active_list_type_id` int NOT NULL,
  `person_id` int NOT NULL,
  `concept_id` int NOT NULL,
  `start_obs_id` int DEFAULT NULL,
  `stop_obs_id` int DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL,
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` varchar(38) NOT NULL,
  PRIMARY KEY (`active_list_id`),
  KEY `active_list_type_of_active_list` (`active_list_type_id`),
  KEY `concept_active_list` (`concept_id`),
  KEY `user_who_created_active_list` (`creator`),
  KEY `person_of_active_list` (`person_id`),
  KEY `start_obs_active_list` (`start_obs_id`),
  KEY `stop_obs_active_list` (`stop_obs_id`),
  KEY `user_who_voided_active_list` (`voided_by`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `active_list_allergy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `active_list_allergy` (
  `active_list_id` int NOT NULL AUTO_INCREMENT,
  `allergy_type` varchar(50) DEFAULT NULL,
  `reaction_concept_id` int DEFAULT NULL,
  `severity` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`active_list_id`),
  KEY `reaction_allergy` (`reaction_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `active_list_problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `active_list_problem` (
  `active_list_id` int NOT NULL AUTO_INCREMENT,
  `status` varchar(50) DEFAULT NULL,
  `sort_weight` double DEFAULT NULL,
  PRIMARY KEY (`active_list_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `active_list_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `active_list_type` (
  `active_list_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL,
  `retired` smallint NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` varchar(38) NOT NULL,
  PRIMARY KEY (`active_list_type_id`),
  KEY `user_who_created_active_list_type` (`creator`),
  KEY `user_who_retired_active_list_type` (`retired_by`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `all_patient_identifiers`;
/*!50001 DROP VIEW IF EXISTS `all_patient_identifiers`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `all_patient_identifiers` AS SELECT 
 1 AS `patient_id`,
 1 AS `openmrs_ident_type`,
 1 AS `national_id`,
 1 AS `arv_number`,
 1 AS `legacy_id`,
 1 AS `prev_art_number`,
 1 AS `tb_number`,
 1 AS `filing_number`,
 1 AS `archived_filing_number`,
 1 AS `pre_art_number`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `all_patients_attributes`;
/*!50001 DROP VIEW IF EXISTS `all_patients_attributes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `all_patients_attributes` AS SELECT 
 1 AS `person_id`,
 1 AS `occupation`,
 1 AS `cell_phone`,
 1 AS `home_phone`,
 1 AS `office_phone`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `all_person_addresses`;
/*!50001 DROP VIEW IF EXISTS `all_person_addresses`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `all_person_addresses` AS SELECT 
 1 AS `person_address_id`,
 1 AS `person_id`,
 1 AS `preferred`,
 1 AS `address1`,
 1 AS `address2`,
 1 AS `city_village`,
 1 AS `state_province`,
 1 AS `postal_code`,
 1 AS `country`,
 1 AS `latitude`,
 1 AS `longitude`,
 1 AS `creator`,
 1 AS `date_created`,
 1 AS `voided`,
 1 AS `voided_by`,
 1 AS `date_voided`,
 1 AS `void_reason`,
 1 AS `county_district`,
 1 AS `neighborhood_cell`,
 1 AS `region`,
 1 AS `subregion`,
 1 AS `township_division`,
 1 AS `uuid`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `alternative_drug_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alternative_drug_names` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `short_name` varchar(255) DEFAULT NULL,
  `drug_inventory_id` int NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `amount_brought_back_obs`;
/*!50001 DROP VIEW IF EXISTS `amount_brought_back_obs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `amount_brought_back_obs` AS SELECT 
 1 AS `person_id`,
 1 AS `encounter_id`,
 1 AS `order_id`,
 1 AS `obs_datetime`,
 1 AS `drug_inventory_id`,
 1 AS `equivalent_daily_dose`,
 1 AS `value_numeric`,
 1 AS `quantity`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `amount_dispensed_obs`;
/*!50001 DROP VIEW IF EXISTS `amount_dispensed_obs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `amount_dispensed_obs` AS SELECT 
 1 AS `person_id`,
 1 AS `encounter_id`,
 1 AS `order_id`,
 1 AS `obs_datetime`,
 1 AS `drug_inventory_id`,
 1 AS `equivalent_daily_dose`,
 1 AS `start_date`,
 1 AS `value_numeric`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `anc_visit_observations`;
/*!50001 DROP VIEW IF EXISTS `anc_visit_observations`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `anc_visit_observations` AS SELECT 
 1 AS `person_id`,
 1 AS `encounter_id`,
 1 AS `value_numeric`,
 1 AS `encounter_datetime`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `art_number_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `art_number_sequence` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `location_id` int NOT NULL,
  `site_prefix` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `last_sequence` bigint NOT NULL DEFAULT '0',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_art_number_sequence_on_location_id` (`location_id`),
  CONSTRAINT `fk_rails_f4e76aab3c` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `arv_drug`;
/*!50001 DROP VIEW IF EXISTS `arv_drug`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `arv_drug` AS SELECT 
 1 AS `drug_id`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `arv_drugs_orders`;
/*!50001 DROP VIEW IF EXISTS `arv_drugs_orders`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `arv_drugs_orders` AS SELECT 
 1 AS `patient_id`,
 1 AS `encounter_id`,
 1 AS `concept_id`,
 1 AS `start_date`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `audits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audits` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `auditable_id` int DEFAULT NULL,
  `auditable_type` varchar(255) DEFAULT NULL,
  `associated_id` int DEFAULT NULL,
  `associated_type` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `user_type` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `audited_changes` text,
  `version` int DEFAULT '0',
  `comment` varchar(255) DEFAULT NULL,
  `remote_address` varchar(255) DEFAULT NULL,
  `request_uuid` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `associated_index` (`associated_type`,`associated_id`),
  KEY `auditable_index` (`auditable_type`,`auditable_id`,`version`),
  KEY `index_audits_on_created_at` (`created_at`),
  KEY `index_audits_on_request_uuid` (`request_uuid`),
  KEY `user_index` (`user_id`,`user_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3621 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `bed_mgmt_bed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bed_mgmt_bed` (
  `bed_id` int NOT NULL AUTO_INCREMENT,
  `uuid` varchar(38) COLLATE utf8mb3_unicode_ci NOT NULL,
  `bed_number` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `bed_label` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `section_id` int NOT NULL,
  `location_id` int DEFAULT NULL,
  `bed_status` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `bed_type` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb3_unicode_ci,
  `creator` int NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime(6) DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime(6) DEFAULT NULL,
  `retire_reason` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`bed_id`),
  UNIQUE KEY `idx_bed_mgmt_bed_uuid` (`uuid`),
  UNIQUE KEY `idx_bed_mgmt_bed_section_number` (`section_id`,`bed_number`),
  KEY `fk_rails_9315cb9d78` (`creator`),
  KEY `fk_rails_54fbc7f967` (`changed_by`),
  KEY `fk_rails_2db7fec740` (`retired_by`),
  KEY `idx_bed_mgmt_bed_section_status` (`section_id`,`bed_status`,`retired`),
  KEY `fk_rails_bbfeaf6894` (`location_id`),
  CONSTRAINT `fk_rails_2db7fec740` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_54fbc7f967` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_59d1372553` FOREIGN KEY (`section_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `fk_rails_9315cb9d78` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_bbfeaf6894` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `bed_mgmt_bed_allocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bed_mgmt_bed_allocation` (
  `bed_allocation_id` int NOT NULL AUTO_INCREMENT,
  `uuid` varchar(38) COLLATE utf8mb3_unicode_ci NOT NULL,
  `bed_id` int NOT NULL,
  `patient_id` int NOT NULL,
  `visit_id` int DEFAULT NULL,
  `allocated_at` datetime(6) NOT NULL,
  `released_at` datetime(6) DEFAULT NULL,
  `allocation_status` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `allocation_reason` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `release_reason` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb3_unicode_ci,
  `creator` int NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime(6) DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime(6) DEFAULT NULL,
  `void_reason` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`bed_allocation_id`),
  UNIQUE KEY `idx_bed_alloc_uuid` (`uuid`),
  KEY `idx_bed_alloc_bed_status_released` (`bed_id`,`allocation_status`,`released_at`,`voided`),
  KEY `idx_bed_alloc_patient` (`patient_id`),
  KEY `idx_bed_alloc_visit` (`visit_id`),
  KEY `fk_rails_6eb6121e8b` (`creator`),
  KEY `fk_rails_2c71980b69` (`changed_by`),
  KEY `fk_rails_d24e82ed2b` (`voided_by`),
  CONSTRAINT `fk_rails_2c71980b69` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_66c22d04fe` FOREIGN KEY (`bed_id`) REFERENCES `bed_mgmt_bed` (`bed_id`),
  CONSTRAINT `fk_rails_6eb6121e8b` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_957ad43d30` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`),
  CONSTRAINT `fk_rails_adac6927e4` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`),
  CONSTRAINT `fk_rails_d24e82ed2b` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `clinic_consultation_encounter`;
/*!50001 DROP VIEW IF EXISTS `clinic_consultation_encounter`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `clinic_consultation_encounter` AS SELECT 
 1 AS `encounter_id`,
 1 AS `encounter_type`,
 1 AS `patient_id`,
 1 AS `provider_id`,
 1 AS `location_id`,
 1 AS `form_id`,
 1 AS `encounter_datetime`,
 1 AS `creator`,
 1 AS `date_created`,
 1 AS `voided`,
 1 AS `voided_by`,
 1 AS `date_voided`,
 1 AS `void_reason`,
 1 AS `uuid`,
 1 AS `changed_by`,
 1 AS `date_changed`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `clinic_registration_encounter`;
/*!50001 DROP VIEW IF EXISTS `clinic_registration_encounter`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `clinic_registration_encounter` AS SELECT 
 1 AS `encounter_id`,
 1 AS `encounter_type`,
 1 AS `patient_id`,
 1 AS `provider_id`,
 1 AS `location_id`,
 1 AS `form_id`,
 1 AS `encounter_datetime`,
 1 AS `creator`,
 1 AS `date_created`,
 1 AS `voided`,
 1 AS `voided_by`,
 1 AS `date_voided`,
 1 AS `void_reason`,
 1 AS `uuid`,
 1 AS `changed_by`,
 1 AS `date_changed`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `cohort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cohort` (
  `cohort_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL,
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`cohort_id`),
  UNIQUE KEY `cohort_uuid_index` (`uuid`),
  KEY `cohort_creator` (`creator`),
  KEY `user_who_voided_cohort` (`voided_by`),
  KEY `user_who_changed_cohort` (`changed_by`),
  CONSTRAINT `cohort_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_changed_cohort` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_voided_cohort` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cohort_drill_down`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cohort_drill_down` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `reporting_report_design_resource_id` int NOT NULL,
  `patient_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `drilldown_report_value` (`reporting_report_design_resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cohort_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cohort_member` (
  `cohort_id` int NOT NULL DEFAULT '0',
  `patient_id` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`cohort_id`,`patient_id`),
  KEY `cohort` (`cohort_id`),
  KEY `patient` (`patient_id`),
  CONSTRAINT `member_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON UPDATE CASCADE,
  CONSTRAINT `parent_cohort` FOREIGN KEY (`cohort_id`) REFERENCES `cohort` (`cohort_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `complex_obs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `complex_obs` (
  `obs_id` int NOT NULL DEFAULT '0',
  `mime_type_id` int NOT NULL DEFAULT '0',
  `urn` text,
  `complex_value` longtext,
  PRIMARY KEY (`obs_id`),
  KEY `mime_type_of_content` (`mime_type_id`),
  CONSTRAINT `complex_obs_ibfk_1` FOREIGN KEY (`mime_type_id`) REFERENCES `mime_type` (`mime_type_id`),
  CONSTRAINT `obs_pointing_to_complex_content` FOREIGN KEY (`obs_id`) REFERENCES `obs` (`obs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept` (
  `concept_id` int NOT NULL AUTO_INCREMENT,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `short_name` varchar(255) DEFAULT NULL,
  `description` text,
  `form_text` text,
  `datatype_id` int NOT NULL DEFAULT '0',
  `class_id` int NOT NULL DEFAULT '0',
  `is_set` tinyint(1) NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`concept_id`),
  UNIQUE KEY `concept_uuid_index` (`uuid`),
  KEY `user_who_changed_concept` (`changed_by`),
  KEY `concept_classes` (`class_id`),
  KEY `concept_creator` (`creator`),
  KEY `concept_datatypes` (`datatype_id`),
  KEY `user_who_retired_concept` (`retired_by`)
) ENGINE=InnoDB AUTO_INCREMENT=159051 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_answer` (
  `concept_answer_id` int NOT NULL AUTO_INCREMENT,
  `concept_id` int NOT NULL DEFAULT '0',
  `answer_concept` int DEFAULT NULL,
  `answer_drug` int DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `uuid` char(38) NOT NULL,
  `sort_weight` double DEFAULT NULL,
  PRIMARY KEY (`concept_answer_id`),
  UNIQUE KEY `concept_answer_uuid_index` (`uuid`),
  KEY `answer_creator` (`creator`),
  KEY `answer` (`answer_concept`),
  KEY `answers_for_concept` (`concept_id`),
  CONSTRAINT `answer` FOREIGN KEY (`answer_concept`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `answer_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `answers_for_concept` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10319 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_attribute` (
  `concept_attribute_id` int NOT NULL AUTO_INCREMENT,
  `concept_id` int NOT NULL,
  `attribute_type_id` int NOT NULL,
  `value_reference` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `uuid` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `creator` int NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime(6) DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime(6) DEFAULT NULL,
  `void_reason` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`concept_attribute_id`),
  UNIQUE KEY `index_concept_attribute_on_uuid` (`uuid`),
  KEY `fk_rails_9f1b0e3de2` (`concept_id`),
  KEY `fk_rails_de8b0e7c3f` (`attribute_type_id`),
  KEY `fk_rails_efdf512074` (`creator`),
  KEY `fk_rails_b117d4eccc` (`changed_by`),
  KEY `fk_rails_3e253396e5` (`voided_by`)
) ENGINE=InnoDB AUTO_INCREMENT=9776 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_attribute_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_attribute_type` (
  `concept_attribute_type_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `datatype` varchar(100) DEFAULT NULL,
  `datatype_config` text,
  `preferred_handler` varchar(255) DEFAULT NULL,
  `handler_config` text,
  `min_occurs` int DEFAULT '0',
  `max_occurs` int DEFAULT '1',
  `creator` int DEFAULT NULL,
  `date_created` datetime(6) DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime(6) DEFAULT NULL,
  `retired` tinyint(1) DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime(6) DEFAULT NULL,
  `retire_reason` text,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`concept_attribute_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_class` (
  `concept_class_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`concept_class_id`),
  UNIQUE KEY `concept_class_uuid_index` (`uuid`),
  KEY `concept_class_retired_status` (`retired`),
  KEY `concept_class_creator` (`creator`),
  KEY `user_who_retired_concept_class` (`retired_by`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_complex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_complex` (
  `concept_id` int NOT NULL,
  `handler` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`concept_id`),
  CONSTRAINT `concept_attributes` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_datatype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_datatype` (
  `concept_datatype_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `hl7_abbreviation` varchar(3) DEFAULT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`concept_datatype_id`),
  UNIQUE KEY `concept_datatype_uuid_index` (`uuid`),
  KEY `concept_datatype_retired_status` (`retired`),
  KEY `concept_datatype_creator` (`creator`),
  KEY `user_who_retired_concept_datatype` (`retired_by`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_description`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_description` (
  `concept_description_id` int NOT NULL AUTO_INCREMENT,
  `concept_id` int NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `locale` varchar(50) NOT NULL DEFAULT '',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`concept_description_id`),
  UNIQUE KEY `concept_description_uuid_index` (`uuid`),
  KEY `concept_being_described` (`concept_id`),
  KEY `user_who_created_description` (`creator`),
  KEY `user_who_changed_description` (`changed_by`),
  CONSTRAINT `description_for_concept` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `user_who_changed_description` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_created_description` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7363 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_map` (
  `concept_map_id` int NOT NULL AUTO_INCREMENT,
  `concept_source_id` int DEFAULT NULL,
  `concept_code` varchar(255) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `concept_id` int NOT NULL DEFAULT '0',
  `uuid` char(38) NOT NULL,
  `concept_map_type_id` bigint DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`concept_map_id`),
  UNIQUE KEY `concept_map_uuid_index` (`uuid`),
  UNIQUE KEY `idx_concept_map_unique` (`concept_id`,`concept_source_id`,`concept_code`),
  KEY `map_source` (`concept_source_id`),
  KEY `map_creator` (`creator`),
  KEY `map_for_concept` (`concept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35399 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_map_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_map_type` (
  `concept_map_type_id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `is_hidden` tinyint(1) NOT NULL DEFAULT '0',
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`concept_map_type_id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `mapped_user_creator_concept_map_type` (`creator`),
  KEY `mapped_user_changed_concept_map_type` (`changed_by`),
  KEY `mapped_user_retired_concept_map_type` (`retired_by`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_name` (
  `concept_name_id` int NOT NULL AUTO_INCREMENT,
  `concept_id` int DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `locale` varchar(50) NOT NULL DEFAULT '',
  `locale_preferred` tinyint(1) DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `concept_name_type` varchar(50) DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`concept_name_id`),
  UNIQUE KEY `concept_name_uuid_index` (`uuid`),
  KEY `name_of_concept` (`name`),
  KEY `name_for_concept` (`concept_id`),
  KEY `user_who_created_name` (`creator`),
  KEY `user_who_voided_this_name` (`voided_by`)
) ENGINE=InnoDB AUTO_INCREMENT=110935 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_name_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_name_tag` (
  `concept_name_tag_id` int NOT NULL AUTO_INCREMENT,
  `tag` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`concept_name_tag_id`),
  UNIQUE KEY `concept_name_tag_id` (`concept_name_tag_id`),
  UNIQUE KEY `concept_name_tag_id_2` (`concept_name_tag_id`),
  UNIQUE KEY `concept_name_tag_unique_tags` (`tag`),
  UNIQUE KEY `concept_name_tag_uuid_index` (`uuid`),
  KEY `user_who_created_name_tag` (`creator`),
  KEY `user_who_voided_name_tag` (`voided_by`)
) ENGINE=InnoDB AUTO_INCREMENT=399 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_name_tag_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_name_tag_map` (
  `concept_name_id` int NOT NULL,
  `concept_name_tag_id` int NOT NULL,
  KEY `map_name` (`concept_name_id`),
  KEY `map_name_tag` (`concept_name_tag_id`),
  CONSTRAINT `mapped_concept_name` FOREIGN KEY (`concept_name_id`) REFERENCES `concept_name` (`concept_name_id`),
  CONSTRAINT `mapped_concept_name_tag` FOREIGN KEY (`concept_name_tag_id`) REFERENCES `concept_name_tag` (`concept_name_tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_numeric`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_numeric` (
  `concept_id` int NOT NULL DEFAULT '0',
  `hi_absolute` double DEFAULT NULL,
  `hi_critical` double DEFAULT NULL,
  `hi_normal` double DEFAULT NULL,
  `low_absolute` double DEFAULT NULL,
  `low_critical` double DEFAULT NULL,
  `low_normal` double DEFAULT NULL,
  `units` varchar(50) DEFAULT NULL,
  `precise` smallint NOT NULL DEFAULT '0',
  PRIMARY KEY (`concept_id`),
  CONSTRAINT `numeric_attributes` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_proposal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_proposal` (
  `concept_proposal_id` int NOT NULL AUTO_INCREMENT,
  `concept_id` int DEFAULT NULL,
  `encounter_id` int DEFAULT NULL,
  `original_text` varchar(255) NOT NULL DEFAULT '',
  `final_text` varchar(255) DEFAULT NULL,
  `obs_id` int DEFAULT NULL,
  `obs_concept_id` int DEFAULT NULL,
  `state` varchar(32) NOT NULL DEFAULT 'UNMAPPED' COMMENT 'Valid values are: UNMAPPED, SYNONYM, CONCEPT, REJECT',
  `comments` varchar(255) DEFAULT NULL COMMENT 'Comment from concept admin/mapper',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `locale` varchar(50) NOT NULL DEFAULT '',
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`concept_proposal_id`),
  UNIQUE KEY `concept_proposal_uuid_index` (`uuid`),
  KEY `encounter_for_proposal` (`encounter_id`),
  KEY `concept_for_proposal` (`concept_id`),
  KEY `user_who_created_proposal` (`creator`),
  KEY `user_who_changed_proposal` (`changed_by`),
  KEY `proposal_obs_id` (`obs_id`),
  KEY `proposal_obs_concept_id` (`obs_concept_id`),
  CONSTRAINT `concept_for_proposal` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `encounter_for_proposal` FOREIGN KEY (`encounter_id`) REFERENCES `encounter` (`encounter_id`),
  CONSTRAINT `proposal_obs_concept_id` FOREIGN KEY (`obs_concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `proposal_obs_id` FOREIGN KEY (`obs_id`) REFERENCES `obs` (`obs_id`),
  CONSTRAINT `user_who_changed_proposal` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_created_proposal` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_proposal_tag_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_proposal_tag_map` (
  `concept_proposal_id` int NOT NULL,
  `concept_name_tag_id` int NOT NULL,
  KEY `map_proposal` (`concept_proposal_id`),
  KEY `map_name_tag` (`concept_name_tag_id`),
  CONSTRAINT `mapped_concept_proposal` FOREIGN KEY (`concept_proposal_id`) REFERENCES `concept_proposal` (`concept_proposal_id`),
  CONSTRAINT `mapped_concept_proposal_tag` FOREIGN KEY (`concept_name_tag_id`) REFERENCES `concept_name_tag` (`concept_name_tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_set` (
  `concept_set_id` int NOT NULL AUTO_INCREMENT,
  `concept_id` int NOT NULL DEFAULT '0',
  `concept_set` int NOT NULL DEFAULT '0',
  `sort_weight` double DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`concept_set_id`),
  UNIQUE KEY `concept_set_uuid_index` (`uuid`),
  KEY `idx_concept_set_concept` (`concept_id`),
  KEY `has_a` (`concept_set`),
  KEY `user_who_created` (`creator`)
) ENGINE=InnoDB AUTO_INCREMENT=97637 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_set_derived`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_set_derived` (
  `concept_id` int NOT NULL DEFAULT '0',
  `concept_set` int NOT NULL DEFAULT '0',
  `sort_weight` double DEFAULT NULL,
  PRIMARY KEY (`concept_id`,`concept_set`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_source` (
  `concept_source_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `hl7_code` varchar(50) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `retired` tinyint(1) NOT NULL,
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`concept_source_id`),
  UNIQUE KEY `concept_source_uuid_index` (`uuid`),
  KEY `concept_source_creator` (`creator`),
  KEY `user_who_voided_concept_source` (`retired_by`),
  KEY `unique_hl7_code` (`hl7_code`,`retired`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_state_conversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_state_conversion` (
  `concept_state_conversion_id` int NOT NULL AUTO_INCREMENT,
  `concept_id` int DEFAULT '0',
  `program_workflow_id` int DEFAULT '0',
  `program_workflow_state_id` int DEFAULT '0',
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`concept_state_conversion_id`),
  UNIQUE KEY `concept_state_conversion_uuid_index` (`uuid`),
  UNIQUE KEY `unique_workflow_concept_in_conversion` (`program_workflow_id`,`concept_id`),
  KEY `triggering_concept` (`concept_id`),
  KEY `affected_workflow` (`program_workflow_id`),
  KEY `resulting_state` (`program_workflow_state_id`),
  CONSTRAINT `concept_triggers_conversion` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `conversion_involves_workflow` FOREIGN KEY (`program_workflow_id`) REFERENCES `program_workflow` (`program_workflow_id`),
  CONSTRAINT `conversion_to_state` FOREIGN KEY (`program_workflow_state_id`) REFERENCES `program_workflow_state` (`program_workflow_state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_synonym`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_synonym` (
  `concept_id` int NOT NULL DEFAULT '0',
  `synonym` varchar(255) NOT NULL DEFAULT '',
  `locale` varchar(255) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`synonym`,`concept_id`),
  KEY `synonym_for` (`concept_id`),
  KEY `synonym_creator` (`creator`),
  CONSTRAINT `synonym_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `synonym_for` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `concept_word`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concept_word` (
  `concept_word_id` int NOT NULL AUTO_INCREMENT,
  `concept_id` int NOT NULL DEFAULT '0',
  `word` varchar(50) NOT NULL DEFAULT '',
  `locale` varchar(20) NOT NULL DEFAULT '',
  `concept_name_id` int NOT NULL,
  `weight` double DEFAULT '1',
  PRIMARY KEY (`concept_word_id`),
  KEY `word_in_concept_name` (`word`),
  KEY `concept_word_concept_idx` (`concept_id`),
  KEY `concept_word_weight_index` (`weight`),
  KEY `word_for_name` (`concept_name_id`)
) ENGINE=InnoDB AUTO_INCREMENT=314184 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `data_cleaning_supervisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_cleaning_supervisions` (
  `data_cleaning_tool_id` bigint NOT NULL AUTO_INCREMENT,
  `data_cleaning_datetime` datetime NOT NULL,
  `supervisors` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `creator` int NOT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `comments` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime(6) DEFAULT NULL,
  `date_voided` datetime(6) DEFAULT NULL,
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `uuid` varchar(38) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`data_cleaning_tool_id`),
  KEY `fk_rails_49c5d63d0f` (`changed_by`),
  KEY `fk_rails_f69409bf54` (`voided_by`),
  CONSTRAINT `fk_rails_49c5d63d0f` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_f69409bf54` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `district`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `district` (
  `district_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `region_id` int NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`district_id`),
  KEY `region_for_district` (`region_id`),
  KEY `user_who_created_district` (`creator`),
  KEY `user_who_retired_district` (`retired_by`),
  KEY `retired_status` (`retired`),
  CONSTRAINT `region_for_district` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`),
  CONSTRAINT `user_who_created_district` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_retired_district` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=293 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `districts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `districts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `drug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug` (
  `drug_id` int NOT NULL AUTO_INCREMENT,
  `concept_id` int NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `combination` tinyint(1) NOT NULL DEFAULT '0',
  `dosage_form` int DEFAULT NULL,
  `dose_strength` double DEFAULT NULL,
  `maximum_daily_dose` double DEFAULT NULL,
  `minimum_daily_dose` double DEFAULT NULL,
  `route` int DEFAULT NULL,
  `units` varchar(50) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`drug_id`),
  UNIQUE KEY `drug_uuid_index` (`uuid`),
  KEY `primary_drug_concept` (`concept_id`),
  KEY `drug_creator` (`creator`),
  KEY `drug_changed_by` (`changed_by`),
  KEY `dosage_form_concept` (`dosage_form`),
  KEY `drug_retired_by` (`retired_by`),
  KEY `route_concept` (`route`)
) ENGINE=InnoDB AUTO_INCREMENT=2680 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `drug_cms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug_cms` (
  `drug_inventory_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `short_name` varchar(225) DEFAULT NULL,
  `tabs` varchar(225) DEFAULT NULL,
  `pack_size` int DEFAULT NULL,
  `weight` int DEFAULT NULL,
  `strength` varchar(255) DEFAULT NULL,
  `voided` tinyint DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(225) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `program_id` int DEFAULT NULL,
  `location_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_drug_cms_on_program_id` (`program_id`),
  KEY `index_drug_cms_on_location_id` (`location_id`),
  KEY `index_drug_cms_on_program_and_location` (`program_id`,`location_id`),
  CONSTRAINT `fk_rails_b424c34433` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `drug_ingredient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug_ingredient` (
  `concept_id` int NOT NULL DEFAULT '0',
  `ingredient_id` int NOT NULL DEFAULT '0',
  KEY `combination_drug` (`concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `drug_ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug_ingredients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `drug_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug_order` (
  `order_id` int NOT NULL DEFAULT '0',
  `drug_inventory_id` int DEFAULT '0',
  `dose` double DEFAULT NULL,
  `equivalent_daily_dose` double DEFAULT NULL,
  `units` varchar(255) DEFAULT NULL,
  `frequency` varchar(255) DEFAULT NULL,
  `prn` smallint NOT NULL DEFAULT '0',
  `complex` smallint NOT NULL DEFAULT '0',
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `inventory_item` (`drug_inventory_id`),
  KEY `inventory_item_and_order_quantity` (`drug_inventory_id`,`quantity`),
  CONSTRAINT `extends_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `inventory_item` FOREIGN KEY (`drug_inventory_id`) REFERENCES `drug` (`drug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `drug_order_barcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug_order_barcodes` (
  `drug_order_barcode_id` int NOT NULL AUTO_INCREMENT,
  `drug_id` int DEFAULT NULL,
  `tabs` int DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`drug_order_barcode_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `drug_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug_set` (
  `drug_set_id` int NOT NULL AUTO_INCREMENT,
  `drug_inventory_id` int DEFAULT NULL,
  `set_id` int DEFAULT NULL,
  `frequency` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `duration` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `date_created` datetime DEFAULT NULL,
  `date_updated` datetime DEFAULT NULL,
  `creator` int DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  PRIMARY KEY (`drug_set_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `dset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dset` (
  `set_id` int NOT NULL AUTO_INCREMENT,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `date_created` datetime DEFAULT NULL,
  `date_updated` datetime DEFAULT NULL,
  `creator` int NOT NULL,
  `status` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`set_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `earliest_start_date`;
/*!50001 DROP VIEW IF EXISTS `earliest_start_date`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `earliest_start_date` AS SELECT 
 1 AS `patient_id`,
 1 AS `gender`,
 1 AS `birthdate`,
 1 AS `earliest_start_date`,
 1 AS `date_enrolled`,
 1 AS `death_date`,
 1 AS `age_at_initiation`,
 1 AS `age_in_days`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `encounter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `encounter` (
  `encounter_id` int NOT NULL AUTO_INCREMENT,
  `encounter_type` int NOT NULL,
  `patient_id` int NOT NULL DEFAULT '0',
  `provider_id` int NOT NULL DEFAULT '0',
  `location_id` varchar(255) DEFAULT NULL,
  `form_id` int DEFAULT NULL,
  `encounter_datetime` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `program_id` int DEFAULT '1',
  `visit_id` int DEFAULT NULL,
  PRIMARY KEY (`encounter_id`),
  UNIQUE KEY `encounter_uuid_index` (`uuid`),
  KEY `encounter_location` (`location_id`),
  KEY `encounter_patient` (`patient_id`),
  KEY `encounter_provider` (`provider_id`),
  KEY `encounter_type_id` (`encounter_type`),
  KEY `encounter_creator` (`creator`),
  KEY `encounter_form` (`form_id`),
  KEY `user_who_voided_encounter` (`voided_by`),
  KEY `encounter_changed_by` (`changed_by`),
  KEY `encounter_datetime_idx` (`encounter_datetime`),
  KEY `fk_rails_ad7f416cd0` (`program_id`),
  KEY `idx_person_encounters` (`patient_id`,`encounter_type`),
  KEY `idx_person_encounters_by_date` (`encounter_datetime`,`patient_id`,`encounter_type`),
  KEY `index_encounter_on_visit_id_and_program_id` (`visit_id`,`program_id`),
  KEY `idx_encounter_loc_void_program_created` (`location_id`,`voided`,`program_id`,`date_created`),
  KEY `idx_encounter_mnh_location_program_time` (`location_id`,`voided`,`program_id`,`encounter_datetime`,`patient_id`),
  KEY `idx_encounter_patient_sync_location_date` (`location_id`,`date_created`,`patient_id`),
  KEY `idx_encounter_patient_sync_date` (`date_created`,`patient_id`),
  KEY `idx_encounter_patient_voided_datetime` (`patient_id`,`voided`,`encounter_datetime`),
  KEY `idx_encounter_patient_program_voided_time` (`patient_id`,`program_id`,`voided`,`encounter_datetime`),
  CONSTRAINT `encounter_changed_by` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `encounter_form` FOREIGN KEY (`form_id`) REFERENCES `form` (`form_id`),
  CONSTRAINT `encounter_ibfk_1` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `encounter_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON UPDATE CASCADE,
  CONSTRAINT `encounter_provider` FOREIGN KEY (`provider_id`) REFERENCES `person` (`person_id`),
  CONSTRAINT `encounter_type_id` FOREIGN KEY (`encounter_type`) REFERENCES `encounter_type` (`encounter_type_id`),
  CONSTRAINT `fk_rails_618a1e853c` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`),
  CONSTRAINT `fk_rails_ad7f416cd0` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`),
  CONSTRAINT `user_who_voided_encounter` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38710 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `encounter_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `encounter_type` (
  `encounter_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `description` text,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`encounter_type_id`),
  UNIQUE KEY `encounter_type_uuid_index` (`uuid`),
  KEY `encounter_type_retired_status` (`retired`),
  KEY `user_who_created_type` (`creator`),
  KEY `user_who_retired_encounter_type` (`retired_by`)
) ENGINE=InnoDB AUTO_INCREMENT=276 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ever_registered_obs`;
/*!50001 DROP VIEW IF EXISTS `ever_registered_obs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ever_registered_obs` AS SELECT 
 1 AS `obs_id`,
 1 AS `person_id`,
 1 AS `concept_id`,
 1 AS `encounter_id`,
 1 AS `order_id`,
 1 AS `obs_datetime`,
 1 AS `location_id`,
 1 AS `obs_group_id`,
 1 AS `accession_number`,
 1 AS `value_group_id`,
 1 AS `value_boolean`,
 1 AS `value_coded`,
 1 AS `value_coded_name_id`,
 1 AS `value_drug`,
 1 AS `value_datetime`,
 1 AS `value_numeric`,
 1 AS `value_modifier`,
 1 AS `value_text`,
 1 AS `date_started`,
 1 AS `date_stopped`,
 1 AS `comments`,
 1 AS `creator`,
 1 AS `date_created`,
 1 AS `voided`,
 1 AS `voided_by`,
 1 AS `date_voided`,
 1 AS `void_reason`,
 1 AS `value_complex`,
 1 AS `uuid`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `external_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `external_source` (
  `external_source_id` int NOT NULL AUTO_INCREMENT,
  `source` int NOT NULL DEFAULT '0',
  `source_code` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  PRIMARY KEY (`external_source_id`),
  KEY `map_ext_source` (`source`),
  KEY `map_ext_creator` (`creator`),
  CONSTRAINT `map_ext_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `map_ext_source` FOREIGN KEY (`source`) REFERENCES `concept_source` (`concept_source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1022 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `facilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facilities` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `common` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ownership` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `facility_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `regulatory_status` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `district` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `date_opened` date DEFAULT NULL,
  `latitude` decimal(10,6) DEFAULT NULL,
  `longitude` decimal(10,6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_facilities_on_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=1902 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `field` (
  `field_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `field_type` int DEFAULT NULL,
  `concept_id` int DEFAULT NULL,
  `table_name` varchar(50) DEFAULT NULL,
  `attribute_name` varchar(50) DEFAULT NULL,
  `default_value` text,
  `select_multiple` smallint NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` smallint NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`field_id`),
  UNIQUE KEY `field_uuid_index` (`uuid`),
  KEY `concept_for_field` (`concept_id`),
  KEY `user_who_changed_field` (`changed_by`),
  KEY `user_who_created_field` (`creator`),
  KEY `type_of_field` (`field_type`),
  KEY `user_who_retired_field` (`retired_by`),
  KEY `field_retired_status` (`retired`),
  CONSTRAINT `concept_for_field` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `type_of_field` FOREIGN KEY (`field_type`) REFERENCES `field_type` (`field_type_id`),
  CONSTRAINT `user_who_changed_field` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_created_field` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_retired_field` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=702 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `field_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `field_answer` (
  `field_id` int NOT NULL DEFAULT '0',
  `answer_id` int NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`field_id`,`answer_id`),
  UNIQUE KEY `field_answer_uuid_index` (`uuid`),
  KEY `answers_for_field` (`field_id`),
  KEY `field_answer_concept` (`answer_id`),
  KEY `user_who_created_field_answer` (`creator`),
  CONSTRAINT `answers_for_field` FOREIGN KEY (`field_id`) REFERENCES `field` (`field_id`),
  CONSTRAINT `field_answer_concept` FOREIGN KEY (`answer_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `user_who_created_field_answer` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `field_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `field_type` (
  `field_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` longtext,
  `is_set` smallint NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`field_type_id`),
  UNIQUE KEY `field_type_uuid_index` (`uuid`),
  KEY `user_who_created_field_type` (`creator`),
  CONSTRAINT `user_who_created_field_type` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form` (
  `form_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `version` varchar(50) NOT NULL DEFAULT '',
  `build` int DEFAULT NULL,
  `published` smallint NOT NULL DEFAULT '0',
  `description` text,
  `encounter_type` int DEFAULT NULL,
  `template` mediumtext,
  `xslt` mediumtext,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` smallint NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retired_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`form_id`),
  UNIQUE KEY `form_uuid_index` (`uuid`),
  KEY `user_who_created_form` (`creator`),
  KEY `user_who_last_changed_form` (`changed_by`),
  KEY `user_who_retired_form` (`retired_by`),
  KEY `encounter_type` (`encounter_type`),
  CONSTRAINT `form_encounter_type` FOREIGN KEY (`encounter_type`) REFERENCES `encounter_type` (`encounter_type_id`),
  CONSTRAINT `user_who_created_form` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_last_changed_form` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_retired_form` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `form2program_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form2program_map` (
  `program` int NOT NULL,
  `encounter_type` int NOT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL,
  `changed_by` int NOT NULL,
  `date_changed` datetime NOT NULL,
  `applied` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`program`,`encounter_type`),
  KEY `encounter_type` (`encounter_type`),
  KEY `user_who_created_form2program` (`creator`),
  KEY `user_who_changed_form2program` (`changed_by`),
  CONSTRAINT `form2program_map_ibfk_1` FOREIGN KEY (`program`) REFERENCES `program` (`program_id`),
  CONSTRAINT `form2program_map_ibfk_2` FOREIGN KEY (`encounter_type`) REFERENCES `encounter_type` (`encounter_type_id`),
  CONSTRAINT `user_who_changed_form2program` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_created_form2program` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `form_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_field` (
  `form_field_id` int NOT NULL AUTO_INCREMENT,
  `form_id` int NOT NULL DEFAULT '0',
  `field_id` int NOT NULL DEFAULT '0',
  `field_number` int DEFAULT NULL,
  `field_part` varchar(5) DEFAULT NULL,
  `page_number` int DEFAULT NULL,
  `parent_form_field` int DEFAULT NULL,
  `min_occurs` int DEFAULT NULL,
  `max_occurs` int DEFAULT NULL,
  `required` smallint NOT NULL DEFAULT '0',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `sort_weight` float(11,5) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`form_field_id`),
  UNIQUE KEY `form_field_uuid_index` (`uuid`),
  KEY `user_who_last_changed_form_field` (`changed_by`),
  KEY `field_within_form` (`field_id`),
  KEY `form_containing_field` (`form_id`),
  KEY `form_field_hierarchy` (`parent_form_field`),
  KEY `user_who_created_form_field` (`creator`),
  CONSTRAINT `field_within_form` FOREIGN KEY (`field_id`) REFERENCES `field` (`field_id`),
  CONSTRAINT `form_containing_field` FOREIGN KEY (`form_id`) REFERENCES `form` (`form_id`),
  CONSTRAINT `form_field_hierarchy` FOREIGN KEY (`parent_form_field`) REFERENCES `form_field` (`form_field_id`),
  CONSTRAINT `user_who_created_form_field` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_last_changed_form_field` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `formentry_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formentry_archive` (
  `formentry_archive_id` int NOT NULL AUTO_INCREMENT,
  `form_data` mediumtext NOT NULL,
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `creator` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`formentry_archive_id`),
  KEY `User who created formentry_archive` (`creator`),
  CONSTRAINT `User who created formentry_archive` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `formentry_error`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formentry_error` (
  `formentry_error_id` int NOT NULL AUTO_INCREMENT,
  `form_data` mediumtext NOT NULL,
  `error` varchar(255) NOT NULL DEFAULT '',
  `error_details` text,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  PRIMARY KEY (`formentry_error_id`),
  KEY `User who created formentry_error` (`creator`),
  CONSTRAINT `User who created formentry_error` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `formentry_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formentry_queue` (
  `formentry_queue_id` int NOT NULL AUTO_INCREMENT,
  `form_data` mediumtext NOT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  PRIMARY KEY (`formentry_queue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `formentry_xsn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formentry_xsn` (
  `formentry_xsn_id` int NOT NULL AUTO_INCREMENT,
  `form_id` int NOT NULL,
  `xsn_data` longblob NOT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `archived` int NOT NULL DEFAULT '0',
  `archived_by` int DEFAULT NULL,
  `date_archived` datetime DEFAULT NULL,
  PRIMARY KEY (`formentry_xsn_id`),
  KEY `User who created formentry_xsn` (`creator`),
  KEY `Form with which this xsn is related` (`form_id`),
  KEY `User who archived formentry_xsn` (`archived_by`),
  CONSTRAINT `Form with which this xsn is related` FOREIGN KEY (`form_id`) REFERENCES `form` (`form_id`),
  CONSTRAINT `User who archived formentry_xsn` FOREIGN KEY (`archived_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `User who created formentry_xsn` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `general_sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `general_sets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `global_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `global_property` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `property` varbinary(255) NOT NULL DEFAULT '',
  `property_value` mediumtext,
  `description` text,
  `uuid` char(38) NOT NULL,
  `location_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_global_property_property_location` (`property`,`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1191 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `guardians`;
/*!50001 DROP VIEW IF EXISTS `guardians`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `guardians` AS SELECT 
 1 AS `patient_id`,
 1 AS `guardian_id`,
 1 AS `gender`,
 1 AS `given_name`,
 1 AS `family_name`,
 1 AS `middle_name`,
 1 AS `birthdate_estimated`,
 1 AS `birthdate`,
 1 AS `home_district`,
 1 AS `current_district`,
 1 AS `landmark`,
 1 AS `current_residence`,
 1 AS `traditional_authority`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `heart_beat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `heart_beat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ip` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `property` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `value` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `time_stamp` datetime DEFAULT NULL,
  `username` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `url` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `hiv_status_obs`;
/*!50001 DROP VIEW IF EXISTS `hiv_status_obs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `hiv_status_obs` AS SELECT 
 1 AS `person_id`,
 1 AS `encounter_id`,
 1 AS `hiv_status`,
 1 AS `obs_datetime`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `hiv_test_and_hiv_test_date_obs`;
/*!50001 DROP VIEW IF EXISTS `hiv_test_and_hiv_test_date_obs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `hiv_test_and_hiv_test_date_obs` AS SELECT 
 1 AS `person_id`,
 1 AS `encounter_id`,
 1 AS `hiv_status`,
 1 AS `hiv_test_date`,
 1 AS `obs_datetime`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `hiv_test_date_obs`;
/*!50001 DROP VIEW IF EXISTS `hiv_test_date_obs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `hiv_test_date_obs` AS SELECT 
 1 AS `person_id`,
 1 AS `encounter_id`,
 1 AS `hiv_test_date`,
 1 AS `obs_datetime`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `hl7_in_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hl7_in_archive` (
  `hl7_in_archive_id` int NOT NULL AUTO_INCREMENT,
  `hl7_source` int NOT NULL DEFAULT '0',
  `hl7_source_key` varchar(255) DEFAULT NULL,
  `hl7_data` mediumtext NOT NULL,
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `message_state` int DEFAULT '2',
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`hl7_in_archive_id`),
  UNIQUE KEY `hl7_in_archive_uuid_index` (`uuid`),
  KEY `hl7_in_archive_message_state_idx` (`message_state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `hl7_in_error`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hl7_in_error` (
  `hl7_in_error_id` int NOT NULL AUTO_INCREMENT,
  `hl7_source` int NOT NULL DEFAULT '0',
  `hl7_source_key` text,
  `hl7_data` mediumtext NOT NULL,
  `error` varchar(255) NOT NULL DEFAULT '',
  `error_details` mediumtext,
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`hl7_in_error_id`),
  UNIQUE KEY `hl7_in_error_uuid_index` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `hl7_in_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hl7_in_queue` (
  `hl7_in_queue_id` int NOT NULL AUTO_INCREMENT,
  `hl7_source` int NOT NULL DEFAULT '0',
  `hl7_source_key` text,
  `hl7_data` mediumtext NOT NULL,
  `message_state` int NOT NULL DEFAULT '0',
  `date_processed` datetime DEFAULT NULL,
  `error_msg` text,
  `date_created` datetime DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`hl7_in_queue_id`),
  UNIQUE KEY `hl7_in_queue_uuid_index` (`uuid`),
  KEY `hl7_source` (`hl7_source`),
  CONSTRAINT `hl7_source` FOREIGN KEY (`hl7_source`) REFERENCES `hl7_source` (`hl7_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `hl7_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hl7_source` (
  `hl7_source_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` tinytext,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`hl7_source_id`),
  UNIQUE KEY `hl7_source_uuid_index` (`uuid`),
  KEY `creator` (`creator`),
  CONSTRAINT `creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `htmlformentry_html_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `htmlformentry_html_form` (
  `id` int NOT NULL AUTO_INCREMENT,
  `form_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `xml_data` mediumtext NOT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `User who created htmlformentry_htmlform` (`creator`),
  KEY `Form with which this htmlform is related` (`form_id`),
  KEY `User who changed htmlformentry_htmlform` (`changed_by`),
  CONSTRAINT `Form with which this htmlform is related` FOREIGN KEY (`form_id`) REFERENCES `form` (`form_id`),
  CONSTRAINT `User who changed htmlformentry_htmlform` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `User who created htmlformentry_htmlform` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `immunization_cache_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `immunization_cache_data` (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` json NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `location_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `internal_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internal_sections` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rails_564f0c6e7f` (`creator`),
  KEY `fk_rails_b4dec3bd71` (`voided_by`),
  CONSTRAINT `fk_rails_564f0c6e7f` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_b4dec3bd71` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lab_accession_number_counters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_accession_number_counters` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `value` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_lab_accession_number_counters_on_date` (`date`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lab_lims_failed_imports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_lims_failed_imports` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `lims_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `tracking_number` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `patient_nhid` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `diff` varchar(2048) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_lab_lims_failed_imports_on_lims_id` (`lims_id`),
  KEY `index_lab_lims_failed_imports_on_patient_nhid` (`patient_nhid`),
  KEY `index_lab_lims_failed_imports_on_tracking_number` (`tracking_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lab_lims_order_mappings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_lims_order_mappings` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `lims_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `order_id` int NOT NULL,
  `pushed_at` datetime DEFAULT NULL,
  `pulled_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `revision` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `result_push_status` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_rails_0171384638` (`order_id`),
  KEY `index_lab_lims_order_mappings_on_lims_id` (`lims_id`),
  CONSTRAINT `fk_rails_0171384638` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `labs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `labs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `last_menstraul_period_date`;
/*!50001 DROP VIEW IF EXISTS `last_menstraul_period_date`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `last_menstraul_period_date` AS SELECT 
 1 AS `person_id`,
 1 AS `encounter_id`,
 1 AS `lmp`,
 1 AS `obs_datetime`,
 1 AS `date_created`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `lims_acknowledgement_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lims_acknowledgement_statuses` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `test` int NOT NULL,
  `date_received` datetime NOT NULL,
  `date_pushed` datetime DEFAULT NULL,
  `acknowledgement_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `pushed` tinyint(1) NOT NULL DEFAULT '0',
  `voided` tinyint(1) DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `fk_rails_c856923164` (`test`),
  KEY `fk_rails_331e1d9232` (`voided_by`),
  CONSTRAINT `fk_rails_331e1d9232` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_83a1b79067` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `fk_rails_c856923164` FOREIGN KEY (`test`) REFERENCES `concept` (`concept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36686 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `liquibasechangelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `liquibasechangelog` (
  `ID` varchar(63) NOT NULL,
  `AUTHOR` varchar(63) NOT NULL,
  `FILENAME` varchar(200) NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `MD5SUM` varchar(32) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `COMMENTS` varchar(255) DEFAULT NULL,
  `TAG` varchar(255) DEFAULT NULL,
  `LIQUIBASE` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ID`,`AUTHOR`,`FILENAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `liquibasechangeloglock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `liquibasechangeloglock` (
  `ID` int NOT NULL,
  `LOCKED` tinyint(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) DEFAULT NULL,
  `address1` varchar(50) DEFAULT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `city_village` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `postal_code` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `latitude` varchar(50) DEFAULT NULL,
  `longitude` varchar(50) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `county_district` varchar(50) DEFAULT NULL,
  `neighborhood_cell` varchar(255) DEFAULT NULL,
  `region` varchar(50) DEFAULT NULL,
  `subregion` varchar(50) DEFAULT NULL,
  `township_division` varchar(50) DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `parent_location` int DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  `village_id` int DEFAULT NULL,
  PRIMARY KEY (`location_id`),
  UNIQUE KEY `location_uuid_index` (`uuid`),
  KEY `user_who_created_location` (`creator`),
  KEY `name_of_location` (`name`),
  KEY `user_who_retired_location` (`retired_by`),
  KEY `retired_status` (`retired`),
  KEY `parent_location` (`parent_location`),
  KEY `index_location_on_village_id` (`village_id`),
  CONSTRAINT `fk_rails_052996bfb2` FOREIGN KEY (`village_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `parent_location` FOREIGN KEY (`parent_location`) REFERENCES `location` (`location_id`),
  CONSTRAINT `user_who_created_location` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_retired_location` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38117 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `location_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location_attribute` (
  `location_attribute_id` int NOT NULL AUTO_INCREMENT,
  `location_id` int DEFAULT NULL,
  `attribute_type_id` int DEFAULT NULL,
  `value_reference` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `uuid` char(38) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `creator` int DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `voided` tinyint(1) DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`location_attribute_id`),
  UNIQUE KEY `location_attribute_uuid_index` (`uuid`),
  KEY `location_attribute_type` (`attribute_type_id`),
  KEY `location_attribute_creator` (`creator`),
  KEY `location_attribute_location` (`location_id`),
  KEY `idx_location_attr_lookup` (`location_id`,`attribute_type_id`,`voided`,`location_attribute_id`),
  CONSTRAINT `location_attribute_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `location_attribute_ibfk_2` FOREIGN KEY (`attribute_type_id`) REFERENCES `location_attribute_type` (`location_attribute_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14194 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `location_attribute_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location_attribute_type` (
  `location_attribute_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `description` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `datatype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `datatype_config` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `preferred_handler` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `handler_config` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `min_occurs` int DEFAULT NULL,
  `max_occurs` int DEFAULT NULL,
  `creator` int DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` tinyint(1) DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `uuid` char(38) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`location_attribute_type_id`),
  UNIQUE KEY `location_attribute_type_uuid_index` (`uuid`),
  KEY `location_attribute_type_creator` (`creator`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `location_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location_tag` (
  `location_tag_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL,
  `retired` smallint NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`location_tag_id`),
  UNIQUE KEY `location_tag_uuid_index` (`uuid`),
  KEY `location_tag_creator` (`creator`),
  KEY `location_tag_retired_by` (`retired_by`),
  CONSTRAINT `location_tag_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `location_tag_retired_by` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `location_tag_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location_tag_map` (
  `location_id` int NOT NULL,
  `location_tag_id` int NOT NULL,
  PRIMARY KEY (`location_id`,`location_tag_id`),
  KEY `location_tag_map_tag` (`location_tag_id`),
  CONSTRAINT `location_tag_map_location` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `location_tag_map_tag` FOREIGN KEY (`location_tag_id`) REFERENCES `location_tag` (`location_tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `location_tag_maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location_tag_maps` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `logic_rule_definition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logic_rule_definition` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uuid` char(38) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `rule_content` varchar(2048) NOT NULL,
  `language` varchar(255) NOT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `creator for rule_definition` (`creator`),
  KEY `changed_by for rule_definition` (`changed_by`),
  KEY `retired_by for rule_definition` (`retired_by`),
  CONSTRAINT `changed_by for rule_definition` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `creator for rule_definition` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `retired_by for rule_definition` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `logic_rule_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logic_rule_token` (
  `logic_rule_token_id` int NOT NULL AUTO_INCREMENT,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL DEFAULT '0002-11-30 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `token` varchar(512) NOT NULL,
  `class_name` varchar(512) NOT NULL,
  `state` varchar(512) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`logic_rule_token_id`),
  UNIQUE KEY `logic_rule_token_uuid` (`uuid`),
  KEY `token_creator` (`creator`),
  KEY `token_changed_by` (`changed_by`),
  CONSTRAINT `token_changed_by` FOREIGN KEY (`changed_by`) REFERENCES `person` (`person_id`),
  CONSTRAINT `token_creator` FOREIGN KEY (`creator`) REFERENCES `person` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `logic_rule_token_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logic_rule_token_tag` (
  `logic_rule_token_id` int NOT NULL,
  `tag` varchar(512) NOT NULL,
  KEY `token_tag` (`logic_rule_token_id`),
  CONSTRAINT `token_tag` FOREIGN KEY (`logic_rule_token_id`) REFERENCES `logic_rule_token` (`logic_rule_token_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `logic_token_registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logic_token_registration` (
  `token_registration_id` int NOT NULL AUTO_INCREMENT,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL DEFAULT '0002-11-30 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `token` varchar(512) NOT NULL,
  `provider_class_name` varchar(512) NOT NULL,
  `provider_token` varchar(512) NOT NULL,
  `configuration` varchar(2000) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`token_registration_id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `token_registration_creator` (`creator`),
  KEY `token_registration_changed_by` (`changed_by`),
  CONSTRAINT `token_registration_changed_by` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `token_registration_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `logic_token_registration_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logic_token_registration_tag` (
  `token_registration_id` int NOT NULL,
  `tag` varchar(512) NOT NULL,
  KEY `token_registration_tag` (`token_registration_id`),
  CONSTRAINT `token_registration_tag` FOREIGN KEY (`token_registration_id`) REFERENCES `logic_token_registration` (`token_registration_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `merge_audits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merge_audits` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `primary_id` int NOT NULL,
  `secondary_id` int NOT NULL,
  `merge_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `secondary_previous_merge_id` bigint DEFAULT NULL,
  `creator` int NOT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rails_76fdfcb4ed` (`primary_id`),
  KEY `fk_rails_afc7a0f240` (`secondary_id`),
  KEY `fk_rails_d1dc00d9b1` (`creator`),
  KEY `fk_rails_83cf4bb331` (`voided_by`),
  KEY `fk_rails_d71d6f2933` (`secondary_previous_merge_id`),
  CONSTRAINT `fk_rails_76fdfcb4ed` FOREIGN KEY (`primary_id`) REFERENCES `patient` (`patient_id`),
  CONSTRAINT `fk_rails_83cf4bb331` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_afc7a0f240` FOREIGN KEY (`secondary_id`) REFERENCES `patient` (`patient_id`),
  CONSTRAINT `fk_rails_d1dc00d9b1` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_d71d6f2933` FOREIGN KEY (`secondary_previous_merge_id`) REFERENCES `merge_audits` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `merged_patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merged_patients` (
  `patient_id` int NOT NULL,
  `merged_to_id` int NOT NULL,
  PRIMARY KEY (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mime_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mime_type` (
  `mime_type_id` int NOT NULL AUTO_INCREMENT,
  `mime_type` varchar(75) NOT NULL DEFAULT '',
  `description` text,
  PRIMARY KEY (`mime_type_id`),
  KEY `mime_type_id` (`mime_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moh_other_medications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moh_other_medications` (
  `medication_id` int NOT NULL AUTO_INCREMENT,
  `drug_inventory_id` int NOT NULL,
  `dose_id` int NOT NULL,
  `min_weight` float NOT NULL,
  `max_weight` float NOT NULL,
  `category` varchar(1) NOT NULL,
  PRIMARY KEY (`medication_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moh_regimen_combination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moh_regimen_combination` (
  `regimen_combination_id` int NOT NULL AUTO_INCREMENT,
  `regimen_name_id` int NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`regimen_combination_id`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moh_regimen_combination_drug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moh_regimen_combination_drug` (
  `regimen_combination_drug_id` int NOT NULL AUTO_INCREMENT,
  `regimen_combination_id` int NOT NULL,
  `drug_id` int NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`regimen_combination_drug_id`)
) ENGINE=InnoDB AUTO_INCREMENT=219 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moh_regimen_doses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moh_regimen_doses` (
  `dose_id` int NOT NULL AUTO_INCREMENT,
  `am` float DEFAULT NULL,
  `pm` float DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `date_updated` datetime DEFAULT NULL,
  `creator` int DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  PRIMARY KEY (`dose_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moh_regimen_ingredient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moh_regimen_ingredient` (
  `ingredient_id` int NOT NULL AUTO_INCREMENT,
  `regimen_id` int DEFAULT NULL,
  `drug_inventory_id` int DEFAULT NULL,
  `dose_id` int DEFAULT NULL,
  `min_weight` float DEFAULT NULL,
  `max_weight` float DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `date_updated` datetime DEFAULT NULL,
  `creator` int DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `min_age` int DEFAULT NULL,
  `max_age` int DEFAULT NULL,
  `gender` varchar(255) DEFAULT 'MF',
  `course` varchar(255) DEFAULT NULL,
  `ingredient_active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ingredient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=542 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moh_regimen_ingredient_starter_packs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moh_regimen_ingredient_starter_packs` (
  `ingredient_id` int NOT NULL AUTO_INCREMENT,
  `regimen_id` int DEFAULT NULL,
  `drug_inventory_id` int DEFAULT NULL,
  `dose_id` int DEFAULT NULL,
  `min_weight` float DEFAULT NULL,
  `max_weight` float DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `date_updated` datetime DEFAULT NULL,
  `creator` int DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  PRIMARY KEY (`ingredient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moh_regimen_ingredient_tb_treatment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moh_regimen_ingredient_tb_treatment` (
  `ingredient_id` int NOT NULL DEFAULT '0',
  `regimen_id` int DEFAULT NULL,
  `drug_inventory_id` int DEFAULT NULL,
  `dose_id` int DEFAULT NULL,
  `min_weight` float DEFAULT NULL,
  `max_weight` float DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `date_updated` datetime DEFAULT NULL,
  `creator` int DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moh_regimen_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moh_regimen_lookup` (
  `regimen_lookup_id` int NOT NULL AUTO_INCREMENT,
  `num_of_drug_combination` int DEFAULT NULL,
  `regimen_name` varchar(5) NOT NULL,
  `drug_inventory_id` int DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `date_updated` datetime DEFAULT NULL,
  `creator` int DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  PRIMARY KEY (`regimen_lookup_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moh_regimen_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moh_regimen_name` (
  `regimen_name_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`regimen_name_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moh_regimens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moh_regimens` (
  `regimen_id` int NOT NULL AUTO_INCREMENT,
  `regimen_index` int NOT NULL,
  `description` text,
  `date_created` datetime DEFAULT NULL,
  `date_updated` datetime DEFAULT NULL,
  `creator` int NOT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  PRIMARY KEY (`regimen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `national_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `national_id` (
  `id` int NOT NULL AUTO_INCREMENT,
  `national_id` varchar(30) NOT NULL DEFAULT '',
  `assigned` tinyint(1) NOT NULL DEFAULT '0',
  `eds` tinyint(1) DEFAULT '0',
  `creator` int DEFAULT NULL,
  `date_issued` datetime DEFAULT NULL,
  `issued_to` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=264255 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `national_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `national_ids` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `note` (
  `note_id` int NOT NULL DEFAULT '0',
  `note_type` varchar(50) DEFAULT NULL,
  `patient_id` int DEFAULT NULL,
  `obs_id` int DEFAULT NULL,
  `encounter_id` int DEFAULT NULL,
  `text` text NOT NULL,
  `priority` int DEFAULT NULL,
  `parent` int DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`note_id`),
  UNIQUE KEY `note_uuid_index` (`uuid`),
  KEY `patient_note` (`patient_id`),
  KEY `obs_note` (`obs_id`),
  KEY `encounter_note` (`encounter_id`),
  KEY `user_who_created_note` (`creator`),
  KEY `user_who_changed_note` (`changed_by`),
  KEY `note_hierarchy` (`parent`),
  CONSTRAINT `encounter_note` FOREIGN KEY (`encounter_id`) REFERENCES `encounter` (`encounter_id`),
  CONSTRAINT `note_hierarchy` FOREIGN KEY (`parent`) REFERENCES `note` (`note_id`),
  CONSTRAINT `obs_note` FOREIGN KEY (`obs_id`) REFERENCES `obs` (`obs_id`),
  CONSTRAINT `patient_note` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON UPDATE CASCADE,
  CONSTRAINT `user_who_changed_note` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_created_note` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `notification_alert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_alert` (
  `alert_id` int NOT NULL AUTO_INCREMENT,
  `text` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `satisfied_by_any` int NOT NULL DEFAULT '0',
  `alert_read` int NOT NULL DEFAULT '0',
  `date_to_expire` datetime DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  `test_type_id` int DEFAULT NULL,
  `order_id` int DEFAULT NULL,
  `specimen_id` int DEFAULT NULL,
  PRIMARY KEY (`alert_id`),
  UNIQUE KEY `notification_alert_uuid_index` (`uuid`),
  UNIQUE KEY `idx_notification_alert_lab_unique` (`test_type_id`,`order_id`,`specimen_id`),
  KEY `alert_creator` (`creator`),
  KEY `user_who_changed_alert` (`changed_by`),
  KEY `idx_notification_alert_expiry_clear` (`alert_read`,`date_to_expire`,`alert_id`),
  KEY `idx_notification_alert_test_type` (`test_type_id`),
  KEY `idx_notification_alert_order` (`order_id`),
  KEY `idx_notification_alert_specimen` (`specimen_id`),
  CONSTRAINT `alert_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_1c68989969` FOREIGN KEY (`test_type_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `fk_rails_493d59c16c` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `user_who_changed_alert` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `notification_alert_recipient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_alert_recipient` (
  `alert_id` int NOT NULL,
  `user_id` int NOT NULL,
  `alert_read` int NOT NULL DEFAULT '0',
  `date_changed` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `uuid` char(38) NOT NULL,
  `cleared` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`alert_id`,`user_id`),
  KEY `alert_read_by_user` (`user_id`),
  KEY `id_of_alert` (`alert_id`),
  CONSTRAINT `alert_read_by_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `id_of_alert` FOREIGN KEY (`alert_id`) REFERENCES `notification_alert` (`alert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `notification_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_template` (
  `template_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `template` text,
  `subject` varchar(100) DEFAULT NULL,
  `sender` varchar(255) DEFAULT NULL,
  `recipients` varchar(512) DEFAULT NULL,
  `ordinal` int DEFAULT '0',
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`template_id`),
  UNIQUE KEY `notification_template_uuid_index` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `notification_tracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_tracker` (
  `tracker_id` int NOT NULL AUTO_INCREMENT,
  `notification_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `notification_response` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `notification_datetime` datetime NOT NULL,
  `patient_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`tracker_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `notification_tracker_user_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_tracker_user_activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `login_datetime` datetime NOT NULL,
  `selected_activities` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ntp_regimens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ntp_regimens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `drug_id` bigint DEFAULT NULL,
  `am_dose` float DEFAULT NULL,
  `noon_dose` float DEFAULT '0',
  `pm_dose` float DEFAULT '0',
  `min_weight` float DEFAULT NULL,
  `max_weight` float DEFAULT NULL,
  `creator` int DEFAULT '0',
  `retired_by` float DEFAULT '0',
  `voided` int DEFAULT '0',
  `void_reason` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ntp_regimens_on_drug_id` (`drug_id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `obs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `obs` (
  `obs_id` int NOT NULL AUTO_INCREMENT,
  `person_id` int NOT NULL,
  `concept_id` int NOT NULL DEFAULT '0',
  `encounter_id` int DEFAULT NULL,
  `order_id` int DEFAULT NULL,
  `obs_datetime` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `location_id` varchar(255) DEFAULT NULL,
  `obs_group_id` int DEFAULT NULL,
  `accession_number` varchar(255) DEFAULT NULL,
  `value_group_id` int DEFAULT NULL,
  `value_boolean` tinyint(1) DEFAULT NULL,
  `value_coded` int DEFAULT NULL,
  `value_coded_name_id` int DEFAULT NULL,
  `value_drug` int DEFAULT NULL,
  `value_datetime` datetime DEFAULT NULL,
  `value_numeric` double DEFAULT NULL,
  `value_modifier` varchar(2) DEFAULT NULL,
  `value_text` text,
  `date_started` datetime DEFAULT NULL,
  `date_stopped` datetime DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `value_complex` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`obs_id`),
  UNIQUE KEY `obs_uuid_index` (`uuid`),
  KEY `answer_concept` (`value_coded`),
  KEY `encounter_observations` (`encounter_id`),
  KEY `obs_concept` (`concept_id`),
  KEY `obs_enterer` (`creator`),
  KEY `obs_location` (`location_id`),
  KEY `obs_order` (`order_id`),
  KEY `patient_obs` (`person_id`),
  KEY `user_who_voided_obs` (`voided_by`),
  KEY `answer_concept_drug` (`value_drug`),
  KEY `obs_grouping_id` (`obs_group_id`),
  KEY `obs_name_of_coded_value` (`value_coded_name_id`),
  KEY `obs_datetime_idx` (`obs_datetime`),
  KEY `idx_person_obs_answers_by_date` (`obs_datetime`,`person_id`,`concept_id`,`value_coded`),
  KEY `idx_person_obs_answer` (`person_id`,`concept_id`,`value_coded`),
  KEY `idx_obs_grouping` (`person_id`,`obs_group_id`,`value_coded`),
  KEY `idx_obs_appt_concept_date_location_voided` (`concept_id`,`value_datetime`,`location_id`,`voided`),
  KEY `idx_obs_concept_person_datetime` (`concept_id`,`person_id`,`obs_datetime`),
  KEY `idx_obs_adherence_lookup` (`concept_id`,`voided`,`person_id`,`obs_datetime`),
  KEY `idx_obs_preg_covering` (`concept_id`,`value_coded`,`voided`,`obs_datetime`,`person_id`),
  KEY `idx_obs_loc_void_encounter_time` (`location_id`,`voided`,`encounter_id`,`obs_datetime`),
  KEY `idx_obs_loc_void_concept_value_time` (`location_id`,`voided`,`concept_id`,`value_coded`,`obs_datetime`),
  KEY `idx_obs_mnh_location_concept_time` (`location_id`,`voided`,`concept_id`,`obs_datetime`,`person_id`),
  KEY `idx_obs_encounter_voided_group` (`encounter_id`,`voided`,`obs_group_id`),
  KEY `idx_obs_order_concept_voided` (`order_id`,`concept_id`,`voided`),
  KEY `idx_obs_patient_voided_group_id` (`person_id`,`voided`,`obs_group_id`,`obs_id`),
  CONSTRAINT `answer_concept` FOREIGN KEY (`value_coded`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `answer_concept_drug` FOREIGN KEY (`value_drug`) REFERENCES `drug` (`drug_id`),
  CONSTRAINT `encounter_observations` FOREIGN KEY (`encounter_id`) REFERENCES `encounter` (`encounter_id`),
  CONSTRAINT `obs_concept` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `obs_enterer` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `obs_grouping_id` FOREIGN KEY (`obs_group_id`) REFERENCES `obs` (`obs_id`),
  CONSTRAINT `obs_name_of_coded_value` FOREIGN KEY (`value_coded_name_id`) REFERENCES `concept_name` (`concept_name_id`),
  CONSTRAINT `obs_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `person_obs` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `user_who_voided_obs` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=208482 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `order_extension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_extension` (
  `order_extension_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `value` varchar(50) NOT NULL DEFAULT '',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`order_extension_id`),
  KEY `user_who_created_ext` (`creator`),
  KEY `user_who_retired_ext` (`voided_by`),
  KEY `retired_status` (`voided`),
  CONSTRAINT `user_who_created_extension` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_voided_extension` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `order_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_type` (
  `order_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`order_type_id`),
  UNIQUE KEY `order_type_uuid_index` (`uuid`),
  KEY `order_type_retired_status` (`retired`),
  KEY `type_created_by` (`creator`),
  KEY `user_who_retired_order_type` (`retired_by`),
  CONSTRAINT `order_type_ibfk_1` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `order_type_ibfk_2` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `order_type_id` int NOT NULL DEFAULT '0',
  `concept_id` int NOT NULL DEFAULT '0',
  `orderer` int DEFAULT '0',
  `encounter_id` int DEFAULT NULL,
  `instructions` text COLLATE utf8mb3_unicode_ci,
  `start_date` datetime DEFAULT NULL,
  `auto_expire_date` datetime DEFAULT NULL,
  `discontinued` smallint NOT NULL DEFAULT '0',
  `discontinued_date` datetime DEFAULT NULL,
  `discontinued_by` int DEFAULT NULL,
  `discontinued_reason` int DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `patient_id` int NOT NULL,
  `accession_number` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `obs_id` int DEFAULT NULL,
  `uuid` char(38) COLLATE utf8mb3_unicode_ci NOT NULL,
  `discontinued_reason_non_coded` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `comment_to_fulfiller` varchar(1024) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `fulfiller_comment` varchar(1024) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `fulfiller_status` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `orders_uuid_index` (`uuid`),
  KEY `order_creator` (`creator`),
  KEY `orderer_not_drug` (`orderer`),
  KEY `orders_in_encounter` (`encounter_id`),
  KEY `type_of_order` (`order_type_id`),
  KEY `user_who_discontinued_order` (`discontinued_by`),
  KEY `user_who_voided_order` (`voided_by`),
  KEY `discontinued_because` (`discontinued_reason`),
  KEY `order_for_patient` (`patient_id`),
  KEY `obs_for_order` (`obs_id`),
  KEY `idx_order` (`order_type_id`,`concept_id`,`patient_id`,`start_date`),
  KEY `idx_order_expiry` (`order_type_id`,`auto_expire_date`),
  KEY `order_id_patient_id_temp` (`patient_id`,`order_id`),
  KEY `idx_orders_patient_start_order` (`patient_id`,`start_date`,`order_id`),
  KEY `idx_orders_encounter_voided_order` (`encounter_id`,`voided`,`order_id`),
  KEY `idx_orders_start_date_order` (`start_date`,`order_id`),
  KEY `idx_orders_patient_voided_id` (`patient_id`,`voided`,`order_id`),
  CONSTRAINT `discontinued_because` FOREIGN KEY (`discontinued_reason`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `obs_for_order` FOREIGN KEY (`obs_id`) REFERENCES `obs` (`obs_id`),
  CONSTRAINT `order_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `order_for_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON UPDATE CASCADE,
  CONSTRAINT `orderer_not_drug` FOREIGN KEY (`orderer`) REFERENCES `users` (`user_id`),
  CONSTRAINT `orders_in_encounter` FOREIGN KEY (`encounter_id`) REFERENCES `encounter` (`encounter_id`),
  CONSTRAINT `type_of_order` FOREIGN KEY (`order_type_id`) REFERENCES `order_type` (`order_type_id`),
  CONSTRAINT `user_who_discontinued_order` FOREIGN KEY (`discontinued_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_voided_order` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36687 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `outpatients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `outpatients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `patient_id` int NOT NULL AUTO_INCREMENT,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `user_who_created_patient` (`creator`),
  KEY `user_who_voided_patient` (`voided_by`),
  KEY `user_who_changed_pat` (`changed_by`),
  KEY `idx_patient_voided_date_voided` (`voided`,`date_voided`),
  CONSTRAINT `person_id_for_patient` FOREIGN KEY (`patient_id`) REFERENCES `person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `user_who_changed_pat` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_created_patient` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_voided_patient` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=344391 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patient_defaulted_dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_defaulted_dates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int DEFAULT NULL,
  `order_id` int DEFAULT NULL,
  `drug_id` int DEFAULT NULL,
  `equivalent_daily_dose` float DEFAULT NULL,
  `amount_dispensed` int DEFAULT NULL,
  `quantity_given` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `defaulted_date` date DEFAULT NULL,
  `date_created` date DEFAULT '2025-11-05',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patient_first_arv_amount_dispensed`;
/*!50001 DROP VIEW IF EXISTS `patient_first_arv_amount_dispensed`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patient_first_arv_amount_dispensed` AS SELECT 
 1 AS `encounter_id`,
 1 AS `encounter_type`,
 1 AS `patient_id`,
 1 AS `provider_id`,
 1 AS `location_id`,
 1 AS `form_id`,
 1 AS `encounter_datetime`,
 1 AS `creator`,
 1 AS `date_created`,
 1 AS `voided`,
 1 AS `voided_by`,
 1 AS `date_voided`,
 1 AS `void_reason`,
 1 AS `uuid`,
 1 AS `changed_by`,
 1 AS `date_changed`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `patient_identifier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_identifier` (
  `patient_identifier_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL DEFAULT '0',
  `identifier` varchar(50) NOT NULL DEFAULT '',
  `identifier_type` int NOT NULL DEFAULT '0',
  `preferred` smallint NOT NULL DEFAULT '0',
  `location_id` int NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`patient_identifier_id`),
  UNIQUE KEY `patient_identifier_uuid_index` (`uuid`),
  KEY `defines_identifier_type` (`identifier_type`),
  KEY `identifier_creator` (`creator`),
  KEY `identifier_voider` (`voided_by`),
  KEY `identifier_location` (`location_id`),
  KEY `identifier_name` (`identifier`),
  KEY `idx_patient_identifier_patient` (`patient_id`),
  KEY `index_patient_identifier_on_identifier_type_and_identifier` (`identifier_type`,`identifier`),
  KEY `index_pi_on_voided_and_identifier_type_and_identifier` (`voided`,`identifier_type`,`identifier`),
  KEY `index_patient_identifier_on_patient_type_voided` (`patient_id`,`identifier_type`,`voided`),
  KEY `index_pi_on_voided_type_and_date_created` (`voided`,`identifier_type`,`date_created`),
  CONSTRAINT `defines_identifier_type` FOREIGN KEY (`identifier_type`) REFERENCES `patient_identifier_type` (`patient_identifier_type_id`),
  CONSTRAINT `identifier_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `identifier_voider` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `identifies_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`),
  CONSTRAINT `patient_identifier_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=838 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patient_identifier_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_identifier_type` (
  `patient_identifier_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `format` varchar(255) DEFAULT NULL,
  `check_digit` tinyint(1) NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `format_description` varchar(255) DEFAULT NULL,
  `validator` varchar(200) DEFAULT NULL,
  `location_behavior` varchar(50) DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`patient_identifier_type_id`),
  UNIQUE KEY `patient_identifier_type_uuid_index` (`uuid`),
  KEY `patient_identifier_type_retired_status` (`retired`),
  KEY `type_creator` (`creator`),
  KEY `user_who_retired_patient_identifier_type` (`retired_by`),
  CONSTRAINT `patient_identifier_type_ibfk_1` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `patient_identifier_type_ibfk_2` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patient_pregnant_obs`;
/*!50001 DROP VIEW IF EXISTS `patient_pregnant_obs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patient_pregnant_obs` AS SELECT 
 1 AS `obs_id`,
 1 AS `person_id`,
 1 AS `concept_id`,
 1 AS `encounter_id`,
 1 AS `order_id`,
 1 AS `obs_datetime`,
 1 AS `location_id`,
 1 AS `obs_group_id`,
 1 AS `accession_number`,
 1 AS `value_group_id`,
 1 AS `value_boolean`,
 1 AS `value_coded`,
 1 AS `value_coded_name_id`,
 1 AS `value_drug`,
 1 AS `value_datetime`,
 1 AS `value_numeric`,
 1 AS `value_modifier`,
 1 AS `value_text`,
 1 AS `date_started`,
 1 AS `date_stopped`,
 1 AS `comments`,
 1 AS `creator`,
 1 AS `date_created`,
 1 AS `voided`,
 1 AS `voided_by`,
 1 AS `date_voided`,
 1 AS `void_reason`,
 1 AS `value_complex`,
 1 AS `uuid`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `patient_program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_program` (
  `patient_program_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL DEFAULT '0',
  `program_id` int NOT NULL DEFAULT '0',
  `date_enrolled` datetime DEFAULT NULL,
  `date_completed` datetime DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  `location_id` int DEFAULT NULL,
  PRIMARY KEY (`patient_program_id`),
  UNIQUE KEY `patient_program_uuid_index` (`uuid`),
  KEY `patient_in_program` (`patient_id`),
  KEY `program_for_patient` (`program_id`),
  KEY `patient_program_creator` (`creator`),
  KEY `user_who_changed` (`changed_by`),
  KEY `user_who_voided_patient_program` (`voided_by`),
  KEY `index_patient_program_on_patient_id_and_program_id` (`patient_id`,`program_id`),
  KEY `index_patient_program_on_location_id_and_voided` (`location_id`,`voided`),
  KEY `index_patient_program_on_date_enrolled` (`date_enrolled`),
  KEY `index_patient_program_on_program_id_and_location_id` (`program_id`,`location_id`),
  KEY `idx_patient_program_mnh_counts` (`program_id`,`location_id`,`voided`,`date_enrolled`,`patient_id`),
  KEY `idx_patient_program_active_lookup` (`patient_id`,`program_id`,`voided`,`date_completed`,`date_enrolled`),
  CONSTRAINT `fk_rails_ea811118c2` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `patient_in_program` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON UPDATE CASCADE,
  CONSTRAINT `patient_program_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `program_for_patient` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`),
  CONSTRAINT `user_who_changed` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_voided_patient_program` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4743 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patient_record_operation_receipts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_record_operation_receipts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `patient_id` int DEFAULT NULL,
  `operation_type` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `operation_id` varchar(191) COLLATE utf8mb3_unicode_ci NOT NULL,
  `payload_hash` varchar(64) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'processing',
  `target_type` varchar(100) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `target_id` varchar(191) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `error_message` text COLLATE utf8mb3_unicode_ci,
  `started_at` datetime(6) DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_pr_op_receipts_patient_unique` (`patient_id`,`operation_type`,`operation_id`),
  KEY `idx_pr_op_receipts_patient_type` (`patient_id`,`operation_type`),
  KEY `idx_pr_op_receipts_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patient_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_state` (
  `patient_state_id` int NOT NULL AUTO_INCREMENT,
  `patient_program_id` int NOT NULL DEFAULT '0',
  `state` int NOT NULL DEFAULT '0',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` varchar(38) NOT NULL,
  PRIMARY KEY (`patient_state_id`),
  UNIQUE KEY `patient_state_uuid_index` (`uuid`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `state_for_patient` (`state`),
  KEY `patient_program_for_state` (`patient_program_id`),
  KEY `patient_state_creator` (`creator`),
  KEY `patient_state_changer` (`changed_by`),
  KEY `patient_state_voider` (`voided_by`),
  KEY `idx_patient_state_program_voided_start` (`patient_program_id`,`voided`,`start_date`,`end_date`),
  CONSTRAINT `patient_program_for_state` FOREIGN KEY (`patient_program_id`) REFERENCES `patient_program` (`patient_program_id`),
  CONSTRAINT `patient_state_changer` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `patient_state_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `patient_state_voider` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `state_for_patient` FOREIGN KEY (`state`) REFERENCES `program_workflow_state` (`program_workflow_state_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1128 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patient_state_on_arvs`;
/*!50001 DROP VIEW IF EXISTS `patient_state_on_arvs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patient_state_on_arvs` AS SELECT 
 1 AS `patient_state_id`,
 1 AS `patient_program_id`,
 1 AS `state`,
 1 AS `start_date`,
 1 AS `end_date`,
 1 AS `creator`,
 1 AS `date_created`,
 1 AS `changed_by`,
 1 AS `date_changed`,
 1 AS `voided`,
 1 AS `voided_by`,
 1 AS `date_voided`,
 1 AS `void_reason`,
 1 AS `uuid`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `patient_void_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_void_batches` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `reason` varchar(191) COLLATE utf8mb3_unicode_ci NOT NULL,
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime(6) NOT NULL,
  `row_counts` json DEFAULT NULL,
  `restored_by` int DEFAULT NULL,
  `restored_at` datetime(6) DEFAULT NULL,
  `restore_reason` varchar(191) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_patient_void_batches_patient` (`patient_id`,`restored_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patientflags_flag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patientflags_flag` (
  `flag_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `criteria` varchar(5000) NOT NULL,
  `message` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `evaluator` varchar(255) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`flag_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patientflags_flag_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patientflags_flag_tag` (
  `flag_id` int NOT NULL,
  `tag_id` int NOT NULL,
  KEY `flag_id` (`flag_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `patientflags_flag_tag_ibfk_1` FOREIGN KEY (`flag_id`) REFERENCES `patientflags_flag` (`flag_id`),
  CONSTRAINT `patientflags_flag_tag_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `patientflags_tag` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patientflags_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patientflags_tag` (
  `tag_id` int NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patients_demographics`;
/*!50001 DROP VIEW IF EXISTS `patients_demographics`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patients_demographics` AS SELECT 
 1 AS `patient_id`,
 1 AS `given_name`,
 1 AS `family_name`,
 1 AS `middle_name`,
 1 AS `gender`,
 1 AS `birthdate_estimated`,
 1 AS `birthdate`,
 1 AS `home_district`,
 1 AS `current_district`,
 1 AS `landmark`,
 1 AS `current_residence`,
 1 AS `traditional_authority`,
 1 AS `date_enrolled`,
 1 AS `earliest_start_date`,
 1 AS `death_date`,
 1 AS `age_at_initiation`,
 1 AS `age_in_days`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `patients_for_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients_for_location` (
  `patient_id` int NOT NULL,
  PRIMARY KEY (`patient_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patients_on_arvs`;
/*!50001 DROP VIEW IF EXISTS `patients_on_arvs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patients_on_arvs` AS SELECT 
 1 AS `patient_id`,
 1 AS `birthdate`,
 1 AS `earliest_start_date`,
 1 AS `death_date`,
 1 AS `gender`,
 1 AS `age_at_initiation`,
 1 AS `age_in_days`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `patients_to_merge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients_to_merge` (
  `patient_id` int DEFAULT NULL,
  `to_merge_to_id` int DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patients_with_has_transfer_letter_yes`;
/*!50001 DROP VIEW IF EXISTS `patients_with_has_transfer_letter_yes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patients_with_has_transfer_letter_yes` AS SELECT 
 1 AS `person_id`,
 1 AS `gender`,
 1 AS `obs_datetime`,
 1 AS `date_created`,
 1 AS `earliest_start_date`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person` (
  `person_id` int NOT NULL AUTO_INCREMENT,
  `gender` varchar(50) DEFAULT '',
  `birthdate` date DEFAULT NULL,
  `birthdate_estimated` smallint NOT NULL DEFAULT '0',
  `dead` smallint NOT NULL DEFAULT '0',
  `death_date` datetime DEFAULT NULL,
  `cause_of_death` int DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`person_id`),
  UNIQUE KEY `person_uuid_index` (`uuid`),
  KEY `user_who_created_patient` (`creator`),
  KEY `user_who_voided_patient` (`voided_by`),
  KEY `user_who_changed_pat` (`changed_by`),
  KEY `person_birthdate` (`birthdate`),
  KEY `person_death_date` (`death_date`),
  KEY `person_died_because` (`cause_of_death`),
  KEY `person_gender_idx` (`gender`),
  CONSTRAINT `person_died_because` FOREIGN KEY (`cause_of_death`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `user_who_changed_person` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_created_person` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_voided_person` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `person_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_address` (
  `person_address_id` int NOT NULL AUTO_INCREMENT,
  `person_id` int DEFAULT NULL,
  `preferred` smallint NOT NULL DEFAULT '0',
  `address1` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `city_village` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `postal_code` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `latitude` varchar(50) DEFAULT NULL,
  `longitude` varchar(50) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `county_district` varchar(50) DEFAULT NULL,
  `neighborhood_cell` varchar(255) DEFAULT NULL,
  `region` varchar(50) DEFAULT NULL,
  `subregion` varchar(50) DEFAULT NULL,
  `township_division` varchar(50) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`person_address_id`),
  UNIQUE KEY `person_address_uuid_index` (`uuid`),
  KEY `patient_address_creator` (`creator`),
  KEY `patient_addresses` (`person_id`),
  KEY `patient_address_void` (`voided_by`),
  KEY `index_date_created_on_person_address` (`date_created` DESC),
  CONSTRAINT `address_for_person` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `patient_address_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `patient_address_void` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=381087 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `person_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_attribute` (
  `person_attribute_id` int NOT NULL AUTO_INCREMENT,
  `person_id` int NOT NULL DEFAULT '0',
  `value` varchar(120) NOT NULL DEFAULT '',
  `person_attribute_type_id` int NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`person_attribute_id`),
  UNIQUE KEY `person_attribute_uuid_index` (`uuid`),
  KEY `identifies_person` (`person_id`),
  KEY `defines_attribute_type` (`person_attribute_type_id`),
  KEY `attribute_creator` (`creator`),
  KEY `attribute_changer` (`changed_by`),
  KEY `attribute_voider` (`voided_by`),
  CONSTRAINT `attribute_changer` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `attribute_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `attribute_voider` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `defines_attribute_type` FOREIGN KEY (`person_attribute_type_id`) REFERENCES `person_attribute_type` (`person_attribute_type_id`),
  CONSTRAINT `identifies_person` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=548824 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `person_attribute_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_attribute_type` (
  `person_attribute_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `format` varchar(50) DEFAULT NULL,
  `foreign_key` int DEFAULT NULL,
  `searchable` tinyint(1) NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `edit_privilege` varchar(255) DEFAULT NULL,
  `sort_weight` double DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`person_attribute_type_id`),
  UNIQUE KEY `person_attribute_type_uuid_index` (`uuid`),
  KEY `attribute_is_searchable` (`searchable`),
  KEY `name_of_attribute` (`name`),
  KEY `person_attribute_type_retired_status` (`retired`),
  KEY `attribute_type_changer` (`changed_by`),
  KEY `attribute_type_creator` (`creator`),
  KEY `user_who_retired_person_attribute_type` (`retired_by`),
  KEY `privilege_which_can_edit` (`edit_privilege`),
  CONSTRAINT `person_attribute_type_ibfk_1` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `person_attribute_type_ibfk_2` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `person_attribute_type_ibfk_3` FOREIGN KEY (`edit_privilege`) REFERENCES `privilege` (`privilege`),
  CONSTRAINT `person_attribute_type_ibfk_4` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `person_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_name` (
  `person_name_id` int NOT NULL AUTO_INCREMENT,
  `preferred` smallint NOT NULL DEFAULT '0',
  `person_id` int NOT NULL,
  `prefix` varchar(50) DEFAULT NULL,
  `given_name` varchar(50) DEFAULT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `family_name_prefix` varchar(50) DEFAULT NULL,
  `family_name` varchar(50) DEFAULT NULL,
  `family_name2` varchar(50) DEFAULT NULL,
  `family_name_suffix` varchar(50) DEFAULT NULL,
  `degree` varchar(50) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`person_name_id`),
  UNIQUE KEY `person_name_uuid_index` (`uuid`),
  KEY `name_for_patient` (`person_id`),
  KEY `user_who_made_name` (`creator`),
  KEY `user_who_voided_name` (`voided_by`),
  KEY `first_name` (`given_name`),
  KEY `middle_name` (`middle_name`),
  KEY `last_name` (`family_name`),
  KEY `family_name2` (`family_name2`),
  KEY `person_name_voided_given_name_idx` (`voided`,`given_name`),
  KEY `person_name_voided_family_name_idx` (`voided`,`family_name`),
  KEY `person_name_voided_middle_name_idx` (`voided`,`middle_name`),
  KEY `index_person_name_on_person_voided_date_created` (`person_id`,`voided`,`date_created`),
  CONSTRAINT `name for person` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `user_who_made_name` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_voided_name` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `person_name_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_name_code` (
  `person_name_code_id` int NOT NULL AUTO_INCREMENT,
  `person_name_id` int DEFAULT NULL,
  `given_name_code` varchar(50) DEFAULT NULL,
  `middle_name_code` varchar(50) DEFAULT NULL,
  `family_name_code` varchar(50) DEFAULT NULL,
  `family_name2_code` varchar(50) DEFAULT NULL,
  `family_name_suffix_code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`person_name_code_id`),
  KEY `name_for_patient` (`person_name_id`),
  KEY `given_name_code` (`given_name_code`),
  KEY `middle_name_code` (`middle_name_code`),
  KEY `family_name_code` (`family_name_code`),
  KEY `given_family_name_code` (`given_name_code`,`family_name_code`),
  CONSTRAINT `code for name` FOREIGN KEY (`person_name_id`) REFERENCES `person_name` (`person_name_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47332 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pharmacies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pharmacy_batch_item_reallocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy_batch_item_reallocations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `reallocation_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `batch_item_id` int DEFAULT NULL,
  `quantity` float DEFAULT NULL,
  `location_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `reallocation_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `date` date DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `creator` int NOT NULL,
  `date_changed` datetime NOT NULL,
  `voided` smallint DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `voided_by` int DEFAULT NULL,
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pharmacy_batch_item_reallocations_on_reallocation_type` (`reallocation_type`),
  KEY `index_pharmacy_batch_item_reallocations_on_program_id` (`program_id`),
  KEY `index_pharmacy_batch_reallocations_on_prog_and_loc` (`program_id`,`location_id`),
  CONSTRAINT `fk_rails_5224010e42` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pharmacy_batch_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy_batch_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `pharmacy_batch_id` int DEFAULT NULL,
  `drug_id` int DEFAULT NULL,
  `delivered_quantity` float DEFAULT NULL,
  `current_quantity` float DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_changed` datetime DEFAULT CURRENT_TIMESTAMP,
  `voided` tinyint(1) DEFAULT NULL,
  `voided_by` int DEFAULT NULL,
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `pack_size` int DEFAULT NULL,
  `barcode` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `product_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `unit_doses` float DEFAULT NULL,
  `manufacture` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dosage_form` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  `location_id` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pharmacy_batch_items_on_program_id` (`program_id`),
  KEY `index_pharmacy_batch_items_on_location_id` (`location_id`),
  KEY `index_pharmacy_batch_items_on_program_and_location` (`program_id`,`location_id`),
  CONSTRAINT `fk_rails_07dd899575` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pharmacy_batch_vvms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy_batch_vvms` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `vvm` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `batch_item_id` int DEFAULT NULL,
  `voided` tinyint(1) DEFAULT NULL,
  `voided_by` int DEFAULT NULL,
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pharmacy_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy_batches` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `batch_number` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_changed` datetime DEFAULT NULL,
  `voided` tinyint(1) DEFAULT NULL,
  `voided_by` int DEFAULT NULL,
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `location_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rails_09e680ca40` (`location_id`),
  KEY `index_pharmacy_batches_on_program_id` (`program_id`),
  KEY `index_pharmacy_batches_on_program_and_location` (`program_id`,`location_id`),
  CONSTRAINT `fk_rails_d8e11862ec` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pharmacy_encounter_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy_encounter_type` (
  `pharmacy_encounter_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `format` varchar(50) DEFAULT NULL,
  `foreign_key` int DEFAULT NULL,
  `searchable` tinyint(1) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`pharmacy_encounter_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pharmacy_obs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy_obs` (
  `pharmacy_module_id` int NOT NULL AUTO_INCREMENT,
  `pharmacy_encounter_type` int NOT NULL DEFAULT '0',
  `quantity` double DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(225) DEFAULT NULL,
  `batch_item_id` int DEFAULT NULL,
  `dispensation_obs_id` int DEFAULT NULL,
  `transaction_reason` text,
  `transaction_date` date DEFAULT NULL,
  `stock_verification_id` bigint DEFAULT NULL,
  `obs_group_id` int DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  `location_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pharmacy_module_id`),
  KEY `fk_rails_c51641b979` (`dispensation_obs_id`),
  KEY `index_pharmacy_obs_on_stock_verification_id` (`stock_verification_id`),
  KEY `fk_rails_353402f537` (`obs_group_id`),
  KEY `index_pharmacy_obs_on_program_id` (`program_id`),
  KEY `index_pharmacy_obs_on_location_id` (`location_id`),
  KEY `index_pharmacy_obs_on_program_and_location` (`program_id`,`location_id`),
  CONSTRAINT `fk_rails_2fb599752d` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_rails_353402f537` FOREIGN KEY (`obs_group_id`) REFERENCES `pharmacy_obs` (`pharmacy_module_id`),
  CONSTRAINT `fk_rails_7f4aa3b94b` FOREIGN KEY (`stock_verification_id`) REFERENCES `pharmacy_stock_verifications` (`id`),
  CONSTRAINT `fk_rails_c51641b979` FOREIGN KEY (`dispensation_obs_id`) REFERENCES `obs` (`obs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pharmacy_stock_balances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy_stock_balances` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `drug_id` bigint NOT NULL,
  `pack_size` int NOT NULL,
  `open_balance` float DEFAULT '0',
  `close_balance` float DEFAULT '0',
  `transaction_date` date NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pharmacy_stock_balances_on_drug_id` (`drug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pharmacy_stock_verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy_stock_verifications` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `verification_date` datetime DEFAULT NULL,
  `creator` int DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `voided` tinyint(1) DEFAULT NULL,
  `voided_by` int DEFAULT NULL,
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `program_id` int DEFAULT NULL,
  `location_id` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pharmacy_stock_verifications_on_program_id` (`program_id`),
  KEY `index_pharmacy_stock_verifications_on_location_id` (`location_id`),
  KEY `index_pharmacy_stock_verif_on_program_and_location` (`program_id`,`location_id`),
  CONSTRAINT `fk_rails_8684008624` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `potential_duplicates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `potential_duplicates` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `patient_id_a` int NOT NULL,
  `patient_id_b` int NOT NULL,
  `match_percentage` int DEFAULT NULL,
  `merge_status` tinyint(1) NOT NULL DEFAULT '0',
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime(6) DEFAULT NULL,
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `uuid` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `match_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_potential_duplicates_on_patient_id_a` (`patient_id_a`),
  KEY `index_potential_duplicates_on_patient_id_b` (`patient_id_b`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `privilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `privilege` (
  `privilege` varchar(50) NOT NULL DEFAULT '',
  `description` varchar(250) NOT NULL DEFAULT '',
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`privilege`),
  UNIQUE KEY `privilege_uuid_index` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program` (
  `program_id` int NOT NULL AUTO_INCREMENT,
  `concept_id` int NOT NULL DEFAULT '0',
  `outcomes_concept_id` int DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(50) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`program_id`),
  UNIQUE KEY `program_uuid_index` (`uuid`),
  KEY `user_who_changed_program` (`changed_by`),
  KEY `program_concept` (`concept_id`),
  KEY `program_creator` (`creator`),
  KEY `program_outcomes_concept_id_fk` (`outcomes_concept_id`),
  CONSTRAINT `program_ibfk_1` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `program_ibfk_2` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `program_ibfk_3` FOREIGN KEY (`outcomes_concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `program_ibfk_4` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `program_encounter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_encounter` (
  `program_encounter_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int DEFAULT NULL,
  `date_time` datetime DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  PRIMARY KEY (`program_encounter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `program_encounter_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_encounter_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `encounter_id` int DEFAULT NULL,
  `program_encounter_id` int DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  `voided` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=595 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `program_encounter_type_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_encounter_type_map` (
  `program_encounter_type_map_id` int NOT NULL AUTO_INCREMENT,
  `program_id` int DEFAULT NULL,
  `encounter_type_id` int DEFAULT NULL,
  PRIMARY KEY (`program_encounter_type_map_id`),
  KEY `program_mapping` (`program_id`,`encounter_type_id`),
  KEY `referenced_encounter_type` (`encounter_type_id`),
  CONSTRAINT `referenced_encounter_type` FOREIGN KEY (`encounter_type_id`) REFERENCES `encounter_type` (`encounter_type_id`),
  CONSTRAINT `referenced_program_encounter_type_map` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `program_location_restriction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_location_restriction` (
  `program_location_restriction_id` int NOT NULL AUTO_INCREMENT,
  `program_id` int DEFAULT NULL,
  `location_id` int DEFAULT NULL,
  PRIMARY KEY (`program_location_restriction_id`),
  KEY `program_mapping` (`program_id`,`location_id`),
  KEY `referenced_location` (`location_id`),
  CONSTRAINT `referenced_location` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `referenced_program` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `program_orders_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_orders_map` (
  `program_orders_map_id` int NOT NULL AUTO_INCREMENT,
  `program_id` int DEFAULT NULL,
  `concept_id` int DEFAULT NULL,
  PRIMARY KEY (`program_orders_map_id`),
  KEY `program_mapping` (`program_id`,`concept_id`),
  KEY `referenced_concept_id` (`concept_id`),
  CONSTRAINT `referenced_concept_id` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `referenced_program_orders_type_map` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `program_patient_identifier_type_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_patient_identifier_type_map` (
  `program_patient_identifier_type_map_id` int NOT NULL AUTO_INCREMENT,
  `program_id` int DEFAULT NULL,
  `patient_identifier_type_id` int DEFAULT NULL,
  PRIMARY KEY (`program_patient_identifier_type_map_id`),
  KEY `program_mapping` (`program_id`,`patient_identifier_type_id`),
  KEY `referenced_patient_identifier_type` (`patient_identifier_type_id`),
  CONSTRAINT `referenced_patient_identifier_type` FOREIGN KEY (`patient_identifier_type_id`) REFERENCES `patient_identifier_type` (`patient_identifier_type_id`),
  CONSTRAINT `referenced_program_patient_identifier_type_map` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `program_relationship_type_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_relationship_type_map` (
  `program_relationship_type_map_id` int NOT NULL AUTO_INCREMENT,
  `program_id` int DEFAULT NULL,
  `relationship_type_id` int DEFAULT NULL,
  PRIMARY KEY (`program_relationship_type_map_id`),
  KEY `program_mapping` (`program_id`,`relationship_type_id`),
  KEY `referenced_relationship_type` (`relationship_type_id`),
  CONSTRAINT `referenced_program_relationship_type_map` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`),
  CONSTRAINT `referenced_relationship_type` FOREIGN KEY (`relationship_type_id`) REFERENCES `relationship_type` (`relationship_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `program_workflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_workflow` (
  `program_workflow_id` int NOT NULL AUTO_INCREMENT,
  `program_id` int NOT NULL DEFAULT '0',
  `concept_id` int NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`program_workflow_id`),
  UNIQUE KEY `program_workflow_uuid_index` (`uuid`),
  KEY `workflow_changed_by` (`changed_by`),
  KEY `workflow_concept` (`concept_id`),
  KEY `workflow_creator` (`creator`),
  KEY `program_for_workflow` (`program_id`),
  CONSTRAINT `program_workflow_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`),
  CONSTRAINT `program_workflow_ibfk_2` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `program_workflow_ibfk_3` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `program_workflow_ibfk_4` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `program_workflow_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_workflow_state` (
  `program_workflow_state_id` int NOT NULL AUTO_INCREMENT,
  `program_workflow_id` int NOT NULL DEFAULT '0',
  `concept_id` int NOT NULL DEFAULT '0',
  `initial` tinyint(1) NOT NULL DEFAULT '0',
  `terminal` tinyint(1) NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`program_workflow_state_id`),
  UNIQUE KEY `program_workflow_state_uuid_index` (`uuid`),
  KEY `state_changed_by` (`changed_by`),
  KEY `state_concept` (`concept_id`),
  KEY `state_creator` (`creator`),
  KEY `workflow_for_state` (`program_workflow_id`),
  CONSTRAINT `program_workflow_state_ibfk_1` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `program_workflow_state_ibfk_2` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `program_workflow_state_ibfk_3` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `program_workflow_state_ibfk_4` FOREIGN KEY (`program_workflow_id`) REFERENCES `program_workflow` (`program_workflow_id`)
) ENGINE=InnoDB AUTO_INCREMENT=243 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `radiology_accession_number_counters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `radiology_accession_number_counters` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `value` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_radiology_accession_number_counters_on_date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `reason_for_art_eligibility_obs`;
/*!50001 DROP VIEW IF EXISTS `reason_for_art_eligibility_obs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `reason_for_art_eligibility_obs` AS SELECT 
 1 AS `person_id`,
 1 AS `concept_id`,
 1 AS `obs_datetime`,
 1 AS `name`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `reason_for_eligibility_obs`;
/*!50001 DROP VIEW IF EXISTS `reason_for_eligibility_obs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `reason_for_eligibility_obs` AS SELECT 
 1 AS `patient_id`,
 1 AS `reason_for_eligibility`,
 1 AS `obs_datetime`,
 1 AS `earliest_start_date`,
 1 AS `date_enrolled`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `record_sync_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `record_sync_statuses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `record_type_id` int NOT NULL,
  `record_id` int NOT NULL,
  `record_doc_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `database` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_record_type_id` (`record_type_id`),
  KEY `idx_record_id` (`record_id`),
  KEY `idx_database` (`database`),
  KEY `idx_database_record_type_id` (`record_type_id`,`record_id`,`database`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `record_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `record_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `regimen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regimen` (
  `regimen_id` int NOT NULL AUTO_INCREMENT,
  `concept_id` int NOT NULL DEFAULT '0',
  `regimen_index` varchar(5) DEFAULT NULL,
  `min_weight` float NOT NULL DEFAULT '0',
  `max_weight` float NOT NULL DEFAULT '200',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `retired` smallint NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `program_id` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`regimen_id`),
  KEY `map_concept` (`concept_id`),
  CONSTRAINT `map_concept` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=247 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `regimen_drug_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regimen_drug_order` (
  `regimen_drug_order_id` int NOT NULL AUTO_INCREMENT,
  `regimen_id` int NOT NULL DEFAULT '0',
  `drug_inventory_id` int DEFAULT '0',
  `dose` double DEFAULT NULL,
  `equivalent_daily_dose` double DEFAULT NULL,
  `units` varchar(255) DEFAULT NULL,
  `frequency` varchar(255) DEFAULT NULL,
  `prn` tinyint(1) NOT NULL DEFAULT '0',
  `complex` tinyint(1) NOT NULL DEFAULT '0',
  `quantity` int DEFAULT NULL,
  `instructions` text,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`regimen_drug_order_id`),
  UNIQUE KEY `regimen_drug_order_uuid_index` (`uuid`),
  KEY `regimen_drug_order_creator` (`creator`),
  KEY `user_who_voided_regimen_drug_order` (`voided_by`),
  KEY `map_regimen` (`regimen_id`),
  KEY `map_drug_inventory` (`drug_inventory_id`),
  CONSTRAINT `map_drug_inventory` FOREIGN KEY (`drug_inventory_id`) REFERENCES `drug` (`drug_id`),
  CONSTRAINT `map_regimen` FOREIGN KEY (`regimen_id`) REFERENCES `regimen` (`regimen_id`),
  CONSTRAINT `regimen_drug_order_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_voided_regimen_drug_order` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=426 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `regimen_observation`;
/*!50001 DROP VIEW IF EXISTS `regimen_observation`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `regimen_observation` AS SELECT 
 1 AS `obs_id`,
 1 AS `person_id`,
 1 AS `concept_id`,
 1 AS `encounter_id`,
 1 AS `order_id`,
 1 AS `obs_datetime`,
 1 AS `location_id`,
 1 AS `obs_group_id`,
 1 AS `accession_number`,
 1 AS `value_group_id`,
 1 AS `value_boolean`,
 1 AS `value_coded`,
 1 AS `value_coded_name_id`,
 1 AS `value_drug`,
 1 AS `value_datetime`,
 1 AS `value_numeric`,
 1 AS `value_modifier`,
 1 AS `value_text`,
 1 AS `date_started`,
 1 AS `date_stopped`,
 1 AS `comments`,
 1 AS `creator`,
 1 AS `date_created`,
 1 AS `voided`,
 1 AS `voided_by`,
 1 AS `date_voided`,
 1 AS `void_reason`,
 1 AS `value_complex`,
 1 AS `uuid`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `region` (
  `region_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`region_id`),
  KEY `user_who_created_region` (`creator`),
  KEY `user_who_retired_region` (`retired_by`),
  KEY `retired_status` (`retired`),
  CONSTRAINT `user_who_created_region` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_retired_region` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relationship` (
  `relationship_id` int NOT NULL AUTO_INCREMENT,
  `person_a` int NOT NULL,
  `relationship` int NOT NULL DEFAULT '0',
  `person_b` int NOT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`relationship_id`),
  UNIQUE KEY `relationship_uuid_index` (`uuid`),
  KEY `related_person` (`person_a`),
  KEY `related_relative` (`person_b`),
  KEY `relationship_type` (`relationship`),
  KEY `relation_creator` (`creator`),
  KEY `relation_voider` (`voided_by`),
  KEY `idx_relationship_a_type_b_voided` (`person_a`,`relationship`,`person_b`,`voided`),
  KEY `idx_relationship_b_type_a_voided` (`person_b`,`relationship`,`person_a`,`voided`),
  CONSTRAINT `person_a` FOREIGN KEY (`person_a`) REFERENCES `person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `person_b` FOREIGN KEY (`person_b`) REFERENCES `person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `relation_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `relation_voider` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `relationship_type_id` FOREIGN KEY (`relationship`) REFERENCES `relationship_type` (`relationship_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35544 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `relationship_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relationship_type` (
  `relationship_type_id` int NOT NULL AUTO_INCREMENT,
  `a_is_to_b` varchar(50) NOT NULL,
  `b_is_to_a` varchar(50) NOT NULL,
  `preferred` tinyint(1) NOT NULL DEFAULT '0',
  `weight` int NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`relationship_type_id`),
  UNIQUE KEY `relationship_type_uuid_index` (`uuid`),
  KEY `user_who_created_rel` (`creator`),
  KEY `user_who_retired_relationship_type` (`retired_by`),
  CONSTRAINT `relationship_type_ibfk_1` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `relationship_type_ibfk_2` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `report_def`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_def` (
  `report_def_id` int NOT NULL AUTO_INCREMENT,
  `name` mediumtext NOT NULL,
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `creator` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`report_def_id`),
  KEY `User who created report_def` (`creator`),
  CONSTRAINT `User who created report_def` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `report_object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_object` (
  `report_object_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `report_object_type` varchar(255) NOT NULL,
  `report_object_sub_type` varchar(255) NOT NULL,
  `xml_data` text,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `voided` smallint NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`report_object_id`),
  UNIQUE KEY `report_object_uuid_index` (`uuid`),
  KEY `report_object_creator` (`creator`),
  KEY `user_who_changed_report_object` (`changed_by`),
  KEY `user_who_voided_report_object` (`voided_by`),
  CONSTRAINT `report_object_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_changed_report_object` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_voided_report_object` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `report_schema_xml`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_schema_xml` (
  `report_schema_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `xml_data` mediumtext NOT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`report_schema_id`),
  UNIQUE KEY `report_schema_xml_uuid_index` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `reporting_report_design`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reporting_report_design` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uuid` char(38) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `report_definition_id` int NOT NULL DEFAULT '0',
  `renderer_type` varchar(255) NOT NULL,
  `properties` text,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `location_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `report_definition_id for reporting_report_design` (`report_definition_id`),
  KEY `creator for reporting_report_design` (`creator`),
  KEY `changed_by for reporting_report_design` (`changed_by`),
  KEY `retired_by for reporting_report_design` (`retired_by`),
  CONSTRAINT `changed_by for reporting_report_design` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `creator for reporting_report_design` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `report_definition_id for reporting_report_design` FOREIGN KEY (`report_definition_id`) REFERENCES `report_def` (`report_def_id`),
  CONSTRAINT `retired_by for reporting_report_design` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `reporting_report_design_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reporting_report_design_resource` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uuid` char(38) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `report_design_id` int NOT NULL DEFAULT '0',
  `content_type` varchar(50) DEFAULT NULL,
  `extension` varchar(20) DEFAULT NULL,
  `contents` longblob,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `indicator_name` varchar(255) DEFAULT NULL,
  `indicator_short_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `report_design_id for reporting_report_design_resource` (`report_design_id`),
  KEY `creator for reporting_report_design_resource` (`creator`),
  KEY `changed_by for reporting_report_design_resource` (`changed_by`),
  KEY `retired_by for reporting_report_design_resource` (`retired_by`),
  CONSTRAINT `changed_by for reporting_report_design_resource` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `creator for reporting_report_design_resource` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `report_design_id for reporting_report_design_resource` FOREIGN KEY (`report_design_id`) REFERENCES `reporting_report_design` (`id`),
  CONSTRAINT `retired_by for reporting_report_design_resource` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `role` varchar(50) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`role`),
  UNIQUE KEY `role_uuid_index` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `role_privilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_privilege` (
  `role` varchar(50) NOT NULL DEFAULT '',
  `privilege` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`privilege`,`role`),
  KEY `role_privilege` (`role`),
  CONSTRAINT `privilege_definitons` FOREIGN KEY (`privilege`) REFERENCES `privilege` (`privilege`),
  CONSTRAINT `role_privilege` FOREIGN KEY (`role`) REFERENCES `role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `role_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_role` (
  `parent_role` varchar(50) NOT NULL DEFAULT '',
  `child_role` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`parent_role`,`child_role`),
  KEY `inherited_role` (`child_role`),
  CONSTRAINT `inherited_role` FOREIGN KEY (`child_role`) REFERENCES `role` (`role`),
  CONSTRAINT `parent_role` FOREIGN KEY (`parent_role`) REFERENCES `role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `scheduler_task_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scheduler_task_config` (
  `task_config_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `schedulable_class` text,
  `start_time` datetime DEFAULT NULL,
  `start_time_pattern` varchar(50) DEFAULT NULL,
  `repeat_interval` int NOT NULL DEFAULT '0',
  `start_on_startup` int NOT NULL DEFAULT '0',
  `started` int NOT NULL DEFAULT '0',
  `created_by` int DEFAULT '0',
  `date_created` datetime DEFAULT '2005-01-01 00:00:00',
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  `last_execution_time` datetime DEFAULT NULL,
  PRIMARY KEY (`task_config_id`),
  UNIQUE KEY `scheduler_task_config_uuid_index` (`uuid`),
  KEY `schedule_creator` (`created_by`),
  KEY `schedule_changer` (`changed_by`),
  CONSTRAINT `scheduler_changer` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `scheduler_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `scheduler_task_config_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scheduler_task_config_property` (
  `task_config_property_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `value` text,
  `task_config_id` int DEFAULT NULL,
  PRIMARY KEY (`task_config_property_id`),
  KEY `task_config` (`task_config_id`),
  CONSTRAINT `task_config_for_property` FOREIGN KEY (`task_config_id`) REFERENCES `scheduler_task_config` (`task_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `schema_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schema_info` (
  `version` int DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `send_results_to_couchdbs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `send_results_to_couchdbs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `serialized_object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `serialized_object` (
  `serialized_object_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(5000) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `subtype` varchar(255) NOT NULL,
  `serialization_class` varchar(255) NOT NULL,
  `serialized_data` text NOT NULL,
  `date_created` datetime NOT NULL,
  `creator` int NOT NULL,
  `date_changed` datetime DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `retired` smallint NOT NULL DEFAULT '0',
  `date_retired` datetime DEFAULT NULL,
  `retired_by` int DEFAULT NULL,
  `retire_reason` varchar(1000) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`serialized_object_id`),
  UNIQUE KEY `serialized_object_uuid_index` (`uuid`),
  KEY `serialized_object_creator` (`creator`),
  KEY `serialized_object_changed_by` (`changed_by`),
  KEY `serialized_object_retired_by` (`retired_by`),
  CONSTRAINT `serialized_object_changed_by` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `serialized_object_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `serialized_object_retired_by` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `session_schedule_assignees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_schedule_assignees` (
  `schedule_assignee_id` int NOT NULL AUTO_INCREMENT,
  `session_schedule_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `voided` tinyint DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`schedule_assignee_id`),
  KEY `fk_rails_1ee3ac6033` (`user_id`),
  KEY `fk_rails_24bab59c57` (`session_schedule_id`),
  CONSTRAINT `fk_rails_1ee3ac6033` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_24bab59c57` FOREIGN KEY (`session_schedule_id`) REFERENCES `session_schedules` (`session_schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `session_schedule_vaccines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_schedule_vaccines` (
  `schedule_vaccine_id` int NOT NULL AUTO_INCREMENT,
  `session_schedule_id` int DEFAULT NULL,
  `drug_id` int DEFAULT NULL,
  `voided` tinyint DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`schedule_vaccine_id`),
  KEY `fk_rails_376ef33ef5` (`drug_id`),
  KEY `fk_rails_ae93f1e553` (`session_schedule_id`),
  CONSTRAINT `fk_rails_376ef33ef5` FOREIGN KEY (`drug_id`) REFERENCES `drug` (`drug_id`),
  CONSTRAINT `fk_rails_ae93f1e553` FOREIGN KEY (`session_schedule_id`) REFERENCES `session_schedules` (`session_schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `session_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_schedules` (
  `session_schedule_id` int NOT NULL AUTO_INCREMENT,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `session_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `repeat_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `voided` tinyint(1) DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime(6) DEFAULT NULL,
  `void_reason` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `session_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `location_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `frequency` int DEFAULT '0',
  PRIMARY KEY (`session_schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) DEFAULT NULL,
  `data` text,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_session_id_index` (`session_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18078 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `visit_id` int NOT NULL,
  `patient_id` int NOT NULL,
  `location_id` int DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  `stage` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `arrival_time` datetime(6) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `disposition_type` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `triage_result` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `visit_number` int DEFAULT NULL,
  `patient_care_area` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `department` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `destination` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `referring_program_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rails_d319d1fd4f` (`visit_id`),
  KEY `fk_rails_83d1394bef` (`patient_id`),
  KEY `fk_rails_dc31c6ac70` (`location_id`),
  KEY `index_stages_on_status` (`status`),
  KEY `index_stages_on_stage` (`stage`),
  KEY `index_stages_on_visit_number` (`visit_number`),
  CONSTRAINT `fk_rails_83d1394bef` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`),
  CONSTRAINT `fk_rails_d319d1fd4f` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`),
  CONSTRAINT `fk_rails_dc31c6ac70` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `start_date_observation`;
/*!50001 DROP VIEW IF EXISTS `start_date_observation`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `start_date_observation` AS SELECT 
 1 AS `person_id`,
 1 AS `obs_datetime`,
 1 AS `value_datetime`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task` (
  `task_id` int NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL,
  `encounter_type` varchar(255) DEFAULT NULL,
  `description` text,
  `location` varchar(255) DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `has_obs_concept_id` int DEFAULT NULL,
  `has_obs_value_coded` int DEFAULT NULL,
  `has_obs_value_drug` int DEFAULT NULL,
  `has_obs_value_datetime` datetime DEFAULT NULL,
  `has_obs_value_numeric` double DEFAULT NULL,
  `has_obs_value_text` text,
  `has_obs_scope` text,
  `has_program_id` int DEFAULT NULL,
  `has_program_workflow_state_id` int DEFAULT NULL,
  `has_identifier_type_id` int DEFAULT NULL,
  `has_relationship_type_id` int DEFAULT NULL,
  `has_order_type_id` int DEFAULT NULL,
  `has_encounter_type_today` varchar(255) DEFAULT NULL,
  `skip_if_has` smallint DEFAULT '0',
  `sort_weight` double DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL,
  `voided` smallint DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `uuid` char(38) DEFAULT NULL,
  PRIMARY KEY (`task_id`),
  KEY `task_creator` (`creator`),
  KEY `user_who_voided_task` (`voided_by`),
  KEY `user_who_changed_task` (`changed_by`),
  CONSTRAINT `task_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_changed_task` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_voided_task` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tb_status_observations`;
/*!50001 DROP VIEW IF EXISTS `tb_status_observations`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `tb_status_observations` AS SELECT 
 1 AS `obs_id`,
 1 AS `person_id`,
 1 AS `concept_id`,
 1 AS `encounter_id`,
 1 AS `order_id`,
 1 AS `obs_datetime`,
 1 AS `location_id`,
 1 AS `obs_group_id`,
 1 AS `accession_number`,
 1 AS `value_group_id`,
 1 AS `value_boolean`,
 1 AS `value_coded`,
 1 AS `value_coded_name_id`,
 1 AS `value_drug`,
 1 AS `value_datetime`,
 1 AS `value_numeric`,
 1 AS `value_modifier`,
 1 AS `value_text`,
 1 AS `date_started`,
 1 AS `date_stopped`,
 1 AS `comments`,
 1 AS `creator`,
 1 AS `date_created`,
 1 AS `voided`,
 1 AS `voided_by`,
 1 AS `date_voided`,
 1 AS `void_reason`,
 1 AS `value_complex`,
 1 AS `uuid`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `temp_art_start_date_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_art_start_date_loc_1` (
  `patient_id` int NOT NULL,
  `value_datetime` date NOT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `tasd_date_loc_1` (`value_datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_cohort_members_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_cohort_members_loc_1` (
  `patient_id` int NOT NULL,
  `date_enrolled` date DEFAULT NULL,
  `earliest_start_date` date DEFAULT NULL,
  `recorded_start_date` date DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `birthdate_estimated` tinyint(1) DEFAULT NULL,
  `death_date` date DEFAULT NULL,
  `gender` varchar(32) DEFAULT NULL,
  `age_at_initiation` int DEFAULT NULL,
  `age_in_days` int DEFAULT NULL,
  `reason_for_starting_art` int DEFAULT NULL,
  `occupation` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `member_id_index_loc_1` (`patient_id`),
  KEY `member_enrolled_index_loc_1` (`date_enrolled`),
  KEY `member_date_enrolled_index_loc_1` (`patient_id`,`date_enrolled`),
  KEY `member_start_date_index_loc_1` (`earliest_start_date`),
  KEY `member_start_date__date_enrolled_index_loc_1` (`patient_id`,`earliest_start_date`,`date_enrolled`,`gender`),
  KEY `member_reason_loc_1` (`reason_for_starting_art`),
  KEY `member_birthdate_idx_loc_1` (`birthdate`),
  KEY `member_occupation_idx_loc_1` (`birthdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_current_medication_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_current_medication_loc_1` (
  `patient_id` int NOT NULL,
  `concept_id` int NOT NULL,
  `drug_id` int NOT NULL,
  `daily_dose` decimal(32,2) NOT NULL,
  `quantity` decimal(32,2) NOT NULL,
  `start_date` date NOT NULL,
  `pill_count` decimal(32,2) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `pepfar_defaulter_date` date DEFAULT NULL,
  `moh_defaulter_date` date DEFAULT NULL,
  PRIMARY KEY (`patient_id`,`drug_id`),
  KEY `idx_cm_concept_loc_1` (`concept_id`),
  KEY `idx_cm_drug_loc_1` (`drug_id`),
  KEY `idx_cm_date_loc_1` (`start_date`),
  KEY `idx_cm_pepfar_loc_1` (`pepfar_defaulter_date`),
  KEY `idx_cm_moh_loc_1` (`moh_defaulter_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_current_medication_start_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_current_medication_start_loc_1` (
  `patient_id` int NOT NULL,
  `concept_id` int NOT NULL,
  `drug_id` int NOT NULL,
  `daily_dose` decimal(32,2) NOT NULL,
  `quantity` decimal(32,2) NOT NULL,
  `start_date` date NOT NULL,
  `pill_count` decimal(32,2) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `pepfar_defaulter_date` date DEFAULT NULL,
  `moh_defaulter_date` date DEFAULT NULL,
  PRIMARY KEY (`patient_id`,`drug_id`),
  KEY `idx_cm_concept_start_loc_1` (`concept_id`),
  KEY `idx_cm_drug_start_loc_1` (`drug_id`),
  KEY `idx_cm_date_start_loc_1` (`start_date`),
  KEY `idx_cm_pepfar_start_loc_1` (`pepfar_defaulter_date`),
  KEY `idx_cm_moh_start_loc_1` (`moh_defaulter_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_current_state_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_current_state_loc_1` (
  `patient_id` int NOT NULL,
  `cum_outcome` varchar(120) COLLATE utf8mb3_unicode_ci NOT NULL,
  `outcome_date` date DEFAULT NULL,
  `state` int NOT NULL,
  `outcomes` int NOT NULL,
  `patient_state_id` int NOT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `idx_state_name_loc_1` (`cum_outcome`),
  KEY `idx_state_id_loc_1` (`state`),
  KEY `idx_state_count_loc_1` (`outcomes`),
  KEY `idx_patient_state_id_loc_1` (`patient_state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_current_state_start_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_current_state_start_loc_1` (
  `patient_id` int NOT NULL,
  `cum_outcome` varchar(120) COLLATE utf8mb3_unicode_ci NOT NULL,
  `outcome_date` date DEFAULT NULL,
  `state` int NOT NULL,
  `outcomes` int NOT NULL,
  `patient_state_id` int NOT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `idx_state_name_start_loc_1` (`cum_outcome`),
  KEY `idx_state_id_start_loc_1` (`state`),
  KEY `idx_state_count_start_loc_1` (`outcomes`),
  KEY `idx_patient_state_id_start_loc_1` (`patient_state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_earliest_start_date_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_earliest_start_date_loc_1` (
  `patient_id` int NOT NULL,
  `date_enrolled` date DEFAULT NULL,
  `earliest_start_date` date DEFAULT NULL,
  `recorded_start_date` date DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `birthdate_estimated` tinyint(1) DEFAULT NULL,
  `death_date` date DEFAULT NULL,
  `gender` varchar(32) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `age_at_initiation` int DEFAULT NULL,
  `age_in_days` int DEFAULT NULL,
  `reason_for_starting_art` int DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `patient_id_index_loc_1` (`patient_id`),
  KEY `date_enrolled_index_loc_1` (`date_enrolled`),
  KEY `patient_id__date_enrolled_index_loc_1` (`patient_id`,`date_enrolled`),
  KEY `earliest_start_date_index_loc_1` (`earliest_start_date`),
  KEY `earliest_start_date__date_enrolled_index_loc_1` (`patient_id`,`earliest_start_date`,`date_enrolled`,`gender`),
  KEY `idx_reason_for_art_loc_1` (`reason_for_starting_art`),
  KEY `birthdate_idx_loc_1` (`birthdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_latest_tb_status_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_latest_tb_status_loc_1` (
  `person_id` int NOT NULL,
  `obs_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_maternal_status_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_maternal_status_loc_1` (
  `patient_id` int NOT NULL,
  `maternal_status` varchar(5) COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `idx_maternal_status_loc_1` (`patient_id`,`maternal_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_max_drug_orders_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_max_drug_orders_loc_1` (
  `patient_id` int NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `min_order_date` datetime DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `idx_max_orders_loc_1` (`start_date`),
  KEY `idx_max_min_orders_loc_1` (`min_order_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_max_drug_orders_start_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_max_drug_orders_start_loc_1` (
  `patient_id` int NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `min_order_date` datetime DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `idx_max_orders_start_loc_1` (`start_date`),
  KEY `idx_max_min_orders_start_loc_1` (`min_order_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_max_patient_state_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_max_patient_state_loc_1` (
  `patient_id` int NOT NULL,
  `start_date` varchar(15) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `idx_max_patient_state_loc_1` (`start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_max_patient_state_start_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_max_patient_state_start_loc_1` (
  `patient_id` int NOT NULL,
  `start_date` varchar(15) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `idx_max_patient_state_start_loc_1` (`start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_min_auto_expire_date_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_min_auto_expire_date_loc_1` (
  `patient_id` int NOT NULL,
  `start_date` date DEFAULT NULL,
  `auto_expire_date` date DEFAULT NULL,
  `pepfar_defaulter_date` date DEFAULT NULL,
  `moh_defaulter_date` date DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `idx_min_auto_expire_date_loc_1` (`auto_expire_date`),
  KEY `idx_min_pepfar_loc_1` (`pepfar_defaulter_date`),
  KEY `idx_min_moh_loc_1` (`moh_defaulter_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_min_auto_expire_date_start_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_min_auto_expire_date_start_loc_1` (
  `patient_id` int NOT NULL,
  `start_date` date DEFAULT NULL,
  `auto_expire_date` date DEFAULT NULL,
  `pepfar_defaulter_date` date DEFAULT NULL,
  `moh_defaulter_date` date DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `idx_min_auto_expire_date_start_loc_1` (`auto_expire_date`),
  KEY `idx_min_pepfar_start_loc_1` (`pepfar_defaulter_date`),
  KEY `idx_min_moh_start_loc_1` (`moh_defaulter_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_order_details_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_order_details_loc_1` (
  `patient_id` int NOT NULL,
  `start_date` date NOT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `tod_date_loc_1` (`start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_other_patient_types_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_other_patient_types_loc_1` (
  `patient_id` int NOT NULL,
  PRIMARY KEY (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_patient_outcomes_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_patient_outcomes_loc_1` (
  `patient_id` int NOT NULL,
  `moh_cum_outcome` varchar(120) COLLATE utf8mb3_unicode_ci NOT NULL,
  `moh_outcome_date` date DEFAULT NULL,
  `pepfar_cum_outcome` varchar(120) COLLATE utf8mb3_unicode_ci NOT NULL,
  `pepfar_outcome_date` date DEFAULT NULL,
  `step` int DEFAULT '0',
  PRIMARY KEY (`patient_id`),
  KEY `moh_outcome_loc_1` (`moh_cum_outcome`),
  KEY `moh_out_date_loc_1` (`moh_outcome_date`),
  KEY `pepfar_outcome_loc_1` (`pepfar_cum_outcome`),
  KEY `pepfar_out_date_loc_1` (`pepfar_outcome_date`),
  KEY `idx_out_step_loc_1` (`step`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_patient_outcomes_start_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_patient_outcomes_start_loc_1` (
  `patient_id` int NOT NULL,
  `moh_cum_outcome` varchar(120) COLLATE utf8mb3_unicode_ci NOT NULL,
  `moh_outcome_date` date DEFAULT NULL,
  `pepfar_cum_outcome` varchar(120) COLLATE utf8mb3_unicode_ci NOT NULL,
  `pepfar_outcome_date` date DEFAULT NULL,
  `step` int DEFAULT '0',
  PRIMARY KEY (`patient_id`),
  KEY `moh_outcome_start_loc_1` (`moh_cum_outcome`),
  KEY `moh_out_date_start_loc_1` (`moh_outcome_date`),
  KEY `pepfar_outcome_start_loc_1` (`pepfar_cum_outcome`),
  KEY `pepfar_out_date_start_loc_1` (`pepfar_outcome_date`),
  KEY `idx_out_step_start_loc_1` (`step`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_patient_side_effects_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_patient_side_effects_loc_1` (
  `patient_id` int NOT NULL,
  `has_se` varchar(120) COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `idx_side_effects_loc_1` (`patient_id`,`has_se`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_patient_tb_status_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_patient_tb_status_loc_1` (
  `patient_id` int NOT NULL,
  `tb_status` int DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `patient_id_index_loc_1` (`patient_id`),
  KEY `tb_status_index_loc_1` (`tb_status`),
  KEY `patient_id_tb_status_index_loc_1` (`patient_id`,`tb_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_pregnant_obs_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_pregnant_obs_loc_1` (
  `person_id` int NOT NULL,
  `value_coded` int DEFAULT NULL,
  `obs_datetime` date DEFAULT NULL,
  PRIMARY KEY (`person_id`),
  KEY `fre_obs_time_loc_1` (`obs_datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `temp_register_start_date_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_register_start_date_loc_1` (
  `patient_id` int NOT NULL,
  `start_date` date NOT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `trsd_date_loc_1` (`start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tmp_first_registration_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tmp_first_registration_loc_1` (
  `patient_id` int NOT NULL,
  `encounter_id` int NOT NULL,
  PRIMARY KEY (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tmp_max_adherence_loc_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tmp_max_adherence_loc_1` (
  `person_id` int NOT NULL,
  `visit_date` date DEFAULT NULL,
  PRIMARY KEY (`person_id`),
  KEY `tma_date_loc_1` (`visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `traditional_authorities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `traditional_authorities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `traditional_authority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `traditional_authority` (
  `traditional_authority_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `district_id` int NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`traditional_authority_id`),
  KEY `district_for_ta` (`district_id`),
  KEY `user_who_created_traditional_authority` (`creator`),
  KEY `user_who_retired_traditional_authority` (`retired_by`),
  KEY `retired_status` (`retired`),
  CONSTRAINT `user_who_created_traditional_authority` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_retired_traditional_authority` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=519 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tribe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tribe` (
  `tribe_id` int NOT NULL AUTO_INCREMENT,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`tribe_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_programs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `program_id` bigint DEFAULT NULL,
  `voided` int DEFAULT '0',
  `void_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_programs_on_user_id` (`user_id`),
  KEY `index_user_programs_on_program_id` (`program_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_property` (
  `user_id` int NOT NULL DEFAULT '0',
  `property` varchar(100) NOT NULL DEFAULT '',
  `property_value` text,
  PRIMARY KEY (`user_id`,`property`),
  CONSTRAINT `user_property` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role` (
  `user_id` int NOT NULL DEFAULT '0',
  `role` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`role`,`user_id`),
  KEY `user_role` (`user_id`),
  CONSTRAINT `role_definitions` FOREIGN KEY (`role`) REFERENCES `role` (`role`),
  CONSTRAINT `user_role` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_villages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_villages` (
  `user_village_id` bigint NOT NULL AUTO_INCREMENT,
  `village_id` int NOT NULL,
  `user_id` int NOT NULL,
  `creator` int NOT NULL,
  `retired` int DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`user_village_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `system_id` varchar(50) NOT NULL DEFAULT '',
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `salt` varchar(128) DEFAULT NULL,
  `secret_question` varchar(255) DEFAULT NULL,
  `secret_answer` varchar(255) DEFAULT NULL,
  `creator` int NOT NULL DEFAULT '0',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `person_id` int DEFAULT NULL,
  `retired` tinyint NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  `authentication_token` varchar(255) DEFAULT NULL,
  `token_expiry_time` datetime DEFAULT NULL,
  `deactivated_on` datetime DEFAULT NULL,
  `location_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `user_creator` (`creator`),
  KEY `user_who_changed_user` (`changed_by`),
  KEY `person_id_for_user` (`person_id`),
  KEY `user_who_retired_this_user` (`retired_by`),
  KEY `fk_rails_5d96f79c2b` (`location_id`),
  KEY `idx_users_username` (`username`),
  KEY `idx_users_auth_token_expiry` (`authentication_token`,`token_expiry_time`),
  CONSTRAINT `fk_rails_fa67535741` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`),
  CONSTRAINT `person_id_for_user` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`),
  CONSTRAINT `user_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_changed_user` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_retired_this_user` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `uuid_remaps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uuid_remaps` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `old_uuid` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `new_uuid` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `database` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `model` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `record_id` int DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_uuid_remaps_on_old_uuid` (`old_uuid`),
  KEY `index_uuid_remaps_on_new_uuid` (`new_uuid`),
  KEY `index_uuid_remaps_on_database` (`database`),
  KEY `index_uuid_remaps_on_model` (`model`),
  KEY `index_all_fields` (`old_uuid`,`new_uuid`,`database`,`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `validation_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `validation_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rule_id` int DEFAULT NULL,
  `failures` int DEFAULT NULL,
  `date_checked` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `validation_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `validation_rules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `expr` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `desc` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `type_id` int DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `village`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `village` (
  `village_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `traditional_authority_id` int NOT NULL DEFAULT '0',
  `creator` int NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`village_id`),
  KEY `ta_for_village` (`traditional_authority_id`),
  KEY `user_who_created_village` (`creator`),
  KEY `user_who_retired_village` (`retired_by`),
  KEY `retired_status` (`retired`),
  CONSTRAINT `user_who_created_village` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_retired_village` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33750 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `villages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `villages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visit` (
  `visit_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `visit_type_id` int NOT NULL,
  `indication_concept_id` int DEFAULT NULL,
  `location_id` int DEFAULT NULL,
  `date_started` datetime(6) NOT NULL,
  `date_stopped` datetime(6) DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` int DEFAULT NULL,
  `date_voided` datetime(6) DEFAULT NULL,
  `void_reason` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime(6) DEFAULT NULL,
  `uuid` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `program_id` int DEFAULT NULL,
  PRIMARY KEY (`visit_id`),
  KEY `fk_rails_a1f67b7ff2` (`creator`),
  KEY `fk_rails_a496173fc2` (`changed_by`),
  KEY `fk_rails_011dd6de27` (`voided_by`),
  KEY `fk_rails_c95796b732` (`visit_type_id`),
  KEY `fk_rails_8b0be4a56e` (`indication_concept_id`),
  KEY `index_visit_on_date_started` (`date_started`),
  KEY `index_visit_on_date_stopped` (`date_stopped`),
  KEY `index_visit_on_location_id_and_date_started` (`location_id`,`date_started`),
  KEY `index_visit_on_location_id_and_date_stopped` (`location_id`,`date_stopped`),
  KEY `index_visit_on_patient_id_and_date_stopped` (`patient_id`,`date_stopped`),
  KEY `idx_visit_program` (`program_id`),
  CONSTRAINT `fk_rails_011dd6de27` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_3bfd15f321` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `fk_rails_8b0be4a56e` FOREIGN KEY (`indication_concept_id`) REFERENCES `concept` (`concept_id`),
  CONSTRAINT `fk_rails_a1f67b7ff2` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_a496173fc2` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_rails_c95796b732` FOREIGN KEY (`visit_type_id`) REFERENCES `visit_type` (`visit_type_id`),
  CONSTRAINT `fk_rails_eb98da7293` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `visit_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visit_type` (
  `visit_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `creator` int NOT NULL,
  `date_created` datetime NOT NULL,
  `changed_by` int DEFAULT NULL,
  `date_changed` datetime DEFAULT NULL,
  `retired` tinyint(1) NOT NULL DEFAULT '0',
  `retired_by` int DEFAULT NULL,
  `date_retired` datetime DEFAULT NULL,
  `retire_reason` varchar(255) DEFAULT NULL,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY (`visit_type_id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `visit_type_creator` (`creator`),
  KEY `visit_type_changed_by` (`changed_by`),
  KEY `visit_type_retired_by` (`retired_by`),
  CONSTRAINT `visit_type_ibfk_1` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `visit_type_ibfk_2` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `visit_type_ibfk_3` FOREIGN KEY (`retired_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visits` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `patientId` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `startDate` datetime(6) DEFAULT NULL,
  `closedDateTime` datetime(6) DEFAULT NULL,
  `programId` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `location_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `weight_for_height`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weight_for_height` (
  `supinecm` double DEFAULT NULL,
  `medianwtht` double DEFAULT NULL,
  `sdlowwtht` double DEFAULT NULL,
  `sdhighwtht` double DEFAULT NULL,
  `sex` smallint DEFAULT NULL,
  `heightsex` char(5) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `weight_for_heights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weight_for_heights` (
  `id` int NOT NULL AUTO_INCREMENT,
  `supine_cm` float DEFAULT NULL,
  `median_weight_height` float DEFAULT NULL,
  `standard_low_weight_height` float DEFAULT NULL,
  `standard_high_weight_height` float DEFAULT NULL,
  `sex` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=509 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `weight_height_for_age`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weight_height_for_age` (
  `agemths` smallint DEFAULT NULL,
  `sex` smallint DEFAULT NULL,
  `medianht` double DEFAULT NULL,
  `sdlowht` double DEFAULT NULL,
  `sdhighht` double DEFAULT NULL,
  `medianwt` double DEFAULT NULL,
  `sdlowwt` double DEFAULT NULL,
  `sdhighwt` double DEFAULT NULL,
  `agesex` char(4) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `weight_height_for_ages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weight_height_for_ages` (
  `age_in_months` smallint DEFAULT NULL,
  `sex` char(12) DEFAULT NULL,
  `median_height` double DEFAULT NULL,
  `standard_low_height` double DEFAULT NULL,
  `standard_high_height` double DEFAULT NULL,
  `median_weight` double DEFAULT NULL,
  `standard_low_weight` double DEFAULT NULL,
  `standard_high_weight` double DEFAULT NULL,
  `age_sex` char(4) DEFAULT NULL,
  KEY `index_weight_height_for_ages_on_age_in_months` (`age_in_months`),
  KEY `index_weight_height_for_ages_on_sex` (`sex`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 DROP FUNCTION IF EXISTS `age` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `age`(birthdate varchar(10),visit_date varchar(10),date_created varchar(10),est int) RETURNS int
    DETERMINISTIC
BEGIN
DECLARE year_when_patient_created INT;
DECLARE cul_age INT;

DECLARE birth_year INT;
DECLARE birth_month INT;
DECLARE birth_day INT;

DECLARE cur_year INT;
DECLARE cur_month INT;
DECLARE cur_day INT;


DECLARE visit_year INT;
DECLARE visit_month INT;
DECLARE visit_day INT;

DECLARE cul_year INT;
DECLARE cul_month INT;
DECLARE cul_day INT;

SET year_when_patient_created = (SELECT YEAR(FROM_DAYS(TO_DAYS(date_created))));

set birth_year = (SELECT YEAR(FROM_DAYS(TO_DAYS(birthdate))));
set birth_month = (SELECT MONTH(FROM_DAYS(TO_DAYS(birthdate))));
set birth_day = (SELECT DAY(FROM_DAYS(TO_DAYS(birthdate))));

set cur_year = (SELECT YEAR(CURDATE()));
set cur_month = (SELECT MONTH(CURDATE()));
set cur_day = (SELECT DAY(CURDATE()));

set visit_year = (SELECT YEAR(FROM_DAYS(TO_DAYS(visit_date))));
set visit_month = (SELECT MONTH(FROM_DAYS(TO_DAYS(visit_date))));
set visit_day = (SELECT DAY(FROM_DAYS(TO_DAYS(visit_date))));

SET cul_year 	= (visit_year - birth_year);
SET cul_month = (visit_month - birth_month);
SET cul_day 	=	(visit_day - birth_day);


IF ((cul_day < 0) = 1) THEN SET cul_day = -1;
ELSEIF ((cul_day < 0) = 0) THEN SET cul_day = 0;
END IF;

SET cul_month = (cul_month + cul_day);

IF ((cul_month < 0) = 1) THEN SET cul_month = -1;
ELSEIF ((cul_month < 0) = 0) THEN SET cul_month = 0;
END IF;

SET cul_age = (cul_year + cul_month);
SET cul_age = ( (cul_age + (est + birth_month = 7 + birth_day = 1 + visit_month < birth_month + year_when_patient_created = visit_year))  );

RETURN cul_age;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `age_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `age_group`(birthdate varchar(10),visit_date varchar(10),date_created varchar(10),est int) RETURNS varchar(25) CHARSET latin1
    DETERMINISTIC
BEGIN
DECLARE avg VARCHAR(25);
DECLARE mths INT;
DECLARE n INT;

set avg="none";
set n =  (SELECT age(birthdate,visit_date,date_created,est));
set mths = (SELECT extract(MONTH FROM DATE(visit_date))-extract(MONTH FROM DATE(birthdate)));

if n >= 1 AND n < 5 then set avg="1 to < 5";
elseif n >= 5 AND n <= 14 then set avg="5 to 14";
elseif n > 14 AND n < 20 then set avg="> 14 to < 20";
elseif n >= 20 AND n < 30 then set avg="20 to < 30";
elseif n >= 30 AND n < 40 then set avg="30 to < 40";
elseif n >= 40 AND n < 50 then set avg="40 to < 50";
elseif n >= 50 then set avg="50 and above";
end if;

if mths >= 0 AND mths < 6 and avg="none" then set avg="< 6 months";
elseif mths >= 6 AND n < 12 and avg="none"then set avg="6 months to < 1 yr";
end if;

RETURN avg;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `anc_age_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `anc_age_group`(birthdate date, end_date date) RETURNS varchar(15) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN

DECLARE age_in_years INT(11);
DECLARE age_group VARCHAR(15);

SET age_in_years  = (SELECT timestampdiff(year, birthdate, end_date));
SET age_group = ('Unknown');

IF age_in_years >= 0 AND age_in_years < 10 THEN SET age_group = "<10 years";
ELSEIF age_in_years >= 10 AND age_in_years <= 14 THEN SET age_group = "10-14 years";
ELSEIF age_in_years >= 15 AND age_in_years <= 19 THEN SET age_group = "15-19 years";
ELSEIF age_in_years >= 20 AND age_in_years <= 24 THEN SET age_group = "20-24 years";
ELSEIF age_in_years >= 25 AND age_in_years <= 29 THEN SET age_group = "25-29 years";
ELSEIF age_in_years >= 30 AND age_in_years <= 34 THEN SET age_group = "30-34 years";
ELSEIF age_in_years >= 35 AND age_in_years <= 39 THEN SET age_group = "35-39 years";
ELSEIF age_in_years >= 40 AND age_in_years <= 44 THEN SET age_group = "40-44 years";
ELSEIF age_in_years >= 45 AND age_in_years <= 49 THEN SET age_group = "45-49 years";
ELSEIF age_in_years >= 50 AND age_in_years <= 54 THEN SET age_group = "50-54 years";
ELSEIF age_in_years >= 55 AND age_in_years <= 59 THEN SET age_group = "55-59 years";
ELSEIF age_in_years >= 60 AND age_in_years <= 64 THEN SET age_group = "60-64 years";
ELSEIF age_in_years >= 65 AND age_in_years <= 69 THEN SET age_group = "65-69 years";
ELSEIF age_in_years >= 70 AND age_in_years <= 74 THEN SET age_group = "70-74 years";
ELSEIF age_in_years >= 75 AND age_in_years <= 79 THEN SET age_group = "75-79 years";
ELSEIF age_in_years >= 80 AND age_in_years <= 84 THEN SET age_group = "80-84 years";
ELSEIF age_in_years >= 85 AND age_in_years <= 89 THEN SET age_group = "85-89 years";
ELSEIF age_in_years >= 90 THEN SET age_group = "90 plus years";
END IF;

RETURN age_group;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cohort_disaggregated_age_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `cohort_disaggregated_age_group`(birthdate date, end_date date) RETURNS varchar(15) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN

DECLARE age_in_months INT(11);
DECLARE age_in_years INT(11);
DECLARE age_group VARCHAR(15);

SET age_in_months = (SELECT timestampdiff(month, birthdate, end_date));
SET age_in_years  = (SELECT timestampdiff(year, birthdate, end_date));
SET age_group = ('Unknown');

IF age_in_months >= 0 AND age_in_months <= 5 THEN SET age_group = "0-5 months";
ELSEIF age_in_months > 5 AND age_in_months <= 11 THEN SET age_group = "6-11 months";
ELSEIF age_in_months > 11 AND age_in_months <= 23 THEN SET age_group = "12-23 months";
ELSEIF age_in_years >= 2 AND age_in_years <= 4 THEN SET age_group = "2-4 years";
ELSEIF age_in_years >= 5 AND age_in_years <= 9 THEN SET age_group = "5-9 years";
ELSEIF age_in_years >= 10 AND age_in_years <= 14 THEN SET age_group = "10-14 years";
ELSEIF age_in_years >= 15 AND age_in_years <= 17 THEN SET age_group = "15-17 years";
ELSEIF age_in_years >= 18 AND age_in_years <= 19 THEN SET age_group = "18-19 years";
ELSEIF age_in_years >= 20 AND age_in_years <= 24 THEN SET age_group = "20-24 years";
ELSEIF age_in_years >= 25 AND age_in_years <= 29 THEN SET age_group = "25-29 years";
ELSEIF age_in_years >= 30 AND age_in_years <= 34 THEN SET age_group = "30-34 years";
ELSEIF age_in_years >= 35 AND age_in_years <= 39 THEN SET age_group = "35-39 years";
ELSEIF age_in_years >= 40 AND age_in_years <= 44 THEN SET age_group = "40-44 years";
ELSEIF age_in_years >= 45 AND age_in_years <= 49 THEN SET age_group = "45-49 years";
ELSEIF age_in_years >= 50 THEN SET age_group = "50 plus years";
END IF;

RETURN age_group;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `current_defaulter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `current_defaulter`(my_patient_id INT, my_end_date DATETIME) RETURNS int
    DETERMINISTIC
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE my_start_date, my_expiry_date, my_obs_datetime DATETIME;
  DECLARE my_daily_dose, my_quantity, my_pill_count, my_total_text, my_total_numeric DECIMAL(6, 2);
  DECLARE my_drug_id, flag INT;

  DECLARE cur1 CURSOR FOR SELECT d.drug_inventory_id, o.start_date, d.equivalent_daily_dose daily_dose, SUM(d.quantity), o.start_date FROM drug_order d
    INNER JOIN arv_drug ad ON d.drug_inventory_id = ad.drug_id
    INNER JOIN orders o ON d.order_id = o.order_id
      AND d.quantity > 0
      AND o.voided = 0
      AND o.start_date <= my_end_date
      AND o.patient_id = my_patient_id
      GROUP BY drug_inventory_id, DATE(start_date), daily_dose;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  SELECT MAX(o.start_date) INTO @obs_datetime FROM drug_order d
    INNER JOIN arv_drug ad ON d.drug_inventory_id = ad.drug_id
    INNER JOIN orders o ON d.order_id = o.order_id
      AND d.quantity > 0
      AND o.voided = 0
      AND o.start_date <= my_end_date
      AND o.patient_id = my_patient_id
    GROUP BY o.patient_id;

  OPEN cur1;

  SET flag = 0;

  read_loop: LOOP
    FETCH cur1 INTO my_drug_id, my_start_date, my_daily_dose, my_quantity, my_obs_datetime;

    IF done THEN
      CLOSE cur1;
      LEAVE read_loop;
    END IF;

    IF DATE(my_obs_datetime) = DATE(@obs_datetime) THEN

      IF my_daily_dose = 0 OR LENGTH(my_daily_dose) < 1 OR my_daily_dose IS NULL THEN
        SET my_daily_dose = 1;
      END IF;

            SET my_pill_count = drug_pill_count(my_patient_id, my_drug_id, my_obs_datetime);

            SET @expiry_date = ADDDATE(DATE_SUB(my_start_date, INTERVAL 1 DAY), ((my_quantity + my_pill_count)/my_daily_dose));

      IF my_expiry_date IS NULL THEN
        SET my_expiry_date = @expiry_date;
      END IF;

      IF @expiry_date < my_expiry_date THEN
        SET my_expiry_date = @expiry_date;
            END IF;
        END IF;
    END LOOP;

    IF TIMESTAMPDIFF(day, my_expiry_date, my_end_date) >= 60 THEN
        SET flag = 1;
    END IF;

  RETURN flag;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `current_defaulter_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `current_defaulter_date`(my_patient_id INT, my_end_date date) RETURNS varchar(25) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE my_start_date, my_expiry_date, my_obs_datetime DATETIME;
  DECLARE my_daily_dose, my_quantity, my_pill_count, my_total_text, my_total_numeric DECIMAL(6, 2);
  DECLARE my_drug_id INT;
  DECLARE my_default_date DATE;

  DECLARE cur1 CURSOR FOR SELECT d.drug_inventory_id, o.start_date, d.equivalent_daily_dose daily_dose, SUM(d.quantity), o.start_date FROM drug_order d
    INNER JOIN arv_drug ad ON d.drug_inventory_id = ad.drug_id
    INNER JOIN orders o ON d.order_id = o.order_id
      AND d.quantity > 0
      AND o.voided = 0
      AND o.start_date <= my_end_date
      AND o.patient_id = my_patient_id
      GROUP BY drug_inventory_id, DATE(start_date), daily_dose;


  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  SELECT MAX(o.start_date) INTO @obs_datetime FROM drug_order d
    INNER JOIN arv_drug ad ON d.drug_inventory_id = ad.drug_id
    INNER JOIN orders o ON d.order_id = o.order_id
      AND d.quantity > 0
      AND o.voided = 0
      AND o.start_date <= my_end_date
      AND o.patient_id = my_patient_id
    GROUP BY o.patient_id;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO my_drug_id, my_start_date, my_daily_dose, my_quantity, my_obs_datetime;

    IF done THEN
      CLOSE cur1;
      LEAVE read_loop;
    END IF;

    IF DATE(my_obs_datetime) = DATE(@obs_datetime) THEN

      IF my_daily_dose = 0 OR LENGTH(my_daily_dose) < 1 OR my_daily_dose IS NULL THEN
        SET my_daily_dose = 1;
      END IF;

            SET my_pill_count = drug_pill_count(my_patient_id, my_drug_id, my_obs_datetime);

            SET @expiry_date = ADDDATE(DATE_SUB(my_start_date, INTERVAL 1 DAY), ((my_quantity + my_pill_count)/my_daily_dose));

      IF my_expiry_date IS NULL THEN
        SET my_expiry_date = @expiry_date;
      END IF;

      IF @expiry_date < my_expiry_date THEN
        SET my_expiry_date = @expiry_date;
            END IF;
        END IF;
    END LOOP;

    IF TIMESTAMPDIFF(day, DATE(my_expiry_date), DATE(my_end_date)) >= 60 THEN
        SET my_default_date = ADDDATE(my_expiry_date, 61);
    END IF;

  RETURN my_default_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `current_hiv_program_start_date_max` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `current_hiv_program_start_date_max`(my_patient_id INT, my_end_date DATETIME) RETURNS varchar(10) CHARSET latin1
    DETERMINISTIC
BEGIN
  SET @patient_id = NULL;
	SELECT max(ft3.current_hiv_program_start_date) INTO @patient_id FROM flat_table2 ft3
    WHERE ft3.patient_id = my_patient_id
	    AND ft3.current_hiv_program_start_date <= my_end_date
	    AND ft3.current_hiv_program_state = 'On antiretrovirals'
	    AND ft3.current_hiv_program_start_date IS NOT NULL;

	RETURN @patient_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `current_pepfar_defaulter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `current_pepfar_defaulter`(my_patient_id INT, my_end_date DATETIME) RETURNS int
    DETERMINISTIC
BEGIN
DECLARE done INT DEFAULT FALSE;
  DECLARE my_start_date, my_expiry_date, my_obs_datetime DATETIME;
  DECLARE my_daily_dose, my_quantity, my_pill_count, my_total_text, my_total_numeric DECIMAL(6, 2);
  DECLARE my_drug_id, flag INT;

  DECLARE cur1 CURSOR FOR SELECT d.drug_inventory_id, o.start_date, d.equivalent_daily_dose daily_dose, SUM(d.quantity), o.start_date FROM drug_order d
    INNER JOIN arv_drug ad ON d.drug_inventory_id = ad.drug_id
    INNER JOIN orders o ON d.order_id = o.order_id
      AND d.quantity > 0
      AND o.voided = 0
      AND o.start_date <= my_end_date
      AND o.patient_id = my_patient_id
      GROUP BY drug_inventory_id, DATE(start_date), daily_dose;


  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  SELECT MAX(o.start_date) INTO @obs_datetime FROM drug_order d
    INNER JOIN arv_drug ad ON d.drug_inventory_id = ad.drug_id
    INNER JOIN orders o ON d.order_id = o.order_id
      AND d.quantity > 0
      AND o.voided = 0
      AND o.start_date <= my_end_date
      AND o.patient_id = my_patient_id
    GROUP BY o.patient_id;

  OPEN cur1;

  SET flag = 0;

  read_loop: LOOP
    FETCH cur1 INTO my_drug_id, my_start_date, my_daily_dose, my_quantity, my_obs_datetime;

    IF done THEN
      CLOSE cur1;
      LEAVE read_loop;
    END IF;

    IF DATE(my_obs_datetime) = DATE(@obs_datetime) THEN

      IF my_daily_dose = 0 OR LENGTH(my_daily_dose) < 1 OR my_daily_dose IS NULL THEN
        SET my_daily_dose = 1;
      END IF;

            SET my_pill_count = drug_pill_count(my_patient_id, my_drug_id, my_obs_datetime);

            SET @expiry_date = ADDDATE(DATE_SUB(my_start_date, INTERVAL 1 DAY), ((my_quantity + my_pill_count)/my_daily_dose));

      IF my_expiry_date IS NULL THEN
        SET my_expiry_date = @expiry_date;
      END IF;

      IF @expiry_date < my_expiry_date THEN
        SET my_expiry_date = @expiry_date;
            END IF;
        END IF;
    END LOOP;

    IF TIMESTAMPDIFF(day, my_expiry_date, my_end_date) >= 30 THEN
        SET flag = 1;
    END IF;

  RETURN flag;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `current_pepfar_defaulter_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `current_pepfar_defaulter_date`(my_patient_id INT, my_end_date DATETIME) RETURNS date
    DETERMINISTIC
BEGIN
	DECLARE done INT DEFAULT FALSE;
	DECLARE my_start_date, my_expiry_date, my_obs_datetime DATETIME;
  DECLARE my_daily_dose, my_quantity, my_pill_count, my_total_text, my_total_numeric DECIMAL(6, 2);
  DECLARE my_drug_id INT;
  DECLARE my_default_date DATE;

  DECLARE cur1 CURSOR FOR SELECT d.drug_inventory_id, o.start_date, d.equivalent_daily_dose daily_dose, SUM(d.quantity), o.start_date FROM drug_order d
    INNER JOIN arv_drug ad ON d.drug_inventory_id = ad.drug_id
    INNER JOIN orders o ON d.order_id = o.order_id
      AND d.quantity > 0
      AND o.voided = 0
      AND o.start_date <= my_end_date
      AND o.patient_id = my_patient_id
      GROUP BY drug_inventory_id, DATE(start_date), daily_dose;


  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  SELECT MAX(o.start_date) INTO @obs_datetime FROM drug_order d
    INNER JOIN arv_drug ad ON d.drug_inventory_id = ad.drug_id
    INNER JOIN orders o ON d.order_id = o.order_id
      AND d.quantity > 0
      AND o.voided = 0
      AND o.start_date <= my_end_date
      AND o.patient_id = my_patient_id
    GROUP BY o.patient_id;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO my_drug_id, my_start_date, my_daily_dose, my_quantity, my_obs_datetime;

    IF done THEN
      CLOSE cur1;
      LEAVE read_loop;
    END IF;

    IF DATE(my_obs_datetime) = DATE(@obs_datetime) THEN

      IF my_daily_dose = 0 OR LENGTH(my_daily_dose) < 1 OR my_daily_dose IS NULL THEN
        SET my_daily_dose = 1;
      END IF;

            SET my_pill_count = drug_pill_count(my_patient_id, my_drug_id, my_obs_datetime);

            SET @expiry_date = ADDDATE(DATE_SUB(my_start_date, INTERVAL 1 DAY), ((my_quantity + my_pill_count)/my_daily_dose));

      IF my_expiry_date IS NULL THEN
        SET my_expiry_date = @expiry_date;
      END IF;

      IF @expiry_date < my_expiry_date THEN
        SET my_expiry_date = @expiry_date;
            END IF;
        END IF;
    END LOOP;

    IF TIMESTAMPDIFF(day, DATE(my_expiry_date), DATE(my_end_date)) >= 30 THEN
        SET my_default_date = ADDDATE(my_expiry_date, 31);
    END IF;

  RETURN my_default_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `current_state_for_patient_in_flat_tables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `current_state_for_patient_in_flat_tables`(my_patient_id INT, my_end_date DATETIME) RETURNS varchar(255) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
  SET @state_id = NULL;
	SELECT current_hiv_program_state INTO @state_id FROM flat_table2
    WHERE current_hiv_program_state IS NOT NULL and current_hiv_program_start_date IS NOT NULL
      AND patient_id = my_patient_id
      AND current_hiv_program_start_date <= my_end_date
    ORDER BY patient_id, current_hiv_program_start_date DESC
    LIMIT 1;

	RETURN @state_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `current_state_for_program` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `current_state_for_program`(my_patient_id INT, my_program_id INT, my_end_date DATETIME) RETURNS int
    DETERMINISTIC
BEGIN
  SET @state_id = NULL;
  SET @new_state_id = NULL;
	SELECT  patient_program_id INTO @patient_program_id FROM patient_program
			WHERE patient_id = my_patient_id
				AND program_id = my_program_id
				AND voided = 0
				ORDER BY patient_program_id DESC LIMIT 1;


	SELECT state, start_date INTO @state_id, @start_date FROM patient_state
		WHERE patient_program_id = @patient_program_id
			AND voided = 0
			AND start_date <= my_end_date
		ORDER BY start_date DESC, date_created DESC, patient_state_id DESC LIMIT 1;

   IF ( @state_id != 3 ) THEN

      SELECT state INTO @new_state_id FROM patient_state
		   WHERE patient_program_id = @patient_program_id
			AND voided = 0
			AND start_date = @start_date
         AND state = 3 LIMIT 1;
   END IF;

    IF ( @new_state_id IS NOT NULL ) THEN
        RETURN @new_state_id;
    END IF;

	RETURN @state_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `current_text_for_obs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `current_text_for_obs`(my_patient_id INT, my_encounter_type_id INT, my_concept_id INT, my_end_date DATETIME) RETURNS varchar(255) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
  SET @obs_value = NULL;
	SELECT encounter_id INTO @encounter_id FROM encounter
		WHERE encounter_type = my_encounter_type_id
			AND voided = 0
			AND patient_id = my_patient_id
			AND encounter_datetime <= my_end_date
		ORDER BY encounter_datetime DESC LIMIT 1;

	SELECT cn.name INTO @obs_value FROM obs o
			LEFT JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED'
		WHERE encounter_id = @encounter_id
			AND o.voided = 0
			AND o.concept_id = my_concept_id
			AND o.voided = 0 LIMIT 1;

	IF @obs_value IS NULL THEN
		SELECT value_text INTO @obs_value FROM obs
			WHERE encounter_id = @encounter_id
				AND voided = 0
				AND concept_id = my_concept_id
				AND voided = 0 LIMIT 1;
	END IF;

	IF @obs_value IS NULL THEN
		SELECT value_numeric INTO @obs_value FROM obs
			WHERE encounter_id = @encounter_id
				AND voided = 0
				AND concept_id = my_concept_id
				AND voided = 0 LIMIT 1;
	END IF;

	RETURN @obs_value;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `current_value_for_obs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `current_value_for_obs`(my_patient_id INT, my_encounter_type_id INT, my_concept_id INT, my_end_date DATETIME) RETURNS int
    DETERMINISTIC
BEGIN
  SET @obs_value_coded = NULL;
	SELECT encounter_id INTO @encounter_id FROM encounter
		WHERE encounter_type = my_encounter_type_id
			AND voided = 0
			AND patient_id = my_patient_id
			AND encounter_datetime <= my_end_date
		ORDER BY encounter_datetime DESC LIMIT 1;

	SELECT value_coded INTO @obs_value_coded FROM obs
			WHERE encounter_id = @encounter_id
				AND voided = 0
				AND concept_id = my_concept_id
				AND voided = 0 LIMIT 1;

	RETURN @obs_value_coded;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `current_value_for_obs_at_initiation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `current_value_for_obs_at_initiation`(my_patient_id INT, my_earliest_start_date DATETIME, my_encounter_type_id INT, my_concept_id INT, my_end_date DATETIME) RETURNS int
    DETERMINISTIC
BEGIN
	DECLARE obs_value_coded, my_encounter_id INT;

	SELECT encounter_id INTO my_encounter_id FROM encounter
		WHERE encounter_type = my_encounter_type_id
			AND voided = 0
			AND patient_id = my_patient_id
			AND encounter_datetime <= ADDDATE(DATE(my_earliest_start_date), 1)
		ORDER BY encounter_datetime DESC LIMIT 1;

	IF my_encounter_id IS NULL THEN
		SELECT encounter_id INTO my_encounter_id FROM encounter
			WHERE encounter_type = my_encounter_type_id
				AND voided = 0
				AND patient_id = my_patient_id
				AND encounter_datetime <= my_end_date
                AND encounter_datetime >= ADDDATE(DATE(my_earliest_start_date), 1)
			ORDER BY encounter_datetime LIMIT 1;
	END IF;

	SELECT value_coded INTO obs_value_coded FROM obs
			WHERE encounter_id = my_encounter_id
				AND voided = 0
				AND concept_id = my_concept_id
				AND voided = 0 LIMIT 1;

	RETURN obs_value_coded;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cxca_age_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `cxca_age_group`(birthdate date, end_date date) RETURNS varchar(15) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN

DECLARE age_in_months INT(11);
DECLARE age_in_years INT(11);
DECLARE age_group VARCHAR(15);

SET age_in_years  = (SELECT timestampdiff(year, birthdate, end_date));
SET age_group = ('Unknown Age');

IF age_in_years >= 15 AND age_in_years <= 19 THEN SET age_group = "15-19";
ELSEIF age_in_years >= 20 AND age_in_years <= 24 THEN SET age_group = "20-24";
ELSEIF age_in_years >= 25 AND age_in_years <= 29 THEN SET age_group = "25-29";
ELSEIF age_in_years >= 30 AND age_in_years <= 34 THEN SET age_group = "30-34";
ELSEIF age_in_years >= 35 AND age_in_years <= 39 THEN SET age_group = "35-39";
ELSEIF age_in_years >= 40 AND age_in_years <= 44 THEN SET age_group = "40-44";
ELSEIF age_in_years >= 45 AND age_in_years <= 49 THEN SET age_group = "45-49";
ELSEIF age_in_years >= 50 THEN SET age_group = "50+";
END IF;

RETURN age_group;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cxca_moh_age_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `cxca_moh_age_group`(birthdate date, end_date date) RETURNS varchar(15) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN

DECLARE age_in_years INT(11);
DECLARE age_group VARCHAR(15);

SET age_in_years  = (SELECT timestampdiff(year, birthdate, end_date));
SET age_group = ('Unknown');

IF age_in_years >= 0 AND age_in_years < 25 THEN SET age_group = "<25 years";
ELSEIF age_in_years >= 25 AND age_in_years <= 29 THEN SET age_group = "25-29 years";
ELSEIF age_in_years >= 30 AND age_in_years <= 44 THEN SET age_group = "30-44 years";
ELSEIF age_in_years >= 45 AND age_in_years <= 49 THEN SET age_group = "45-49 years";
ELSEIF age_in_years > 49 THEN SET age_group = ">49 years";
END IF;

RETURN age_group;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `date_antiretrovirals_started` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES' */ ;
DELIMITER ;;
CREATE FUNCTION `date_antiretrovirals_started`(set_patient_id INT, min_state_date DATE) RETURNS date
    DETERMINISTIC
BEGIN
  DECLARE date_started DATE;
  DECLARE estimated_art_date_months VARCHAR(45);
  DECLARE legacy_art_start_concept_id INT;

  SET legacy_art_start_concept_id = (
    SELECT concept_id
    FROM concept_name
    WHERE name = 'Date antiretrovirals started'
      AND concept_name_type = 'FULLY_SPECIFIED'
      AND voided = 0
    LIMIT 1
  );

  SET date_started = (
    SELECT DATE(o.value_datetime)
    FROM obs o
    INNER JOIN concept_name cn ON cn.concept_id = o.concept_id
      AND cn.name IN ('ART start date', 'Date antiretrovirals started')
      AND cn.voided = 0
    WHERE o.encounter_id > 0
      AND o.person_id = set_patient_id
      AND o.voided = 0
      AND o.value_datetime IS NOT NULL
    ORDER BY DATE(o.value_datetime), o.obs_datetime, o.obs_id
    LIMIT 1
  );

  IF date_started IS NULL THEN
    SET estimated_art_date_months = (
      SELECT value_text
      FROM obs
      WHERE encounter_id > 0
        AND concept_id = legacy_art_start_concept_id
        AND person_id = set_patient_id
        AND voided = 0
      ORDER BY obs_datetime, obs_id
      LIMIT 1
    );

    SET min_state_date = (
      SELECT obs_datetime
      FROM obs
      WHERE encounter_id > 0
        AND concept_id = legacy_art_start_concept_id
        AND person_id = set_patient_id
        AND voided = 0
      ORDER BY obs_datetime, obs_id
      LIMIT 1
    );

    IF estimated_art_date_months = '6 months' THEN
      SET date_started = DATE_SUB(min_state_date, INTERVAL 6 MONTH);
    ELSEIF estimated_art_date_months = '12 months' THEN
      SET date_started = DATE_SUB(min_state_date, INTERVAL 12 MONTH);
    ELSEIF estimated_art_date_months = '18 months' THEN
      SET date_started = DATE_SUB(min_state_date, INTERVAL 18 MONTH);
    ELSEIF estimated_art_date_months = '24 months' THEN
      SET date_started = DATE_SUB(min_state_date, INTERVAL 24 MONTH);
    ELSEIF estimated_art_date_months = '48 months' THEN
      SET date_started = DATE_SUB(min_state_date, INTERVAL 48 MONTH);
    ELSEIF estimated_art_date_months = 'Over 2 years' THEN
      SET date_started = DATE_SUB(min_state_date, INTERVAL 60 MONTH);
    ELSE
      SET date_started = patient_start_date(set_patient_id);
    END IF;
  END IF;

  RETURN date_started;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `died_in` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `died_in`(set_patient_id INT, set_status VARCHAR(25), date_enrolled DATE) RETURNS varchar(25) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
DECLARE set_outcome varchar(25) default 'N/A';
DECLARE date_of_death DATE;
DECLARE num_of_days INT;

IF set_status = 'Patient died' THEN

  SET date_of_death = (
    SELECT COALESCE(death_date, moh_outcome_date)
    FROM temp_patient_outcomes INNER JOIN temp_earliest_start_date USING (patient_id)
    WHERE moh_cum_outcome = 'Patient died' AND patient_id = set_patient_id
  );

  IF date_of_death IS NULL THEN
    RETURN 'Unknown';
  END IF;


  set num_of_days = (TIMESTAMPDIFF(day, date(date_enrolled), date(date_of_death)));

  IF num_of_days <= 30 THEN set set_outcome ="1st month";
  ELSEIF num_of_days <= 60 THEN set set_outcome ="2nd month";
  ELSEIF num_of_days <= 91 THEN set set_outcome ="3rd month";
  ELSEIF num_of_days > 91 THEN set set_outcome ="4+ months";
  ELSEIF num_of_days IS NULL THEN set set_outcome = "Unknown";
  END IF;


END IF;

RETURN set_outcome;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `died_in_loc_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES' */ ;
DELIMITER ;;
CREATE FUNCTION `died_in_loc_1`(set_patient_id INT, set_status VARCHAR(25), date_enrolled DATE) RETURNS varchar(25) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
  DECLARE set_outcome varchar(25) default 'N/A';
  DECLARE date_of_death DATE;
  DECLARE num_of_days INT;

  IF set_status = 'Patient died' THEN
    SET date_of_death = (
      SELECT COALESCE(death_date, moh_outcome_date)
      FROM temp_patient_outcomes_loc_1 INNER JOIN temp_earliest_start_date_loc_1
      USING (patient_id)
      WHERE moh_cum_outcome = 'Patient died' AND patient_id = set_patient_id
    );

    IF date_of_death IS NULL THEN
      RETURN 'Unknown';
    END IF;

    set num_of_days = (TIMESTAMPDIFF(day, date(date_enrolled), date(date_of_death)));
    IF num_of_days <= 30 THEN set set_outcome ="1st month";
    ELSEIF num_of_days <= 60 THEN set set_outcome ="2nd month";
    ELSEIF num_of_days <= 91 THEN set set_outcome ="3rd month";
    ELSEIF num_of_days > 91 THEN set set_outcome ="4+ months";
    ELSEIF num_of_days IS NULL THEN set set_outcome = "Unknown";
    END IF;
  END IF;

  RETURN set_outcome;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `disaggregated_age_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `disaggregated_age_group`(birthdate date, end_date date) RETURNS varchar(15) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN

DECLARE age_in_months INT(11);
DECLARE age_in_years INT(11);
DECLARE age_group VARCHAR(15);

SET age_in_months = (SELECT timestampdiff(month, birthdate, end_date));
SET age_in_years  = (SELECT timestampdiff(year, birthdate, end_date));
SET age_group = ('Unknown');

IF age_in_months >= 0 AND age_in_months <= 11 THEN SET age_group = "<1 year";
ELSEIF age_in_years >= 1 AND age_in_years <= 4 THEN SET age_group = "1-4 years";
ELSEIF age_in_years >= 5 AND age_in_years <= 9 THEN SET age_group = "5-9 years";
ELSEIF age_in_years >= 10 AND age_in_years <= 14 THEN SET age_group = "10-14 years";
ELSEIF age_in_years >= 15 AND age_in_years <= 19 THEN SET age_group = "15-19 years";
ELSEIF age_in_years >= 20 AND age_in_years <= 24 THEN SET age_group = "20-24 years";
ELSEIF age_in_years >= 25 AND age_in_years <= 29 THEN SET age_group = "25-29 years";
ELSEIF age_in_years >= 30 AND age_in_years <= 34 THEN SET age_group = "30-34 years";
ELSEIF age_in_years >= 35 AND age_in_years <= 39 THEN SET age_group = "35-39 years";
ELSEIF age_in_years >= 40 AND age_in_years <= 44 THEN SET age_group = "40-44 years";
ELSEIF age_in_years >= 45 AND age_in_years <= 49 THEN SET age_group = "45-49 years";
ELSEIF age_in_years >= 50 AND age_in_years <= 54 THEN SET age_group = "50-54 years";
ELSEIF age_in_years >= 55 AND age_in_years <= 59 THEN SET age_group = "55-59 years";
ELSEIF age_in_years >= 60 AND age_in_years <= 64 THEN SET age_group = "60-64 years";
ELSEIF age_in_years >= 65 AND age_in_years <= 69 THEN SET age_group = "65-69 years";
ELSEIF age_in_years >= 70 AND age_in_years <= 74 THEN SET age_group = "70-74 years";
ELSEIF age_in_years >= 75 AND age_in_years <= 79 THEN SET age_group = "75-79 years";
ELSEIF age_in_years >= 80 AND age_in_years <= 84 THEN SET age_group = "80-84 years";
ELSEIF age_in_years >= 85 AND age_in_years <= 89 THEN SET age_group = "85-89 years";
ELSEIF age_in_years >= 90 THEN SET age_group = "90 plus years";
END IF;

RETURN age_group;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `drug_pill_count` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `drug_pill_count`(my_patient_id INT, my_drug_id INT, my_date DATE) RETURNS decimal(10,0)
    DETERMINISTIC
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE my_pill_count, my_total_numeric, my_total_text, my_total_transfer_in DECIMAL;

  DECLARE cur1 CURSOR FOR SELECT SUM(ob.value_numeric), SUM(CAST(ob.value_text AS DECIMAL)) FROM obs ob
                        INNER JOIN drug_order do ON ob.order_id = do.order_id
                        INNER JOIN orders o ON do.order_id = o.order_id
                    WHERE ob.person_id = my_patient_id
                        AND ob.concept_id = 2540
                        AND ob.voided = 0
                        AND o.voided = 0
                        AND do.drug_inventory_id = my_drug_id
                        AND DATE(ob.obs_datetime) = my_date
                    GROUP BY ob.person_id;

  DECLARE cur2 CURSOR FOR SELECT SUM(ob.value_numeric) FROM obs ob
                    WHERE ob.person_id = my_patient_id
                        AND ob.concept_id = (SELECT concept_id FROM drug WHERE drug_id = my_drug_id)
                        AND ob.voided = 0
                        AND DATE(ob.obs_datetime) = my_date
                    GROUP BY ob.person_id;
  
  DECLARE cur3 CURSOR FOR SELECT SUM(ob.value_numeric)
                    FROM obs ob
                    INNER JOIN encounter e ON e.encounter_id = ob.encounter_id AND e.voided = 0
                    INNER JOIN encounter_type et ON et.encounter_type_id = e.encounter_type AND et.retired = 0 AND et.name = 'HIV CLINIC CONSULTATION'
                    WHERE ob.person_id = my_patient_id
                        AND ob.concept_id = 2540
                        AND ob.voided = 0
                        AND DATE(ob.obs_datetime) = my_date
                        AND ob.value_drug = my_drug_id
                    GROUP BY ob.person_id;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  SET my_pill_count = 0;

  read_loop1: LOOP
    FETCH cur1 INTO my_total_numeric, my_total_text;

    IF done THEN
      CLOSE cur1;
      LEAVE read_loop1;
    END IF;

    IF my_total_numeric IS NULL THEN
      SET my_total_numeric = 0;
    END IF;
    IF my_total_text IS NULL THEN
      SET my_total_text = 0;
    END IF;

    SET my_pill_count = my_total_numeric + my_total_text;
  END LOOP;

  SET done = FALSE;
  OPEN cur2;
  read_loop2: LOOP
    FETCH cur2 INTO my_total_numeric;

    IF done THEN
      CLOSE cur2;
      LEAVE read_loop2;
    END IF;

    IF my_total_numeric IS NULL THEN
      SET my_total_numeric = 0;
    END IF;

    SET my_pill_count = my_total_numeric + my_pill_count;
  END LOOP;

  SET done = FALSE;
  OPEN cur3;
  read_loop3: LOOP
    FETCH cur3 INTO my_total_transfer_in;

    IF done THEN
      CLOSE cur3;
      LEAVE read_loop3;
    END IF;

    IF my_total_transfer_in IS NULL THEN
      SET my_total_transfer_in = 0;
    END IF;

    SET my_pill_count = my_total_transfer_in + my_pill_count;
  END LOOP;

  RETURN my_pill_count;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `earliest_start_date_at_clinic` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE FUNCTION `earliest_start_date_at_clinic`(set_patient_id INT) RETURNS date
    DETERMINISTIC
BEGIN

DECLARE date_started DATE;

SET date_started = (SELECT MIN(start_date) FROM patient_state s INNER JOIN patient_program p ON p.patient_program_id = s.patient_program_id WHERE s.voided = 0 AND s.state = 7 AND p.program_id = 1 AND p.patient_id = set_patient_id);

RETURN date_started;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `female_maternal_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `female_maternal_status`(my_patient_id int, end_datetime datetime) RETURNS varchar(20) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN

DECLARE breastfeeding_date DATETIME;
DECLARE pregnant_date DATETIME;
DECLARE maternal_status VARCHAR(20);
DECLARE obs_value_coded INT(11);


SET @reason_for_starting = (SELECT concept_id FROM concept_name WHERE name = 'Reason for ART eligibility' LIMIT 1);

SET @pregnant_concepts := (SELECT GROUP_CONCAT(concept_id) FROM concept_name WHERE name IN('Is patient pregnant?','Patient pregnant'));
SET @breastfeeding_concept := (SELECT GROUP_CONCAT(concept_id) FROM concept_name WHERE name = 'Breastfeeding');

SET pregnant_date = (SELECT MAX(obs_datetime) FROM obs WHERE concept_id IN(@pregnant_concepts) AND voided = 0 AND person_id = my_patient_id AND        obs_datetime <= end_datetime);
SET breastfeeding_date = (SELECT MAX(obs_datetime) FROM obs WHERE concept_id IN(@breastfeeding_concept) AND voided = 0 AND person_id = my_patient_id   AND obs_datetime <= end_datetime);

IF pregnant_date IS NULL THEN
  SET pregnant_date = (SELECT MAX(obs_datetime) FROM obs WHERE concept_id = @reason_for_starting AND voided = 0 AND person_id = my_patient_id AND      obs_datetime <= end_datetime AND value_coded IN(1755));
END IF;

IF breastfeeding_date IS NULL THEN
  SET breastfeeding_date = (SELECT MAX(obs_datetime) FROM obs WHERE concept_id = @reason_for_starting AND voided = 0 AND person_id = my_patient_id AND obs_datetime <= end_datetime AND value_coded IN(834,5632));
END IF;

IF pregnant_date IS NULL AND breastfeeding_date IS NULL THEN SET maternal_status = "FNP";
ELSEIF pregnant_date IS NOT NULL AND breastfeeding_date IS NOT NULL THEN SET maternal_status = "Unknown";
ELSEIF pregnant_date IS NULL AND breastfeeding_date IS NOT NULL THEN SET maternal_status = "Check BF";
ELSEIF pregnant_date IS NOT NULL AND breastfeeding_date IS NULL THEN SET maternal_status = "Check FP";
END IF;

IF maternal_status = 'Unknown' THEN

  IF breastfeeding_date <= pregnant_date THEN
    SET obs_value_coded = (SELECT value_coded FROM obs WHERE concept_id IN(@pregnant_concepts) AND voided = 0 AND person_id = my_patient_id AND        obs_datetime = pregnant_date LIMIT 1);
    IF obs_value_coded = 1065 THEN SET maternal_status = 'FP';
    ELSEIF obs_value_coded = 1066 THEN SET maternal_status = 'FNP';
    END IF;
  END IF;

  IF breastfeeding_date > pregnant_date THEN
    SET obs_value_coded = (SELECT value_coded FROM obs WHERE concept_id IN(@breastfeeding_concept) AND voided = 0 AND person_id = my_patient_id AND    obs_datetime = breastfeeding_date LIMIT 1);
    IF obs_value_coded = 1065 THEN SET maternal_status = 'FBf';
    ELSEIF obs_value_coded = 1066 THEN SET maternal_status = 'FNP';
    END IF;
  END IF;

  IF DATE(breastfeeding_date) = DATE(pregnant_date) AND maternal_status = 'FNP' THEN
    SET obs_value_coded = (SELECT value_coded FROM obs WHERE concept_id IN(@breastfeeding_concept) AND voided = 0 AND person_id = my_patient_id AND    obs_datetime = breastfeeding_date LIMIT 1);
    IF obs_value_coded = 1065 THEN SET maternal_status = 'FBf';
    ELSEIF obs_value_coded = 1066 THEN SET maternal_status = 'FNP';
    END IF;
  END IF;
END IF;


IF maternal_status = 'Check FP' THEN

  SET obs_value_coded = (SELECT value_coded FROM obs WHERE concept_id IN(@pregnant_concepts) AND voided = 0 AND person_id = my_patient_id AND          obs_datetime = pregnant_date LIMIT 1);
  IF obs_value_coded = 1065 THEN SET maternal_status = 'FP';
  ELSEIF obs_value_coded = 1066 THEN SET maternal_status = 'FNP';
  END IF;

  IF obs_value_coded IS NULL THEN
    SET obs_value_coded = (SELECT GROUP_CONCAT(value_coded) FROM obs WHERE concept_id IN(7563) AND voided = 0 AND person_id = my_patient_id AND        obs_datetime = pregnant_date);
    IF obs_value_coded IN(1755) THEN SET maternal_status = 'FP';
    END IF;
  END IF;

  IF maternal_status = 'Check FP' THEN SET maternal_status = 'FNP';
  END IF;
END IF;

IF maternal_status = 'Check BF' THEN

  SET obs_value_coded = (SELECT value_coded FROM obs WHERE concept_id IN(@breastfeeding_concept) AND voided = 0 AND person_id = my_patient_id AND      obs_datetime = breastfeeding_date LIMIT 1);
  IF obs_value_coded = 1065 THEN SET maternal_status = 'FBf';
  ELSEIF obs_value_coded = 1066 THEN SET maternal_status = 'FNP';
  END IF;

  IF obs_value_coded IS NULL THEN
    SET obs_value_coded = (SELECT GROUP_CONCAT(value_coded) FROM obs WHERE concept_id IN(7563) AND voided = 0 AND person_id = my_patient_id AND        obs_datetime = breastfeeding_date);
    IF obs_value_coded IN(834,5632) THEN SET maternal_status = 'FBf';
    END IF;
  END IF;

  IF maternal_status = 'Check BF' THEN SET maternal_status = 'FNP';
  END IF;
END IF;



RETURN maternal_status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `last_text_for_obs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `last_text_for_obs`(my_patient_id INT, my_encounter_type_id INT, my_concept_id INT, my_regimem_given INT, unknown_regimen_value INT, my_end_date DATETIME) RETURNS varchar(255) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
  SET @obs_value = NULL;
  SET @encounter_id = NULL;

  SELECT o.encounter_id INTO @encounter_id FROM encounter e
  	INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.concept_id IN (my_concept_id, @unknown_drug_concept_id) AND o.voided = 0
  WHERE e.encounter_type = my_encounter_type_id
  AND e.voided = 0
  AND e.patient_id = my_patient_id
  AND e.encounter_datetime <= my_end_date
  ORDER BY e.encounter_datetime DESC LIMIT 1;

  SELECT cn.name INTO @obs_value FROM obs o
  	LEFT JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED'
  WHERE encounter_id = @encounter_id
  AND o.voided = 0
  AND o.concept_id = my_concept_id
  AND o.voided = 0 LIMIT 1;

  IF @obs_value IS NULL THEN
    SELECT 'unknown_drug_value' INTO @obs_value FROM obs
    WHERE encounter_id = @encounter_id
    AND voided = 0
    AND concept_id = my_regimem_given
    AND (value_coded = unknown_regimen_value OR value_text = 'Unknown')
    AND voided = 0 LIMIT 1;
  END IF;

  IF @obs_value IS NULL THEN
    SELECT value_text INTO @obs_value FROM obs
    WHERE encounter_id = @encounter_id
    AND voided = 0
    AND concept_id = my_concept_id
    AND voided = 0 LIMIT 1;
  END IF;

  IF @obs_value IS NULL THEN
    SELECT value_numeric INTO @obs_value FROM obs
    WHERE encounter_id = @encounter_id
    AND voided = 0
    AND concept_id = my_concept_id
    AND voided = 0 LIMIT 1;
  END IF;

  RETURN @obs_value;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `malaria_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `malaria_report`(_order_id varchar(100),_value_text varchar(100),_value_coded varchar(100),_person_id varchar(100),_obs_datetime varchar(100),_concept_name varchar(100),birthdate varchar(100),today_date varchar(100)) RETURNS text CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN

DECLARE report_data TEXT;
DECLARE age_in_years INT(11);

SET age_in_years  = (SELECT timestampdiff(year, birthdate, today_date));
SET report_data = NULL;
SET @old_confirm_results = '';
SET @confirm_results = NULL;
SET @pregnant_patient = NULL;
SET @drug_data = '';

IF _concept_name = 'Revisiting' OR _concept_name = 'New patient' OR _concept_name = 'Referral' THEN
    IF age_in_years <= 5 THEN SET report_data = "total_patient_less_5yrs";
	ELSEIF age_in_years > 5 THEN SET report_data = "total_patient_more_5yrs";
	END IF;
ELSE
	SELECT  CONCAT(',',c.name) as confirmed_malaria_treatment_failure INTO @old_confirm_results FROM `obs`
	INNER JOIN concept_name c ON c.concept_id = obs.concept_id
	WHERE `obs`.`voided` = 0 AND obs_datetime BETWEEN DATE_SUB(_obs_datetime, INTERVAL 7 DAY) AND DATE_SUB(_obs_datetime, INTERVAL 3 DAY)
	AND obs.person_id = _person_id
	AND c.name IN('MRDT','Malaria film','Malaria Species') AND c.voided = 0 AND (value_text = 'Positive' OR value_text = 'Parasites seen') LIMIT 1;

	SELECT  CONCAT(',',c.name) INTO @suspected_malaria FROM `obs`
	INNER JOIN concept_name c ON c.concept_id = obs.concept_id
	WHERE `obs`.`voided` = 0 AND DATE(obs_datetime) = _obs_datetime
	AND obs.person_id = _person_id
	AND c.name IN('MRDT','Malaria film','Malaria Species') AND c.voided = 0 AND (value_text = 'Negative' OR value_text = 'No parasites seen') LIMIT 1;


	SELECT c.name INTO @pregnant_patient FROM `obs`
	INNER JOIN concept_name c ON c.concept_id = obs.concept_id
	WHERE `obs`.`voided` = 0 AND DATE(obs_datetime) = _obs_datetime
    AND c.name = 'Is patient pregnant?' AND value_coded = 1065
	AND obs.person_id = _person_id AND c.voided = 0 LIMIT 1;

	SELECT CONCAT(',',orders.instructions,'=',`quantity`) INTO @drug_data FROM `orders`
	INNER JOIN drug_order do ON do.order_id = orders.order_id
	INNER JOIN concept_name c ON c.concept_id = orders.concept_id
	WHERE `orders`.`voided` = 0 AND DATE(orders.start_date) = _obs_datetime AND patient_id = _person_id AND quantity > 0
	AND c.name IN ('LA(Lumefantrine + arthemether)','Artesunate and amodiaquin','Sulfadoxine and Pyrimethamine') LIMIT 1;

	SELECT CONCAT(orders.instructions,'=',`quantity`) INTO report_data FROM `orders`
	INNER JOIN drug_order do ON do.order_id = orders.order_id
	INNER JOIN concept_name c ON c.concept_id = orders.concept_id
	WHERE `orders`.`voided` = 0 AND DATE(orders.start_date) = _obs_datetime AND patient_id = _person_id AND quantity > 0
	AND c.name IN ('LA(Lumefantrine + arthemether)','Artesunate and amodiaquin','Sulfadoxine and Pyrimethamine') AND orders.order_id = _order_id LIMIT 1;

	IF (_concept_name = 'MRDT'AND _value_text = 'Positive') OR (_value_text = 'Parasites seen' AND _concept_name = 'Malaria film') OR (_value_text = 'Parasites seen' AND _concept_name = 'Malaria Species') THEN
		SET _concept_name = CONCAT('positive_',_concept_name);
        IF @pregnant_patient = 'Is patient pregnant?' THEN
			IF age_in_years <= 5 THEN SET report_data = CONCAT("< 5yrs,","confirm_pregnant,",_concept_name,@drug_data,@old_confirm_results);
			ELSEIF age_in_years > 5 THEN SET report_data = CONCAT("> 5yrs,","confirm_pregnant,",_concept_name,@drug_data,@old_confirm_results);
			END IF;
		END IF;

		IF @pregnant_patient IS NULL THEN
			IF age_in_years <= 5 THEN SET report_data = CONCAT("< 5yrs,","confrim_non_pregnant,",_concept_name,@drug_data,@old_confirm_results);
			ELSEIF age_in_years > 5 THEN SET report_data = CONCAT("> 5yrs,","confrim_non_pregnant,", _concept_name,@drug_data,@old_confirm_results);
			END IF;
		END IF;
	ELSEIF(_concept_name = 'MRDT'AND _value_text = 'Negative') OR (_value_text = 'No parasites seen' AND _concept_name = 'Malaria film') OR (_value_text = 'No parasites seen' AND _concept_name = 'Malaria Species') THEN
		SET _concept_name = CONCAT('negative_',_concept_name);
        IF age_in_years <= 5 THEN SET report_data = CONCAT("< 5yrs,","suspected_malaria,",_concept_name,@drug_data,@old_confirm_results);
		ELSEIF age_in_years > 5 THEN SET report_data = CONCAT("> 5yrs,","suspected_malaria,",_concept_name,@drug_data,@old_confirm_results);
		END IF;
	ELSEIF _value_coded = 123 THEN
			IF @pregnant_patient = 'Is patient pregnant?' THEN
				IF age_in_years <= 5 THEN SET report_data = CONCAT("< 5yrs,","presume_pregnant,",@drug_data,@old_confirm_results);
				ELSEIF age_in_years > 5 THEN SET report_data = CONCAT("> 5yrs,","presume_pregnant,",@drug_data,@old_confirm_results);
				END IF;
			END IF;

			IF @pregnant_patient IS NULL THEN
				IF age_in_years <= 5 THEN SET report_data = CONCAT("< 5yrs,","presume_non_pregnant,",@drug_data,@old_confirm_results );
				ELSEIF age_in_years > 5 THEN SET report_data = CONCAT("> 5yrs,","presume_non_pregnant,",@drug_data,@old_confirm_results);
				END IF;
			END IF;
	END IF;
END IF;


RETURN report_data;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `max_anc_visit_obs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE FUNCTION `max_anc_visit_obs`(my_patient_id INT, my_e_date DATE, my_min_date DATE) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE visits INT;

SET visits = (SELECT MAX(a.value_numeric) FROM anc_visit_observations a
                WHERE DATE(encounter_datetime) <= my_e_date
                AND DATE(encounter_datetime) >= my_min_date
                AND person_id = my_patient_id);

RETURN visits;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `max_patient_lmp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE FUNCTION `max_patient_lmp`(my_patient_id INT, my_e_date DATE, my_min_date DATE) RETURNS date
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE lmp_date DATE;

SET lmp_date = (SELECT DATE(MAX(lmp)) FROM last_menstraul_period_date
                WHERE DATE(obs_datetime) <= my_e_date
                AND DATE(obs_datetime) >= my_min_date
                AND person_id = my_patient_id);

RETURN lmp_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `opd_disaggregated_age_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `opd_disaggregated_age_group`(birthdate date, end_date date) RETURNS varchar(15) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN

DECLARE age_in_months INT(11);
DECLARE age_in_years INT(11);
DECLARE age_group VARCHAR(15);

SET age_in_months = (SELECT timestampdiff(month, birthdate, end_date));
SET age_in_years  = (SELECT timestampdiff(year, birthdate, end_date));
SET age_group = ('Unknown');

IF age_in_months >= 0 AND age_in_months <= 5 THEN SET age_group = "0-5 months";
ELSEIF age_in_months >= 6 AND age_in_years < 5 THEN SET age_group = "6 mth < 5 yrs";
ELSEIF age_in_years >= 5 AND age_in_years < 14 THEN SET age_group = "5-14 yrs";
ELSEIF age_in_years >= 14 THEN SET age_group = ">= 14 years";
END IF;

RETURN age_group;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `OPD_syndromic_statistics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `OPD_syndromic_statistics`(start_date date, end_date date) RETURNS varchar(15) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN

DECLARE obs_in_months INT(11);
DECLARE obs_date_group VARCHAR(15);

SET obs_in_months = (SELECT timestampdiff(month, start_date, end_date));
SET obs_date_group = ('Unknown');

IF obs_in_months < 1  THEN SET obs_date_group = "0 months";
ELSEIF obs_in_months = 1 THEN SET obs_date_group = "1 months";
ELSEIF obs_in_months = 2  THEN SET obs_date_group = "2 months";
ELSEIF obs_in_months = 3 THEN SET obs_date_group = "3 months";
ELSEIF obs_in_months = 4 THEN SET obs_date_group = "4 months";
ELSEIF obs_in_months = 5 THEN SET obs_date_group = "5 months";
ELSEIF obs_in_months = 6 THEN SET obs_date_group = "6 months";
ELSEIF obs_in_months = 7 THEN SET obs_date_group = "7 months";
ELSEIF obs_in_months = 8 THEN SET obs_date_group = "8 months";
ELSEIF obs_in_months = 9 THEN SET obs_date_group = "9 months";
ELSEIF obs_in_months = 10 THEN SET obs_date_group = "10 months";
ELSEIF obs_in_months = 11 THEN SET obs_date_group = "11 months";
END IF;

RETURN obs_date_group;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_current_regimen` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_current_regimen`(`my_patient_id` INT, `my_date` DATE) RETURNS varchar(10) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
  DECLARE max_obs_datetime DATETIME;
  DECLARE regimen VARCHAR(10) DEFAULT 'N/A';

  SET max_obs_datetime = (
    SELECT MAX(start_date)
    FROM orders
      INNER JOIN drug_order
        ON drug_order.order_id = orders.order_id
        AND drug_order.drug_inventory_id IN (SELECT * FROM arv_drug)
        AND orders.voided = 0
        AND DATE(orders.start_date) <= DATE(my_date)
    WHERE orders.patient_id = my_patient_id AND drug_order.quantity > 0
  );

  SET @drug_ids := (
    SELECT GROUP_CONCAT(DISTINCT(drug_order.drug_inventory_id) ORDER BY drug_order.drug_inventory_id ASC)
    FROM drug_order
      INNER JOIN arv_drug ON drug_order.drug_inventory_id = arv_drug.drug_id
      INNER JOIN orders ON drug_order.order_id = orders.order_id AND drug_order.quantity > 0
      INNER JOIN encounter
        ON encounter.encounter_id = orders.encounter_id
        AND encounter.voided = 0
        AND encounter.encounter_type = 22
    WHERE orders.voided = 0
      AND date(orders.start_date) = DATE(max_obs_datetime)
      AND encounter.patient_id = my_patient_id
    ORDER BY arv_drug.drug_id ASC
  );

  SET regimen = (
    SELECT DISTINCT name FROM (
      SELECT GROUP_CONCAT(drug.drug_id ORDER BY drug.drug_id ASC) AS drugs,
             regimen_name.name AS name
      FROM moh_regimen_combination AS combo
        INNER JOIN moh_regimen_combination_drug AS drug USING (regimen_combination_id)
        INNER JOIN moh_regimen_name AS regimen_name USING (regimen_name_id)
      GROUP BY combo.regimen_combination_id
    ) AS regimens
    WHERE drugs = @drug_ids
    LIMIT 1
  );

  IF regimen IS NULL THEN
    SET regimen = 'N/A';
  END IF;

  RETURN regimen;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_date_enrolled` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_date_enrolled`(my_patient_id int) RETURNS date
    DETERMINISTIC
BEGIN
DECLARE my_start_date DATE;
DECLARE min_start_date DATETIME;
DECLARE arv_concept_id INT(11);

SET arv_concept_id = (SELECT concept_id FROM concept_name WHERE name ='ANTIRETROVIRAL DRUGS' LIMIT 1);

SET my_start_date = (SELECT DATE(o.start_date) FROM drug_order d INNER JOIN orders o ON d.order_id = o.order_id AND o.voided = 0 WHERE o.patient_id = my_patient_id AND drug_inventory_id IN(SELECT drug_id FROM drug WHERE concept_id IN(SELECT concept_id FROM concept_set WHERE concept_set = arv_concept_id)) AND d.quantity > 0 AND o.start_date = (SELECT min(start_date) FROM drug_order d INNER JOIN orders o ON d.order_id = o.order_id AND o.voided = 0 WHERE d.quantity > 0 AND o.patient_id = my_patient_id AND drug_inventory_id IN(SELECT drug_id FROM drug WHERE concept_id IN(SELECT concept_id FROM concept_set WHERE concept_set = arv_concept_id))) LIMIT 1);


RETURN my_start_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_given_ipt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_given_ipt`(my_patient_id INT, my_start_date DATE, my_end_date DATE) RETURNS int
    DETERMINISTIC
BEGIN
	DECLARE given INT DEFAULT FALSE;
	DECLARE record_value INT;

  SET record_value = (SELECT o.patient_id FROM drug_order d
      INNER JOIN orders o ON o.order_id = d.order_id
      WHERE d.drug_inventory_id IN(
        SELECT GROUP_CONCAT(DISTINCT(drug_id)
        ORDER BY drug_id ASC) FROM drug WHERE
        concept_id IN(SELECT concept_id FROM concept_name WHERE name IN('Isoniazid'))
      ) AND d.quantity > 0
      AND o.start_date = (SELECT MAX(start_date) FROM orders t WHERE t.patient_id = o.patient_id
      AND t.start_date BETWEEN DATE_FORMAT(DATE(my_start_date), '%Y-%m-%d 00:00:00')
      AND DATE_FORMAT(DATE(my_end_date), '%Y-%m-%d 23:59:59')
      AND t.patient_id = my_patient_id
      ) GROUP BY o.patient_id);

  IF record_value IS NOT NULL THEN
    SET given = TRUE;
  END IF;


	RETURN given;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_has_side_effects` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_has_side_effects`(my_patient_id INT, my_end_date DATE) RETURNS varchar(7) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
  DECLARE mw_side_effects_concept_id INT;
  DECLARE yes_concept_id INT;
  DECLARE no_concept_id INT;
  DECLARE side_effect INT;
  DECLARE latest_obs_date DATE;

  SET mw_side_effects_concept_id = (SELECT concept_id FROM concept_name
    WHERE name IN('Malawi ART Side Effects') AND voided = 0 LIMIT 1);

  SET yes_concept_id = (SELECT concept_id FROM concept_name WHERE name = 'YES' LIMIT 1);
  SET no_concept_id = (SELECT concept_id FROM concept_name WHERE name = 'NO' LIMIT 1);

  SET latest_obs_date = (SELECT DATE(MAX(t.obs_datetime)) FROM obs t
        WHERE t.obs_datetime <= DATE_FORMAT(DATE(my_end_date), '%Y-%m-%d 23:59:59')
        AND t.concept_id = mw_side_effects_concept_id AND t.voided = 0
        AND t.person_id = my_patient_id);

  IF latest_obs_date IS NULL THEN
    return 'Unknown';
  END IF;



  SET side_effect = (SELECT value_coded FROM obs
      INNER JOIN temp_earliest_start_date e ON e.patient_id = obs.person_id
      WHERE obs_group_id IN (
      SELECT obs_id FROM obs
      WHERE concept_id = mw_side_effects_concept_id
        AND person_id = my_patient_id
        AND obs.obs_datetime BETWEEN DATE_FORMAT(DATE(latest_obs_date), '%Y-%m-%d 00:00:00')
        AND DATE_FORMAT(DATE(latest_obs_date), '%Y-%m-%d 23:59:59')
        AND DATE(obs_datetime) != DATE(e.date_enrolled)
      )GROUP BY concept_id HAVING value_coded = yes_concept_id LIMIT 1);

  IF side_effect IS NOT NULL THEN
    return 'Yes';
  END IF;


	RETURN 'No';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_max_defaulted_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_max_defaulted_date`(m_patient_id int, my_end_date DATETIME) RETURNS date
    DETERMINISTIC
BEGIN

DECLARE my_defaulted_date DATETIME;

set my_defaulted_date = (SELECT MAX(defaulted_date) FROM patient_defaulted_dates WHERE patient_id = m_patient_id AND start_date <= my_end_date);

RETURN my_defaulted_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_outcome` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_outcome`(patient_id INT, visit_date date) RETURNS varchar(25) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
DECLARE set_program_id INT;
DECLARE set_patient_state INT;
DECLARE set_outcome varchar(25);
DECLARE set_date_started date;
DECLARE set_patient_state_died INT;
DECLARE set_died_concept_id INT;
DECLARE set_timestamp DATETIME;
DECLARE dispensed_quantity INT;

SET set_timestamp = TIMESTAMP(CONCAT(DATE(visit_date), ' ', '23:59:59'));
SET set_program_id = (SELECT program_id FROM program WHERE name ="HIV PROGRAM" LIMIT 1);

SET set_patient_state = (SELECT state FROM `patient_state` INNER JOIN patient_program p ON p.patient_program_id = patient_state.patient_program_id AND p.program_id = set_program_id WHERE (patient_state.voided = 0 AND p.voided = 0 AND p.program_id = program_id AND DATE(start_date) <= visit_date AND p.patient_id = patient_id) AND (patient_state.voided = 0) ORDER BY start_date DESC, patient_state.patient_state_id DESC, patient_state.date_created DESC LIMIT 1);

IF set_patient_state = 1 THEN
  SET set_patient_state = current_defaulter(patient_id, set_timestamp);

  IF set_patient_state = 1 THEN
    SET set_outcome = 'Defaulted';
  ELSE
    SET set_outcome = 'Pre-ART (Continue)';
  END IF;
END IF;

IF set_patient_state = 2   THEN
  SET set_outcome = 'Patient transferred out';
END IF;

IF set_patient_state = 3 OR set_patient_state = 127 THEN
  SET set_outcome = 'Patient died';
END IF;


IF set_patient_state != 3 AND set_patient_state != 127 THEN
  SET set_patient_state_died = (SELECT state FROM `patient_state` INNER JOIN patient_program p ON p.patient_program_id = patient_state.patient_program_id AND p.program_id = set_program_id WHERE (patient_state.voided = 0 AND p.voided = 0 AND p.program_id = program_id AND DATE(start_date) <= visit_date AND p.patient_id = patient_id) AND (patient_state.voided = 0) AND state = 3 ORDER BY patient_state.patient_state_id DESC, patient_state.date_created DESC, start_date DESC LIMIT 1);

  SET set_died_concept_id = (SELECT concept_id FROM concept_name WHERE name = 'Patient died' LIMIT 1);

  IF set_patient_state_died IN(SELECT program_workflow_state_id FROM program_workflow_state WHERE concept_id = set_died_concept_id AND retired = 0) THEN
    SET set_outcome = 'Patient died';
    SET set_patient_state = 3;
  END IF;
END IF;



IF set_patient_state = 6 THEN
  SET set_outcome = 'Treatment stopped';
END IF;

IF set_patient_state = 7 OR set_outcome = 'Pre-ART (Continue)' OR set_outcome IS NULL THEN
  SET set_patient_state = current_defaulter(patient_id, set_timestamp);

  IF set_patient_state = 1 THEN
    SET set_outcome = 'Defaulted';
  END IF;

  IF set_patient_state = 0 OR set_outcome IS NULL THEN

    SET dispensed_quantity = (SELECT d.quantity
      FROM orders o
      INNER JOIN drug_order d ON d.order_id = o.order_id
      INNER JOIN drug ON drug.drug_id = d.drug_inventory_id
      WHERE o.patient_id = patient_id AND o.voided = 0
      AND d.drug_inventory_id IN(
        SELECT DISTINCT(drug_id) FROM drug WHERE
        concept_id IN(SELECT concept_id FROM concept_set WHERE concept_set=37989)
    ) AND DATE(o.start_date) <= visit_date AND d.quantity > 0 ORDER BY start_date DESC LIMIT 1);

    IF dispensed_quantity > 0 THEN
      SET set_outcome = 'On antiretrovirals';
    END IF;
  END IF;
END IF;

IF set_outcome IS NULL THEN
  SET set_patient_state = current_defaulter(patient_id, set_timestamp);

  IF set_patient_state = 1 THEN
    SET set_outcome = 'Defaulted';
  END IF;

  IF set_outcome IS NULL THEN
    SET set_outcome = 'Unknown';
  END IF;

END IF;

RETURN set_outcome;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_reason_for_starting_art` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_reason_for_starting_art`(my_patient_id INT) RETURNS int
    DETERMINISTIC
BEGIN
  DECLARE reason_for_art_eligibility INT DEFAULT 0;
  DECLARE reason_concept_id INT;
  DECLARE coded_concept_id INT;
  DECLARE max_obs_datetime DATETIME;

  SET reason_concept_id = (SELECT concept_id FROM concept_name WHERE name = 'Reason for ART eligibility' AND voided = 0 LIMIT 1);
  SET max_obs_datetime = (SELECT MAX(obs_datetime) FROM obs WHERE person_id = my_patient_id AND concept_id = reason_concept_id AND voided = 0);
  SET coded_concept_id = (SELECT value_coded FROM obs WHERE person_id = my_patient_id AND concept_id = reason_concept_id AND voided = 0 AND obs_datetime = max_obs_datetime  LIMIT 1);
  SET reason_for_art_eligibility = (coded_concept_id);


  RETURN reason_for_art_eligibility;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_reason_for_starting_art_text` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_reason_for_starting_art_text`(my_patient_id INT) RETURNS varchar(255) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
  DECLARE reason_for_art_eligibility VARCHAR(255);
  DECLARE reason_concept_id INT;
  DECLARE coded_concept_id INT;
  DECLARE max_obs_datetime DATETIME;

  SET reason_concept_id = (SELECT concept_id FROM concept_name WHERE name = 'Reason for ART eligibility' AND voided = 0 LIMIT 1);
  SET max_obs_datetime = (SELECT MAX(obs_datetime) FROM obs WHERE person_id = my_patient_id AND concept_id = reason_concept_id AND voided = 0);
  SET coded_concept_id = (SELECT value_coded FROM obs WHERE person_id = my_patient_id AND concept_id = reason_concept_id AND voided = 0 AND obs_datetime = max_obs_datetime  LIMIT 1);
  SET reason_for_art_eligibility = (SELECT name FROM concept_name WHERE concept_id = coded_concept_id AND LENGTH(name) > 0 LIMIT 1);

  RETURN reason_for_art_eligibility;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_screened_for_tb` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_screened_for_tb`(my_patient_id INT, my_start_date DATE, my_end_date DATE) RETURNS int
    DETERMINISTIC
BEGIN
	DECLARE screened INT DEFAULT FALSE;
	DECLARE record_value INT;

  SET record_value = (SELECT ob.person_id FROM obs ob
    INNER JOIN temp_earliest_start_date e
    ON e.patient_id = ob.person_id
    WHERE ob.concept_id IN(
      SELECT GROUP_CONCAT(DISTINCT(concept_id)
      ORDER BY concept_id ASC) FROM concept_name
      WHERE name IN('TB treatment','TB status') AND voided = 0
    ) AND ob.voided = 0
    AND ob.obs_datetime = (
    SELECT MAX(t.obs_datetime) FROM obs t WHERE
    t.obs_datetime BETWEEN DATE_FORMAT(DATE(my_start_date), '%Y-%m-%d 00:00:00')
    AND DATE_FORMAT(DATE(my_end_date), '%Y-%m-%d 23:59:59')
    AND t.person_id = ob.person_id AND t.concept_id IN(
      SELECT GROUP_CONCAT(DISTINCT(concept_id)
      ORDER BY concept_id ASC) FROM concept_name
      WHERE name IN('TB treatment','TB status') AND voided = 0))
    AND ob.person_id = my_patient_id
    GROUP BY ob.person_id);

  IF record_value IS NOT NULL THEN
    SET screened = TRUE;
  END IF;

	RETURN screened;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_start_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_start_date`(patient_id int) RETURNS varchar(10) CHARSET latin1
    DETERMINISTIC
BEGIN
DECLARE start_date VARCHAR(10);
DECLARE dispension_concept_id INT;
DECLARE arv_concept INT;

set dispension_concept_id = (SELECT concept_id FROM concept_name WHERE name = 'AMOUNT DISPENSED');
set arv_concept = (SELECT concept_id FROM concept_name WHERE name = "ANTIRETROVIRAL DRUGS");

set start_date = (SELECT MIN(DATE(obs_datetime)) FROM obs WHERE voided = 0 AND person_id = patient_id AND concept_id = dispension_concept_id AND value_drug IN (SELECT drug_id FROM drug d WHERE d.concept_id IN (SELECT cs.concept_id FROM concept_set cs WHERE cs.concept_set = arv_concept)));

RETURN start_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_tb_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_tb_status`(my_patient_id INT, my_end_date DATE) RETURNS int
    DETERMINISTIC
BEGIN
	DECLARE screened INT DEFAULT FALSE;
	DECLARE tb_status INT;
  DECLARE tb_status_concept_id INT;

  SET tb_status_concept_id = (SELECT concept_id FROM concept_name
    WHERE name IN('TB status') AND voided = 0 LIMIT 1);

  SET tb_status = (SELECT ob.value_coded FROM obs ob
    INNER JOIN concept_name cn
    ON ob.value_coded = cn.concept_id
    WHERE ob.concept_id = tb_status_concept_id AND ob.voided = 0
    AND ob.obs_datetime = (
    SELECT MAX(t.obs_datetime) FROM obs t WHERE
    t.obs_datetime <= DATE_FORMAT(DATE(my_end_date), '%Y-%m-%d 23:59:59')
    AND t.voided = 0 AND t.person_id = ob.person_id AND t.concept_id = tb_status_concept_id)
    AND ob.person_id = my_patient_id
    GROUP BY ob.person_id);

	RETURN tb_status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `patient_who_stage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `patient_who_stage`(my_patient_id INT) RETURNS varchar(50) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
  DECLARE who_stage VARCHAR(255);
  DECLARE reason_concept_id INT;
  DECLARE coded_concept_id INT;
  DECLARE max_obs_datetime DATETIME;

  SET reason_concept_id = (SELECT concept_id FROM concept_name WHERE name = 'WHO stage' AND voided = 0 LIMIT 1);
  SET max_obs_datetime = (SELECT MAX(obs_datetime) FROM obs WHERE person_id = my_patient_id AND concept_id = reason_concept_id AND voided = 0);
  SET coded_concept_id = (SELECT value_coded FROM obs WHERE person_id = my_patient_id AND concept_id = reason_concept_id AND voided = 0 AND obs_datetime = max_obs_datetime  LIMIT 1);
  SET who_stage = (SELECT name FROM concept_name WHERE concept_id = coded_concept_id AND LENGTH(name) > 0 LIMIT 1);

  RETURN who_stage;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `pepfar_patient_outcome` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `pepfar_patient_outcome`(patient_id INT, visit_date date) RETURNS varchar(25) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
DECLARE set_program_id INT;
DECLARE set_patient_state INT;
DECLARE set_outcome varchar(25);
DECLARE set_date_started date;
DECLARE set_patient_state_died INT;
DECLARE set_died_concept_id INT;
DECLARE set_timestamp DATETIME;
DECLARE dispensed_quantity INT;

SET set_timestamp = TIMESTAMP(CONCAT(DATE(visit_date), ' ', '23:59:59'));
SET set_program_id = (SELECT program_id FROM program WHERE name ="HIV PROGRAM" LIMIT 1);

SET set_patient_state = (SELECT state FROM `patient_state` INNER JOIN patient_program p ON p.patient_program_id = patient_state.patient_program_id AND p.program_id = set_program_id WHERE (patient_state.voided = 0 AND p.voided = 0 AND p.program_id = program_id AND DATE(start_date) <= visit_date AND p.patient_id = patient_id) AND (patient_state.voided = 0) ORDER BY start_date DESC, patient_state.patient_state_id DESC, patient_state.date_created DESC LIMIT 1);

IF set_patient_state = 1 THEN
  SET set_patient_state = current_pepfar_defaulter(patient_id, set_timestamp);

  IF set_patient_state = 1 THEN
    SET set_outcome = 'Defaulted';
  ELSE
    SET set_outcome = 'Pre-ART (Continue)';
  END IF;
END IF;

IF set_patient_state = 2   THEN
  SET set_outcome = 'Patient transferred out';
END IF;

IF set_patient_state = 3 OR set_patient_state = 127 THEN
  SET set_outcome = 'Patient died';
END IF;


IF set_patient_state != 3 AND set_patient_state != 127 THEN
  SET set_patient_state_died = (SELECT state FROM `patient_state` INNER JOIN patient_program p ON p.patient_program_id = patient_state.patient_program_id AND p.program_id = set_program_id WHERE (patient_state.voided = 0 AND p.voided = 0 AND p.program_id = program_id AND DATE(start_date) <= visit_date AND p.patient_id = patient_id) AND (patient_state.voided = 0) AND state = 3 ORDER BY patient_state.patient_state_id DESC, patient_state.date_created DESC, start_date DESC LIMIT 1);

  SET set_died_concept_id = (SELECT concept_id FROM concept_name WHERE name = 'Patient died' LIMIT 1);

  IF set_patient_state_died IN(SELECT program_workflow_state_id FROM program_workflow_state WHERE concept_id = set_died_concept_id AND retired = 0) THEN
    SET set_outcome = 'Patient died';
    SET set_patient_state = 3;
  END IF;
END IF;



IF set_patient_state = 6 THEN
  SET set_outcome = 'Treatment stopped';
END IF;

IF set_patient_state = 7 OR set_outcome = 'Pre-ART (Continue)' OR set_outcome IS NULL THEN

  SET set_patient_state = current_pepfar_defaulter(patient_id, set_timestamp);

  IF set_patient_state = 1 THEN
    SET set_outcome = 'Defaulted';
  END IF;

  IF set_patient_state = 0 OR set_outcome IS NULL THEN

    SET dispensed_quantity = (SELECT d.quantity
      FROM orders o
      INNER JOIN drug_order d ON d.order_id = o.order_id
      INNER JOIN drug ON drug.drug_id = d.drug_inventory_id
      WHERE o.patient_id = patient_id AND d.drug_inventory_id IN(
        SELECT DISTINCT(drug_id) FROM drug WHERE
        concept_id IN(SELECT concept_id FROM concept_set WHERE concept_set = 1085)
    ) AND DATE(o.start_date) <= visit_date AND d.quantity > 0 ORDER BY start_date DESC LIMIT 1);

    IF dispensed_quantity > 0 THEN
      SET set_outcome = 'On antiretrovirals';
    END IF;
  END IF;
END IF;

IF set_outcome IS NULL THEN
  SET set_patient_state = current_pepfar_defaulter(patient_id, set_timestamp);

  IF set_patient_state = 1 THEN
    SET set_outcome = 'Defaulted';
  END IF;

  IF set_outcome IS NULL THEN
    SET set_outcome = 'Unknown';
  END IF;

END IF;

RETURN set_outcome;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `re_initiated_check` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `re_initiated_check`(set_patient_id INT, set_date_enrolled DATE) RETURNS varchar(15) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
DECLARE re_initiated VARCHAR(15) DEFAULT 'N/A';
DECLARE check_one INT DEFAULT 0;
DECLARE check_two INT DEFAULT 0;

DECLARE yes_concept INT;
DECLARE no_concept INT;
DECLARE date_art_last_taken_concept INT;
DECLARE taken_arvs_concept INT;

set yes_concept = (SELECT concept_id FROM concept_name WHERE name ='YES' LIMIT 1);
set no_concept = (SELECT concept_id FROM concept_name WHERE name ='NO' LIMIT 1);
set date_art_last_taken_concept = (SELECT concept_id FROM concept_name WHERE name ='DATE ART LAST TAKEN' LIMIT 1);

set check_one = (SELECT e.patient_id FROM clinic_registration_encounter e INNER JOIN ever_registered_obs AS ero ON e.encounter_id = ero.encounter_id INNER JOIN obs o ON o.encounter_id = e.encounter_id AND o.concept_id = date_art_last_taken_concept AND o.voided = 0 WHERE ((o.concept_id = date_art_last_taken_concept AND (TIMESTAMPDIFF(day, o.value_datetime, o.obs_datetime)) > 14)) AND patient_date_enrolled(e.patient_id) = set_date_enrolled AND e.patient_id = set_patient_id GROUP BY e.patient_id);

if check_one >= 1 then set re_initiated ="Re-initiated";
elseif check_two >= 1 then set re_initiated ="Re-initiated";
end if;

if check_one = 'N/A' then
  set taken_arvs_concept = (SELECT concept_id FROM concept_name WHERE name ='HAS THE PATIENT TAKEN ART IN THE LAST TWO MONTHS' LIMIT 1);
  set check_two = (SELECT e.patient_id FROM clinic_registration_encounter e INNER JOIN ever_registered_obs AS ero ON e.encounter_id = ero.encounter_id INNER JOIN obs o ON o.encounter_id = e.encounter_id AND o.concept_id = taken_arvs_concept AND o.voided = 0 WHERE  ((o.concept_id = taken_arvs_concept AND o.value_coded = no_concept)) AND patient_date_enrolled(e.patient_id) = set_date_enrolled AND e.patient_id = set_patient_id GROUP BY e.patient_id);

  if check_two >= 1 then set re_initiated ="Re-initiated";
  end if;
end if;

RETURN re_initiated;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `triage_covid_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `triage_covid_report`(obs_date VARCHAR(25), my_patient_id int) RETURNS varchar(15) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN

DECLARE count_obs VARCHAR(25);

SET count_obs = (SELECT DATE(`obs`.`obs_datetime`) FROM `obs`
                  INNER JOIN concept_name c ON c.concept_id = obs.concept_id
                  WHERE `obs`.`voided` = 0 AND DATE(`obs`.`obs_datetime`) =  DATE(obs_date) AND `obs`.`person_id` = my_patient_id
                  AND c.name IN('History of COVID-19 contact') AND c.voided = 0 LIMIT 1);

RETURN count_obs;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50001 DROP VIEW IF EXISTS `all_patient_identifiers`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `all_patient_identifiers` AS select `patient_identifier`.`patient_id` AS `patient_id`,max((case when (`patient_identifier`.`identifier_type` = 1) then `patient_identifier`.`identifier` end)) AS `openmrs_ident_type`,max((case when (`patient_identifier`.`identifier_type` = 3) then `patient_identifier`.`identifier` end)) AS `national_id`,max((case when (`patient_identifier`.`identifier_type` = 4) then `patient_identifier`.`identifier` end)) AS `arv_number`,max((case when (`patient_identifier`.`identifier_type` = 2) then `patient_identifier`.`identifier` end)) AS `legacy_id`,max((case when (`patient_identifier`.`identifier_type` = 5) then `patient_identifier`.`identifier` end)) AS `prev_art_number`,max((case when (`patient_identifier`.`identifier_type` = 7) then `patient_identifier`.`identifier` end)) AS `tb_number`,max((case when (`patient_identifier`.`identifier_type` = 17) then `patient_identifier`.`identifier` end)) AS `filing_number`,max((case when (`patient_identifier`.`identifier_type` = 18) then `patient_identifier`.`identifier` end)) AS `archived_filing_number`,max((case when (`patient_identifier`.`identifier_type` = 22) then `patient_identifier`.`identifier` end)) AS `pre_art_number` from `patient_identifier` where (`patient_identifier`.`voided` = 0) group by `patient_identifier`.`patient_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `all_patients_attributes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `all_patients_attributes` AS select `person_attribute`.`person_id` AS `person_id`,max((case when (`person_attribute`.`person_attribute_type_id` = 13) then `person_attribute`.`value` end)) AS `occupation`,max((case when (`person_attribute`.`person_attribute_type_id` = 12) then `person_attribute`.`value` end)) AS `cell_phone`,max((case when (`person_attribute`.`person_attribute_type_id` = 14) then `person_attribute`.`value` end)) AS `home_phone`,max((case when (`person_attribute`.`person_attribute_type_id` = 15) then `person_attribute`.`value` end)) AS `office_phone` from `person_attribute` where (`person_attribute`.`voided` = 0) group by `person_attribute`.`person_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `all_person_addresses`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `all_person_addresses` AS select `p`.`person_address_id` AS `person_address_id`,`p`.`person_id` AS `person_id`,`p`.`preferred` AS `preferred`,`p`.`address1` AS `address1`,`p`.`address2` AS `address2`,`p`.`city_village` AS `city_village`,`p`.`state_province` AS `state_province`,`p`.`postal_code` AS `postal_code`,`p`.`country` AS `country`,`p`.`latitude` AS `latitude`,`p`.`longitude` AS `longitude`,`p`.`creator` AS `creator`,`p`.`date_created` AS `date_created`,`p`.`voided` AS `voided`,`p`.`voided_by` AS `voided_by`,`p`.`date_voided` AS `date_voided`,`p`.`void_reason` AS `void_reason`,`p`.`county_district` AS `county_district`,`p`.`neighborhood_cell` AS `neighborhood_cell`,`p`.`region` AS `region`,`p`.`subregion` AS `subregion`,`p`.`township_division` AS `township_division`,`p`.`uuid` AS `uuid` from `person_address` `p` where ((`p`.`person_address_id` = (select max(`pad`.`person_address_id`) from `person_address` `pad` where ((`pad`.`person_id` = `p`.`person_id`) and (`pad`.`voided` = 0)))) and (`p`.`voided` = 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `amount_brought_back_obs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `amount_brought_back_obs` AS select `o`.`person_id` AS `person_id`,`o`.`encounter_id` AS `encounter_id`,`o`.`order_id` AS `order_id`,`o`.`obs_datetime` AS `obs_datetime`,`do`.`drug_inventory_id` AS `drug_inventory_id`,`do`.`equivalent_daily_dose` AS `equivalent_daily_dose`,`o`.`value_numeric` AS `value_numeric`,`do`.`quantity` AS `quantity` from ((`obs` `o` join `drug_order` `do` on((`o`.`order_id` = `do`.`order_id`))) join `arv_drug` `ad` on((`do`.`drug_inventory_id` = `ad`.`drug_id`))) where ((`o`.`concept_id` = 2540) and (`o`.`voided` = 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `amount_dispensed_obs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `amount_dispensed_obs` AS select `o`.`person_id` AS `person_id`,`o`.`encounter_id` AS `encounter_id`,`o`.`order_id` AS `order_id`,`o`.`obs_datetime` AS `obs_datetime`,`do`.`drug_inventory_id` AS `drug_inventory_id`,`do`.`equivalent_daily_dose` AS `equivalent_daily_dose`,`ord`.`start_date` AS `start_date`,`o`.`value_numeric` AS `value_numeric` from (((`obs` `o` join `orders` `ord` on(((`o`.`order_id` = `ord`.`order_id`) and (`ord`.`voided` = 0)))) join `drug_order` `do` on((`ord`.`order_id` = `do`.`order_id`))) join `arv_drug` `ad` on((`do`.`drug_inventory_id` = `ad`.`drug_id`))) where ((`o`.`concept_id` = 2834) and (`o`.`voided` = 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `anc_visit_observations`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `anc_visit_observations` AS select `o`.`person_id` AS `person_id`,`e`.`encounter_id` AS `encounter_id`,`o`.`value_numeric` AS `value_numeric`,`e`.`encounter_datetime` AS `encounter_datetime` from (`encounter` `e` join `obs` `o` on(((`o`.`encounter_id` = `e`.`encounter_id`) and (`e`.`encounter_type` = 107) and (`o`.`concept_id` = 6189)))) where ((`o`.`voided` = 0) and (`e`.`voided` = 0)) order by `o`.`person_id`,`e`.`encounter_datetime` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `arv_drug`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `arv_drug` AS select `drug`.`drug_id` AS `drug_id` from `drug` where `drug`.`concept_id` in (select `concept_set`.`concept_id` from `concept_set` where (`concept_set`.`concept_set` = (select `concept_name`.`concept_id` from `concept_name` where (`concept_name`.`name` = 'Antiretroviral drugs') limit 1))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `arv_drugs_orders`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `arv_drugs_orders` AS select `ord`.`patient_id` AS `patient_id`,`ord`.`encounter_id` AS `encounter_id`,`ord`.`concept_id` AS `concept_id`,`ord`.`start_date` AS `start_date` from `orders` `ord` where ((`ord`.`voided` = 0) and `ord`.`concept_id` in (select `concept_set`.`concept_id` from `concept_set` where (`concept_set`.`concept_set` = 1085))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `clinic_consultation_encounter`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `clinic_consultation_encounter` AS select `encounter`.`encounter_id` AS `encounter_id`,`encounter`.`encounter_type` AS `encounter_type`,`encounter`.`patient_id` AS `patient_id`,`encounter`.`provider_id` AS `provider_id`,`encounter`.`location_id` AS `location_id`,`encounter`.`form_id` AS `form_id`,`encounter`.`encounter_datetime` AS `encounter_datetime`,`encounter`.`creator` AS `creator`,`encounter`.`date_created` AS `date_created`,`encounter`.`voided` AS `voided`,`encounter`.`voided_by` AS `voided_by`,`encounter`.`date_voided` AS `date_voided`,`encounter`.`void_reason` AS `void_reason`,`encounter`.`uuid` AS `uuid`,`encounter`.`changed_by` AS `changed_by`,`encounter`.`date_changed` AS `date_changed` from `encounter` where ((`encounter`.`encounter_type` = 53) and (`encounter`.`voided` = 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `clinic_registration_encounter`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `clinic_registration_encounter` AS select `e`.`encounter_id` AS `encounter_id`,`e`.`encounter_type` AS `encounter_type`,`e`.`patient_id` AS `patient_id`,`e`.`provider_id` AS `provider_id`,`e`.`location_id` AS `location_id`,`e`.`form_id` AS `form_id`,`e`.`encounter_datetime` AS `encounter_datetime`,`e`.`creator` AS `creator`,`e`.`date_created` AS `date_created`,`e`.`voided` AS `voided`,`e`.`voided_by` AS `voided_by`,`e`.`date_voided` AS `date_voided`,`e`.`void_reason` AS `void_reason`,`e`.`uuid` AS `uuid`,`e`.`changed_by` AS `changed_by`,`e`.`date_changed` AS `date_changed` from `encounter` `e` where ((`e`.`encounter_type` = (select `encounter_type`.`encounter_type_id` from `encounter_type` where (`encounter_type`.`name` = 'HIV CLINIC REGISTRATION') limit 1)) and (`e`.`voided` = 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `earliest_start_date`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `earliest_start_date` AS select `p`.`patient_id` AS `patient_id`,`pe`.`gender` AS `gender`,`pe`.`birthdate` AS `birthdate`,`date_antiretrovirals_started`(`p`.`patient_id`,min(`s`.`start_date`)) AS `earliest_start_date`,cast(`patient_date_enrolled`(`p`.`patient_id`) as date) AS `date_enrolled`,`person`.`death_date` AS `death_date`,(select timestampdiff(YEAR,`pe`.`birthdate`,min(`s`.`start_date`))) AS `age_at_initiation`,(select timestampdiff(DAY,`pe`.`birthdate`,min(`s`.`start_date`))) AS `age_in_days` from (((`patient_program` `p` left join `person` `pe` on((`pe`.`person_id` = `p`.`patient_id`))) left join `patient_state` `s` on((`p`.`patient_program_id` = `s`.`patient_program_id`))) left join `person` on((`person`.`person_id` = `p`.`patient_id`))) where ((`p`.`voided` = 0) and (`s`.`voided` = 0) and (`p`.`program_id` = 1) and (`s`.`state` = 7)) group by `p`.`patient_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `ever_registered_obs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `ever_registered_obs` AS select `obs`.`obs_id` AS `obs_id`,`obs`.`person_id` AS `person_id`,`obs`.`concept_id` AS `concept_id`,`obs`.`encounter_id` AS `encounter_id`,`obs`.`order_id` AS `order_id`,`obs`.`obs_datetime` AS `obs_datetime`,`obs`.`location_id` AS `location_id`,`obs`.`obs_group_id` AS `obs_group_id`,`obs`.`accession_number` AS `accession_number`,`obs`.`value_group_id` AS `value_group_id`,`obs`.`value_boolean` AS `value_boolean`,`obs`.`value_coded` AS `value_coded`,`obs`.`value_coded_name_id` AS `value_coded_name_id`,`obs`.`value_drug` AS `value_drug`,`obs`.`value_datetime` AS `value_datetime`,`obs`.`value_numeric` AS `value_numeric`,`obs`.`value_modifier` AS `value_modifier`,`obs`.`value_text` AS `value_text`,`obs`.`date_started` AS `date_started`,`obs`.`date_stopped` AS `date_stopped`,`obs`.`comments` AS `comments`,`obs`.`creator` AS `creator`,`obs`.`date_created` AS `date_created`,`obs`.`voided` AS `voided`,`obs`.`voided_by` AS `voided_by`,`obs`.`date_voided` AS `date_voided`,`obs`.`void_reason` AS `void_reason`,`obs`.`value_complex` AS `value_complex`,`obs`.`uuid` AS `uuid` from `obs` where ((`obs`.`concept_id` = (select `concept_name`.`concept_id` from `concept_name` where (`concept_name`.`name` = 'Ever registered at ART clinic') limit 1)) and (`obs`.`voided` = 0) and (`obs`.`value_coded` = (select `concept_name`.`concept_id` from `concept_name` where (`concept_name`.`name` = 'Yes') limit 1))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `guardians`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `guardians` AS select `r`.`person_a` AS `patient_id`,`r`.`person_b` AS `guardian_id`,`per`.`gender` AS `gender`,`p`.`given_name` AS `given_name`,`p`.`family_name` AS `family_name`,`p`.`middle_name` AS `middle_name`,`per`.`birthdate_estimated` AS `birthdate_estimated`,`per`.`birthdate` AS `birthdate`,`pa`.`address2` AS `home_district`,`pa`.`state_province` AS `current_district`,`pa`.`address1` AS `landmark`,`pa`.`city_village` AS `current_residence`,`pa`.`county_district` AS `traditional_authority` from (((`relationship` `r` join `person_name` `p` on((`p`.`person_id` = `r`.`person_b`))) left join `all_person_addresses` `pa` on((`pa`.`person_id` = `p`.`person_id`))) join `person` `per` on(((`per`.`person_id` = `p`.`person_id`) and (`p`.`voided` = 0)))) where ((`r`.`voided` = 0) and `r`.`person_a` in (select `e`.`patient_id` from `earliest_start_date` `e`)) order by `r`.`person_a` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `hiv_status_obs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `hiv_status_obs` AS select `o`.`person_id` AS `person_id`,`o`.`encounter_id` AS `encounter_id`,ifnull(`o`.`value_coded`,`o`.`value_text`) AS `hiv_status`,`o`.`obs_datetime` AS `obs_datetime` from `obs` `o` where ((`o`.`concept_id` = 3753) and (`o`.`voided` = 0)) order by `o`.`person_id`,`o`.`obs_datetime` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `hiv_test_and_hiv_test_date_obs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `hiv_test_and_hiv_test_date_obs` AS select `hs`.`person_id` AS `person_id`,`hs`.`encounter_id` AS `encounter_id`,`hs`.`hiv_status` AS `hiv_status`,`ht`.`hiv_test_date` AS `hiv_test_date`,`ht`.`obs_datetime` AS `obs_datetime` from (`hiv_status_obs` `hs` left join `hiv_test_date_obs` `ht` on(((`hs`.`person_id` = `ht`.`person_id`) and (`hs`.`encounter_id` = `ht`.`encounter_id`) and (cast(`hs`.`obs_datetime` as date) = cast(`ht`.`obs_datetime` as date))))) order by `ht`.`person_id`,`ht`.`obs_datetime` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `hiv_test_date_obs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `hiv_test_date_obs` AS select `obs`.`person_id` AS `person_id`,`obs`.`encounter_id` AS `encounter_id`,ifnull(`obs`.`value_datetime`,`obs`.`value_text`) AS `hiv_test_date`,`obs`.`obs_datetime` AS `obs_datetime` from `obs` where ((`obs`.`concept_id` = 1837) and (`obs`.`voided` = 0)) order by `obs`.`person_id`,`obs`.`obs_datetime` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `last_menstraul_period_date`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `last_menstraul_period_date` AS select `obs`.`person_id` AS `person_id`,`obs`.`encounter_id` AS `encounter_id`,`obs`.`value_datetime` AS `lmp`,`obs`.`obs_datetime` AS `obs_datetime`,`obs`.`date_created` AS `date_created` from `obs` where ((`obs`.`concept_id` = 968) and (`obs`.`voided` = 0)) order by `obs`.`person_id`,`obs`.`obs_datetime` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `patient_first_arv_amount_dispensed`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `patient_first_arv_amount_dispensed` AS select `enc`.`encounter_id` AS `encounter_id`,`enc`.`encounter_type` AS `encounter_type`,`enc`.`patient_id` AS `patient_id`,`enc`.`provider_id` AS `provider_id`,`enc`.`location_id` AS `location_id`,`enc`.`form_id` AS `form_id`,`enc`.`encounter_datetime` AS `encounter_datetime`,`enc`.`creator` AS `creator`,`enc`.`date_created` AS `date_created`,`enc`.`voided` AS `voided`,`enc`.`voided_by` AS `voided_by`,`enc`.`date_voided` AS `date_voided`,`enc`.`void_reason` AS `void_reason`,`enc`.`uuid` AS `uuid`,`enc`.`changed_by` AS `changed_by`,`enc`.`date_changed` AS `date_changed` from `encounter` `enc` where ((`enc`.`encounter_type` = 54) and (`enc`.`voided` = 0) and (cast(`enc`.`encounter_datetime` as date) = (select cast(min(`e`.`encounter_datetime`) as date) from `encounter` `e` where ((`e`.`patient_id` = `enc`.`patient_id`) and (`e`.`encounter_type` = `enc`.`encounter_type`) and (`e`.`voided` = 0))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `patient_pregnant_obs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `patient_pregnant_obs` AS select `obs`.`obs_id` AS `obs_id`,`obs`.`person_id` AS `person_id`,`obs`.`concept_id` AS `concept_id`,`obs`.`encounter_id` AS `encounter_id`,`obs`.`order_id` AS `order_id`,`obs`.`obs_datetime` AS `obs_datetime`,`obs`.`location_id` AS `location_id`,`obs`.`obs_group_id` AS `obs_group_id`,`obs`.`accession_number` AS `accession_number`,`obs`.`value_group_id` AS `value_group_id`,`obs`.`value_boolean` AS `value_boolean`,`obs`.`value_coded` AS `value_coded`,`obs`.`value_coded_name_id` AS `value_coded_name_id`,`obs`.`value_drug` AS `value_drug`,`obs`.`value_datetime` AS `value_datetime`,`obs`.`value_numeric` AS `value_numeric`,`obs`.`value_modifier` AS `value_modifier`,`obs`.`value_text` AS `value_text`,`obs`.`date_started` AS `date_started`,`obs`.`date_stopped` AS `date_stopped`,`obs`.`comments` AS `comments`,`obs`.`creator` AS `creator`,`obs`.`date_created` AS `date_created`,`obs`.`voided` AS `voided`,`obs`.`voided_by` AS `voided_by`,`obs`.`date_voided` AS `date_voided`,`obs`.`void_reason` AS `void_reason`,`obs`.`value_complex` AS `value_complex`,`obs`.`uuid` AS `uuid` from (`obs` join `person` on((`person`.`person_id` = `obs`.`person_id`))) where ((`obs`.`concept_id` in (6131,1755,7972)) and (`obs`.`value_coded` = 1065) and (`obs`.`voided` = 0) and (`person`.`gender` = 'F')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `patient_state_on_arvs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `patient_state_on_arvs` AS select `patient_state`.`patient_state_id` AS `patient_state_id`,`patient_state`.`patient_program_id` AS `patient_program_id`,`patient_state`.`state` AS `state`,`patient_state`.`start_date` AS `start_date`,`patient_state`.`end_date` AS `end_date`,`patient_state`.`creator` AS `creator`,`patient_state`.`date_created` AS `date_created`,`patient_state`.`changed_by` AS `changed_by`,`patient_state`.`date_changed` AS `date_changed`,`patient_state`.`voided` AS `voided`,`patient_state`.`voided_by` AS `voided_by`,`patient_state`.`date_voided` AS `date_voided`,`patient_state`.`void_reason` AS `void_reason`,`patient_state`.`uuid` AS `uuid` from `patient_state` where ((`patient_state`.`state` = 7) and (`patient_state`.`voided` = 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `patients_demographics`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `patients_demographics` AS select `esd`.`patient_id` AS `patient_id`,`p`.`given_name` AS `given_name`,`p`.`family_name` AS `family_name`,`p`.`middle_name` AS `middle_name`,`per`.`gender` AS `gender`,`per`.`birthdate_estimated` AS `birthdate_estimated`,`per`.`birthdate` AS `birthdate`,`pa`.`address2` AS `home_district`,`pa`.`state_province` AS `current_district`,`pa`.`address1` AS `landmark`,`pa`.`city_village` AS `current_residence`,`pa`.`county_district` AS `traditional_authority`,`esd`.`date_enrolled` AS `date_enrolled`,`esd`.`earliest_start_date` AS `earliest_start_date`,`esd`.`death_date` AS `death_date`,`esd`.`age_at_initiation` AS `age_at_initiation`,`esd`.`age_in_days` AS `age_in_days` from (((`earliest_start_date` `esd` join `person_name` `p` on(((`p`.`person_id` = `esd`.`patient_id`) and (`p`.`voided` = 0)))) left join `all_person_addresses` `pa` on(((`pa`.`person_id` = `p`.`person_id`) and (`pa`.`voided` = 0)))) join `person` `per` on(((`per`.`person_id` = `p`.`person_id`) and (`per`.`voided` = 0)))) group by `esd`.`patient_id` order by `esd`.`patient_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `patients_on_arvs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `patients_on_arvs` AS select `p`.`patient_id` AS `patient_id`,`person`.`birthdate` AS `birthdate`,`date_antiretrovirals_started`(`p`.`patient_id`,min(`s`.`start_date`)) AS `earliest_start_date`,`person`.`death_date` AS `death_date`,`person`.`gender` AS `gender`,((to_days(`date_antiretrovirals_started`(`p`.`patient_id`,min(`s`.`start_date`))) - to_days(`person`.`birthdate`)) / 365.25) AS `age_at_initiation`,(to_days(min(`s`.`start_date`)) - to_days(`person`.`birthdate`)) AS `age_in_days` from ((`patient_program` `p` left join `patient_state` `s` on((`p`.`patient_program_id` = `s`.`patient_program_id`))) left join `person` on((`person`.`person_id` = `p`.`patient_id`))) where ((`p`.`voided` = 0) and (`s`.`voided` = 0) and (`p`.`program_id` = 1) and (`s`.`state` = 7)) group by `p`.`patient_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `patients_with_has_transfer_letter_yes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `patients_with_has_transfer_letter_yes` AS select `o`.`person_id` AS `person_id`,`p`.`gender` AS `gender`,`o`.`obs_datetime` AS `obs_datetime`,`o`.`date_created` AS `date_created`,`e`.`earliest_start_date` AS `earliest_start_date` from ((`obs` `o` join `person` `p` on(((`p`.`person_id` = `o`.`person_id`) and (`p`.`voided` = 0) and (`o`.`voided` = 0)))) join `earliest_start_date` `e` on((`e`.`patient_id` = `o`.`person_id`))) where ((`o`.`concept_id` = 6393) and (`o`.`value_coded` = 1065) and (`o`.`voided` = 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `reason_for_art_eligibility_obs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `reason_for_art_eligibility_obs` AS select `o`.`person_id` AS `person_id`,`o`.`concept_id` AS `concept_id`,`o`.`obs_datetime` AS `obs_datetime`,`n`.`name` AS `name` from (`obs` `o` left join `concept_name` `n` on(((`n`.`concept_id` = `o`.`value_coded`) and (`n`.`concept_name_type` = 'FULLY_SPECIFIED') and (`n`.`voided` = 0)))) where ((`o`.`concept_id` = 7563) and (`o`.`voided` = 0)) order by `o`.`obs_datetime` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `reason_for_eligibility_obs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `reason_for_eligibility_obs` AS select `e`.`patient_id` AS `patient_id`,`n`.`name` AS `reason_for_eligibility`,`o`.`obs_datetime` AS `obs_datetime`,`e`.`earliest_start_date` AS `earliest_start_date`,`e`.`date_enrolled` AS `date_enrolled` from ((`earliest_start_date` `e` left join `obs` `o` on(((`e`.`patient_id` = `o`.`person_id`) and (`o`.`concept_id` = 7563) and (`o`.`voided` = 0)))) left join `concept_name` `n` on(((`n`.`concept_id` = `o`.`value_coded`) and (`n`.`concept_name_type` = 'FULLY_SPECIFIED') and (`n`.`voided` = 0)))) order by `e`.`patient_id`,`o`.`obs_datetime` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `regimen_observation`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `regimen_observation` AS select `obs`.`obs_id` AS `obs_id`,`obs`.`person_id` AS `person_id`,`obs`.`concept_id` AS `concept_id`,`obs`.`encounter_id` AS `encounter_id`,`obs`.`order_id` AS `order_id`,`obs`.`obs_datetime` AS `obs_datetime`,`obs`.`location_id` AS `location_id`,`obs`.`obs_group_id` AS `obs_group_id`,`obs`.`accession_number` AS `accession_number`,`obs`.`value_group_id` AS `value_group_id`,`obs`.`value_boolean` AS `value_boolean`,`obs`.`value_coded` AS `value_coded`,`obs`.`value_coded_name_id` AS `value_coded_name_id`,`obs`.`value_drug` AS `value_drug`,`obs`.`value_datetime` AS `value_datetime`,`obs`.`value_numeric` AS `value_numeric`,`obs`.`value_modifier` AS `value_modifier`,`obs`.`value_text` AS `value_text`,`obs`.`date_started` AS `date_started`,`obs`.`date_stopped` AS `date_stopped`,`obs`.`comments` AS `comments`,`obs`.`creator` AS `creator`,`obs`.`date_created` AS `date_created`,`obs`.`voided` AS `voided`,`obs`.`voided_by` AS `voided_by`,`obs`.`date_voided` AS `date_voided`,`obs`.`void_reason` AS `void_reason`,`obs`.`value_complex` AS `value_complex`,`obs`.`uuid` AS `uuid` from `obs` where ((`obs`.`concept_id` = 2559) and (`obs`.`voided` = 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `start_date_observation`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `start_date_observation` AS select `obs`.`person_id` AS `person_id`,`obs`.`obs_datetime` AS `obs_datetime`,`obs`.`value_datetime` AS `value_datetime` from `obs` where ((`obs`.`concept_id` = 2516) and (`obs`.`voided` = 0)) group by `obs`.`person_id`,`obs`.`value_datetime` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `tb_status_observations`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `tb_status_observations` AS select `obs`.`obs_id` AS `obs_id`,`obs`.`person_id` AS `person_id`,`obs`.`concept_id` AS `concept_id`,`obs`.`encounter_id` AS `encounter_id`,`obs`.`order_id` AS `order_id`,`obs`.`obs_datetime` AS `obs_datetime`,`obs`.`location_id` AS `location_id`,`obs`.`obs_group_id` AS `obs_group_id`,`obs`.`accession_number` AS `accession_number`,`obs`.`value_group_id` AS `value_group_id`,`obs`.`value_boolean` AS `value_boolean`,`obs`.`value_coded` AS `value_coded`,`obs`.`value_coded_name_id` AS `value_coded_name_id`,`obs`.`value_drug` AS `value_drug`,`obs`.`value_datetime` AS `value_datetime`,`obs`.`value_numeric` AS `value_numeric`,`obs`.`value_modifier` AS `value_modifier`,`obs`.`value_text` AS `value_text`,`obs`.`date_started` AS `date_started`,`obs`.`date_stopped` AS `date_stopped`,`obs`.`comments` AS `comments`,`obs`.`creator` AS `creator`,`obs`.`date_created` AS `date_created`,`obs`.`voided` AS `voided`,`obs`.`voided_by` AS `voided_by`,`obs`.`date_voided` AS `date_voided`,`obs`.`void_reason` AS `void_reason`,`obs`.`value_complex` AS `value_complex`,`obs`.`uuid` AS `uuid` from `obs` where ((`obs`.`concept_id` = 7459) and (`obs`.`voided` = 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

INSERT INTO `schema_migrations` (version) VALUES
('20260917000000'),
('20260916000000'),
('20260913000000'),
('20260904000000'),
('20260831010000'),
('20260821000000'),
('20260820000100'),
('20260820000000'),
('20260819170000'),
('20260818000000'),
('20260817000000'),
('20260814090000'),
('20260808000000'),
('20260803000000'),
('20260801000000'),
('20260728050000'),
('20260727000000'),
('20260711000000'),
('20260710000000'),
('20260709000000'),
('20260708000000'),
('20260625000001'),
('20260619000200'),
('20260619000100'),
('20260617000300'),
('20260617000200'),
('20260617000100'),
('20260612000000'),
('20260611000000'),
('20260610000001'),
('20260610000000'),
('20260608000000'),
('20260603093000'),
('20260602090000'),
('20260602010000'),
('20260602000000'),
('20260522090000'),
('20260521001000'),
('20260521000000'),
('20260519090000'),
('20260507114610'),
('20260506062053'),
('20260506000001'),
('20260505090000'),
('20260427123000'),
('20260427120254'),
('20260421000001'),
('20260412181618'),
('20260408100000'),
('20260407183715'),
('20260407131425'),
('20260407124645'),
('20260405090000'),
('20260402000001'),
('20260327115337'),
('20260317013416'),
('20260218153035'),
('20260212100000'),
('20260212093000'),
('20260128095853'),
('20260128000000'),
('20260101000000'),
('20210126092910'),
('20210310115457'),
('20210323080140'),
('20210326195504'),
('20210407071728'),
('20210610095024'),
('20210807111531'),
('20260119104240'),
('20260119104241'),
('20260128111557'),
('20260226065149');

