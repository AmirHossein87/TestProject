IF OBJECT_ID('[tSQLt].[NewConnection]') IS NOT NULL
	DROP PROCEDURE [tSQLt].[NewConnection];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [tSQLt].[NewConnection] (@command [nvarchar] (max))
WITH EXECUTE AS CALLER
AS EXTERNAL NAME [tSQLtCLR].[tSQLtCLR.StoredProcedures].[NewConnection]
GO
