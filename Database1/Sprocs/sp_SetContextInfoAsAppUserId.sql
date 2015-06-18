CREATE PROCEDURE sp_setContextInfoAsAppUserId(@AppUserId int)
AS 
    SET CONTEXT_INFO @AppUserId;
GO