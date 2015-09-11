-- MySQL dump 10.13  Distrib 5.5.8, for Win64 (x86)
--
-- Host: localhost    Database: memex_sotera
-- ------------------------------------------------------
-- Server version	5.5.8

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `datawake_data`
--
DROP DATABASE IF EXISTS c3;
CREATE DATABASE IF NOT EXISTS c3;
USE c3;

DROP TABLE IF EXISTS `datawake_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datawake_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `url` text,
  `userEmail` varchar(245) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `domain_id` int(11) DEFAULT NULL,
  `trail_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `team_id` (`team_id`),
  KEY `domain_id` (`domain_id`),
  KEY `trail_id` (`trail_id`),
  KEY `url` (`url`(30)),
  CONSTRAINT `datawake_data_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `datawake_teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `datawake_data_ibfk_2` FOREIGN KEY (`domain_id`) REFERENCES `datawake_domains` (`id`) ON DELETE CASCADE,
  CONSTRAINT `datawake_data_ibfk_3` FOREIGN KEY (`trail_id`) REFERENCES `datawake_trails` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datawake_data`
--

LOCK TABLES `datawake_data` WRITE;
/*!40000 ALTER TABLE `datawake_data` DISABLE KEYS */;
INSERT INTO `datawake_data` VALUES (27,'2014-09-09 00:35:49','http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','john.doe@nomail.none',1,5,19),(28,'2014-09-09 00:36:05','https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','john.doe@nomail.none',1,5,19),(29,'2014-09-09 00:36:23','http://myproviderguide.com/phone/626-344-9893','john.doe@nomail.none',1,5,19),(30,'2014-09-09 00:36:36','https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','john.doe@nomail.none',1,5,19),(31,'2014-09-09 00:37:46','http://www.theeroticreview.com/reviews/show.asp?id=227534','john.doe@nomail.none',1,5,19),(32,'2014-09-09 00:38:00','https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','john.doe@nomail.none',1,5,19),(33,'2014-09-09 00:38:37','https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=6263449893','john.doe@nomail.none',1,5,19),(34,'2014-09-09 00:38:54','http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','john.doe@nomail.none',1,5,19);
ALTER TABLE `datawake_data`
ADD COLUMN `crawl_type` VARCHAR(255) NULL AFTER `trail_id`,
ADD COLUMN `comments` VARCHAR(1000) NULL AFTER `crawl_type`;
/*!40000 ALTER TABLE `datawake_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datawake_domain_entities`
--

DROP TABLE IF EXISTS `datawake_domain_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datawake_domain_entities` (
  `domain_entity_id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) DEFAULT NULL,
  `feature_type` varchar(100) DEFAULT NULL,
  `feature_value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`domain_entity_id`),
  KEY `domain_id` (`domain_id`),
  CONSTRAINT `datawake_domain_entities_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `datawake_domains` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3626220 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datawake_domain_entities`
--

LOCK TABLES `datawake_domain_entities` WRITE;
/*!40000 ALTER TABLE `datawake_domain_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `datawake_domain_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datawake_domains`
--

DROP TABLE IF EXISTS `datawake_domains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datawake_domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) DEFAULT NULL,
  `description` text,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`team_id`),
  KEY `team_id` (`team_id`),
  CONSTRAINT `datawake_domains_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `datawake_teams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datawake_domains`
--

LOCK TABLES `datawake_domains` WRITE;
/*!40000 ALTER TABLE `datawake_domains` DISABLE KEYS */;
INSERT INTO `datawake_domains` VALUES (5,'memexht','anti human trafficking data',1);
/*!40000 ALTER TABLE `datawake_domains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datawake_selections`
--

DROP TABLE IF EXISTS `datawake_selections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datawake_selections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `trail_id` int(11) DEFAULT NULL,
  `userEmail` varchar(245) DEFAULT NULL,
  `url` text,
  `selection` text,
  PRIMARY KEY (`id`),
  KEY `trail_id` (`trail_id`,`url`(60)),
  CONSTRAINT `datawake_selections_ibfk_1` FOREIGN KEY (`trail_id`) REFERENCES `datawake_trails` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datawake_selections`
--

LOCK TABLES `datawake_selections` WRITE;
/*!40000 ALTER TABLE `datawake_selections` DISABLE KEYS */;
/*!40000 ALTER TABLE `datawake_selections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datawake_team_users`
--

DROP TABLE IF EXISTS `datawake_team_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datawake_team_users` (
  `team_user_id` int(11) NOT NULL AUTO_INCREMENT,
  `team_id` int(11) DEFAULT NULL,
  `email` varchar(245) DEFAULT NULL,
  PRIMARY KEY (`team_user_id`),
  KEY `fkTeamID` (`team_id`),
  CONSTRAINT `datawake_team_users_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `datawake_teams` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datawake_team_users`
--

LOCK TABLES `datawake_team_users` WRITE;
/*!40000 ALTER TABLE `datawake_team_users` DISABLE KEYS */;
INSERT INTO `datawake_team_users` VALUES (1,1,'john.doe@nomail.none\n');
/*!40000 ALTER TABLE `datawake_team_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datawake_teams`
--

DROP TABLE IF EXISTS `datawake_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datawake_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datawake_teams`
--

LOCK TABLES `datawake_teams` WRITE;
/*!40000 ALTER TABLE `datawake_teams` DISABLE KEYS */;
INSERT INTO `datawake_teams` VALUES (1,'CWhite','CWhite Team\n');
/*!40000 ALTER TABLE `datawake_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datawake_trails`
--

DROP TABLE IF EXISTS `datawake_trails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datawake_trails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(245) DEFAULT NULL,
  `description` text,
  `team_id` int(11) DEFAULT NULL,
  `domain_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain_id` (`domain_id`,`name`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  KEY `team_id` (`team_id`),
  CONSTRAINT `datawake_trails_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `datawake_teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `datawake_trails_ibfk_2` FOREIGN KEY (`domain_id`) REFERENCES `datawake_domains` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datawake_trails`
--

LOCK TABLES `datawake_trails` WRITE;
/*!40000 ALTER TABLE `datawake_trails` DISABLE KEYS */;
INSERT INTO `datawake_trails` VALUES (19,'cherry11','2014-09-08 22:12:21','curtis.colridge@gmail.com','A search on the cherry11 network',1,5);
/*!40000 ALTER TABLE `datawake_trails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datawake_url_rank`
--

DROP TABLE IF EXISTS `datawake_url_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datawake_url_rank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` text,
  `userEmail` varchar(245) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `domain_id` int(11) DEFAULT NULL,
  `trail_id` int(11) DEFAULT NULL,
  `rank` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `team_id` (`team_id`),
  KEY `domain_id` (`domain_id`),
  KEY `trail_id` (`trail_id`,`userEmail`(30),`url`(30)),
  CONSTRAINT `datawake_url_rank_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `datawake_teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `datawake_url_rank_ibfk_2` FOREIGN KEY (`domain_id`) REFERENCES `datawake_domains` (`id`) ON DELETE CASCADE,
  CONSTRAINT `datawake_url_rank_ibfk_3` FOREIGN KEY (`trail_id`) REFERENCES `datawake_trails` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datawake_url_rank`
--

LOCK TABLES `datawake_url_rank` WRITE;
/*!40000 ALTER TABLE `datawake_url_rank` DISABLE KEYS */;
/*!40000 ALTER TABLE `datawake_url_rank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_extractor_web_index`
--

DROP TABLE IF EXISTS `domain_extractor_web_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain_extractor_web_index` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) DEFAULT NULL,
  `url` varchar(1024) DEFAULT NULL,
  `feature_type` varchar(100) DEFAULT NULL,
  `feature_value` varchar(1024) DEFAULT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueFeature` (`url`(300),`feature_type`,`feature_value`(100)),
  KEY `domain_id` (`domain_id`,`url`(300))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_extractor_web_index`
--

LOCK TABLES `domain_extractor_web_index` WRITE;
/*!40000 ALTER TABLE `domain_extractor_web_index` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_extractor_web_index` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `general_extractor_web_index`
--

DROP TABLE IF EXISTS `general_extractor_web_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `general_extractor_web_index` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(1024) DEFAULT NULL,
  `feature_type` varchar(100) DEFAULT NULL,
  `feature_value` varchar(1024) DEFAULT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uniqueFeature` (`url`(300),`feature_type`,`feature_value`(100)),
  KEY `url` (`url`(300))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `general_extractor_web_index`
--

LOCK TABLES `general_extractor_web_index` WRITE;
/*!40000 ALTER TABLE `general_extractor_web_index` DISABLE KEYS */;
/*!40000 ALTER TABLE `general_extractor_web_index` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `general_extractor_web_index` WRITE;
/*!40000 ALTER TABLE `general_extractor_web_index` DISABLE KEYS */;
INSERT INTO `general_extractor_web_index` (`id`,`url`,`feature_type`,`feature_value`,`ts`) VALUES (null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/topic/5349/bedazzled-girls/','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://rubmaps.com/users-reset-password','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/advanced-search','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/topic/5347/lasd-sting-santa-clarita/','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/users-sign-in','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/rubmaps-slang','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/topic/5346/new-guy-old-monger/','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://aff.camplace.com/delivery/?w=12&amp;b=Webcams&amp;t=2&amp;c=Rubmaps','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/blog','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/users-login','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/topic/5345/my-avatar-not-showingjust-black-box/','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/signup?from=new-user-button','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/topic/5348/harmony-spa-in-watsonville/','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','turner','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','joejoeda','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Sherry Chinese','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Chick','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Rose Garden Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Amy Chinese','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Atmosphere','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','sherry','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Sofie','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Id have','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Bebe Asian','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Din Din Asian','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Lilly','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Grabbed','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Mary Chinese','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Marilyn','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Mimi Chinese','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Hilarious','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Grace Asian','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Stroking','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Celia','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Anyways','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Brown Brown','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Linda Chinese','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Mary Asian','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Nancy','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Grace','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Linda','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Din Din Chinese','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Nancy Chinese','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','my Perineum','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','nolikey Bebe','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Kelly','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Rose Garden','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Din Din','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Claudia','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Heard','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Senor Fish','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Masseuse','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Helen','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Brown Black','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Jane Lac Dhara','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Cindy','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Helen Chinese','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Emily','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','SpaIn Thai','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Moon Massage','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Thai Day Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Thai Massage Saranrom','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Lee-Lee','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Residence Morning $50 Massage Parlor','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Spa Delight Day Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Chinese','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Hot Chinese','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Thai Spa Healing','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Grace Asian','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Asian Hours of Operation : 10am','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Koreans','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Asian','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','English','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','phone','6263449893','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','phone','3239829369','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Colorado','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Rose Garden Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','DakotaOhioOklahomaOregonPennsylvaniaRhode IslandSouth','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Los Angeles','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Montreal','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','bakersfield','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Sofia','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','San Gabriel','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','California','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','between York','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Italy','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Norwalk','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Watsonville','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Eagle Rock','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','China','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Lexington Chiropractor','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Forth','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Sabai Thai Spa Thai Therapy Ploi Siam Thai Yoga Massage The Health Center The Raven Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','CarolinaSouth DakotaTennesseeTexasUtahVermontVirginiaWashingtonWest','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Rose Aroma Rose Garden Spa Rose Massage Rose Therapy','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Keerati Thai Keson Massage Spaah Kiku Massage King Spa KL Health Center Kona Spa LA Face & Mind LA Foot Massage LA Massage La Nuru Spa LA Shiatsu Massage LA Sports Massage Lake Therapy Lala Massage','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Resolution Rape Culture','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','H Therapy Wat Po Thai Massage Water Flower Massage Wellness Center Wellness Face and Bodyworks Wellness Therapy West LA Foot Massage Western Massage Western Spa Massage Wilshire Massage Wonderful Asian Massage World Thai Spa Xin Xin Health Center YaYa Massage YC','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','More Spring Leisure Massage Star Holistic Spa Star Spa Sunny Health Center Sunshine Facial & Thai Massage Sunshine Thai Massage','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Early Evening $50 Massage Parlor','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Resolution DDOS','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Asian Massage Top Oriental Massage Top Oriental Therapy','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Spa Holiday Spa Hollywood Hills Thai Spa Hot Asian Girls Huang','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Store Front Noon $40 Massage Parlor','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Royal Thai Massage Ruby Safari Therapy Sage Spa Sakura Shiatsu Sakura Spa Sandy','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','LP Health CareNatural Healing Therapy','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Spa Sawadi Body Works SD Health Care','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','YorkNorth CarolinaNorth','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Spa Thai House Massage Thai Massage Thai Orchid Massage Thai','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Jian Kang Acupuncture Jiuan Health Center JJ \'s JM Wellness Center Joy Thai Massage Joy Wellness Center','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','CFS BBBJTC','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Vitalitypro LLC','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Relaxing Massage Health and Beauty Center Health Center Heaven Spa Highland Park Acupuncture Highland Thai Massage','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Petite Nice & Round','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Li Yue Massage Lily Care Lion Spa Los Angeles Acucare Lotus Therapeutic Massage LP Health Care Lucky Spa Ly Health Center M & M Best Spa M&T Massage Main Avenue Spa Manju Spa Massage In LA Massage','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Store Front Early Evening $40 Massage Parlor','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Relax MassageWater Flower MassageDelight Day SpaFootssage SawtelleCentury Health CenterSerenity Thai MassageChinatown Massage Western Spa Massage Acu Therapy Pain ClinicVenice Health Center','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Ananya Thai Massage Ancient Thai Massage Angel Massage Center Antique Thai Massage Apple Massage Apple One Spa Apple VIP Massage Apple VIP Spa Aqua Thai Spa Aroma Spa & Massage Aroma Therapy Asian Acupressure Asian Body Massage Asian Latina Beauty Massage Asian Massage Asian Massage Asian Massage Asian Massage Asian Massage Asian Massage Asian Massage Asian Massage Center Asian Oasis Massage Asian Spa Asian Spa Asian Spa Asian Touch ATLANTIC Massage Spa B Z Acupuncture Bai Po & Thai Massage Bailan Body Work BB Hills Beauty Center Bella Bellissimo Best Alternative Medicine Best Massage Therapy Beverly Hills Spa Beverly Total Clinic','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Los Angeles CA Rose Garden Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Bliss Massage Spa Blue Moon Thai Spa Body Care Body Care Thai Massage Body Centre Spa Brazilian Massage Buahinia Spa CAK Health Care CC Acupuncture Central Acupuncture Century Health Center Chandra Thai Spa Cherry Spa China Doll China Doll Massage China Doll Massage Chinatown Massage Chinese Therapy Chinese Therapy Center Chiva Massage','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thin Nice & Round Clean Shaven','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Perfect Nice','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Real Massage The Stars Body Center TJ Health Care Center TJ Healthy Massage Tokyo Massage Tokyo Spa Tokyo Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Dhevi Thai Massage Dream Spa Dreamy Massage Dtox Day Spa Dynasty Wellness Center Eagle Health Care Eagle Health Center East West Health Center Eastern Massage Eden Spa Wellness Center Ela Heath Care Elemental Beauty Spa Enliven Massage Euphoria Massage Euphoria Massage Euphoria Massage Euphoria Massage Evergreen Accupuncture Evergreen Massage Foot Heaven Footssage Sawtelle Forever Body Massage Gentlemens Service Center GG Health Center Gigi Massage Ginger Foot Spa Godibas Face Skin Care Good Eastern Chinese Massage Green Acupressure Green Health Spa Green Massage Spa Green Massage Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thin Nice & Round','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Los Angeles CA Rose Garden Spa Rubmaps','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Rose Garden Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','SpaSunshine Facial & Thai MassageChiva MassageLet','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Energizing Spa Relief Thai Massage Reseda Rest','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Daisy Day Spa Daisy Wellness Center Day Spa Dayko Spa Del Rey','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Spa In Thai Spa In Thai Spa International Latina Therapy International Latinas Intimate Asian Massage Jade Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Lake Silverlake Spa Singular Massage SK Green Care SK Massage & Spa Sky Aroma Massage Sole To Sole Spa Spa D \' Rainbow Spa de Beverly Spaahbulous','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','California Distance','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','AAA Relax Massage Acu Care Acu Therapy Pain Clinic','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Bodyrub Santa Monica Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Lavish Massage LB Health Center Lee Health Leelavadee Thai Wellness Center Leisure Massage Leisure Massage Let','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Jian Kang AcupunctureDaisy Wellness CenterInternational LatinasSky','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Massage Paradise Spa Paradise Thai Spa Paradise Total Care Parichat','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Spa Pattaya Thai Massage Pico Spa Pink One Spa PL Acupuncture Health Center Potalai Thai Massage Power Health Princess Thai Massage Pure Relaxation','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Spa Crystal Body','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','LA Massage Massa Massa Massage Place Massage Salon Massage Spa Massage Therapy Maximo Massage Meridian Acupuncture Merry Spa Mike Relax Moon Health Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Spa Sunstone Massage Center Super Spa Super','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Store Front Afternoon $50 Massage Parlor','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Store Front Noon $10 Massage Parlor','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Tanya Massage Temple Spa Thai Classic Massage Thai Day Spa Thai Friendly Massage','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Healthcenter York Asian Massage York Health Center Newest Forum Posts Bedazzled girls Harmony Spa','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Spa Rafa-L Acupuncture Rainbow De \' Spa Raya Thai Massage Red Pearl Thai Massage Relaxing','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Massage Touch Massage Tranquility Body Spa Tulip Med Spa Ultimate Great Spa Unforgettable Oriental Massage Union Therapy Upscale Spa Venice Health Center Vermont Thai Massage','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Salon National Thai Spa Natural Healing Therapy Natural Massage Therapy Nature Health Care New Qilin Nirvana Wellness Center Nuch Thai Massage Nuru City Omni Massage Oriental Day Spa Oriental Massage Oriental Massage Oriental Paradise Oxford Spa Palm Spa Palm Tree Therapy Palm Tree Therapy Palmtree Spa Pampered Foot Spa Pandaria','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Spa SD Health Care Thai Massage Season Day Spa Self Indulgence Sepulveda Healing Center Serene Thai Massage Serenity Healing Spa Serenity Palace Serenity Thai Massage Shanghai Massage Shanghai Massage Silver','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Santa Clarita New','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Store Front Afternoon $40 Massage Parlor','2015-08-03 18:32:39'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://rubmaps.com/users-reset-password','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/topic/5349/bedazzled-girls/','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/advanced-search','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/topic/5346/new-guy-old-monger/','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/topic/5347/lasd-sting-santa-clarita/','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/users-sign-in','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/rubmaps-slang','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://aff.camplace.com/delivery/?w=12&amp;b=Webcams&amp;t=2&amp;c=Rubmaps','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/blog','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/users-login','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://www.rubmaps.com/signup?from=new-user-button','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/topic/5345/my-avatar-not-showingjust-black-box/','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','website','http://forum.rubmaps.com/topic/5348/harmony-spa-in-watsonville/','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','turner','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','joejoeda','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Sherry Chinese','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Chick','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Rose Garden Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Amy Chinese','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Atmosphere','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','sherry','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Id have','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Sofie','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Bebe Asian','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Din Din Asian','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Lilly','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Grabbed','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Mary Chinese','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Marilyn','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Mimi Chinese','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Hilarious','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Grace Asian','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Jane Lac Dhara','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Stroking','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Celia','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Anyways','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Brown Brown','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Linda Chinese','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Mary Asian','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Nancy','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Grace','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Linda','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Din Din Chinese','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Nancy Chinese','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','my Perineum','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','nolikey Bebe','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Kelly','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Rose Garden','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Din Din','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Claudia','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Heard','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Senor Fish','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Masseuse','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Helen','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Brown Black','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Cindy','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Helen Chinese','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','PERSON','Emily','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Moon Massage','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Thai Day Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Thai Massage Saranrom','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Lee-Lee','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Residence Morning $50 Massage Parlor','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Spa Delight Day Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Chinese','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Hot Chinese','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Thai Spa Healing','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Grace Asian','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Asian Hours of Operation : 10am','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Koreans','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Asian','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','Thai MassageCherry','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','MISC','English','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','phone','6263449893','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','phone','3239829369','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Colorado','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Rose Garden Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','DakotaOhioOklahomaOregonPennsylvaniaRhode IslandSouth','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Los Angeles','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Montreal','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','bakersfield','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Sofia','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','San Gabriel','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','California','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','between York','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Italy','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Norwalk','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Watsonville','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Eagle Rock','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','China','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Lexington Chiropractor','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','LOCATION','Forth','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Sabai Thai Spa Thai Therapy Ploi Siam Thai Yoga Massage The Health Center The Raven Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','CarolinaSouth DakotaTennesseeTexasUtahVermontVirginiaWashingtonWest','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Rose Aroma Rose Garden Spa Rose Massage Rose Therapy','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Keerati Thai Keson Massage Spaah Kiku Massage King Spa KL Health Center Kona Spa LA Face & Mind LA Foot Massage LA Massage La Nuru Spa LA Shiatsu Massage LA Sports Massage Lake Therapy Lala Massage','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Resolution Rape Culture','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','H Therapy Wat Po Thai Massage Water Flower Massage Wellness Center Wellness Face and Bodyworks Wellness Therapy West LA Foot Massage Western Massage Western Spa Massage Wilshire Massage Wonderful Asian Massage World Thai Spa Xin Xin Health Center YaYa Massage YC','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','More Spring Leisure Massage Star Holistic Spa Star Spa Sunny Health Center Sunshine Facial & Thai Massage Sunshine Thai Massage','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Early Evening $50 Massage Parlor','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Resolution DDOS','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Asian Massage Top Oriental Massage Top Oriental Therapy','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Store Front Noon $40 Massage Parlor','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Royal Thai Massage Ruby Safari Therapy Sage Spa Sakura Shiatsu Sakura Spa Sandy','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Spa Sawadi Body Works SD Health Care','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','YorkNorth CarolinaNorth','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Spa Thai House Massage Thai Massage Thai Orchid Massage Thai','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','MassageSafari TherapyK L Health CenterTokyo SpaBai Po','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Jian Kang Acupuncture Jiuan Health Center JJ \'s JM Wellness Center Joy Thai Massage Joy Wellness Center','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','CFS BBBJTC','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Vitalitypro LLC','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai SpaLP Health CareGood Eastern Chinese MassageRainbow De \' SpaRose AromaJiuan Health CenterChina Doll','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Relaxing Massage Health and Beauty Center Health Center Heaven Spa Highland Park Acupuncture Highland Thai Massage','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Petite Nice & Round','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Li Yue Massage Lily Care Lion Spa Los Angeles Acucare Lotus Therapeutic Massage LP Health Care Lucky Spa Ly Health Center M & M Best Spa M&T Massage Main Avenue Spa Manju Spa Massage In LA Massage','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Store Front Early Evening $40 Massage Parlor','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Ananya Thai Massage Ancient Thai Massage Angel Massage Center Antique Thai Massage Apple Massage Apple One Spa Apple VIP Massage Apple VIP Spa Aqua Thai Spa Aroma Spa & Massage Aroma Therapy Asian Acupressure Asian Body Massage Asian Latina Beauty Massage Asian Massage Asian Massage Asian Massage Asian Massage Asian Massage Asian Massage Asian Massage Asian Massage Center Asian Oasis Massage Asian Spa Asian Spa Asian Spa Asian Touch ATLANTIC Massage Spa B Z Acupuncture Bai Po & Thai Massage Bailan Body Work BB Hills Beauty Center Bella Bellissimo Best Alternative Medicine Best Massage Therapy Beverly Hills Spa Beverly Total Clinic','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Los Angeles CA Rose Garden Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thin Nice & Round Clean Shaven','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Perfect Nice','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Real Massage The Stars Body Center TJ Health Care Center TJ Healthy Massage Tokyo Massage Tokyo Spa Tokyo Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Dhevi Thai Massage Dream Spa Dreamy Massage Dtox Day Spa Dynasty Wellness Center Eagle Health Care Eagle Health Center East West Health Center Eastern Massage Eden Spa Wellness Center Ela Heath Care Elemental Beauty Spa Enliven Massage Euphoria Massage Euphoria Massage Euphoria Massage Euphoria Massage Evergreen Accupuncture Evergreen Massage Foot Heaven Footssage Sawtelle Forever Body Massage Gentlemens Service Center GG Health Center Gigi Massage Ginger Foot Spa Godibas Face Skin Care Good Eastern Chinese Massage Green Acupressure Green Health Spa Green Massage Spa Green Massage Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thin Nice & Round','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Los Angeles CA Rose Garden Spa Rubmaps','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Rose Garden Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Energizing Spa Relief Thai Massage Reseda Rest','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Daisy Day Spa Daisy Wellness Center Day Spa Dayko Spa Del Rey','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Spa In Thai Spa In Thai Spa International Latina Therapy International Latinas Intimate Asian Massage Jade Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Lake Silverlake Spa Singular Massage SK Green Care SK Massage & Spa Sky Aroma Massage Sole To Sole Spa Spa D \' Rainbow Spa de Beverly Spaahbulous','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','California Distance','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','AAA Relax Massage Acu Care Acu Therapy Pain Clinic','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Bodyrub Santa Monica Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Lavish Massage LB Health Center Lee Health Leelavadee Thai Wellness Center Leisure Massage Leisure Massage Let','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Bliss Massage Spa Blue Moon Thai Spa Body Care Body Care Thai Massage Body Centre Spa Brazilian Massage Buahinia Spa CAK Health Care CC Acupuncture Central Acupuncture Century Health Center Chandra Thai Spa Cherry Spa China Doll China Doll Massage China Doll Massage Chinatown Massage Chinese Therapy Chinese Therapy Center Chiva Massage','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Massage Paradise Spa Paradise Thai Spa Paradise Total Care Parichat','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Spa Pattaya Thai Massage Pico Spa Pink One Spa PL Acupuncture Health Center Potalai Thai Massage Power Health Princess Thai Massage Pure Relaxation','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Spa Crystal Body','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','LA Massage Massa Massa Massage Place Massage Salon Massage Spa Massage Therapy Maximo Massage Meridian Acupuncture Merry Spa Mike Relax Moon Health Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Spa Sunstone Massage Center Super Spa Super','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Store Front Afternoon $50 Massage Parlor','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Store Front Noon $10 Massage Parlor','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Tanya Massage Temple Spa Thai Classic Massage Thai Day Spa Thai Friendly Massage','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Healthcenter York Asian Massage York Health Center Newest Forum Posts Bedazzled girls Harmony Spa','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Spa Rafa-L Acupuncture Rainbow De \' Spa Raya Thai Massage Red Pearl Thai Massage Relaxing','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Massage Touch Massage Tranquility Body Spa Tulip Med Spa Ultimate Great Spa Unforgettable Oriental Massage Union Therapy Upscale Spa Venice Health Center Vermont Thai Massage','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Salon National Thai Spa Natural Healing Therapy Natural Massage Therapy Nature Health Care New Qilin Nirvana Wellness Center Nuch Thai Massage Nuru City Omni Massage Oriental Day Spa Oriental Massage Oriental Massage Oriental Paradise Oxford Spa Palm Spa Palm Tree Therapy Palm Tree Therapy Palmtree Spa Pampered Foot Spa Pandaria','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Thai Spa SD Health Care Thai Massage Season Day Spa Self Indulgence Sepulveda Healing Center Serene Thai Massage Serenity Healing Spa Serenity Palace Serenity Thai Massage Shanghai Massage Shanghai Massage Silver','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Spa Holiday Spa Hollywood Hills Thai Spa Hot Asian Girls Huang','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Santa Clarita New','2015-08-03 18:32:50'),(null,'http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','ORGANIZATION','Store Front Afternoon $40 Massage Parlor','2015-08-03 18:32:50'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://www.google.com/finance?tab=we','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','//www.google.com/intl/en/ads/?fg=1','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://www.youtube.com/','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://wallet.google.com/manage/?tab=wa','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://translate.google.com/?hl=en&amp;tab=wT','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','//support.google.com/websearch/?p=ws_results_help&amp;hl=en&amp;fg=1','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','//www.google.com/services/?fg=1','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://www.blogger.com/?tab=wj','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','//www.google.com/intl/en/policies/terms/?fg=1','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://plus.google.com/?gpsrc=ogpy0&amp;tab=wX','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://books.google.com/bkshp?hl=en&amp;tab=wp&amp;ei=E-y_VbfuOMSx-AGB7JDAAQ&amp;ved=0CBAQqS4oEA','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://mail.google.com/mail/?tab=wm','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','http://www.google.com/shopping?hl=en&amp;tab=wf&amp;ei=E-y_VbfuOMSx-AGB7JDAAQ&amp;ved=0CAwQqS4oDA','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://photos.google.com/?tab=wq','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://www.google.com/calendar?tab=wc','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://www.google.com/preferences?hl=en','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://www.google.com/preferences?hl=en&amp;fg=1','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','//www.google.com/intl/en/policies/privacy/?fg=1','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://maps.google.com/maps?hl=en&amp;tab=wl','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://myaccount.google.com/?utm_source=OGB','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://news.google.com/nwshp?hl=en&amp;tab=wn&amp;ei=E-y_VbfuOMSx-AGB7JDAAQ&amp;ved=0CAUQqS4oBQ','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://play.google.com/?ie=UTF-8&amp;hl=en&amp;tab=w8','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','http://www.google.com/intl/en/options/','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://www.google.com/webhp?tab=ww&amp;ei=E-y_VbfuOMSx-AGB7JDAAQ&amp;ved=0CAEQqS4oAQ','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://www.youtube.com/watch?v=06olHmcJjS0&amp;utm_medium=HPPMobileEN&amp;utm_campaign=Translate','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://www.google.com/contacts/?hl=en&amp;tab=wC','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://docs.google.com/document/?usp=docs_alc','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://www.google.com/webhp?hl=en','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','website','https://drive.google.com/?tab=wo','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','PERSON','AccountSearchMapsYouTubePlayNewsGmailDriveCalendarGoogle+TranslatePhotosMoreShoppingWalletFinanceDocsBooksBloggerContactsEven','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','MISC','Screen','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','ORGANIZATION','Google','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','ORGANIZATION','Google Translate','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','ORGANIZATION','Google Instant','2015-08-03 18:32:55'),(null,'https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','ORGANIZATION','La Bamba Privacy','2015-08-03 18:32:55'),(null,'http://myproviderguide.com/phone/626-344-9893','website','https://www.ashleymadison.com/?ac=12503&amp;keywords=120x60_nav','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','website','https://www.ashleymadison.com/?ac=12503&amp;keywords=120x60_brand','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','website','http://d.hottraffic.com/srv/click-record?impression_id=3823765356','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','website','http://twitter.com/mproviderguide','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','website','https://www.ashleymadison.com/?ac=12503&amp;keywords=120x60_text','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','website','http://www.meetcammodels.com/?AFNO=1-013','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','website','http://www.HolidaywithHilary.com','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','website','http://www.adultsearch.com','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','website','http://hookmilfs.us/mph/','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','website','http://www.cams4free.com/landing/1/?AFNO=1-208','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','website','http://www.cams4free.com/landing/1/?AFNO=1-207','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','website','http://hookmilfs.us/mpb/','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','PERSON','Classy','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','PERSON','Marilyn','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','PERSON','Latina Bella','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','PERSON','Jamin','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','PERSON','Sherry','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','MISC','BeautyFive Star Service OPEN','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','MISC','Visa Master','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','MISC','Free Escort','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','phone','6263449893','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','LOCATION','Los Angeles','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','LOCATION','Lake County','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','LOCATION','Phoenix','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','LOCATION','The City','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','ORGANIZATION','Jamine','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','ORGANIZATION','Sweet and Sexy Young Pretty Girls','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','ORGANIZATION','Post View Gallery View Click','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','ORGANIZATION','SEXISET Girls','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','ORGANIZATION','MyProviderGuide >','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','ORGANIZATION','Escorts','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','ORGANIZATION','Cute Sexy College','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/phone/626-344-9893','ORGANIZATION','EliteZoe Avail','2015-08-03 18:33:03'),(null,'http://myproviderguide.com/','ORGANIZATION','Hot Asian & Latina College','2015-08-03 18:33:03');
/*!40000 ALTER TABLE `general_extractor_web_index` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manual_extractor_markup_additions`
--

DROP TABLE IF EXISTS `manual_extractor_markup_additions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `manual_extractor_markup_additions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trail_id` int(11) DEFAULT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userEmail` varchar(245) DEFAULT NULL,
  `url` text,
  `raw_text` varchar(1024) DEFAULT NULL,
  `feature_type` varchar(100) DEFAULT NULL,
  `feature_value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `trail_id` (`trail_id`),
  CONSTRAINT `manual_extractor_markup_additions_ibfk_1` FOREIGN KEY (`trail_id`) REFERENCES `datawake_trails` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manual_extractor_markup_additions`
--

LOCK TABLES `manual_extractor_markup_additions` WRITE;
/*!40000 ALTER TABLE `manual_extractor_markup_additions` DISABLE KEYS */;
/*!40000 ALTER TABLE `manual_extractor_markup_additions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manual_extractor_markup_removals`
--

DROP TABLE IF EXISTS `manual_extractor_markup_removals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `manual_extractor_markup_removals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trail_id` int(11) DEFAULT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userEmail` varchar(245) DEFAULT NULL,
  `feature_type` varchar(100) DEFAULT NULL,
  `feature_value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `trail_id` (`trail_id`),
  CONSTRAINT `manual_extractor_markup_removals_ibfk_1` FOREIGN KEY (`trail_id`) REFERENCES `datawake_trails` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manual_extractor_markup_removals`
--

LOCK TABLES `manual_extractor_markup_removals` WRITE;
/*!40000 ALTER TABLE `manual_extractor_markup_removals` DISABLE KEYS */;
/*!40000 ALTER TABLE `manual_extractor_markup_removals` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE datawake_xmit_recipient (
  recipient_id int(11) NOT NULL AUTO_INCREMENT,
  recipient_name varchar(255) DEFAULT NULL,
  recipient_index varchar(255) DEFAULT NULL,
  recipient_domain_id int(11) DEFAULT NULL,
  recipient_team_id int(11) DEFAULT NULL,
  recipient_trail_id int(11) DEFAULT NULL,
  recipient_protocol varchar(10) DEFAULT NULL,
  recipient_url varchar(255) DEFAULT NULL,
  credentials varchar(255) DEFAULT NULL,
  service_type varchar(255) DEFAULT NULL,
  PRIMARY KEY (recipient_id),
  KEY fkRecDomain (recipient_domain_id),
  KEY fkRecTeam (recipient_team_id),
  KEY fkRecTrail (recipient_trail_id),
  CONSTRAINT fkRecDomain FOREIGN KEY (recipient_domain_id) REFERENCES datawake_domains (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fkRecTeam FOREIGN KEY (recipient_team_id) REFERENCES datawake_teams (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fkRecTrail FOREIGN KEY (recipient_trail_id) REFERENCES datawake_trails (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE datawake_xmit (
  xmit_id int(11) NOT NULL AUTO_INCREMENT,
  recipient_id int(11) DEFAULT NULL,
  service_type varchar(10) DEFAULT NULL,
  datawake_url varchar(255) DEFAULT NULL,
  xmit_status varchar(255) DEFAULT NULL,
  domain_id int(11) DEFAULT NULL,
  team_id int(11) DEFAULT NULL,
  trail_id int(11) DEFAULT NULL,
  ts timestamp NULL DEFAULT NULL,
  PRIMARY KEY (xmit_id),
  KEY fkRecipient (recipient_id),
  KEY fkDomain (domain_id),
  KEY fkTrail (trail_id),
  KEY fkTeam (team_id),
  CONSTRAINT fkDomain FOREIGN KEY (domain_id) REFERENCES datawake_domains (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fkRecipient FOREIGN KEY (recipient_id) REFERENCES datawake_xmit_recipient (recipient_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fkTeam FOREIGN KEY (team_id) REFERENCES datawake_teams (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fkTrail FOREIGN KEY (trail_id) REFERENCES datawake_trails (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
--
-- Temporary table structure for view `vw_domain_entities`
--

DROP VIEW IF EXISTS `vw_domain_entities`;
/*!50001 DROP VIEW IF EXISTS `vw_domain_entities`*/;
CREATE VIEW vw_domain_entities AS
	SELECT	d.id,
			d.name,
			d.description,
			d.team_id,
			e.domain_entity_id as domainEntityID,
			e.feature_Type,
			e.feature_Value
	FROM datawake_domains as d
		INNER JOIN datawake_domain_entities as e on d.id = e.domain_id;

--
-- Temporary table structure for view `vw_team_users`
--

DROP VIEW IF EXISTS `vw_team_users`;
/*!50001 DROP VIEW IF EXISTS `vw_team_users`*/;
CREATE VIEW vw_team_users AS
	SELECT t.id as teamID,
		t.name as teamName,
		t.description as teamDescription,
		u.team_user_id as userID,
		u.email
	FROM (datawake_teams t
			join datawake_team_users u on(t.id = u.team_id));
--
-- Temporary table structure for view `vw_urls_in_trails`
--

DROP VIEW IF EXISTS `vw_urls_in_trails`;
/*!50001 DROP VIEW IF EXISTS `vw_urls_in_trails`*/;
CREATE VIEW vw_urls_in_trails AS
	SELECT dd2.ts as ts,
		dd2.id,
		dd1.domain_id,
		dd1.trail_id,
		dd1.team_id,
		dd2.userEmail,
		dd3.name as domainName,
		dd3.description as domainDescription,
		dd1.url,
		count(2) as hits
	FROM datawake_data as dd1
	RIGHT JOIN datawake_data as dd2 ON dd1.trail_id = dd2.trail_id and dd1.url = dd2.url
	RIGHT JOIN datawake_domains dd3 on dd1.domain_id = dd3.id
	GROUP BY url, ts;

DROP VIEW IF EXISTS `vw_datawake_domains`;
CREATE VIEW vw_datawake_domains AS
	SELECT 	d.id as domainId,
			d.name as domainName,
			d.description as domainDescription,
			d.team_id as teamId,
			t.name as teamName,
			t.description as teamDescription
	FROM datawake_domains as d
		INNER JOIN datawake_teams t on d.team_id = t.id
;

DROP VIEW IF EXISTS `vw_xmit_recipients`;
CREATE VIEW vw_xmit_recipients AS
	SELECT	r.recipient_id AS recipientId,
		r.recipient_name AS recipientName,
		r.credentials AS recipientCredentials,
		r.recipient_index AS recipientIndex,
		r.service_type AS serviceType,
		r.recipient_protocol AS recipientProtocol,
		r.recipient_url as recipientURL,
		r.recipient_domain_id AS recipientDomainId,
		d.name AS recipientDomain,
		r.recipient_team_id AS recipientTeamId,
		t.name AS recipientTeam,
		r.recipient_trail_id AS recipientTrailId,
		dt.name AS recipientTrail
	FROM datawake_xmit_recipient r
			left join datawake_xmit x on r.recipient_id = x.recipient_id
			left join datawake_domains d on r.recipient_domain_id = d.id
			left join datawake_teams t on r.recipient_team_id = t.id
			left join datawake_trails dt on r.recipient_trail_id = dt.id
;

DROP VIEW IF EXISTS `vw_xmit_log`;
CREATE VIEW vw_xmit_log AS
	SELECT x.xmit_id AS xmitId,
	x.recipient_id AS recipientId,
	r.recipient_name AS recipientName,
	r.recipient_protocol AS recipientProtocol,
	r.recipient_url as recipientURL,
	x.service_type AS serviceType,
	x.datawake_url AS datawakeUrl,
	x.xmit_status AS status,
	x.domain_id AS domainId,
	d.name AS domainName,
	x.team_id AS teamId,
	t.name AS teamName,
	x.trail_id AS trailId,
	dt.name AS trailName,
	x.ts as timeStamp
	FROM datawake_xmit x
			join datawake_xmit_recipient r on x.recipient_id = r.recipient_id
			left join datawake_domains d on x.domain_id = d.id
			left join datawake_teams t on x.team_id = t.id
			left join datawake_trails dt on x.trail_id = dt.id
;

DROP VIEW IF EXISTS `vw_browse_count`;
CREATE VIEW vw_browse_count AS
	SELECT url,
    crawl_type,
    comments,
    trail_id,
    count(1) as count
    FROM datawake_data
    GROUP BY url,
    crawl_type,
    comments;
