/*
Purpose:
    Create the pedscreen database, schema, and user
Usage:
    Change the file's name to be initdb.sql
Reference:
- https://github.com/chop-dbhi/ped-screen/blob/main/doc/Installing_Pedscreen.md#setting-up-the-pedscreen-database
*/
CREATE DATABASE pedscreen;

CREATE USER pedscreen WITH PASSWORD '[password here]';

GRANT ALL ON DATABASE pedscreen TO pedscreen;

\connect pedscreen;

CREATE SCHEMA pedscreen;

GRANT USAGE ON SCHEMA pedscreen to pedscreen;
GRANT CREATE ON SCHEMA pedscreen to pedscreen;