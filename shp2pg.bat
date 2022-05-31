@echo off

set db_name=world
set path=%path%;D:\PostgreSQL\bin;D:\Green\Git\bin;D:\Green\Git\usr\bin
set PGPASSWORD=123456

dropdb -U postgres %db_name%
createdb -U postgres %db_name%
psql -U postgres -d %db_name% -c "CREATE EXTENSION IF NOT EXISTS postgis"

rem shp2pgsql -D world.shp > world.shp.sql
rem psql -U postgres %db_name% < world.shp.sql
shp2pgsql -D world.shp | psql -U postgres %db_name%

pause
