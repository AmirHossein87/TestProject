IF OBJECT_ID('[tSQLt].[CaptureOutput]') IS NOT NULL
	DROP PROCEDURE [tSQLt].[CaptureOutput];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [tSQLt].[CaptureOutput] (@command [nvarchar] (max))
WITH EXECUTE AS CALLER
AS EXTERNAL NAME [tSQLtCLR].[tSQLtCLR.StoredProcedures].[CaptureOutput]
GO
