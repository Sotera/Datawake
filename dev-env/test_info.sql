USE memex_sotera;

INSERT INTO datawake_teams (name,description) VALUES ("team1","test team 1");
INSERT INTO datawake_teams (name,description) VALUES ("team2","test team 2");

INSERT INTO datawake_team_users (team_id,email) VALUES (1,"john.doe@nomail.none");
INSERT INTO datawake_team_users (team_id,email) VALUES (1,"jane.doe@nomail.none");
INSERT INTO datawake_team_users (team_id,email) VALUES (2,"john.doe@nomail.none");


INSERT INTO datawake_domains (name,description,team_id) VALUES ("memex.program","Information relating to darpa's memex program",1);
INSERT INTO datawake_domains (name,description,team_id) VALUES ("domain2","second domain",2);
INSERT INTO datawake_domains (name,description,team_id) VALUES ("domain3","another domain",1);
INSERT INTO datawake_domains (name,description,team_id) VALUES ("domain4","yet another domain",2);


INSERT INTO datawake_trails (name,team_id,domain_id) VALUES ("memex program details",1,1);
INSERT INTO datawake_trails (name,team_id,domain_id) VALUES ("trail2",1,3);
INSERT INTO datawake_trails (name,team_id,domain_id) VALUES ("trail3",1,3);

INSERT INTO datawake_domain_entities(domain_id,feature_type,feature_value) VALUES(1,"website",""http://www.darpa.mil/NewsEvents/Releases/2014/02/09.aspx");
INSERT INTO datawake_domain_entities(domain_id,feature_type,feature_value) VALUES(1,"website",""http://www.darpa.mil/Our_Work/I2O/Programs/Memex.aspx");
INSERT INTO datawake_domain_entities(domain_id,feature_type,feature_value) VALUES(1,"email","memex@darpa.mil");
INSERT INTO datawake_domain_entities(domain_id,feature_type,feature_value) VALUES(1,"email",christopher.white@darpa.mil);
INSERT INTO datawake_domain_entities(domain_id,feature_type,feature_value) VALUES(1,"PERSON","Christopher White");
INSERT INTO datawake_domain_entities(domain_id,feature_type,feature_value) VALUES(1,"PERSON","Vannevar Bush");
INSERT INTO datawake_domain_entities(domain_id,feature_type,feature_value) VALUES(1,"ORGANIZATION","DARPA");


\q
