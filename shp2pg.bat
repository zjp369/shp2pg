@echo off

set db_name=world
set path=%path%;D:\PostgreSQL\bin;D:\Green\Git\bin;D:\Green\Git\usr\bin
set PGPASSWORD=123456

dropdb -U postgres %db_name%
createdb -U postgres %db_name%
psql -U postgres -d %db_name% -c "CREATE EXTENSION IF NOT EXISTS postgis"

rem shp2pgsql -D world.shp > world.shp.sql
rem psql -U postgres %db_name% < world.shp.sql
rem shp2pgsql -D world.shp | psql -U postgres %db_name%

set keyword=*.shp
for /f %%i in ('dir /b/s %keyword%') do (
	echo %%~ni
	rem shp2pgsql -D -W gbk %%i | psql -U postgres %db_name%
	rem shp2pgsql -D -W gbk %%i | iconv -f gbk -t utf-8 | psql -U postgres %db_name%
	for /f %%j in ('echo %%~ni ^| iconv -f gb18030 -t utf-8') do (
		rem echo %%j
		shp2pgsql -D -W gb18030 %%i %%j > %%i.sql
	)
	psql -U postgres %db_name% < %%i.sql
	rem del %%i.sql
)

pause
