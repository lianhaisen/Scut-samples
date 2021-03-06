/*
参数:
$gameuser 游戏项目数据库登录账号
$loginPass 数据库登录账号密码
$dbpath 数据库存储路径
*/

IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = N'$(gameuser)')
BEGIN
    CREATE LOGIN [$(gameuser)] WITH PASSWORD=N'$(loginPass)', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
END
go


IF NOT EXISTS (SELECT * FROM sys.sysdatabases WHERE name = N'PHData')
BEGIN
	CREATE DATABASE [PHData] 
	ON  PRIMARY ( NAME = N'PHData', FILENAME = N'$(dbpath)/PHData.mdf' , SIZE = 3072KB , FILEGROWTH = 1024KB )
	 LOG ON ( NAME = N'PHData_log', FILENAME = N'$(dbpath)/PHData_log.ldf' , SIZE = 1024KB , FILEGROWTH = 10%)
	
END
GO
	ALTER DATABASE [PHData] SET RECOVERY SIMPLE 
	
GO

use PHData
GO
--权限
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'$(gameuser)')
	CREATE USER $(gameuser) FOR LOGIN $(gameuser) WITH DEFAULT_SCHEMA=[dbo]
GO
EXEC sp_addrolemember N'db_datareader', N'$(gameuser)'
EXEC sp_addrolemember N'db_datawriter', N'$(gameuser)'
EXEC sp_addrolemember N'db_ddladmin', N'$(gameuser)'
GO