CREATE DATABASE  IF NOT EXISTS `vitrapo` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `vitrapo`;
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: vitrapo
-- ------------------------------------------------------
-- Server version	8.0.35

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

--
-- Table structure for table `ACDMessage`
--

DROP TABLE IF EXISTS `ACDMessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ACDMessage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ACDId` int NOT NULL,
  `userId` int NOT NULL,
  `message` varchar(200) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ACDMessage`
--

LOCK TABLES `ACDMessage` WRITE;
/*!40000 ALTER TABLE `ACDMessage` DISABLE KEYS */;
/*!40000 ALTER TABLE `ACDMessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicant`
--

DROP TABLE IF EXISTS `applicant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicant` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `nationalId` char(10) DEFAULT NULL,
  `DestCountryId` int DEFAULT NULL,
  `VisaType` enum('education','job','tourist') DEFAULT NULL,
  `fieldOfStudy` varchar(100) DEFAULT NULL,
  `superVisorMobile` varchar(11) DEFAULT NULL,
  `studyLanguage` char(2) DEFAULT NULL,
  `fileNumber` varchar(100) DEFAULT NULL,
  `grade` varchar(50) DEFAULT NULL,
  `telephone` varchar(15) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `passportNumber` varchar(15) DEFAULT NULL,
  `passportExpireDate` timestamp NULL DEFAULT NULL,
  `passportIssueDate` timestamp NULL DEFAULT NULL,
  `address` text,
  `gender` enum('male','female','other') DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  KEY `applicant_FK` (`userId`),
  CONSTRAINT `applicant_FK` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicant`
--

LOCK TABLES `applicant` WRITE;
/*!40000 ALTER TABLE `applicant` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicantContractDocument`
--

DROP TABLE IF EXISTS `applicantContractDocument`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicantContractDocument` (
  `id` int NOT NULL AUTO_INCREMENT,
  `applicantId` int NOT NULL,
  `contractId` int NOT NULL,
  `documentId` int NOT NULL,
  `original` varchar(100) DEFAULT NULL,
  `translate` varchar(100) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  UNIQUE KEY `applicantContractDocument_UN` (`applicantId`,`contractId`,`documentId`),
  KEY `applicantContractDocument_FK_1` (`contractId`),
  KEY `applicantContractDocument_FK_2` (`documentId`),
  CONSTRAINT `applicantContractDocument_FK` FOREIGN KEY (`applicantId`) REFERENCES `applicant` (`id`),
  CONSTRAINT `applicantContractDocument_FK_1` FOREIGN KEY (`contractId`) REFERENCES `contracts` (`id`),
  CONSTRAINT `applicantContractDocument_FK_2` FOREIGN KEY (`documentId`) REFERENCES `documents` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicantContractDocument`
--

LOCK TABLES `applicantContractDocument` WRITE;
/*!40000 ALTER TABLE `applicantContractDocument` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicantContractDocument` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicantInformation`
--

DROP TABLE IF EXISTS `applicantInformation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicantInformation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `applicantId` int NOT NULL,
  `contractId` varchar(100) NOT NULL,
  `groupTitle` varchar(100) DEFAULT NULL,
  `groupDecription` varchar(100) DEFAULT NULL,
  `fields` json DEFAULT NULL,
  `values` json DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  UNIQUE KEY `applicantInformation_UN` (`applicantId`,`contractId`,`groupTitle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicantInformation`
--

LOCK TABLES `applicantInformation` WRITE;
/*!40000 ALTER TABLE `applicantInformation` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicantInformation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contracts`
--

DROP TABLE IF EXISTS `contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contracts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `applicantId` int NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `issueDate` timestamp NULL DEFAULT NULL,
  `executeDate` timestamp NULL DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `totalPrice` int DEFAULT NULL,
  `istallmetNumbers` tinyint DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  KEY `contracts_FK` (`applicantId`),
  CONSTRAINT `contracts_FK` FOREIGN KEY (`applicantId`) REFERENCES `applicant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contracts`
--

LOCK TABLES `contracts` WRITE;
/*!40000 ALTER TABLE `contracts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` char(2) DEFAULT NULL,
  `phoneCode` char(6) DEFAULT NULL,
  `threeDigitCode` char(3) DEFAULT NULL,
  `extraDetails` json DEFAULT NULL,
  `map` json DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  KEY `index2` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=258 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES (1,'AD','00376','AND','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"36\"}, \"phonecode\": \"00376\"}','2020-05-23 06:18:29',NULL),(2,'AE','00971','ARE','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"22\", \"pasargad\": \"20\"}, \"phonecode\": \"00971\"}','2020-05-23 06:18:29',NULL),(3,'AF','0093','AFG','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"109\", \"pasargad\": \"16\"}, \"phonecode\": \"0093\"}','2020-05-23 06:18:29',NULL),(4,'AG','001','ATG','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"35\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(5,'AI','001','AIA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(6,'AL','00355','ALB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"101\", \"pasargad\": \"33\"}, \"phonecode\": \"00355\"}','2020-05-23 06:18:29',NULL),(7,'AM','00374','ARM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"40\", \"pasargad\": \"7\"}, \"phonecode\": \"00374\"}','2020-05-23 06:18:29',NULL),(8,'AN','00599','ANT','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00599\"}','2020-05-23 06:18:29',NULL),(9,'AO','00244','AGO','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"37\"}, \"phonecode\": \"00244\"}','2020-05-23 06:18:29',NULL),(10,'AQ','00672','ATA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00672\"}','2020-05-23 06:18:29',NULL),(11,'AR','0054','ARG','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"36\", \"pasargad\": \"30\"}, \"phonecode\": \"0054\"}','2020-05-23 06:18:29',NULL),(12,'AS','001','ASM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(13,'AT','0043','AUT','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"18\", \"pasargad\": \"4\"}, \"phonecode\": \"0043\"}','2020-05-23 06:18:29',NULL),(14,'AU','0061','AUS','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"42\", \"pasargad\": \"11\"}, \"phonecode\": \"0061\"}','2020-05-23 06:18:29',NULL),(15,'AW','00297','ABW','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00297\"}','2020-05-23 06:18:29',NULL),(16,'AZ','00994','AZE','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"58\", \"pasargad\": \"194\"}, \"phonecode\": \"00994\"}','2020-05-23 06:18:29',NULL),(17,'BA','00994','BIH','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00994\"}','2020-05-23 06:18:29',NULL),(18,'BB','001','BRB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"38\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(19,'BD','00880','BGD','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"11\", \"pasargad\": \"48\"}, \"phonecode\": \"00880\"}','2020-05-23 06:18:29',NULL),(20,'BE','0032','BEL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"10\", \"pasargad\": \"45\"}, \"phonecode\": \"0032\"}','2020-05-23 06:18:29',NULL),(21,'BF','00226','BFA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"52\"}, \"phonecode\": \"00226\"}','2020-05-23 06:18:29',NULL),(22,'BG','00359','BGR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"50\", \"pasargad\": \"46\"}, \"phonecode\": \"00359\"}','2020-05-23 06:18:29',NULL),(23,'BH','00973','BHR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"31\", \"pasargad\": \"40\"}, \"phonecode\": \"00973\"}','2020-05-23 06:18:29',NULL),(24,'BI','00257','BDI','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"53\"}, \"phonecode\": \"00257\"}','2020-05-23 06:18:29',NULL),(25,'BJ','00229','BEN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"49\"}, \"phonecode\": \"00229\"}','2020-05-23 06:18:29',NULL),(26,'BM','001','BMU','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(27,'BN','00673','BRN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00673\"}','2020-05-23 06:18:29',NULL),(28,'BO','00591','BOL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"151\", \"pasargad\": \"55\"}, \"phonecode\": \"00591\"}','2020-05-23 06:18:29',NULL),(29,'BQ','00599',NULL,'{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00599\"}','2020-05-23 06:18:29',NULL),(30,'BR','0055','BRA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"48\", \"pasargad\": \"41\"}, \"phonecode\": \"0055\"}','2020-05-23 06:18:29',NULL),(31,'BS','001','BHS','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"39\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(32,'BT','00975','BTN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"50\"}, \"phonecode\": \"00975\"}','2020-05-23 06:18:29',NULL),(33,'BW','00267','BWA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"51\"}, \"phonecode\": \"00267\"}','2020-05-23 06:18:29',NULL),(34,'BY','00375','BLR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"117\", \"pasargad\": \"44\"}, \"phonecode\": \"00375\"}','2020-05-23 06:18:29',NULL),(35,'BZ','00501','BLZ','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"47\"}, \"phonecode\": \"00501\"}','2020-05-23 06:18:29',NULL),(36,'CA','001','CAN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"26\", \"pasargad\": \"127\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(37,'CB','001',NULL,'{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(38,'CC','0061','CCK','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"0061\"}','2020-05-23 06:18:29',NULL),(39,'CD','00243','COD','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00243\"}','2020-05-23 06:18:29',NULL),(40,'CF','00236','CAF','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"38\", \"pasargad\": \"32\"}, \"phonecode\": \"00236\"}','2020-05-23 06:18:29',NULL),(41,'CG','00242','COG','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00242\"}','2020-05-23 06:18:29',NULL),(42,'CH','0041','CHE','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"66\", \"pasargad\": \"2\"}, \"phonecode\": \"0041\"}','2020-05-23 06:18:29',NULL),(43,'CI','00225','CIV','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00225\"}','2020-05-23 06:18:29',NULL),(44,'CK','00682','COK','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00682\"}','2020-05-23 06:18:29',NULL),(45,'CL','0056','CHL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"124\", \"pasargad\": \"108\"}, \"phonecode\": \"0056\"}','2020-05-23 06:18:29',NULL),(46,'CM','00237','CMR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"126\"}, \"phonecode\": \"00237\"}','2020-05-23 06:18:29',NULL),(47,'CN','0086','CHN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"59\", \"pasargad\": \"78\"}, \"phonecode\": \"0086\"}','2020-05-23 06:18:29',NULL),(48,'CO','0057','COL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"105\", \"pasargad\": \"131\"}, \"phonecode\": \"0057\"}','2020-05-23 06:18:29',NULL),(49,'CR','00506','CRI','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"124\"}, \"phonecode\": \"00506\"}','2020-05-23 06:18:29',NULL),(50,'CU','0053','CUB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"84\", \"pasargad\": \"133\"}, \"phonecode\": \"0053\"}','2020-05-23 06:18:29',NULL),(51,'CV','00238','CPV','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"135\"}, \"phonecode\": \"00238\"}','2020-05-23 06:18:29',NULL),(52,'CW','00599',NULL,'{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00599\"}','2020-05-23 06:18:29',NULL),(53,'CX','0061','CXR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"0061\"}','2020-05-23 06:18:29',NULL),(54,'CY','00357','CYP','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"77\", \"pasargad\": \"120\"}, \"phonecode\": \"00357\"}','2020-05-23 06:18:29',NULL),(55,'CZ','00420','CZE','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"75\"}, \"phonecode\": \"00420\"}','2020-05-23 06:18:29',NULL),(56,'DE','0049','DEU','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"2\", \"pasargad\": \"1\"}, \"phonecode\": \"0049\"}','2020-05-23 06:18:29',NULL),(57,'DJ','00253','DJI','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"76\"}, \"phonecode\": \"00253\"}','2020-05-23 06:18:29',NULL),(58,'DK','0045','DNK','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"60\", \"pasargad\": \"79\"}, \"phonecode\": \"0045\"}','2020-05-23 06:18:29',NULL),(59,'DM','001','DMA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"81\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(60,'DO','001','DOM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(61,'DZ','00213','DZA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"106\", \"pasargad\": \"18\"}, \"phonecode\": \"00213\"}','2020-05-23 06:18:29',NULL),(62,'EC','00593','ECU','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"120\", \"pasargad\": \"17\"}, \"phonecode\": \"00593\"}','2020-05-23 06:18:29',NULL),(63,'EE','00372','EST','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"43\", \"pasargad\": \"12\"}, \"phonecode\": \"00372\"}','2020-05-23 06:18:29',NULL),(64,'EG','0020','EGY','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"27\", \"pasargad\": \"164\"}, \"phonecode\": \"0020\"}','2020-05-23 06:18:29',NULL),(65,'EH','00212','ESH','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00212\"}','2020-05-23 06:18:29',NULL),(66,'ER','00291','ERI','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"115\", \"pasargad\": \"8\"}, \"phonecode\": \"00291\"}','2020-05-23 06:18:29',NULL),(67,'ES','0034','ESP','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"17\", \"pasargad\": \"10\"}, \"phonecode\": \"0034\"}','2020-05-23 06:18:29',NULL),(68,'ET','00251','ETH','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"96\", \"pasargad\": \"5\"}, \"phonecode\": \"00251\"}','2020-05-23 06:18:29',NULL),(69,'FI','00358','FIN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"75\", \"pasargad\": \"117\"}, \"phonecode\": \"00358\"}','2020-05-23 06:18:29',NULL),(70,'FJ','00679','FJI','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"118\"}, \"phonecode\": \"00679\"}','2020-05-23 06:18:29',NULL),(71,'FK','00500','FLK','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00500\"}','2020-05-23 06:18:29',NULL),(72,'FM','00691','FSM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"175\"}, \"phonecode\": \"00691\"}','2020-05-23 06:18:29',NULL),(73,'FO','00298','FRO','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00298\"}','2020-05-23 06:18:29',NULL),(74,'FR','0033','FRA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"74\", \"pasargad\": \"115\"}, \"phonecode\": \"0033\"}','2020-05-23 06:18:29',NULL),(75,'GA','00241','GAB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"137\"}, \"phonecode\": \"00241\"}','2020-05-23 06:18:29',NULL),(76,'GB','0044','GBR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"3\", \"pasargad\": \"43\"}, \"phonecode\": \"0044\"}','2020-05-23 06:18:29',NULL),(77,'GD','001','GRD','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"139\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(78,'GE','00995','GEO','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"29\", \"pasargad\": \"140\"}, \"phonecode\": \"00995\"}','2020-05-23 06:18:29',NULL),(79,'GF','00594','GUF','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00594\"}','2020-05-23 06:18:29',NULL),(80,'GH','00233','GHA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"138\", \"pasargad\": \"114\"}, \"phonecode\": \"00233\"}','2020-05-23 06:18:29',NULL),(81,'GI','00350','GIB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00350\"}','2020-05-23 06:18:29',NULL),(82,'GL','00299','GRL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00299\"}','2020-05-23 06:18:29',NULL),(83,'GM','00220','GMB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"138\"}, \"phonecode\": \"00220\"}','2020-05-23 06:18:29',NULL),(84,'GN','00224','GIN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"142\", \"pasargad\": \"143\"}, \"phonecode\": \"00224\"}','2020-05-23 06:18:29',NULL),(85,'GP','00590','GLP','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00590\"}','2020-05-23 06:18:29',NULL),(86,'GQ','00240','GNQ','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"144\"}, \"phonecode\": \"00240\"}','2020-05-23 06:18:29',NULL),(87,'GR','0030','GRC','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"32\", \"pasargad\": \"190\"}, \"phonecode\": \"0030\"}','2020-05-23 06:18:29',NULL),(88,'GT','00502','GTM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"141\"}, \"phonecode\": \"00502\"}','2020-05-23 06:18:29',NULL),(89,'GU','001','GUM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(90,'GW','00245','GNB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00245\"}','2020-05-23 06:18:29',NULL),(91,'GY','00592','GUY','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"142\"}, \"phonecode\": \"00592\"}','2020-05-23 06:18:29',NULL),(92,'HK','00852','HKG','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"195\"}, \"phonecode\": \"00852\"}','2020-05-23 06:18:29',NULL),(93,'HN','00504','HND','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"185\"}, \"phonecode\": \"00504\"}','2020-05-23 06:18:29',NULL),(94,'HR','00385','HRV','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"82\", \"pasargad\": \"130\"}, \"phonecode\": \"00385\"}','2020-05-23 06:18:29',NULL),(95,'HT','00509','HTI','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"183\"}, \"phonecode\": \"00509\"}','2020-05-23 06:18:29',NULL),(96,'HU','0036','HUN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"20\", \"pasargad\": \"162\"}, \"phonecode\": \"0036\"}','2020-05-23 06:18:29',NULL),(97,'ID','0062','IDN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"47\", \"pasargad\": \"21\"}, \"phonecode\": \"0062\"}','2020-05-23 06:18:29',NULL),(98,'IE','00353','IRL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"103\", \"pasargad\": \"27\"}, \"phonecode\": \"00353\"}','2020-05-23 06:18:29',NULL),(99,'IL','00972','ISR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00972\"}','2020-05-23 06:18:29',NULL),(100,'IN','0091','IND','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"16\", \"pasargad\": \"191\"}, \"phonecode\": \"0091\"}','2020-05-23 06:18:29',NULL),(101,'IQ','00964','IRQ','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"71\", \"pasargad\": \"111\"}, \"phonecode\": \"00964\"}','2020-05-23 06:18:29',NULL),(102,'IR','0098','IRN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"0098\"}','2020-05-23 06:18:29',NULL),(103,'IS','00354','ISL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"29\"}, \"phonecode\": \"00354\"}','2020-05-23 06:18:29',NULL),(104,'IT','0039','ITA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"4\", \"pasargad\": \"28\"}, \"phonecode\": \"0039\"}','2020-05-23 06:18:29',NULL),(105,'JM','001','JAM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"73\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(106,'JO','00962','JOR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"121\", \"pasargad\": \"6\"}, \"phonecode\": \"00962\"}','2020-05-23 06:18:29',NULL),(107,'JP','0081','JPN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"15\", \"pasargad\": \"89\"}, \"phonecode\": \"0081\"}','2020-05-23 06:18:29',NULL),(108,'KE','00254','KEN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"111\", \"pasargad\": \"132\"}, \"phonecode\": \"00254\"}','2020-05-23 06:18:29',NULL),(109,'KG','00996','KGZ','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"78\", \"pasargad\": \"121\"}, \"phonecode\": \"00996\"}','2020-05-23 06:18:29',NULL),(110,'KH','00855','KHM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"81\", \"pasargad\": \"125\"}, \"phonecode\": \"00855\"}','2020-05-23 06:18:29',NULL),(111,'KI','00686','KIR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"136\"}, \"phonecode\": \"00686\"}','2020-05-23 06:18:29',NULL),(112,'KM','00269','COM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00269\"}','2020-05-23 06:18:29',NULL),(113,'KN','001','KNA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(114,'KP','00850','PRK','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00850\"}','2020-05-23 06:18:29',NULL),(115,'KR','0082','KOR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"0082\"}','2020-05-23 06:18:29',NULL),(116,'KW','00965','KWT','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"85\", \"pasargad\": \"134\"}, \"phonecode\": \"00965\"}','2020-05-23 06:18:29',NULL),(117,'KY','001','CYM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(118,'KZ','007','KAZ','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"79\", \"pasargad\": \"122\"}, \"phonecode\": \"007\"}','2020-05-23 06:18:29',NULL),(119,'LA','00856','LAO','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00856\"}','2020-05-23 06:18:29',NULL),(120,'LB','00961','LBN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"6\", \"pasargad\": \"147\"}, \"phonecode\": \"00961\"}','2020-05-23 06:18:29',NULL),(121,'LC','001','LCA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(122,'LI','00423','LIE','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"154\"}, \"phonecode\": \"00423\"}','2020-05-23 06:18:29',NULL),(123,'LK','0094','LKA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"64\", \"pasargad\": \"94\"}, \"phonecode\": \"0094\"}','2020-05-23 06:18:29',NULL),(124,'LR','00231','LBR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"152\"}, \"phonecode\": \"00231\"}','2020-05-23 06:18:29',NULL),(125,'LS','00266','LSO','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"149\"}, \"phonecode\": \"00266\"}','2020-05-23 06:18:29',NULL),(126,'LT','00352','LTU','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"9\", \"pasargad\": \"155\"}, \"phonecode\": \"00352\"}','2020-05-23 06:18:29',NULL),(127,'LU','00352','LUX','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"8\", \"pasargad\": \"151\"}, \"phonecode\": \"00352\"}','2020-05-23 06:18:29',NULL),(128,'LV','00371','LVA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"148\"}, \"phonecode\": \"00371\"}','2020-05-23 06:18:29',NULL),(129,'LY','00218','LBY','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00218\"}','2020-05-23 06:18:29',NULL),(130,'MA','00212','MAR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"140\", \"pasargad\": \"165\"}, \"phonecode\": \"00212\"}','2020-05-23 06:18:29',NULL),(131,'MB','0055',NULL,'{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"0055\"}','2020-05-23 06:18:29',NULL),(132,'MC','00377','MCO','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"173\"}, \"phonecode\": \"00377\"}','2020-05-23 06:18:29',NULL),(133,'MD','00373','MDA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"126\", \"pasargad\": \"172\"}, \"phonecode\": \"00373\"}','2020-05-23 06:18:29',NULL),(134,'ME','00382','MNE','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"122\", \"pasargad\": \"110\"}, \"phonecode\": \"00382\"}','2020-05-23 06:18:29',NULL),(135,'MG','00261','MDG','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00261\"}','2020-05-23 06:18:29',NULL),(136,'MH','00692','MHL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00692\"}','2020-05-23 06:18:29',NULL),(137,'MK','00389','MKD','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00389\"}','2020-05-23 06:18:29',NULL),(138,'ML','00223','MLI','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"108\", \"pasargad\": \"161\"}, \"phonecode\": \"00223\"}','2020-05-23 06:18:29',NULL),(139,'MM','0095','MMR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"49\", \"pasargad\": \"174\"}, \"phonecode\": \"0095\"}','2020-05-23 06:18:29',NULL),(140,'MN','00976','MNG','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"166\"}, \"phonecode\": \"00976\"}','2020-05-23 06:18:29',NULL),(141,'MO','00853','MAC','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00853\"}','2020-05-23 06:18:29',NULL),(142,'MP','001','MNP','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(143,'MQ','00596','MTQ','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00596\"}','2020-05-23 06:18:29',NULL),(144,'MR','00222','MRT','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"169\"}, \"phonecode\": \"00222\"}','2020-05-23 06:18:29',NULL),(145,'MS','001','MSR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(146,'MT','00356','MLT','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"94\", \"pasargad\": \"158\"}, \"phonecode\": \"00356\"}','2020-05-23 06:18:29',NULL),(147,'MU','00230','MUS','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00230\"}','2020-05-23 06:18:29',NULL),(148,'MV','00960','MDV','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00960\"}','2020-05-23 06:18:29',NULL),(149,'MW','00265','MWI','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"157\"}, \"phonecode\": \"00265\"}','2020-05-23 06:18:29',NULL),(150,'MX','0052','MEX','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"88\", \"pasargad\": \"168\"}, \"phonecode\": \"0052\"}','2020-05-23 06:18:29',NULL),(151,'MY','0060','MYS','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"30\", \"pasargad\": \"160\"}, \"phonecode\": \"0060\"}','2020-05-23 06:18:29',NULL),(152,'MZ','00258','MOZ','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"171\"}, \"phonecode\": \"00258\"}','2020-05-23 06:18:29',NULL),(153,'NA','00264','NAM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"176\"}, \"phonecode\": \"00264\"}','2020-05-23 06:18:29',NULL),(154,'NC','00687','NCL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00687\"}','2020-05-23 06:18:29',NULL),(155,'NE','00227','NER','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"179\"}, \"phonecode\": \"00227\"}','2020-05-23 06:18:29',NULL),(156,'NF','00672','NFK','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00672\"}','2020-05-23 06:18:29',NULL),(157,'NG','00234','NGA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"112\", \"pasargad\": \"180\"}, \"phonecode\": \"00234\"}','2020-05-23 06:18:29',NULL),(158,'NI','00505','NIC','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"181\"}, \"phonecode\": \"00505\"}','2020-05-23 06:18:29',NULL),(159,'NL','0031','NLD','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"25\", \"pasargad\": \"184\"}, \"phonecode\": \"0031\"}','2020-05-23 06:18:29',NULL),(160,'NO','0047','NOR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"87\", \"pasargad\": \"3\"}, \"phonecode\": \"0047\"}','2020-05-23 06:18:29',NULL),(161,'NP','00977','NPL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"178\"}, \"phonecode\": \"00977\"}','2020-05-23 06:18:29',NULL),(162,'NR','00674','NRU','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"177\"}, \"phonecode\": \"00674\"}','2020-05-23 06:18:29',NULL),(163,'NU','00683','NIU','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00683\"}','2020-05-23 06:18:29',NULL),(164,'NZ','0064','NZL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"63\", \"pasargad\": \"182\"}, \"phonecode\": \"0064\"}','2020-05-23 06:18:29',NULL),(165,'OM','00968','OMN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"73\", \"pasargad\": \"113\"}, \"phonecode\": \"00968\"}','2020-05-23 06:18:29',NULL),(166,'PA','00507','PAN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"107\", \"pasargad\": \"59\"}, \"phonecode\": \"00507\"}','2020-05-23 06:18:29',NULL),(167,'PE','0051','PER','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"148\", \"pasargad\": \"61\"}, \"phonecode\": \"0051\"}','2020-05-23 06:18:29',NULL),(168,'PF','00689','PYF','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00689\"}','2020-05-23 06:18:29',NULL),(169,'PG','00675','PNG','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"56\"}, \"phonecode\": \"00675\"}','2020-05-23 06:18:29',NULL),(170,'PH','0063','PHL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"76\", \"pasargad\": \"119\"}, \"phonecode\": \"0063\"}','2020-05-23 06:18:29',NULL),(171,'PK','0092','PAK','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"53\", \"pasargad\": \"58\"}, \"phonecode\": \"0092\"}','2020-05-23 06:18:29',NULL),(172,'PL','0048','POL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"28\", \"pasargad\": \"150\"}, \"phonecode\": \"0048\"}','2020-05-23 06:18:29',NULL),(173,'PM','00508','SPM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00508\"}','2020-05-23 06:18:29',NULL),(174,'PR','001','PRI','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(175,'PS','00970','PSE','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00970\"}','2020-05-23 06:18:29',NULL),(176,'PT','00351','PRT','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"54\", \"pasargad\": \"60\"}, \"phonecode\": \"00351\"}','2020-05-23 06:18:29',NULL),(177,'PW','00680','PLW','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00680\"}','2020-05-23 06:18:29',NULL),(178,'PY','00595','PRY','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"52\", \"pasargad\": \"57\"}, \"phonecode\": \"00595\"}','2020-05-23 06:18:29',NULL),(179,'QA','00974','QAT','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"80\", \"pasargad\": \"123\"}, \"phonecode\": \"00974\"}','2020-05-23 06:18:29',NULL),(180,'RE','00262','REU','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00262\"}','2020-05-23 06:18:29',NULL),(181,'RO','0040','ROU','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"61\", \"pasargad\": \"84\"}, \"phonecode\": \"0040\"}','2020-05-23 06:18:29',NULL),(182,'RS','00381','SRB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"122\", \"pasargad\": \"109\"}, \"phonecode\": \"00381\"}','2020-05-23 06:18:29',NULL),(183,'RU','007','RUS','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"12\", \"pasargad\": \"83\"}, \"phonecode\": \"007\"}','2020-05-23 06:18:29',NULL),(184,'RW','00250','RWA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"82\"}, \"phonecode\": \"00250\"}','2020-05-23 06:18:29',NULL),(185,'SA','00966','SAU','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"72\", \"pasargad\": \"112\"}, \"phonecode\": \"00966\"}','2020-05-23 06:18:29',NULL),(186,'SB','00677','SLB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"74\"}, \"phonecode\": \"00677\"}','2020-05-23 06:18:29',NULL),(187,'SC','00248','SYC','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00248\"}','2020-05-23 06:18:29',NULL),(188,'SD','00249','SDN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"67\", \"pasargad\": \"101\"}, \"phonecode\": \"00249\"}','2020-05-23 06:18:29',NULL),(189,'SE','0046','SWE','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"35\", \"pasargad\": \"105\"}, \"phonecode\": \"0046\"}','2020-05-23 06:18:29',NULL),(190,'SG','0065','SGP','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"65\", \"pasargad\": \"98\"}, \"phonecode\": \"0065\"}','2020-05-23 06:18:29',NULL),(191,'SH','00290','SHN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00290\"}','2020-05-23 06:18:29',NULL),(192,'SI','00386','SVN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"45\", \"pasargad\": \"15\"}, \"phonecode\": \"00386\"}','2020-05-23 06:18:29',NULL),(193,'SK','00421','SVK','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"44\", \"pasargad\": \"14\"}, \"phonecode\": \"00421\"}','2020-05-23 06:18:29',NULL),(194,'SL','00232','SLE','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"70\", \"pasargad\": \"106\"}, \"phonecode\": \"00232\"}','2020-05-23 06:18:29',NULL),(195,'SM','00378','SMR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"92\"}, \"phonecode\": \"00378\"}','2020-05-23 06:18:29',NULL),(196,'SN','00221','SEN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"141\", \"pasargad\": \"99\"}, \"phonecode\": \"00221\"}','2020-05-23 06:18:29',NULL),(197,'SO','00252','SOM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"96\", \"pasargad\": \"104\"}, \"phonecode\": \"00252\"}','2020-05-23 06:18:29',NULL),(198,'SR','00597','SUR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"102\"}, \"phonecode\": \"00597\"}','2020-05-23 06:18:29',NULL),(199,'SS','00211',NULL,'{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00211\"}','2020-05-23 06:18:29',NULL),(200,'ST','00503','STP','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00503\"}','2020-05-23 06:18:29',NULL),(201,'SV','00503','SLV','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"19\"}, \"phonecode\": \"00503\"}','2020-05-23 06:18:29',NULL),(202,'SX','001',NULL,'{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(203,'SY','00963','SYR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00963\"}','2020-05-23 06:18:29',NULL),(204,'SZ','00268','SWZ','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"100\"}, \"phonecode\": \"00268\"}','2020-05-23 06:18:29',NULL),(205,'TC','001','TCA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(206,'TD','00235','TCD','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"77\"}, \"phonecode\": \"00235\"}','2020-05-23 06:18:29',NULL),(207,'TG','00228','TGO','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"69\"}, \"phonecode\": \"00228\"}','2020-05-23 06:18:29',NULL),(208,'TH','0066','THA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"56\", \"pasargad\": \"64\"}, \"phonecode\": \"0066\"}','2020-05-23 06:18:29',NULL),(209,'TJ','00690','TJK','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"55\", \"pasargad\": \"62\"}, \"phonecode\": \"00690\"}','2020-05-23 06:18:29',NULL),(210,'TK','00690','TKL','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00690\"}','2020-05-23 06:18:29',NULL),(211,'TL','00670','TLS','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00670\"}','2020-05-23 06:18:29',NULL),(212,'TM','00993','TKM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"57\", \"pasargad\": \"66\"}, \"phonecode\": \"00993\"}','2020-05-23 06:18:29',NULL),(213,'TN','00216','TUN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"119\", \"pasargad\": \"70\"}, \"phonecode\": \"00216\"}','2020-05-23 06:18:29',NULL),(214,'TO','00676','TON','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"71\"}, \"phonecode\": \"00676\"}','2020-05-23 06:18:29',NULL),(215,'TP','00670',NULL,'{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00670\"}','2020-05-23 06:18:29',NULL),(216,'TR','0090','TUR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"5\", \"pasargad\": \"67\"}, \"phonecode\": \"0090\"}','2020-05-23 06:18:29',NULL),(217,'TT','001','TTO','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"68\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(218,'TV','00688','TUV','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"72\"}, \"phonecode\": \"00688\"}','2020-05-23 06:18:29',NULL),(219,'TW','00886','TWN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"65\"}, \"phonecode\": \"00886\"}','2020-05-23 06:18:29',NULL),(220,'TZ','00255','TZA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00255\"}','2020-05-23 06:18:29',NULL),(221,'UA','00380','UKR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"135\", \"pasargad\": \"24\"}, \"phonecode\": \"00380\"}','2020-05-23 06:18:29',NULL),(222,'UG','00256','UGA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"25\"}, \"phonecode\": \"00256\"}','2020-05-23 06:18:29',NULL),(223,'UM','00246','UMI','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00246\"}','2020-05-23 06:18:29',NULL),(224,'US','001','USA','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(225,'UY','00598','URY','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"130\", \"pasargad\": \"23\"}, \"phonecode\": \"00598\"}','2020-05-23 06:18:29',NULL),(226,'UZ','00998','UZB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"41\", \"pasargad\": \"9\"}, \"phonecode\": \"00998\"}','2020-05-23 06:18:29',NULL),(227,'VA','00379','VAT','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00379\"}','2020-05-23 06:18:29',NULL),(228,'VC','001','VCT','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(229,'VE','0058','VEN','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"116\", \"pasargad\": \"188\"}, \"phonecode\": \"0058\"}','2020-05-23 06:18:29',NULL),(230,'VG','001','VGB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(231,'VI','001','VIR','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"001\"}','2020-05-23 06:18:29',NULL),(232,'VN','0085','VNM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"21\", \"pasargad\": \"192\"}, \"phonecode\": \"0084\"}','2020-05-23 06:18:29',NULL),(233,'VU','00678','VUT','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"187\"}, \"phonecode\": \"00678\"}','2020-05-23 06:18:29',NULL),(234,'WF','00681','WLF','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00681\"}','2020-05-23 06:18:29',NULL),(235,'WS','00685','WSM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00685\"}','2020-05-23 06:18:29',NULL),(236,'YE','00967','YEM','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00967\"}','2020-05-23 06:18:29',NULL),(237,'YT','00262','MYT','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"null\"}, \"phonecode\": \"00262\"}','2020-05-23 06:18:29',NULL),(238,'ZA','0027','ZAF','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"37\", \"pasargad\": \"31\"}, \"phonecode\": \"0027\"}','2020-05-23 06:18:29',NULL),(239,'ZM','00260','ZMB','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"null\", \"pasargad\": \"85\"}, \"phonecode\": \"00260\"}','2020-05-23 06:18:29',NULL),(240,'ZW','00263','ZWE','{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"129\", \"pasargad\": \"87\"}, \"phonecode\": \"00263\"}','2020-05-23 06:18:29',NULL),(256,'EX','00363',NULL,'{\"flag\": \"??\"}','{\"flag\": \"??\", \"insurance\": {\"saman\": \"129\", \"pasargad\": \"87\"}, \"phonecode\": \"00263\"}','2020-06-07 11:56:34',NULL);
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countryTranslation`
--

DROP TABLE IF EXISTS `countryTranslation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countryTranslation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `countryId` int DEFAULT NULL,
  `languageId` int DEFAULT NULL,
  `languageAbbr` char(2) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `continent` varchar(45) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index7` (`countryId`,`languageId`),
  KEY `index2` (`countryId`),
  KEY `index3` (`languageId`),
  KEY `index4` (`name`),
  KEY `index5` (`continent`),
  KEY `index6` (`languageId`,`countryId`)
) ENGINE=InnoDB AUTO_INCREMENT=1234 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countryTranslation`
--

LOCK TABLES `countryTranslation` WRITE;
/*!40000 ALTER TABLE `countryTranslation` DISABLE KEYS */;
INSERT INTO `countryTranslation` VALUES (1,1,1,'en','Andorra','Sw Europe','2020-05-23 06:58:56',NULL),(2,2,1,'en','United Arab Emirates','Middle East','2020-05-23 06:58:56',NULL),(3,3,1,'en','Afghanistan','Asia','2020-05-23 06:58:56',NULL),(4,4,1,'en','Antigua And Barbuda','Caribbean','2020-05-23 06:58:56',NULL),(5,5,1,'en','Anguilla','Caribbean','2020-05-23 06:58:56',NULL),(6,6,1,'en','Albania','Europe','2020-05-23 06:58:56',NULL),(7,7,1,'en','Armenia','Euro-Asia','2020-05-23 06:58:56',NULL),(8,8,1,'en','Netherlands Antilles','Caribbean','2020-05-23 06:58:56',NULL),(9,9,1,'en','Angola','Sw Africa','2020-05-23 06:58:56',NULL),(10,10,1,'en','Antarctica','S Pacific','2020-05-23 06:58:56',NULL),(11,11,1,'en','Argentina','S America','2020-05-23 06:58:56',NULL),(12,12,1,'en','American Samoa','Sw Pacific','2020-05-23 06:58:56',NULL),(13,13,1,'en','Austria','C Europe','2020-05-23 06:58:56',NULL),(14,14,1,'en','Australia','Sw Pacific','2020-05-23 06:58:56',NULL),(15,15,1,'en','Aruba','Caribbean','2020-05-23 06:58:56',NULL),(16,16,1,'en','Azerbaijan','Euro-Asia','2020-05-23 06:58:56',NULL),(17,17,1,'en','Bosnia-Herzegovina','Europe','2020-05-23 06:58:56',NULL),(18,18,1,'en','Barbados','Caribbean','2020-05-23 06:58:56',NULL),(19,19,1,'en','Bangladesh','Asia','2020-05-23 06:58:56',NULL),(20,20,1,'en','Belgium','Europe','2020-05-23 06:58:56',NULL),(21,21,1,'en','Burkina Faso','Cw Africa','2020-05-23 06:58:56',NULL),(22,22,1,'en','Bulgaria','Europe','2020-05-23 06:58:56',NULL),(23,23,1,'en','Bahrain','Middle East','2020-05-23 06:58:56',NULL),(24,24,1,'en','Burundi','Ce Africa','2020-05-23 06:58:56',NULL),(25,25,1,'en','Benin','Cw Africa','2020-05-23 06:58:56',NULL),(26,26,1,'en','Bermuda','C Atlantic','2020-05-23 06:58:56',NULL),(27,27,1,'en','Brunei Darussalam','Se Asia','2020-05-23 06:58:56',NULL),(28,28,1,'en','Bolivia','S America','2020-05-23 06:58:56',NULL),(29,29,1,'en','Bonaire St Eustatius And Saba','Caribbean','2020-05-23 06:58:56',NULL),(30,30,1,'en','Brazil','S America','2020-05-23 06:58:56',NULL),(31,31,1,'en','Bahamas','Caribbean','2020-05-23 06:58:56',NULL),(32,32,1,'en','Bhutan','Asia','2020-05-23 06:58:56',NULL),(33,33,1,'en','Botswana','S Africa','2020-05-23 06:58:56',NULL),(34,34,1,'en','Belarus','Euro-Asia','2020-05-23 06:58:56',NULL),(35,35,1,'en','Belize','C America','2020-05-23 06:58:56',NULL),(36,36,1,'en','Canada','N America','2020-05-23 06:58:56',NULL),(37,37,1,'en','Canada Buffer','N America','2020-05-23 06:58:56',NULL),(38,38,1,'en','Cocos Islands','Indian Ocean','2020-05-23 06:58:56',NULL),(39,39,1,'en','Congo The Democratic Rep Of','Sw Africa','2020-05-23 06:58:56',NULL),(40,40,1,'en','Central African Republic','C Africa','2020-05-23 06:58:56',NULL),(41,41,1,'en','Congo Brazzaville','Cw Africa','2020-05-23 06:58:56',NULL),(42,42,1,'en','Switzerland','C Europe','2020-05-23 06:58:56',NULL),(43,43,1,'en','Cote D Ivoire','Cw Africa','2020-05-23 06:58:56',NULL),(44,44,1,'en','Cook Islands','Sw Pacific','2020-05-23 06:58:56',NULL),(45,45,1,'en','Chile','S America','2020-05-23 06:58:56',NULL),(46,46,1,'en','Cameroon','Cw Africa','2020-05-23 06:58:56',NULL),(47,47,1,'en','China','Asia','2020-05-23 06:58:56',NULL),(48,48,1,'en','Colombia','S America','2020-05-23 06:58:56',NULL),(49,49,1,'en','Costa Rica','C America','2020-05-23 06:58:56',NULL),(50,50,1,'en','Cuba','Caribbean','2020-05-23 06:58:56',NULL),(51,51,1,'en','Cape Verde','Cw Africa','2020-05-23 06:58:56',NULL),(52,52,1,'en','Curacao','Caribbean','2020-05-23 06:58:56',NULL),(53,53,1,'en','Christmas Island','Indian Ocean','2020-05-23 06:58:56',NULL),(54,54,1,'en','Cyprus','Mediterranean','2020-05-23 06:58:56',NULL),(55,55,1,'en','Czech Republic','Europe','2020-05-23 06:58:56',NULL),(56,56,1,'en','Germany','Europe','2020-05-23 06:58:56',NULL),(57,57,1,'en','Djibouti','E Africa','2020-05-23 06:58:56',NULL),(58,58,1,'en','Denmark','Nw Europe','2020-05-23 06:58:56',NULL),(59,59,1,'en','Dominica','Caribbean','2020-05-23 06:58:56',NULL),(60,60,1,'en','Dominican Republic','Caribbean','2020-05-23 06:58:56',NULL),(61,61,1,'en','Algeria','Nw Africa','2020-05-23 06:58:56',NULL),(62,62,1,'en','Ecuador','S America','2020-05-23 06:58:56',NULL),(63,63,1,'en','Estonia','Ne Europe','2020-05-23 06:58:56',NULL),(64,64,1,'en','Egypt','Middle East','2020-05-23 06:58:56',NULL),(65,65,1,'en','Western Sahara','Nw Africa','2020-05-23 06:58:56',NULL),(66,66,1,'en','Eritrea','E Africa','2020-05-23 06:58:56',NULL),(67,67,1,'en','Spain','Sw Europe','2020-05-23 06:58:56',NULL),(68,68,1,'en','Ethiopia','E Africa','2020-05-23 06:58:56',NULL),(69,69,1,'en','Finland','N Europe','2020-05-23 06:58:56',NULL),(70,70,1,'en','Fiji','Sw Pacific','2020-05-23 06:58:56',NULL),(71,71,1,'en','Falkland Islands','S Atlantic','2020-05-23 06:58:56',NULL),(72,72,1,'en','Micronesia','Se Asia','2020-05-23 06:58:56',NULL),(73,73,1,'en','Faroe Islands','N Atlantic','2020-05-23 06:58:56',NULL),(74,74,1,'en','France','W Europe','2020-05-23 06:58:56',NULL),(75,75,1,'en','Gabon','Cw Africa','2020-05-23 06:58:56',NULL),(76,76,1,'en','United Kingdom','Nw Europe','2020-05-23 06:58:56',NULL),(77,77,1,'en','Grenada','Caribbean','2020-05-23 06:58:56',NULL),(78,78,1,'en','Georgia','Euro-Asia','2020-05-23 06:58:56',NULL),(79,79,1,'en','French Guiana','S America','2020-05-23 06:58:56',NULL),(80,80,1,'en','Ghana','Cw Africa','2020-05-23 06:58:56',NULL),(81,81,1,'en','Gibraltar','Sw Europe','2020-05-23 06:58:56',NULL),(82,82,1,'en','Greenland','N Atlantic','2020-05-23 06:58:56',NULL),(83,83,1,'en','Gambia','Cw Africa','2020-05-23 06:58:56',NULL),(84,84,1,'en','Guinea','Cw Africa','2020-05-23 06:58:56',NULL),(85,85,1,'en','Guadeloupe','Caribbean','2020-05-23 06:58:56',NULL),(86,86,1,'en','Equatorial Guinea','Cw Africa','2020-05-23 06:58:56',NULL),(87,87,1,'en','Greece','Europe','2020-05-23 06:58:56',NULL),(88,88,1,'en','Guatemala','C America','2020-05-23 06:58:56',NULL),(89,89,1,'en','Guam','Se Asia','2020-05-23 06:58:56',NULL),(90,90,1,'en','Guinea Bissau','Cw Africa','2020-05-23 06:58:56',NULL),(91,91,1,'en','Guyana','S America','2020-05-23 06:58:56',NULL),(92,92,1,'en','Hong Kong','Se Asia','2020-05-23 06:58:56',NULL),(93,93,1,'en','Honduras','C America','2020-05-23 06:58:56',NULL),(94,94,1,'en','Croatia','Europe','2020-05-23 06:58:56',NULL),(95,95,1,'en','Haiti','Caribbean','2020-05-23 06:58:56',NULL),(96,96,1,'en','Hungary','Europe','2020-05-23 06:58:56',NULL),(97,97,1,'en','Indonesia','Se Asia','2020-05-23 06:58:56',NULL),(98,98,1,'en','Ireland','Nw Europe','2020-05-23 06:58:56',NULL),(99,99,1,'en','Israel','Middle East','2020-05-23 06:58:56',NULL),(100,100,1,'en','India','Asia','2020-05-23 06:58:56',NULL),(101,101,1,'en','Iraq','Middle East','2020-05-23 06:58:56',NULL),(102,102,1,'en','Iran','Middle East','2020-05-23 06:58:56',NULL),(103,103,1,'en','Iceland','N Atlantic','2020-05-23 06:58:56',NULL),(104,104,1,'en','Italy','S Europe','2020-05-23 06:58:56',NULL),(105,105,1,'en','Jamaica','Caribbean','2020-05-23 06:58:56',NULL),(106,106,1,'en','Jordan','Middle East','2020-05-23 06:58:56',NULL),(107,107,1,'en','Japan','Asia','2020-05-23 06:58:56',NULL),(108,108,1,'en','Kenya','E Africa','2020-05-23 06:58:56',NULL),(109,109,1,'en','Kyrgyzstan','Se Asia','2020-05-23 06:58:56',NULL),(110,110,1,'en','Cambodia','Se Asia','2020-05-23 06:58:56',NULL),(111,111,1,'en','Kiribati','Sw Pacific','2020-05-23 06:58:56',NULL),(112,112,1,'en','Comoros','Indian Ocean','2020-05-23 06:58:56',NULL),(113,113,1,'en','St. Kitts','Caribbean','2020-05-23 06:58:56',NULL),(114,114,1,'en','Korea Dem Peoples Rep Of','Asia','2020-05-23 06:58:56',NULL),(115,115,1,'en','Korea','Asia','2020-05-23 06:58:56',NULL),(116,116,1,'en','Kuwait','Middle East','2020-05-23 06:58:56',NULL),(117,117,1,'en','Cayman Islands','Caribbean','2020-05-23 06:58:56',NULL),(118,118,1,'en','Kazakhstan','Se Asia','2020-05-23 06:58:56',NULL),(119,119,1,'en','Lao People\'s Dem Republic','Se','2020-05-23 06:58:56',NULL),(120,120,1,'en','Lebanon','Middle East','2020-05-23 06:58:56',NULL),(121,121,1,'en','St. Lucia','Caribbean','2020-05-23 06:58:56',NULL),(122,122,1,'en','Liechtenstein','Europe','2020-05-23 06:58:56',NULL),(123,123,1,'en','Sri Lanka','Asia','2020-05-23 06:58:56',NULL),(124,124,1,'en','Liberia','Cw Africa','2020-05-23 06:58:56',NULL),(125,125,1,'en','Lesotho','S Africa','2020-05-23 06:58:56',NULL),(126,126,1,'en','Lithuania','Ne Europe','2020-05-23 06:58:56',NULL),(127,127,1,'en','Luxembourg','C Europe','2020-05-23 06:58:56',NULL),(128,128,1,'en','Latvia','Ne Europe','2020-05-23 06:58:56',NULL),(129,129,1,'en','Libyan Arab Jamahiriya','N Africa','2020-05-23 06:58:56',NULL),(130,130,1,'en','Morocco','Nw Africa','2020-05-23 06:58:56',NULL),(131,131,1,'en','Mexico Buffer','C America','2020-05-23 06:58:56',NULL),(132,132,1,'en','Monaco','C Europe','2020-05-23 06:58:56',NULL),(133,133,1,'en','Moldova','Euro-Asia','2020-05-23 06:58:56',NULL),(134,134,1,'en','Montenegro','Europe','2020-05-23 06:58:56',NULL),(135,135,1,'en','Madagascar Island','E Africa','2020-05-23 06:58:56',NULL),(136,136,1,'en','Marshall Islands','Se Asia','2020-05-23 06:58:56',NULL),(137,137,1,'en','Macedonia -Fyrom-','Europe','2020-05-23 06:58:56',NULL),(138,138,1,'en','Mali','Nw Africa','2020-05-23 06:58:56',NULL),(139,139,1,'en','Myanmar','Se Asia','2020-05-23 06:58:56',NULL),(140,140,1,'en','Mongolia','Asia','2020-05-23 06:58:56',NULL),(141,141,1,'en','Macau','Se Asia','2020-05-23 06:58:56',NULL),(142,142,1,'en','Northern Mariana Islands','Se Asia','2020-05-23 06:58:56',NULL),(143,143,1,'en','Martinique','Caribbean','2020-05-23 06:58:56',NULL),(144,144,1,'en','Mauritania','Nw Africa','2020-05-23 06:58:56',NULL),(145,145,1,'en','Montserrat','Caribbean','2020-05-23 06:58:56',NULL),(146,146,1,'en','Malta','Mediterranean','2020-05-23 06:58:56',NULL),(147,147,1,'en','Mauritius Island','Indian Ocean','2020-05-23 06:58:56',NULL),(148,148,1,'en','Maldives Island','Indian Ocean','2020-05-23 06:58:56',NULL),(149,149,1,'en','Malawi','Se Africa','2020-05-23 06:58:56',NULL),(150,150,1,'en','Mexico','N America','2020-05-23 06:58:56',NULL),(151,151,1,'en','Malaysia','Se Asia','2020-05-23 06:58:56',NULL),(152,152,1,'en','Mozambique','Se Africa','2020-05-23 06:58:56',NULL),(153,153,1,'en','Namibia','Sw Africa','2020-05-23 06:58:56',NULL),(154,154,1,'en','New Caledonia','Sw Pacific','2020-05-23 06:58:56',NULL),(155,155,1,'en','Niger','Cw Africa','2020-05-23 06:58:56',NULL),(156,156,1,'en','Norfolk Island','Sw Pacific','2020-05-23 06:58:56',NULL),(157,157,1,'en','Nigeria','Cw Africa','2020-05-23 06:58:56',NULL),(158,158,1,'en','Nicaragua','C America','2020-05-23 06:58:56',NULL),(159,159,1,'en','Netherlands','Nw Europe','2020-05-23 06:58:56',NULL),(160,160,1,'en','Norway','N Europe','2020-05-23 06:58:56',NULL),(161,161,1,'en','Nepal','Asia','2020-05-23 06:58:56',NULL),(162,162,1,'en','Nauru','C Pacific','2020-05-23 06:58:56',NULL),(163,163,1,'en','Niue','Sw Pacific','2020-05-23 06:58:56',NULL),(164,164,1,'en','New Zealand','Sw Pacific','2020-05-23 06:58:56',NULL),(165,165,1,'en','Oman','Middle East','2020-05-23 06:58:56',NULL),(166,166,1,'en','Panama','C America','2020-05-23 06:58:56',NULL),(167,167,1,'en','Peru','S America','2020-05-23 06:58:56',NULL),(168,168,1,'en','French Polynesia','S Pacific','2020-05-23 06:58:56',NULL),(169,169,1,'en','Papua New Guinea','Sw Pacific','2020-05-23 06:58:56',NULL),(170,170,1,'en','Philippines','Se Asia','2020-05-23 06:58:56',NULL),(171,171,1,'en','Pakistan','Asia','2020-05-23 06:58:56',NULL),(172,172,1,'en','Poland','Europe','2020-05-23 06:58:56',NULL),(173,173,1,'en','St. Pierre And Miquelon','N Atlantic','2020-05-23 06:58:56',NULL),(174,174,1,'en','Puerto Rico','Caribbean','2020-05-23 06:58:56',NULL),(175,175,1,'en','Palestinian Occ. Territories','Middle East','2020-05-23 06:58:56',NULL),(176,176,1,'en','Portugal','Sw Europe','2020-05-23 06:58:56',NULL),(177,177,1,'en','Palau Islands','Se Asia','2020-05-23 06:58:56',NULL),(178,178,1,'en','Paraguay','S America','2020-05-23 06:58:56',NULL),(179,179,1,'en','Qatar','Middle East','2020-05-23 06:58:56',NULL),(180,180,1,'en','Reunion Island','Indian Ocean','2020-05-23 06:58:56',NULL),(181,181,1,'en','Romania','Europe','2020-05-23 06:58:56',NULL),(182,182,1,'en','Serbia','Europe','2020-05-23 06:58:56',NULL),(183,183,1,'en','Russia','Euro-Asia','2020-05-23 06:58:56',NULL),(184,184,1,'en','Rwanda','Ce Africa','2020-05-23 06:58:56',NULL),(185,185,1,'en','Saudi Arabia','Middle East','2020-05-23 06:58:56',NULL),(186,186,1,'en','Solomon Islands','Sw Pacific','2020-05-23 06:58:56',NULL),(187,187,1,'en','Seychelles Islands','Indian Ocean','2020-05-23 06:58:56',NULL),(188,188,1,'en','Sudan','Middle East','2020-05-23 06:58:56',NULL),(189,189,1,'en','Sweden','N Europe','2020-05-23 06:58:56',NULL),(190,190,1,'en','Singapore','Se Asia','2020-05-23 06:58:56',NULL),(191,191,1,'en','St. Helena Island','S Atlantic','2020-05-23 06:58:56',NULL),(192,192,1,'en','Slovenia','C Europe','2020-05-23 06:58:56',NULL),(193,193,1,'en','Slovakia','Europe','2020-05-23 06:58:56',NULL),(194,194,1,'en','Sierra Leone','Cw Africa','2020-05-23 06:58:56',NULL),(195,195,1,'en','San Marino','N Italy','2020-05-23 06:58:56',NULL),(196,196,1,'en','Senegal','Cw Africa','2020-05-23 06:58:56',NULL),(197,197,1,'en','Somalia','E Africa','2020-05-23 06:58:56',NULL),(198,198,1,'en','Suriname','S America','2020-05-23 06:58:56',NULL),(199,199,1,'en','South Sudan','Africa','2020-05-23 06:58:56',NULL),(200,200,1,'en','Sao Tome And Principe Islands','Cw Africa','2020-05-23 06:58:56',NULL),(201,201,1,'en','El Salvador','C America','2020-05-23 06:58:56',NULL),(202,202,1,'en','Sint Maarten','Caribbean','2020-05-23 06:58:56',NULL),(203,203,1,'en','Syrian Arab Republic','Middle East','2020-05-23 06:58:56',NULL),(204,204,1,'en','Swaziland','S Africa','2020-05-23 06:58:56',NULL),(205,205,1,'en','Turks And Caicos Islands','Caribbean','2020-05-23 06:58:56',NULL),(206,206,1,'en','Chad','C Africa','2020-05-23 06:58:56',NULL),(207,207,1,'en','Togo','Cw Africa','2020-05-23 06:58:56',NULL),(208,208,1,'en','Thailand','Se Asia','2020-05-23 06:58:56',NULL),(209,209,1,'en','Tajikistan','Se Asia','2020-05-23 06:58:56',NULL),(210,210,1,'en','Tokelau','Sw Pacific','2020-05-23 06:58:56',NULL),(211,211,1,'en','Timor Leste','Asia','2020-05-23 06:58:56',NULL),(212,212,1,'en','Turkmenistan','Se Asia','2020-05-23 06:58:56',NULL),(213,213,1,'en','Tunisia','N Africa','2020-05-23 06:58:56',NULL),(214,214,1,'en','Tonga','Sw Pacific','2020-05-23 06:58:56',NULL),(215,215,1,'en','East Timor','Asia','2020-05-23 06:58:56',NULL),(216,216,1,'en','Turkey','Euro-Asia','2020-05-23 06:58:56',NULL),(217,217,1,'en','Trinidad And Tobago','Caribbean','2020-05-23 06:58:56',NULL),(218,218,1,'en','Tuvalu','Sw Pacific','2020-05-23 06:58:56',NULL),(219,219,1,'en','Taiwan','Asia','2020-05-23 06:58:56',NULL),(220,220,1,'en','Tanzania-United Republic','Se Africa','2020-05-23 06:58:56',NULL),(221,221,1,'en','Ukraine','Euro-Asia','2020-05-23 06:58:56',NULL),(222,222,1,'en','Uganda','Ce Africa','2020-05-23 06:58:56',NULL),(223,223,1,'en','U.S. Minor Outlying Islands','Caribbean','2020-05-23 06:58:56',NULL),(224,224,1,'en','United States Of America','N America','2020-05-23 06:58:56',NULL),(225,225,1,'en','Uruguay','S America','2020-05-23 06:58:56',NULL),(226,226,1,'en','Uzbekistan','Euro-Asia','2020-05-23 06:58:56',NULL),(227,227,1,'en','Vatican','S Europe','2020-05-23 06:58:56',NULL),(228,228,1,'en','St. Vincent','Caribbean','2020-05-23 06:58:56',NULL),(229,229,1,'en','Venezuela','S America','2020-05-23 06:58:56',NULL),(230,230,1,'en','Virgin Islands-British','Caribbean','2020-05-23 06:58:56',NULL),(231,231,1,'en','Virgin Islands-United States','Caribbean','2020-05-23 06:58:56',NULL),(232,232,1,'en','Vietnam','Se Asia','2020-05-23 06:58:56',NULL),(233,233,1,'en','Vanuatu','Sw Pacific','2020-05-23 06:58:56',NULL),(234,234,1,'en','Wallis And Futuna Islands','C Pacific','2020-05-23 06:58:56',NULL),(235,235,1,'en','Samoa-Independent State Of','Sw Pacific','2020-05-23 06:58:56',NULL),(236,236,1,'en','Yemen Republic','Middle East','2020-05-23 06:58:56',NULL),(237,237,1,'en','Mayotte','Indian Ocean','2020-05-23 06:58:56',NULL),(238,238,1,'en','South Africa','S Africa','2020-05-23 06:58:56',NULL),(239,239,1,'en','Zambia','S Africa','2020-05-23 06:58:56',NULL),(240,240,1,'en','Zimbabwe','S Africa','2020-05-23 06:58:56',NULL),(513,2,2,'fa','امارات متحده عربی',NULL,'2020-05-23 07:01:25',NULL),(514,3,2,'fa','افغانستان',NULL,'2020-05-23 07:01:25',NULL),(515,4,2,'fa','آنتیگوا',NULL,'2020-05-23 07:01:25',NULL),(516,5,2,'fa','آنگوییلا',NULL,'2020-05-23 07:01:25',NULL),(517,6,2,'fa','آلبانی',NULL,'2020-05-23 07:01:25',NULL),(518,7,2,'fa','ارمنستان',NULL,'2020-05-23 07:01:25',NULL),(519,8,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(520,9,2,'fa','آنگولا',NULL,'2020-05-23 07:01:25',NULL),(521,10,2,'fa','آنگولا',NULL,'2020-05-23 07:01:25',NULL),(522,11,2,'fa','آرژانتین',NULL,'2020-05-23 07:01:25',NULL),(523,12,2,'fa','ساموآ',NULL,'2020-05-23 07:01:25',NULL),(524,13,2,'fa','اتریش',NULL,'2020-05-23 07:01:25',NULL),(525,14,2,'fa','استرالیا',NULL,'2020-05-23 07:01:25',NULL),(526,15,2,'fa','آروبا',NULL,'2020-05-23 07:01:25',NULL),(527,16,2,'fa','آذربایجان',NULL,'2020-05-23 07:01:25',NULL),(528,17,2,'fa','بوسنی و هرزگوین',NULL,'2020-05-23 07:01:25',NULL),(529,18,2,'fa','باربادوس',NULL,'2020-05-23 07:01:25',NULL),(530,19,2,'fa','بنگلادش',NULL,'2020-05-23 07:01:25',NULL),(531,20,2,'fa','بلژیک',NULL,'2020-05-23 07:01:25',NULL),(532,21,2,'fa','بورکینافاسو',NULL,'2020-05-23 07:01:25',NULL),(533,22,2,'fa','بلغارستان',NULL,'2020-05-23 07:01:25',NULL),(534,23,2,'fa','بحرین',NULL,'2020-05-23 07:01:25',NULL),(535,24,2,'fa','بروندی',NULL,'2020-05-23 07:01:25',NULL),(536,25,2,'fa','بنین',NULL,'2020-05-23 07:01:25',NULL),(537,26,2,'fa','برمودا',NULL,'2020-05-23 07:01:25',NULL),(538,27,2,'fa','برونئی',NULL,'2020-05-23 07:01:25',NULL),(539,28,2,'fa','بولیوی',NULL,'2020-05-23 07:01:25',NULL),(540,29,2,'fa','کارائیب',NULL,'2020-05-23 07:01:25',NULL),(541,30,2,'fa','برزیل',NULL,'2020-05-23 07:01:25',NULL),(542,31,2,'fa','باهاما',NULL,'2020-05-23 07:01:25',NULL),(543,32,2,'fa','بوتان',NULL,'2020-05-23 07:01:25',NULL),(544,33,2,'fa','بوتسوانا',NULL,'2020-05-23 07:01:25',NULL),(545,34,2,'fa','بلاروس',NULL,'2020-05-23 07:01:25',NULL),(546,35,2,'fa','بلیز',NULL,'2020-05-23 07:01:25',NULL),(547,36,2,'fa','کانادا',NULL,'2020-05-23 07:01:25',NULL),(548,37,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(549,38,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(550,39,2,'fa','کنگو',NULL,'2020-05-23 07:01:25',NULL),(551,40,2,'fa','آفریقای مرکزی',NULL,'2020-05-23 07:01:25',NULL),(552,41,2,'fa','کنگو برازاویل',NULL,'2020-05-23 07:01:25',NULL),(553,42,2,'fa','سوییس',NULL,'2020-05-23 07:01:25',NULL),(554,43,2,'fa','ساحل عاج',NULL,'2020-05-23 07:01:25',NULL),(555,44,2,'fa','کوک آیلندز',NULL,'2020-05-23 07:01:25',NULL),(556,45,2,'fa','شیلی',NULL,'2020-05-23 07:01:25',NULL),(557,46,2,'fa','کامرون',NULL,'2020-05-23 07:01:25',NULL),(558,47,2,'fa','چین',NULL,'2020-05-23 07:01:25',NULL),(559,48,2,'fa','کلمبیا',NULL,'2020-05-23 07:01:25',NULL),(560,49,2,'fa','کاستاریکا',NULL,'2020-05-23 07:01:25',NULL),(561,50,2,'fa','کوبا',NULL,'2020-05-23 07:01:25',NULL),(562,51,2,'fa','کیپ ورد',NULL,'2020-05-23 07:01:25',NULL),(563,52,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(564,53,2,'fa','کیپ ورد',NULL,'2020-05-23 07:01:25',NULL),(565,54,2,'fa','قبرس',NULL,'2020-05-23 07:01:25',NULL),(566,55,2,'fa','چک',NULL,'2020-05-23 07:01:25',NULL),(567,56,2,'fa','آلمان',NULL,'2020-05-23 07:01:25',NULL),(568,57,2,'fa','جیبوتی',NULL,'2020-05-23 07:01:25',NULL),(569,58,2,'fa','دانمارک',NULL,'2020-05-23 07:01:25',NULL),(570,59,2,'fa','دامنیکا',NULL,'2020-05-23 07:01:25',NULL),(571,60,2,'fa','دومنیکن',NULL,'2020-05-23 07:01:25',NULL),(572,61,2,'fa','الجزیره',NULL,'2020-05-23 07:01:25',NULL),(573,62,2,'fa','اکوادور',NULL,'2020-05-23 07:01:25',NULL),(574,63,2,'fa','استونی',NULL,'2020-05-23 07:01:25',NULL),(575,64,2,'fa','مصر',NULL,'2020-05-23 07:01:25',NULL),(576,65,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(577,66,2,'fa','اریتره',NULL,'2020-05-23 07:01:25',NULL),(578,67,2,'fa','اسپانیا',NULL,'2020-05-23 07:01:25',NULL),(579,68,2,'fa','اتیوپی',NULL,'2020-05-23 07:01:25',NULL),(580,69,2,'fa','فنلاند',NULL,'2020-05-23 07:01:25',NULL),(581,70,2,'fa','فیجی',NULL,'2020-05-23 07:01:25',NULL),(582,71,2,'fa','فالکلند',NULL,'2020-05-23 07:01:25',NULL),(583,72,2,'fa','میکرونزی',NULL,'2020-05-23 07:01:25',NULL),(584,73,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(585,74,2,'fa','فرانسه',NULL,'2020-05-23 07:01:25',NULL),(586,75,2,'fa','گابن',NULL,'2020-05-23 07:01:25',NULL),(587,76,2,'fa','بریتانیا',NULL,'2020-05-23 07:01:25',NULL),(588,77,2,'fa','گرانادا',NULL,'2020-05-23 07:01:25',NULL),(589,78,2,'fa','گرجستان',NULL,'2020-05-23 07:01:25',NULL),(590,79,2,'fa','سورینام',NULL,'2020-05-23 07:01:25',NULL),(591,80,2,'fa','غنا',NULL,'2020-05-23 07:01:25',NULL),(592,81,2,'fa','غنا',NULL,'2020-05-23 07:01:25',NULL),(593,82,2,'fa','گرینلند',NULL,'2020-05-23 07:01:25',NULL),(594,83,2,'fa','گامبیا',NULL,'2020-05-23 07:01:25',NULL),(595,84,2,'fa','گینه نو',NULL,'2020-05-23 07:01:25',NULL),(596,85,2,'fa','گوآدالوپ',NULL,'2020-05-23 07:01:25',NULL),(597,86,2,'fa','گینه استوایی',NULL,'2020-05-23 07:01:25',NULL),(598,87,2,'fa','یونان',NULL,'2020-05-23 07:01:25',NULL),(599,88,2,'fa','گواتمالا',NULL,'2020-05-23 07:01:25',NULL),(600,89,2,'fa','گوام',NULL,'2020-05-23 07:01:25',NULL),(601,90,2,'fa','گینه بیسائو',NULL,'2020-05-23 07:01:25',NULL),(602,91,2,'fa','گویانا',NULL,'2020-05-23 07:01:25',NULL),(603,92,2,'fa','هنگ کنگ',NULL,'2020-05-23 07:01:25',NULL),(604,93,2,'fa','هندوراس',NULL,'2020-05-23 07:01:25',NULL),(605,94,2,'fa','کرواسی',NULL,'2020-05-23 07:01:25',NULL),(606,95,2,'fa','هاییتی',NULL,'2020-05-23 07:01:25',NULL),(607,96,2,'fa','مجارستان',NULL,'2020-05-23 07:01:25',NULL),(608,97,2,'fa','اندونزی',NULL,'2020-05-23 07:01:25',NULL),(609,98,2,'fa','ایرلند جنوبی',NULL,'2020-05-23 07:01:25',NULL),(610,99,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(611,100,2,'fa','هندوستان',NULL,'2020-05-23 07:01:25',NULL),(612,101,2,'fa','عراق',NULL,'2020-05-23 07:01:25',NULL),(613,102,2,'fa','ایران',NULL,'2020-05-23 07:01:25',NULL),(614,103,2,'fa','ایسلند',NULL,'2020-05-23 07:01:25',NULL),(615,104,2,'fa','ایتالیا',NULL,'2020-05-23 07:01:25',NULL),(616,105,2,'fa','جامائیکا',NULL,'2020-05-23 07:01:25',NULL),(617,106,2,'fa','اردن',NULL,'2020-05-23 07:01:25',NULL),(618,107,2,'fa','ژاپن',NULL,'2020-05-23 07:01:25',NULL),(619,108,2,'fa','کنیا',NULL,'2020-05-23 07:01:25',NULL),(620,109,2,'fa','قرقیزستان',NULL,'2020-05-23 07:01:25',NULL),(621,110,2,'fa','کامبوج',NULL,'2020-05-23 07:01:25',NULL),(622,111,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(623,112,2,'fa','کومور',NULL,'2020-05-23 07:01:25',NULL),(624,113,2,'fa','سن کیتس',NULL,'2020-05-23 07:01:25',NULL),(625,114,2,'fa','کره شمالی',NULL,'2020-05-23 07:01:25',NULL),(626,115,2,'fa','کره جنوبی',NULL,'2020-05-23 07:01:25',NULL),(627,116,2,'fa','کویت',NULL,'2020-05-23 07:01:25',NULL),(628,117,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(629,118,2,'fa','قزاقستان',NULL,'2020-05-23 07:01:25',NULL),(630,119,2,'fa','لائوس',NULL,'2020-05-23 07:01:25',NULL),(631,120,2,'fa','لبنان',NULL,'2020-05-23 07:01:25',NULL),(632,121,2,'fa','سنت لوسیا',NULL,'2020-05-23 07:01:25',NULL),(633,122,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(634,123,2,'fa','سریلانکا',NULL,'2020-05-23 07:01:25',NULL),(635,124,2,'fa','لیبری',NULL,'2020-05-23 07:01:25',NULL),(636,125,2,'fa','لسوتو',NULL,'2020-05-23 07:01:25',NULL),(637,126,2,'fa','لیتوانی',NULL,'2020-05-23 07:01:25',NULL),(638,127,2,'fa','لوگزامبورگ',NULL,'2020-05-23 07:01:25',NULL),(639,128,2,'fa','لاتویا',NULL,'2020-05-23 07:01:25',NULL),(640,129,2,'fa','لیبی',NULL,'2020-05-23 07:01:25',NULL),(641,130,2,'fa','مراکش',NULL,'2020-05-23 07:01:25',NULL),(642,131,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(643,132,2,'fa','موناکو',NULL,'2020-05-23 07:01:25',NULL),(644,133,2,'fa','مولداوی',NULL,'2020-05-23 07:01:25',NULL),(645,134,2,'fa','مونتنگرو',NULL,'2020-05-23 07:01:25',NULL),(646,135,2,'fa','ماداگاسکار',NULL,'2020-05-23 07:01:25',NULL),(647,136,2,'fa','مارشال آیلندز',NULL,'2020-05-23 07:01:25',NULL),(648,137,2,'fa','مقدونیه',NULL,'2020-05-23 07:01:25',NULL),(649,138,2,'fa','مالی',NULL,'2020-05-23 07:01:25',NULL),(650,139,2,'fa','میانمار',NULL,'2020-05-23 07:01:25',NULL),(651,140,2,'fa','مغولستان',NULL,'2020-05-23 07:01:25',NULL),(652,141,2,'fa','ماکائو',NULL,'2020-05-23 07:01:25',NULL),(653,142,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(654,143,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(655,144,2,'fa','موریتانی',NULL,'2020-05-23 07:01:25',NULL),(656,145,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(657,146,2,'fa','مالتا',NULL,'2020-05-23 07:01:25',NULL),(658,147,2,'fa','موریس',NULL,'2020-05-23 07:01:25',NULL),(659,148,2,'fa','مالدیو',NULL,'2020-05-23 07:01:25',NULL),(660,149,2,'fa','مالاوی',NULL,'2020-05-23 07:01:25',NULL),(661,150,2,'fa','مکزیک',NULL,'2020-05-23 07:01:25',NULL),(662,151,2,'fa','مالزی',NULL,'2020-05-23 07:01:25',NULL),(663,152,2,'fa','موزامبیک',NULL,'2020-05-23 07:01:25',NULL),(664,153,2,'fa','نامیبیا',NULL,'2020-05-23 07:01:25',NULL),(665,154,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(666,155,2,'fa','نیجر',NULL,'2020-05-23 07:01:25',NULL),(667,156,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(668,157,2,'fa','نیجریه',NULL,'2020-05-23 07:01:25',NULL),(669,158,2,'fa','نیکاراگوئه',NULL,'2020-05-23 07:01:25',NULL),(670,159,2,'fa','هلند',NULL,'2020-05-23 07:01:25',NULL),(671,160,2,'fa','نروژ',NULL,'2020-05-23 07:01:25',NULL),(672,161,2,'fa','نپال',NULL,'2020-05-23 07:01:25',NULL),(673,162,2,'fa','نا اورو',NULL,'2020-05-23 07:01:25',NULL),(674,163,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(675,164,2,'fa','نیوزلند',NULL,'2020-05-23 07:01:25',NULL),(676,165,2,'fa','عمان',NULL,'2020-05-23 07:01:25',NULL),(677,166,2,'fa','پاناما',NULL,'2020-05-23 07:01:25',NULL),(678,167,2,'fa','پرو',NULL,'2020-05-23 07:01:25',NULL),(679,168,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(680,169,2,'fa','گینه نو',NULL,'2020-05-23 07:01:25',NULL),(681,170,2,'fa','فیلیپین',NULL,'2020-05-23 07:01:25',NULL),(682,171,2,'fa','پاکستان',NULL,'2020-05-23 07:01:25',NULL),(683,172,2,'fa','لهستان',NULL,'2020-05-23 07:01:25',NULL),(684,173,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(685,174,2,'fa','پورتوریکو',NULL,'2020-05-23 07:01:25',NULL),(686,175,2,'fa','فلسطین',NULL,'2020-05-23 07:01:25',NULL),(687,176,2,'fa','پرتغال',NULL,'2020-05-23 07:01:25',NULL),(688,177,2,'fa','پائولو',NULL,'2020-05-23 07:01:25',NULL),(689,178,2,'fa','پاراگوئه',NULL,'2020-05-23 07:01:25',NULL),(690,179,2,'fa','قطر ',NULL,'2020-05-23 07:01:25',NULL),(691,180,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(692,181,2,'fa','رومانی',NULL,'2020-05-23 07:01:25',NULL),(693,182,2,'fa','صربستان',NULL,'2020-05-23 07:01:25',NULL),(694,183,2,'fa','روسیه',NULL,'2020-05-23 07:01:25',NULL),(695,184,2,'fa','رواندا',NULL,'2020-05-23 07:01:25',NULL),(696,185,2,'fa','عربستان سعودی',NULL,'2020-05-23 07:01:25',NULL),(697,186,2,'fa','جزایر سلیمان',NULL,'2020-05-23 07:01:25',NULL),(698,187,2,'fa','سی شل',NULL,'2020-05-23 07:01:25',NULL),(699,188,2,'fa','سودان',NULL,'2020-05-23 07:01:25',NULL),(700,189,2,'fa','سوئد',NULL,'2020-05-23 07:01:25',NULL),(701,190,2,'fa','سنگاپور',NULL,'2020-05-23 07:01:25',NULL),(702,191,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(703,192,2,'fa','اسلوانی',NULL,'2020-05-23 07:01:25',NULL),(704,193,2,'fa','اسلواکی',NULL,'2020-05-23 07:01:25',NULL),(705,194,2,'fa','سیرالئون',NULL,'2020-05-23 07:01:25',NULL),(706,195,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(707,196,2,'fa','سنگال',NULL,'2020-05-23 07:01:25',NULL),(708,197,2,'fa','سومالی',NULL,'2020-05-23 07:01:25',NULL),(709,198,2,'fa','سورینام',NULL,'2020-05-23 07:01:25',NULL),(710,199,2,'fa','سودان جنوبی',NULL,'2020-05-23 07:01:25',NULL),(711,200,2,'fa','سائو تومه',NULL,'2020-05-23 07:01:25',NULL),(712,201,2,'fa','ال سالداودور',NULL,'2020-05-23 07:01:25',NULL),(713,202,2,'fa','سن مارتین',NULL,'2020-05-23 07:01:25',NULL),(714,203,2,'fa','سوریه',NULL,'2020-05-23 07:01:25',NULL),(715,204,2,'fa','سوازیلند',NULL,'2020-05-23 07:01:25',NULL),(716,205,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(717,206,2,'fa','چاد',NULL,'2020-05-23 07:01:25',NULL),(718,207,2,'fa','توگو',NULL,'2020-05-23 07:01:25',NULL),(719,208,2,'fa','تایلند',NULL,'2020-05-23 07:01:25',NULL),(720,209,2,'fa','تاجیکستان',NULL,'2020-05-23 07:01:25',NULL),(721,210,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(722,211,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(723,212,2,'fa','ترکمنستان',NULL,'2020-05-23 07:01:25',NULL),(724,213,2,'fa','تونس',NULL,'2020-05-23 07:01:25',NULL),(725,214,2,'fa','تونگا',NULL,'2020-05-23 07:01:25',NULL),(726,215,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(727,216,2,'fa','ترکیه',NULL,'2020-05-23 07:01:25',NULL),(728,217,2,'fa','ترینیداد و توباگو',NULL,'2020-05-23 07:01:25',NULL),(729,218,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(730,219,2,'fa','تایوان',NULL,'2020-05-23 07:01:25',NULL),(731,220,2,'fa','تانزانیا',NULL,'2020-05-23 07:01:25',NULL),(732,221,2,'fa','اوکراین',NULL,'2020-05-23 07:01:25',NULL),(733,222,2,'fa','اوگاندا',NULL,'2020-05-23 07:01:25',NULL),(734,223,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(735,224,2,'fa','ایالات متحده آمریکا',NULL,'2020-05-23 07:01:25',NULL),(736,225,2,'fa','اروگوئه',NULL,'2020-05-23 07:01:25',NULL),(737,226,2,'fa','ازبکستان',NULL,'2020-05-23 07:01:25',NULL),(738,227,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(739,228,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(740,229,2,'fa','ونزوئلا',NULL,'2020-05-23 07:01:25',NULL),(741,230,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(742,231,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(743,232,2,'fa','ویتنام',NULL,'2020-05-23 07:01:25',NULL),(744,233,2,'fa','وانوآتو',NULL,'2020-05-23 07:01:25',NULL),(745,234,2,'fa',NULL,NULL,'2020-05-23 07:01:25',NULL),(746,235,2,'fa','ساموا',NULL,'2020-05-23 07:01:25',NULL),(747,236,2,'fa','یمن',NULL,'2020-05-23 07:01:25',NULL),(748,237,2,'fa','مایوت',NULL,'2020-05-23 07:01:25',NULL),(749,238,2,'fa','آفریقای جنوبی',NULL,'2020-05-23 07:01:25',NULL),(750,239,2,'fa','زامبیا',NULL,'2020-05-23 07:01:25',NULL),(751,240,2,'fa','زیمباوه',NULL,'2020-05-23 07:01:25',NULL),(993,1,3,'ar','أندورا',NULL,'2022-03-07 06:40:54',NULL),(994,2,3,'ar','الإمارات العربية المتحدة',NULL,'2022-03-07 06:40:54',NULL),(995,3,3,'ar','أفغانستان',NULL,'2022-03-07 06:40:54',NULL),(996,4,3,'ar','أنتيغوا وبربودا',NULL,'2022-03-07 06:40:54',NULL),(997,5,3,'ar','أنغيلا',NULL,'2022-03-07 06:40:54',NULL),(998,6,3,'ar','ألبانيا',NULL,'2022-03-07 06:40:54',NULL),(999,7,3,'ar','أرمينيا',NULL,'2022-03-07 06:40:54',NULL),(1000,8,3,'ar','جزر الأنتيل الهولندية',NULL,'2022-03-07 06:40:54',NULL),(1001,9,3,'ar','أنغولا',NULL,'2022-03-07 06:40:54',NULL),(1002,10,3,'ar','القارة القطبية الجنوبية',NULL,'2022-03-07 06:40:54',NULL),(1003,11,3,'ar','الأرجنتين',NULL,'2022-03-07 06:40:54',NULL),(1004,12,3,'ar','ساموا الأمريكية',NULL,'2022-03-07 06:40:54',NULL),(1005,13,3,'ar','النمسا',NULL,'2022-03-07 06:40:54',NULL),(1006,14,3,'ar','أستراليا',NULL,'2022-03-07 06:40:54',NULL),(1007,15,3,'ar','أروبا',NULL,'2022-03-07 06:40:55',NULL),(1008,16,3,'ar','أذربيجان',NULL,'2022-03-07 06:40:55',NULL),(1009,17,3,'ar','البوسنة والهرسك',NULL,'2022-03-07 06:40:55',NULL),(1010,18,3,'ar','بربادوس',NULL,'2022-03-07 06:40:55',NULL),(1011,19,3,'ar','بنغلاديش',NULL,'2022-03-07 06:40:55',NULL),(1012,20,3,'ar','بلجيكا',NULL,'2022-03-07 06:40:55',NULL),(1013,21,3,'ar','بوركينا فاسو',NULL,'2022-03-07 06:40:55',NULL),(1014,22,3,'ar','بلغاريا',NULL,'2022-03-07 06:40:55',NULL),(1015,23,3,'ar','البحرين',NULL,'2022-03-07 06:40:55',NULL),(1016,24,3,'ar','بوروندي',NULL,'2022-03-07 06:40:55',NULL),(1017,25,3,'ar','بنين',NULL,'2022-03-07 06:40:55',NULL),(1018,26,3,'ar','برمودا',NULL,'2022-03-07 06:40:55',NULL),(1019,27,3,'ar','بروناي دار السلام',NULL,'2022-03-07 06:40:55',NULL),(1020,28,3,'ar','بوليفيا',NULL,'2022-03-07 06:40:55',NULL),(1021,29,3,'ar','بونير سانت أوستاتيوس وسابا',NULL,'2022-03-07 06:40:56',NULL),(1022,30,3,'ar','البرازيل',NULL,'2022-03-07 06:40:56',NULL),(1023,31,3,'ar','جزر البهاما',NULL,'2022-03-07 06:40:56',NULL),(1024,32,3,'ar','بوتان',NULL,'2022-03-07 06:40:56',NULL),(1025,33,3,'ar','بوتسوانا',NULL,'2022-03-07 06:40:56',NULL),(1026,34,3,'ar','بيلاروسيا',NULL,'2022-03-07 06:40:56',NULL),(1027,35,3,'ar','بليز',NULL,'2022-03-07 06:40:56',NULL),(1028,36,3,'ar','كندا',NULL,'2022-03-07 06:40:56',NULL),(1029,37,3,'ar','كندا العازلة',NULL,'2022-03-07 06:40:56',NULL),(1030,38,3,'ar','جزر كوكوس',NULL,'2022-03-07 06:40:56',NULL),(1031,39,3,'ar','جمهورية الكونغو الديموقراطية',NULL,'2022-03-07 06:40:56',NULL),(1032,40,3,'ar','جمهورية افريقيا الوسطى',NULL,'2022-03-07 06:40:56',NULL),(1033,41,3,'ar','الكونغو برازافيل',NULL,'2022-03-07 06:40:56',NULL),(1034,42,3,'ar','سويسرا',NULL,'2022-03-07 06:40:56',NULL),(1035,43,3,'ar','كوت ديفوار',NULL,'2022-03-07 06:40:56',NULL),(1036,44,3,'ar','جزر كوك',NULL,'2022-03-07 06:40:56',NULL),(1037,45,3,'ar','تشيلي',NULL,'2022-03-07 06:40:57',NULL),(1038,46,3,'ar','الكاميرون',NULL,'2022-03-07 06:40:57',NULL),(1039,47,3,'ar','الصين',NULL,'2022-03-07 06:40:57',NULL),(1040,48,3,'ar','كولومبيا',NULL,'2022-03-07 06:40:57',NULL),(1041,49,3,'ar','كوستا ريكا',NULL,'2022-03-07 06:40:57',NULL),(1042,50,3,'ar','كوبا',NULL,'2022-03-07 06:40:57',NULL),(1043,51,3,'ar','الرأس الأخضر',NULL,'2022-03-07 06:40:57',NULL),(1044,52,3,'ar','كوراكاو',NULL,'2022-03-07 06:40:57',NULL),(1045,53,3,'ar','جزيرة الكريسماس',NULL,'2022-03-07 06:40:57',NULL),(1046,54,3,'ar','قبرص',NULL,'2022-03-07 06:40:57',NULL),(1047,55,3,'ar','جمهورية التشيك',NULL,'2022-03-07 06:40:57',NULL),(1048,56,3,'ar','ألمانيا',NULL,'2022-03-07 06:40:57',NULL),(1049,57,3,'ar','جيبوتي',NULL,'2022-03-07 06:40:57',NULL),(1050,58,3,'ar','الدنمارك',NULL,'2022-03-07 06:40:57',NULL),(1051,59,3,'ar','دومينيكا',NULL,'2022-03-07 06:40:57',NULL),(1052,60,3,'ar','جمهورية الدومينيكان',NULL,'2022-03-07 06:40:57',NULL),(1053,61,3,'ar','الجزائر',NULL,'2022-03-07 06:40:57',NULL),(1054,62,3,'ar','الاكوادور',NULL,'2022-03-07 06:40:57',NULL),(1055,63,3,'ar','إستونيا',NULL,'2022-03-07 06:40:57',NULL),(1056,64,3,'ar','مصر',NULL,'2022-03-07 06:40:57',NULL),(1057,65,3,'ar','الصحراء الغربية',NULL,'2022-03-07 06:40:57',NULL),(1058,66,3,'ar','إريتريا',NULL,'2022-03-07 06:40:58',NULL),(1059,67,3,'ar','إسبانيا',NULL,'2022-03-07 06:40:58',NULL),(1060,68,3,'ar','أثيوبيا',NULL,'2022-03-07 06:40:58',NULL),(1061,69,3,'ar','فنلندا',NULL,'2022-03-07 06:40:58',NULL),(1062,70,3,'ar','فيجي',NULL,'2022-03-07 06:40:58',NULL),(1063,71,3,'ar','جزر فوكلاند',NULL,'2022-03-07 06:40:58',NULL),(1064,72,3,'ar','ميكرونيزيا',NULL,'2022-03-07 06:40:58',NULL),(1065,73,3,'ar','جزر فاروس',NULL,'2022-03-07 06:40:58',NULL),(1066,74,3,'ar','فرنسا',NULL,'2022-03-07 06:40:58',NULL),(1067,75,3,'ar','الجابون',NULL,'2022-03-07 06:40:58',NULL),(1068,76,3,'ar','المملكة المتحدة',NULL,'2022-03-07 06:40:58',NULL),(1069,77,3,'ar','غرينادا',NULL,'2022-03-07 06:40:58',NULL),(1070,78,3,'ar','جورجيا',NULL,'2022-03-07 06:40:58',NULL),(1071,79,3,'ar','غيانا الفرنسية',NULL,'2022-03-07 06:40:58',NULL),(1072,80,3,'ar','غانا',NULL,'2022-03-07 06:40:58',NULL),(1073,81,3,'ar','جبل طارق',NULL,'2022-03-07 06:40:58',NULL),(1074,82,3,'ar','الأرض الخضراء',NULL,'2022-03-07 06:40:58',NULL),(1075,83,3,'ar','غامبيا',NULL,'2022-03-07 06:40:58',NULL),(1076,84,3,'ar','غينيا',NULL,'2022-03-07 06:40:58',NULL),(1077,85,3,'ar','جوادلوب',NULL,'2022-03-07 06:40:58',NULL),(1078,86,3,'ar','غينيا الإستوائية',NULL,'2022-03-07 06:40:58',NULL),(1079,87,3,'ar','اليونان',NULL,'2022-03-07 06:40:59',NULL),(1080,88,3,'ar','غواتيمالا',NULL,'2022-03-07 06:40:59',NULL),(1081,89,3,'ar','غوام',NULL,'2022-03-07 06:40:59',NULL),(1082,90,3,'ar','غينيا بيساو',NULL,'2022-03-07 06:40:59',NULL),(1083,91,3,'ar','غيانا',NULL,'2022-03-07 06:40:59',NULL),(1084,92,3,'ar','هونج كونج',NULL,'2022-03-07 06:40:59',NULL),(1085,93,3,'ar','هندوراس',NULL,'2022-03-07 06:40:59',NULL),(1086,94,3,'ar','كرواتيا',NULL,'2022-03-07 06:40:59',NULL),(1087,95,3,'ar','هايتي',NULL,'2022-03-07 06:40:59',NULL),(1088,96,3,'ar','هنغاريا',NULL,'2022-03-07 06:40:59',NULL),(1089,97,3,'ar','إندونيسيا',NULL,'2022-03-07 06:40:59',NULL),(1090,98,3,'ar','أيرلندا',NULL,'2022-03-07 06:40:59',NULL),(1091,99,3,'ar','إسرائيل',NULL,'2022-03-07 06:40:59',NULL),(1092,100,3,'ar','الهند',NULL,'2022-03-07 06:40:59',NULL),(1093,101,3,'ar','العراق',NULL,'2022-03-07 06:40:59',NULL),(1094,102,3,'ar','إيران',NULL,'2022-03-07 06:40:59',NULL),(1095,103,3,'ar','أيسلندا',NULL,'2022-03-07 06:40:59',NULL),(1096,104,3,'ar','إيطاليا',NULL,'2022-03-07 06:40:59',NULL),(1097,105,3,'ar','جامايكا',NULL,'2022-03-07 06:40:59',NULL),(1098,106,3,'ar','الأردن',NULL,'2022-03-07 06:40:59',NULL),(1099,107,3,'ar','اليابان',NULL,'2022-03-07 06:40:59',NULL),(1100,108,3,'ar','كينيا',NULL,'2022-03-07 06:41:00',NULL),(1101,109,3,'ar','قيرغيزستان',NULL,'2022-03-07 06:41:00',NULL),(1102,110,3,'ar','كمبوديا',NULL,'2022-03-07 06:41:00',NULL),(1103,111,3,'ar','كيريباتي',NULL,'2022-03-07 06:41:00',NULL),(1104,112,3,'ar','جزر القمر',NULL,'2022-03-07 06:41:00',NULL),(1105,113,3,'ar','سانت كيتس',NULL,'2022-03-07 06:41:00',NULL),(1106,114,3,'ar','جمهورية كوريا الديمقراطية الشعبية',NULL,'2022-03-07 06:41:00',NULL),(1107,115,3,'ar','كوريا',NULL,'2022-03-07 06:41:00',NULL),(1108,116,3,'ar','الكويت',NULL,'2022-03-07 06:41:00',NULL),(1109,117,3,'ar','جزر كايمان',NULL,'2022-03-07 06:41:00',NULL),(1110,118,3,'ar','كازاخستان',NULL,'2022-03-07 06:41:00',NULL),(1111,119,3,'ar','جمهورية لاو الديمقراطية الشعبية',NULL,'2022-03-07 06:41:00',NULL),(1112,120,3,'ar','لبنان',NULL,'2022-03-07 06:41:00',NULL),(1113,121,3,'ar','شارع لوسيا',NULL,'2022-03-07 06:41:00',NULL),(1114,122,3,'ar','ليختنشتاين',NULL,'2022-03-07 06:41:00',NULL),(1115,123,3,'ar','سيريلانكا',NULL,'2022-03-07 06:41:00',NULL),(1116,124,3,'ar','ليبيريا',NULL,'2022-03-07 06:41:00',NULL),(1117,125,3,'ar','ليسوتو',NULL,'2022-03-07 06:41:00',NULL),(1118,126,3,'ar','ليتوانيا',NULL,'2022-03-07 06:41:00',NULL),(1119,127,3,'ar','لوكسمبورغ',NULL,'2022-03-07 06:41:00',NULL),(1120,128,3,'ar','لاتفيا',NULL,'2022-03-07 06:41:00',NULL),(1121,129,3,'ar','الجماهيرية العربية الليبية',NULL,'2022-03-07 06:41:01',NULL),(1122,130,3,'ar','المغرب',NULL,'2022-03-07 06:41:01',NULL),(1123,131,3,'ar','المكسيك العازلة',NULL,'2022-03-07 06:41:01',NULL),(1124,132,3,'ar','موناكو',NULL,'2022-03-07 06:41:01',NULL),(1125,133,3,'ar','مولدوفا',NULL,'2022-03-07 06:41:01',NULL),(1126,134,3,'ar','الجبل الأسود',NULL,'2022-03-07 06:41:01',NULL),(1127,135,3,'ar','جزيرة مدغشقر',NULL,'2022-03-07 06:41:01',NULL),(1128,136,3,'ar','جزر مارشال',NULL,'2022-03-07 06:41:01',NULL),(1129,137,3,'ar','مقدونيا -Fyrom-',NULL,'2022-03-07 06:41:01',NULL),(1130,138,3,'ar','مالي',NULL,'2022-03-07 06:41:01',NULL),(1131,139,3,'ar','ميانمار',NULL,'2022-03-07 06:41:01',NULL),(1132,140,3,'ar','منغوليا',NULL,'2022-03-07 06:41:01',NULL),(1133,141,3,'ar','ماكاو',NULL,'2022-03-07 06:41:01',NULL),(1134,142,3,'ar','جزر مريانا الشمالية',NULL,'2022-03-07 06:41:01',NULL),(1135,143,3,'ar','مارتينيك',NULL,'2022-03-07 06:41:01',NULL),(1136,144,3,'ar','موريتانيا',NULL,'2022-03-07 06:41:01',NULL),(1137,145,3,'ar','مونتسيرات',NULL,'2022-03-07 06:41:01',NULL),(1138,146,3,'ar','مالطا',NULL,'2022-03-07 06:41:01',NULL),(1139,147,3,'ar','جزيرة موريشيوس',NULL,'2022-03-07 06:41:01',NULL),(1140,148,3,'ar','جزيرة المالديف',NULL,'2022-03-07 06:41:01',NULL),(1141,149,3,'ar','ملاوي',NULL,'2022-03-07 06:41:01',NULL),(1142,150,3,'ar','المكسيك',NULL,'2022-03-07 06:41:01',NULL),(1143,151,3,'ar','ماليزيا',NULL,'2022-03-07 06:41:02',NULL),(1144,152,3,'ar','موزمبيق',NULL,'2022-03-07 06:41:02',NULL),(1145,153,3,'ar','ناميبيا',NULL,'2022-03-07 06:41:02',NULL),(1146,154,3,'ar','كاليدونيا الجديدة',NULL,'2022-03-07 06:41:02',NULL),(1147,155,3,'ar','النيجر',NULL,'2022-03-07 06:41:02',NULL),(1148,156,3,'ar','جزيرة نورفولك',NULL,'2022-03-07 06:41:02',NULL),(1149,157,3,'ar','نيجيريا',NULL,'2022-03-07 06:41:02',NULL),(1150,158,3,'ar','نيكاراغوا',NULL,'2022-03-07 06:41:02',NULL),(1151,159,3,'ar','هولندا',NULL,'2022-03-07 06:41:02',NULL),(1152,160,3,'ar','النرويج',NULL,'2022-03-07 06:41:02',NULL),(1153,161,3,'ar','نيبال',NULL,'2022-03-07 06:41:02',NULL),(1154,162,3,'ar','ناورو',NULL,'2022-03-07 06:41:02',NULL),(1155,163,3,'ar','نيوي',NULL,'2022-03-07 06:41:02',NULL),(1156,164,3,'ar','نيوزيلاندا',NULL,'2022-03-07 06:41:02',NULL),(1157,165,3,'ar','سلطنة عمان',NULL,'2022-03-07 06:41:02',NULL),(1158,166,3,'ar','بنما',NULL,'2022-03-07 06:41:03',NULL),(1159,167,3,'ar','بيرو',NULL,'2022-03-07 06:41:03',NULL),(1160,168,3,'ar','بولينيزيا الفرنسية',NULL,'2022-03-07 06:41:03',NULL),(1161,169,3,'ar','بابوا غينيا الجديدة',NULL,'2022-03-07 06:41:03',NULL),(1162,170,3,'ar','فيلبيني',NULL,'2022-03-07 06:41:03',NULL),(1163,171,3,'ar','باكستان',NULL,'2022-03-07 06:41:03',NULL),(1164,172,3,'ar','بولندا',NULL,'2022-03-07 06:41:03',NULL),(1165,173,3,'ar','سانت بيير وميكلون',NULL,'2022-03-07 06:41:03',NULL),(1166,174,3,'ar','بورتوريكو',NULL,'2022-03-07 06:41:03',NULL),(1167,175,3,'ar','فلسطيني خارجي إقليم',NULL,'2022-03-07 06:41:03',NULL),(1168,176,3,'ar','البرتغال',NULL,'2022-03-07 06:41:03',NULL),(1169,177,3,'ar','جزر بالاو',NULL,'2022-03-07 06:41:03',NULL),(1170,178,3,'ar','باراغواي',NULL,'2022-03-07 06:41:03',NULL),(1171,179,3,'ar','دولة قطر',NULL,'2022-03-07 06:41:03',NULL),(1172,180,3,'ar','جزيرة ريونيون',NULL,'2022-03-07 06:41:03',NULL),(1173,181,3,'ar','رومانيا',NULL,'2022-03-07 06:41:03',NULL),(1174,182,3,'ar','صربيا',NULL,'2022-03-07 06:41:03',NULL),(1175,183,3,'ar','روسيا',NULL,'2022-03-07 06:41:03',NULL),(1176,184,3,'ar','رواندا',NULL,'2022-03-07 06:41:03',NULL),(1177,185,3,'ar','المملكة العربية السعودية',NULL,'2022-03-07 06:41:04',NULL),(1178,186,3,'ar','جزر سليمان',NULL,'2022-03-07 06:41:04',NULL),(1179,187,3,'ar','جزر سيشل',NULL,'2022-03-07 06:41:04',NULL),(1180,188,3,'ar','السودان',NULL,'2022-03-07 06:41:04',NULL),(1181,189,3,'ar','السويد',NULL,'2022-03-07 06:41:04',NULL),(1182,190,3,'ar','سنغافورة',NULL,'2022-03-07 06:41:04',NULL),(1183,191,3,'ar','جزيرة سانت هيلانة',NULL,'2022-03-07 06:41:04',NULL),(1184,192,3,'ar','سلوفينيا',NULL,'2022-03-07 06:41:04',NULL),(1185,193,3,'ar','سلوفاكيا',NULL,'2022-03-07 06:41:04',NULL),(1186,194,3,'ar','سيرا ليون',NULL,'2022-03-07 06:41:04',NULL),(1187,195,3,'ar','سان مارينو',NULL,'2022-03-07 06:41:04',NULL),(1188,196,3,'ar','السنغال',NULL,'2022-03-07 06:41:04',NULL),(1189,197,3,'ar','الصومال',NULL,'2022-03-07 06:41:04',NULL),(1190,198,3,'ar','سورينام',NULL,'2022-03-07 06:41:04',NULL),(1191,199,3,'ar','جنوب السودان',NULL,'2022-03-07 06:41:04',NULL),(1192,200,3,'ar','جزر ساو تومي وبرينسيبي',NULL,'2022-03-07 06:41:04',NULL),(1193,201,3,'ar','السلفادور',NULL,'2022-03-07 06:41:04',NULL),(1194,202,3,'ar','سينت مارتن',NULL,'2022-03-07 06:41:04',NULL),(1195,203,3,'ar','الجمهورية العربية السورية',NULL,'2022-03-07 06:41:05',NULL),(1196,204,3,'ar','سوازيلاند',NULL,'2022-03-07 06:41:05',NULL),(1197,205,3,'ar','جزر تركس وكايكوس',NULL,'2022-03-07 06:41:05',NULL),(1198,206,3,'ar','تشاد',NULL,'2022-03-07 06:41:05',NULL),(1199,207,3,'ar','توجو',NULL,'2022-03-07 06:41:05',NULL),(1200,208,3,'ar','تايلاند',NULL,'2022-03-07 06:41:05',NULL),(1201,209,3,'ar','طاجيكستان',NULL,'2022-03-07 06:41:05',NULL),(1202,210,3,'ar','توكيلاو',NULL,'2022-03-07 06:41:05',NULL),(1203,211,3,'ar','تيمور ليشتي',NULL,'2022-03-07 06:41:05',NULL),(1204,212,3,'ar','تركمانستان',NULL,'2022-03-07 06:41:05',NULL),(1205,213,3,'ar','تونس',NULL,'2022-03-07 06:41:05',NULL),(1206,214,3,'ar','تونغا',NULL,'2022-03-07 06:41:05',NULL),(1207,215,3,'ar','تيمور الشرقية',NULL,'2022-03-07 06:41:05',NULL),(1208,216,3,'ar','ديك رومى',NULL,'2022-03-07 06:41:05',NULL),(1209,217,3,'ar','ترينداد وتوباغو',NULL,'2022-03-07 06:41:05',NULL),(1210,218,3,'ar','توفالو',NULL,'2022-03-07 06:41:05',NULL),(1211,219,3,'ar','تايوان',NULL,'2022-03-07 06:41:05',NULL),(1212,220,3,'ar','جمهورية تنزانيا المتحدة',NULL,'2022-03-07 06:41:05',NULL),(1213,221,3,'ar','أوكرانيا',NULL,'2022-03-07 06:41:05',NULL),(1214,222,3,'ar','أوغندا',NULL,'2022-03-07 06:41:05',NULL),(1215,223,3,'ar','الجزر الصغيرة البعيدة عن الولايات المتحدة',NULL,'2022-03-07 06:41:05',NULL),(1216,224,3,'ar','الولايات المتحدة الامريكية',NULL,'2022-03-07 06:41:05',NULL),(1217,225,3,'ar','أوروغواي',NULL,'2022-03-07 06:41:06',NULL),(1218,226,3,'ar','أوزبكستان',NULL,'2022-03-07 06:41:06',NULL),(1219,227,3,'ar','الفاتيكان',NULL,'2022-03-07 06:41:06',NULL),(1220,228,3,'ar','شارع فنسنت',NULL,'2022-03-07 06:41:06',NULL),(1221,229,3,'ar','فنزويلا',NULL,'2022-03-07 06:41:06',NULL),(1222,230,3,'ar','جزر العذراء البريطانية',NULL,'2022-03-07 06:41:06',NULL),(1223,231,3,'ar','جزر فيرجن - الولايات المتحدة',NULL,'2022-03-07 06:41:06',NULL),(1224,232,3,'ar','فيتنام',NULL,'2022-03-07 06:41:06',NULL),(1225,233,3,'ar','فانواتو',NULL,'2022-03-07 06:41:06',NULL),(1226,234,3,'ar','جزر واليس وفوتونا',NULL,'2022-03-07 06:41:06',NULL),(1227,235,3,'ar','دولة ساموا المستقلة',NULL,'2022-03-07 06:41:06',NULL),(1228,236,3,'ar','الجمهورية اليمنية',NULL,'2022-03-07 06:41:06',NULL),(1229,237,3,'ar','مايوت',NULL,'2022-03-07 06:41:06',NULL),(1230,238,3,'ar','جنوب أفريقيا',NULL,'2022-03-07 06:41:06',NULL),(1231,239,3,'ar','زامبيا',NULL,'2022-03-07 06:41:06',NULL),(1232,240,3,'ar','زيمبابوي',NULL,'2022-03-07 06:41:06',NULL),(1233,256,3,'ar','',NULL,'2022-03-07 06:41:06',NULL);
/*!40000 ALTER TABLE `countryTranslation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `docTitle` varchar(100) NOT NULL,
  `docDescription` varchar(200) DEFAULT NULL,
  `hasTranslate` tinyint NOT NULL DEFAULT '0',
  `groupName` varchar(100) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  UNIQUE KEY `documents_UN` (`docTitle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `installmentMessages`
--

DROP TABLE IF EXISTS `installmentMessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `installmentMessages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `installmentId` int NOT NULL,
  `userId` int NOT NULL,
  `message` varchar(300) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `installmentMessages`
--

LOCK TABLES `installmentMessages` WRITE;
/*!40000 ALTER TABLE `installmentMessages` DISABLE KEYS */;
/*!40000 ALTER TABLE `installmentMessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `installments`
--

DROP TABLE IF EXISTS `installments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `installments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `contractId` int NOT NULL,
  `applicantId` int DEFAULT NULL,
  `installmentNumber` tinyint NOT NULL DEFAULT '1',
  `price` decimal(14,2) NOT NULL,
  `priceCurrency` char(3) NOT NULL,
  `dueDate` timestamp NULL DEFAULT NULL,
  `deadLine` tinyint DEFAULT NULL,
  `documentFile` varchar(100) DEFAULT NULL,
  `isMain` tinyint DEFAULT '1',
  `status` tinyint DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  UNIQUE KEY `installments_UN` (`contractId`,`applicantId`,`installmentNumber`,`isMain`),
  KEY `installments_FK_1` (`applicantId`),
  CONSTRAINT `installments_FK` FOREIGN KEY (`contractId`) REFERENCES `contracts` (`id`),
  CONSTRAINT `installments_FK_1` FOREIGN KEY (`applicantId`) REFERENCES `applicant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `installments`
--

LOCK TABLES `installments` WRITE;
/*!40000 ALTER TABLE `installments` DISABLE KEYS */;
/*!40000 ALTER TABLE `installments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'شناسه',
  `name` varchar(50) NOT NULL COMMENT 'نام',
  `path` varchar(50) NOT NULL COMMENT 'مسیر',
  `method` enum('GET','POST','PUT','DELETE') NOT NULL COMMENT 'متد',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index2` (`method`,`path`),
  KEY `index3` (`path`,`method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='سطوح دسترسی';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolePermission_NN`
--

DROP TABLE IF EXISTS `rolePermission_NN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolePermission_NN` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'شناسه',
  `roleId` int NOT NULL COMMENT 'شناسه نقش',
  `permissionId` int NOT NULL COMMENT 'شناسه دسترسی',
  `status` enum('enabled','disabled') NOT NULL DEFAULT 'enabled' COMMENT 'وضعیت',
  `expiredAt` timestamp NULL DEFAULT NULL COMMENT 'زمان انقضا',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index2` (`permissionId`,`roleId`),
  KEY `index4` (`permissionId`,`status`),
  KEY `index3` (`status`,`roleId`)
) ENGINE=InnoDB AUTO_INCREMENT=29421 DEFAULT CHARSET=utf8mb3 COMMENT='ارتباط سطوح دسترسی به نقش';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolePermission_NN`
--

LOCK TABLES `rolePermission_NN` WRITE;
/*!40000 ALTER TABLE `rolePermission_NN` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolePermission_NN` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(45) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  UNIQUE KEY `title_UNIQUE` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'کاربر عادی','2024-06-18 13:39:00',NULL);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticketActions`
--

DROP TABLE IF EXISTS `ticketActions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticketActions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `url` varchar(100) NOT NULL,
  `requestFields` json DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticketActions`
--

LOCK TABLES `ticketActions` WRITE;
/*!40000 ALTER TABLE `ticketActions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticketActions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticketCategory`
--

DROP TABLE IF EXISTS `ticketCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticketCategory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ticketCategory_UN` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticketCategory`
--

LOCK TABLES `ticketCategory` WRITE;
/*!40000 ALTER TABLE `ticketCategory` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticketCategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticketCategoryActions_NN`
--

DROP TABLE IF EXISTS `ticketCategoryActions_NN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticketCategoryActions_NN` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoryId` int NOT NULL,
  `actionId` int NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticketCategoryActions_NN`
--

LOCK TABLES `ticketCategoryActions_NN` WRITE;
/*!40000 ALTER TABLE `ticketCategoryActions_NN` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticketCategoryActions_NN` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticketMasseges`
--

DROP TABLE IF EXISTS `ticketMasseges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticketMasseges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `ticketId` int NOT NULL,
  `message` varchar(200) DEFAULT NULL,
  `isRead` tinyint DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  KEY `ticketMasseges_FK` (`userId`),
  KEY `ticketMasseges_FK_1` (`ticketId`),
  CONSTRAINT `ticketMasseges_FK` FOREIGN KEY (`userId`) REFERENCES `users` (`id`),
  CONSTRAINT `ticketMasseges_FK_1` FOREIGN KEY (`ticketId`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticketMasseges`
--

LOCK TABLES `ticketMasseges` WRITE;
/*!40000 ALTER TABLE `ticketMasseges` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticketMasseges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoryId` int NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `status` enum('created','replyed','closed','waiting') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'created',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  KEY `tickets_FK` (`categoryId`),
  CONSTRAINT `tickets_FK` FOREIGN KEY (`categoryId`) REFERENCES `ticketCategory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `smscode` char(4) DEFAULT NULL,
  `mobile` varchar(11) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `roleId` int DEFAULT '1',
  `name` varchar(100) DEFAULT NULL,
  `family` varchar(100) DEFAULT NULL,
  `profilePicture` varchar(100) DEFAULT NULL,
  `status` tinyint DEFAULT '0',
  `smsTimeLeft` timestamp NULL DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'زمان ایجاد',
  `updatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'زمان بروزرسانی',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_UN_username` (`username`),
  UNIQUE KEY `users_UN` (`mobile`),
  UNIQUE KEY `users_email_UN` (`email`),
  KEY `users_FK` (`roleId`),
  CONSTRAINT `users_FK` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (28,'09361762073','$2b$10$cJowczIikcn2F08GOK8T1.Mz8zdLReeU2s0PG0pX8GZzOqrqg/Iti',NULL,'09361762073','3',1,'mohammad','moradi','localhost:9000/users/08eee24c62be9a33693b9d6bcad84832.png',1,NULL,'2024-06-18 10:34:26',NULL),(30,'09361762074','$2b$10$grrkJPX6lvYHrh.X6XLbN.eC11OMYY/MyaJlY.9w3z890PFPBRccq',NULL,'09361762074',NULL,1,'mohammad','moradi','localhost:9000/users/ec62216b67ddc63d17b53177850d97da.png',1,NULL,'2024-06-18 10:34:47',NULL),(31,'09361762072','$2b$10$iys748s4s8FdhxjMoP01feF6M7F2U.uIZf.Nfg4xNhmQHFvkUJhKe','9172','09361762072',NULL,1,'mohammad','moradi','localhost:9000/users/3a0deb91bd08a8365a6e27dbefa7c94a.png',1,'2024-06-19 10:18:51','2024-06-18 10:34:58','2024-06-19 13:48:50');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `viwCountries`
--

DROP TABLE IF EXISTS `viwCountries`;
/*!50001 DROP VIEW IF EXISTS `viwCountries`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `viwCountries` AS SELECT 
 1 AS `id`,
 1 AS `code`,
 1 AS `phoneCode`,
 1 AS `extraDetails`,
 1 AS `map`,
 1 AS `createdAt`,
 1 AS `updatedAt`,
 1 AS `en`,
 1 AS `fa`,
 1 AS `ar`,
 1 AS `ru`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'vitrapo'
--

--
-- Dumping routines for database 'vitrapo'
--

--
-- Final view structure for view `viwCountries`
--

/*!50001 DROP VIEW IF EXISTS `viwCountries`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `viwCountries` AS select `c`.`id` AS `id`,`c`.`code` AS `code`,`c`.`phoneCode` AS `phoneCode`,`c`.`extraDetails` AS `extraDetails`,`c`.`map` AS `map`,`c`.`createdAt` AS `createdAt`,`c`.`updatedAt` AS `updatedAt`,(select `b`.`name` from `countryTranslation` `b` where ((`b`.`languageId` = 1) and (`b`.`countryId` = `c`.`id`))) AS `en`,(select `b`.`name` from `countryTranslation` `b` where ((`b`.`languageId` = 2) and (`b`.`countryId` = `c`.`id`))) AS `fa`,(select `b`.`name` from `countryTranslation` `b` where ((`b`.`languageId` = 3) and (`b`.`countryId` = `c`.`id`))) AS `ar`,(select `b`.`name` from `countryTranslation` `b` where ((`b`.`languageId` = 4) and (`b`.`countryId` = `c`.`id`))) AS `ru` from `countries` `c` */;
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

-- Dump completed on 2024-06-19 17:21:58
