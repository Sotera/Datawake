DROP DATABASE IF EXISTS memex_sotera;
CREATE DATABASE IF NOT EXISTS memex_sotera;
USE memex_sotera;

CREATE TABLE datawake_settings (
  setting VARCHAR(50) NOT NULL,
  value VARCHAR(500) NULL,
  PRIMARY KEY (setting),
  UNIQUE INDEX setting_UNIQUE (setting ASC)
  ) ;


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

CREATE TABLE `datawake_domains` (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(300) DEFAULT NULL,
  description text,
  team_id int(11) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY name (name,team_id),
  KEY team_id (team_id),
  CONSTRAINT datawake_domains_ibfk_1 FOREIGN KEY (team_id) REFERENCES datawake_teams (id) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

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
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
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
  crawl_type VARCHAR(255),
  comments VARCHAR(1000),
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
  KEY uniqueFeature (url(300),feature_type,feature_value(100))
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=latin1;

CREATE TABLE general_extractor_web_index (
  id int(11) NOT NULL AUTO_INCREMENT,
  url varchar(1024) DEFAULT NULL,
  feature_type varchar(100) DEFAULT NULL,
  feature_value varchar(1024) DEFAULT NULL,
  ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY uniqueFeature (url(300),feature_type,feature_value(100)),
  KEY url (url(300))
) ENGINE=InnoDB AUTO_INCREMENT=147920 DEFAULT CHARSET=latin1;


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
  CONSTRAINT fkRecipient FOREIGN KEY (recipient_id) REFERENCES datawake_xmit_recipient (recipient_id) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT fkTeam FOREIGN KEY (team_id) REFERENCES datawake_teams (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fkTrail FOREIGN KEY (trail_id) REFERENCES datawake_trails (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS trail_term_rank (
  org VARCHAR(300),
  domain varchar(300),
  trail varchar(100),
  url varchar(1024),
  title varchar(1024),
  rank DOUBLE,
  pageRank INT,
  removed INT DEFAULT 0,
  index(org(300), domain(300), trail(100), url(255))
);


CREATE VIEW vw_team_users AS
	SELECT t.id as teamId,
		t.name as teamName,
		t.description as teamDescription,
		u.team_user_id as userID,
		u.email
	FROM (datawake_teams t
			join datawake_team_users u on(t.id = u.team_id))
;

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
	GROUP BY url, ts
;

CREATE VIEW vw_domain_entities AS
	SELECT	d.id,
			d.name,
			d.description,
			d.team_id,
			e.domain_entity_id as domainEntityID,
			e.feature_Type,
			e.feature_Value
	FROM datawake_domains as d
		INNER JOIN datawake_domain_entities as e on d.id = e.domain_id
;

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
			left join datawake_domains d on r.recipient_domain_id = d.id
			left join datawake_teams t on r.recipient_team_id = t.id
			left join datawake_trails dt on r.recipient_trail_id = dt.id
;

CREATE VIEW vw_xmit_log AS
        SELECT x.xmit_id AS xmitId,
        x.recipient_id AS recipientId,
        r.recipient_name AS recipientName,
        r.recipient_protocol as recipientProtocol,
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
