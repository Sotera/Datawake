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
DROP DATABASE IF EXISTS memex_sotera;
CREATE DATABASE IF NOT EXISTS memex_sotera;
USE memex_sotera;

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
INSERT INTO `datawake_data` VALUES (27,'2014-09-09 00:35:49','http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','john.doe@nomail.none',1,1,2),(28,'2014-09-09 00:36:05','https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','john.doe@nomail.none',1,1,2),(29,'2014-09-09 00:36:23','http://myproviderguide.com/phone/626-344-9893','john.doe@nomail.none',1,1,2),(30,'2014-09-09 00:36:36','https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','john.doe@nomail.none',1,1,2),(31,'2014-09-09 00:37:46','http://www.theeroticreview.com/reviews/show.asp?id=227534','john.doe@nomail.none',1,1,2),(32,'2014-09-09 00:38:00','https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=cherry110510%40gmail.com','john.doe@nomail.none',1,1,2),(33,'2014-09-09 00:38:37','https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=6263449893','john.doe@nomail.none',1,1,2),(34,'2014-09-09 00:38:54','http://www.rubmaps.com/erotic-massage-rose-garden-spa-los-angeles-ca-8875','john.doe@nomail.none',1,1,2);
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
INSERT INTO `datawake_domains` VALUES (1,'memexht','anti human trafficking data',1);
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
INSERT INTO `datawake_trails` VALUES (2,'cherry11','2014-09-08 22:12:21','curtis.colridge@gmail.com','A search on the cherry11 network',1,1);
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
  UNIQUE KEY `uniqueFeature` (`url`(300),`feature_type`,`feature_value`(100)),
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

--
-- Temporary table structure for view `vw_domain_entities`
--

DROP TABLE IF EXISTS `vw_domain_entities`;
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

DROP TABLE IF EXISTS `vw_team_users`;
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

DROP TABLE IF EXISTS `vw_urls_in_trails`;
/*!50001 DROP VIEW IF EXISTS `vw_urls_in_trails`*/;
CREATE VIEW vw_urls_in_trails AS
	SELECT unix_timestamp(dd2.ts) as ts,
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

DROP TABLE IF EXISTS `vw_datawake_domains`;
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
