@echo off

set db_name=%1
set path=%path%;D:\PostgreSQL\bin;D:\Green\Git\bin;D:\Green\Git\usr\bin
set PGPASSWORD=123456
rem SET ICU_DATA=D:\Green\icu4c\commondata

set d1=%~dp0%
if "%db_name%"=="" (
	set d1=%d1:\= %
	for %%i in (%d1%) do (
		set db_name=%%i
	)
)
echo %db_name%

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
		shp2pgsql -D -W gb18030 %%i %%j | psql -U postgres %db_name%
	)
)

echo 成功将数据导入PostGis空间数据库：“%db_name%”中。

pause
