CREATE SECURITY POLICY Security.SalesFilter
    ADD FILTER PREDICATE Security.fn_securitypredicate(AppUserId) ON dbo.Sales
    WITH (STATE = ON);