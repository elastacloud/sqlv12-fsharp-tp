CREATE FUNCTION Security.fn_securitypredicate(@AppUserId int)
    RETURNS TABLE
    WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS fn_securitypredicate_result
    WHERE
        DATABASE_PRINCIPAL_ID() = DATABASE_PRINCIPAL_ID('dbo')  -- application context
        AND CONVERT(int, CONVERT(VARBINARY(4), CONTEXT_INFO())) = @AppUserId; 
        -- AppUserId (int) is 4 bytes