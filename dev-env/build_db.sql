
CREATE DATABASE IF NOT EXISTS memex_sotera;
USE memex_sotera;

DROP TABLE IF EXISTS datawake_team_users;
DROP TABLE IF EXISTS datawake_domains;
DROP TABLE IF EXISTS datawake_domain_entities;
DROP TABLE IF EXISTS datawake_trails;
DROP TABLE IF EXISTS datawake_selections;
DROP TABLE IF EXISTS datawake_data;
DROP TABLE IF EXISTS datawake_url_rank;
DROP TABLE IF EXISTS general_extractor_web_index;
DROP TABLE IF EXISTS domain_extractor_web_index;
DROP TABLE IF EXISTS scraping_feedback;
DROP TABLE IF EXISTS invalid_extracted_entity;
DROP TABLE IF EXISTS datawake_teams;

CREATE TABLE datawake_teams (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100),
  description TEXT,
  PRIMARY KEY(id),
  UNIQUE (name)
);


CREATE TABLE datawake_team_users (
  team_id INT,
  email VARCHAR(245),
  FOREIGN KEY (team_id) REFERENCES datawake_teams(id) ON DELETE CASCADE
);


CREATE TABLE datawake_domains (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(300),
  description TEXT,
  team_id INT,
  FOREIGN KEY (team_id) REFERENCES datawake_teams(id) ON DELETE CASCADE,
  PRIMARY KEY(id),
  UNIQUE (name,team_id)
);


CREATE TABLE datawake_domain_entities (
  domain_id INT,
  feature_type varchar(100),
  feature_value varchar(1024),
  INDEX(domain_id,feature_type(100),feature_value(100))
);


CREATE TABLE datawake_trails (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(245),
  description TEXT,
  team_id INT,
  domain_id INT,
  FOREIGN KEY (team_id) REFERENCES datawake_teams(id) ON DELETE CASCADE,
  FOREIGN KEY (domain_id) REFERENCES datawake_domains(id) ON DELETE CASCADE,
  PRIMARY KEY(id),
  UNIQUE(domain_id,name)
);


CREATE TABLE datawake_data (
  id INT NOT NULL AUTO_INCREMENT,
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  url TEXT,
  userEmail VARCHAR(245),
  team_id INT,
  domain_id INT,
  trail_id INT,
  PRIMARY KEY(id),
  FOREIGN KEY (team_id) REFERENCES datawake_teams(id) ON DELETE CASCADE,
  FOREIGN KEY (domain_id) REFERENCES datawake_domains(id) ON DELETE CASCADE,
  FOREIGN KEY (trail_id) REFERENCES datawake_trails(id) ON DELETE CASCADE,
  INDEX(url(30))
);



CREATE TABLE datawake_url_rank (
  id INT NOT NULL AUTO_INCREMENT,
  url TEXT,
  userEmail VARCHAR(245),
  team_id INT,
  domain_id INT,
  trail_id INT,
  rank INT,
  PRIMARY KEY(id),
  FOREIGN KEY (team_id) REFERENCES datawake_teams(id) ON DELETE CASCADE,
  FOREIGN KEY (domain_id) REFERENCES datawake_domains(id) ON DELETE CASCADE,
  FOREIGN KEY (trail_id) REFERENCES datawake_trails(id) ON DELETE CASCADE,
  INDEX(trail_id,userEmail(30),url(30))
);


CREATE TABLE datawake_selections (
  id INT NOT NULL AUTO_INCREMENT,
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  trail_id INT,
  userEmail VARCHAR(245),
  url TEXT,
  selection TEXT,
  PRIMARY KEY(id),
  INDEX(trail_id,url(60))
);





CREATE TABLE general_extractor_web_index (
  url varchar(1024),
  feature_type varchar(100),
  feature_value varchar(1024),
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  index(url(300))
);


CREATE TABLE domain_extractor_web_index (
  domain_id INT,
  url varchar(1024),
  feature_type varchar(100),
  feature_value varchar(1024),
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  index(domain_id,url(300))
);


CREATE TABLE manual_extractor_markup_additions (
  trail_id INT,
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  userEmail VARCHAR(245),
  url TEXT,
  raw_text varchar (1024),
  feature_type varchar(100),
  feature_value varchar(1024),
  FOREIGN KEY (trail_id) REFERENCES datawake_trails(id) ON DELETE CASCADE,
  INDEX(trail_id,url(60))
);


CREATE TABLE manual_extractor_markup_removals (
  trail_id INT,
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  userEmail VARCHAR(245),
  feature_type varchar(100),
  feature_value varchar(1024),
  FOREIGN KEY (trail_id) REFERENCES datawake_trails(id) ON DELETE CASCADE,
  INDEX(trail_id)
);



\q
