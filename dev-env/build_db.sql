DROP DATABASE IF EXISTS memex_sotera;
CREATE DATABASE IF NOT EXISTS memex_sotera;
USE memex_sotera;

CREATE TABLE datawake_teams (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) DEFAULT NULL,
  description text,
  PRIMARY KEY (id),
  UNIQUE KEY name (name)
) ;

CREATE TABLE datawake_team_users (
  team_user_id INT NOT NULL AUTO_INCREMENT,
  team_id int(11) DEFAULT NULL,
  email varchar(245) DEFAULT NULL,
  PRIMARY KEY (team_user_id),
  KEY fkTeamID (team_id),
  FOREIGN KEY (team_id) REFERENCES datawake_teams (id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ;

CREATE TABLE datawake_domains (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(300) DEFAULT NULL,
  description text,
  team_id int(11) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY name (name,team_id),
  KEY team_id (team_id),
  FOREIGN KEY (team_id) REFERENCES datawake_teams (id) ON DELETE CASCADE
);

CREATE TABLE datawake_domain_entities (
  domain_entity_id INT NOT NULL AUTO_INCREMENT,
  domain_id int(11) DEFAULT NULL,
  feature_type varchar(100) DEFAULT NULL,
  feature_value varchar(1024) DEFAULT NULL,
  PRIMARY KEY (domain_entity_id),
  KEY domain_id (domain_id),
  FOREIGN KEY (domain_id) REFERENCES datawake_domains (id) ON DELETE CASCADE
);

CREATE TABLE datawake_trails (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by varchar(245) DEFAULT NULL,
  description text,
  team_id int(11) DEFAULT NULL,
  domain_id int(11) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY domain_id (domain_id,name),
  KEY team_id (team_id),
  FOREIGN KEY (team_id) REFERENCES datawake_teams (id) ON DELETE CASCADE,
  FOREIGN KEY (domain_id) REFERENCES datawake_domains (id) ON DELETE CASCADE
) ;

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
  id int(11) NOT NULL AUTO_INCREMENT,
  url text,
  userEmail varchar(245) DEFAULT NULL,
  team_id int(11) DEFAULT NULL,
  domain_id int(11) DEFAULT NULL,
  trail_id int(11) DEFAULT NULL,
  rank int(11) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY team_id (team_id),
  KEY domain_id (domain_id),
  KEY trail_id (trail_id,userEmail(30),url(30)),
  FOREIGN KEY (team_id) REFERENCES datawake_teams (id) ON DELETE CASCADE,
  FOREIGN KEY (domain_id) REFERENCES datawake_domains (id) ON DELETE CASCADE,
  FOREIGN KEY (trail_id) REFERENCES datawake_trails (id) ON DELETE CASCADE
);

CREATE TABLE datawake_selections (
  id int(11) NOT NULL AUTO_INCREMENT,
  ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  trail_id int(11) DEFAULT NULL,
  userEmail varchar(245) DEFAULT NULL,
  url text,
  selection text,
  PRIMARY KEY (id),
  KEY trail_id (trail_id,url(60)),
  FOREIGN KEY (trail_id) REFERENCES datawake_trails (id) ON DELETE CASCADE
) ;

CREATE TABLE domain_extractor_web_index (
  id int(11) NOT NULL AUTO_INCREMENT,
  domain_id int(11) DEFAULT NULL,
  url varchar(1024) DEFAULT NULL,
  feature_type varchar(100) DEFAULT NULL,
  feature_value varchar(1024) DEFAULT NULL,
  ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY domain_id (domain_id,url(300))
) ;

CREATE TABLE general_extractor_web_index (
  id int(11) NOT NULL AUTO_INCREMENT,
  url varchar(1024) DEFAULT NULL,
  feature_type varchar(100) DEFAULT NULL,
  feature_value varchar(1024) DEFAULT NULL,
  ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uniqueFeature (url(300), feature_type, feature_value(100)),
  KEY url (url(300))
) ;


CREATE TABLE manual_extractor_markup_additions (
  id INT NOT NULL AUTO_INCREMENT,	
  trail_id int(11) DEFAULT NULL,
  ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  userEmail varchar(245) DEFAULT NULL,
  url text,
  raw_text varchar(1024) DEFAULT NULL,
  feature_type varchar(100) DEFAULT NULL,
  feature_value varchar(1024) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY trail_id (trail_id),
  FOREIGN KEY (trail_id) REFERENCES datawake_trails (id) ON DELETE CASCADE
);

CREATE TABLE manual_extractor_markup_removals (
  id INT NOT NULL AUTO_INCREMENT,	
  trail_id int(11) DEFAULT NULL,
  ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  userEmail varchar(245) DEFAULT NULL,
  feature_type varchar(100) DEFAULT NULL,
  feature_value varchar(1024) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY trail_id (trail_id),
  FOREIGN KEY (trail_id) REFERENCES datawake_trails (id) ON DELETE CASCADE
);

CREATE VIEW vw_team_users AS
	SELECT t.id as teamID,
		t.name as teamName,
		u.team_user_id as userID,
		u.email
	FROM (datawake_teams t 
			join datawake_team_users u on((t.id = u.team_id)))
;

CREATE VIEW vw_urls_in_trails AS	
	SELECT unix_timestamp(dd2.ts) as ts,
		dd2.id,
		dd1.trail_id,
		dd1.team_id,	
		dd2.userEmail,
		dd1.url,
		count(2) as hits		
	FROM datawake_data as dd1 
	RIGHT JOIN datawake_data as dd2 ON dd1.trail_id = dd2.trail_id and dd1.url = dd2.url 
	GROUP BY url, ts
;

CREATE VIEW vw_domain_entities AS	
	SELECT	d.id,
			d.name,
			d.description,
			d.team_id,
			e.feature_Type,
			e.feature_Value
	FROM datawake_domains as d
		INNER JOIN datawake_domain_entities as e on d.id = e.domain_id
;