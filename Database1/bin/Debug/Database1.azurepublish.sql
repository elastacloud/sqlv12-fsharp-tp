﻿/*
Deployment script for Database1

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Database1"
:setvar DefaultFilePrefix "Database1"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [master];


GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)] COLLATE SQL_Latin1_General_CP1_CI_AS
GO
DECLARE  @job_state INT = 0;
DECLARE  @index INT = 0;
DECLARE @EscapedDBNameLiteral sysname = N'$(DatabaseName)'
WAITFOR DELAY '00:00:30';
WHILE (@index < 60) 
BEGIN
	SET @job_state = ISNULL( (SELECT SUM (result)  FROM (
		SELECT TOP 1 [state] AS result
		FROM sys.dm_operation_status WHERE resource_type = 0 
		AND operation = 'CREATE DATABASE' AND major_resource_id = @EscapedDBNameLiteral AND [state] = 2
		ORDER BY start_time DESC
		) r), -1);

	SET @index = @index + 1;

	IF @job_state = 0 /* pending */ OR @job_state = 1 /* in progress */ OR @job_state = -1 /* job not found */ OR (SELECT [state] FROM sys.databases WHERE name = @EscapedDBNameLiteral) <> 0
		WAITFOR DELAY '00:00:30';
	ELSE 
    	BREAK;
END
GO
