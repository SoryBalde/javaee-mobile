CREATE TABLE mobile_users (username VARCHAR(20) NOT NULL, password VARCHAR(255) NOT NULL, PRIMARY KEY (username))
CREATE TABLE mobile_groups (username VARCHAR(20) NOT NULL, group_name VARCHAR(20) NOT NULL, PRIMARY KEY (username, group_name))
ALTER TABLE mobile_groups ADD CONSTRAINT fk_username FOREIGN KEY(username) REFERENCES mobile_users (username)