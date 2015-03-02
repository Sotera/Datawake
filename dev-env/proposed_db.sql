CREATE DATABASE IF NOT EXISTS memex_sotera;
USE memex_sotera;


#
# MAIN APPLICATION DATA
#

DROP TABLE IF EXISTS datawake_users;
CREATE TABLE datawake_users (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100),
  email VARCHAR(245),
  PRIMARY KEY(id)
);


DROP TABLE IF EXISTS datawake_teams;
CREATE TABLE datawake_teams (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100),
  description TEXT,
  PRIMARY KEY(id)
);


DROP TABLE IF EXISTS datawake_team_users;
CREATE TABLE datawake_team_users (
  team_id INT,
  user_id INT,
  FOREIGN KEY (team_id) REFERENCES datawake_teams(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES datawake_users(id) ON DELETE CASCADE
);



DROP TABLE IF EXISTS datawake_domains;
CREATE TABLE datawake_domains (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100),
  description TEXT,
  PRIMARY KEY(id)
);

DROP TABLE IF EXISTS datawake_domain_teams;
CREATE TABLE datawake_domain_teams (
  domain_id INT,
  team_id INT,
  FOREIGN KEY (domain_id) REFERENCES datawake_domains(id) ON DELETE CASCADE,
  FOREIGN KEY (team_id) REFERENCES datawake_teams(id) ON DELETE CASCADE
);


DROP TABLE IF EXISTS datawake_trails;
CREATE TABLE datawake_trails (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  domain_id INT,
  description TEXT,
  created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by_user_id INT,
  PRIMARY KEY(id),
  FOREIGN KEY (domain_id) REFERENCES datawake_domains(id)
);


DROP TABLE IF EXISTS datawake_trail_teams;
CREATE TABLE datawake_trail_teams (
  domain_id INT,
  team_id INT,
  FOREIGN KEY (domain_id) REFERENCES datawake_domains(id) ON DELETE CASCADE,
  FOREIGN KEY (team_id) REFERENCES datawake_teams(id) ON DELETE CASCADE
);





DROP TABLE IF EXISTS datawake_data;
CREATE TABLE datawake_data (
  id INT NOT NULL AUTO_INCREMENT,
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  url TEXT,
  user_id INT,
  trail_id INT,
  PRIMARY KEY(id),
  FOREIGN KEY (user_id) REFERENCES datawake_users(id),
  FOREIGN KEY (trail_id) REFERENCES datawake_trails(id) ON DELETE CASCADE,
  INDEX(url(30))
);


DROP TABLE IF EXISTS datawake_url_rank;
CREATE TABLE datawake_url_rank (
  id INT NOT NULL AUTO_INCREMENT,
  url TEXT,
  user_id INT,
  trail_id INT,
  rank INT,
  PRIMARY KEY(id),
  FOREIGN KEY (user_id) REFERENCES datawake_users(id),
  FOREIGN KEY (trail_id) REFERENCES datawake_trails(id) ON DELETE CASCADE,
  INDEX(url(30),user_id,trail_id)
);



# TODO, re think data model for selections

DROP TABLE IF EXISTS datawake_selections;
CREATE TABLE datawake_selections (
  id INT NOT NULL AUTO_INCREMENT,
  postId INT NOT NULL,
  selection TEXT,
  PRIMARY KEY(id),
  INDEX(postId)
);



DROP TABLE IF EXISTS datawake_manual_features;
CREATE TABLE datawake_manual_features (
  entity_type varchar(100),
  entity_value varchar(1024),
  raw_text varchar (100),
  url TEXT,
  trail_id INT,
  user_id  INT,
  FOREIGN KEY (user_id) REFERENCES datawake_users(id),
  FOREIGN KEY (trail_id) REFERENCES datawake_trails(id) ON DELETE CASCADE
);


DROP TABLE IF EXISTS invalid_extracted_entity;
CREATE TABLE invalid_extracted_entity (
  entity_value varchar (1024),
  entity_type varchar (100),
  domain varchar (300),
  org VARCHAR(300),
  userName TEXT,
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  index(org(300),domain(300), entity_type(100), entity_value(100))
);


#
# EXTRACTOR DATA
#

DROP TABLE IF EXISTS datawake_domain_entities;
CREATE TABLE datawake_domain_entities (
  rowkey varchar(1024),
  INDEX(rowkey(300))
);


DROP TABLE IF EXISTS general_extractor_web_index;
CREATE TABLE general_extractor_web_index (
  url varchar(1024),
  entity_type varchar(100),
  entity_value varchar(1024),
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  index(url(300))
);


DROP TABLE IF EXISTS domain_extractor_web_index;
CREATE TABLE domain_extractor_web_index (
  domain VARCHAR(300),
  url varchar(1024),
  entity_type varchar(100),
  entity_value varchar(1024),
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  index(domain(300),url(300))
);







\q
