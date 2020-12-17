IF OBJECT_ID('[dspInboxMessage].[MessageLastData_ReadJson]') IS NOT NULL
	DROP FUNCTION [dspInboxMessage].[MessageLastData_ReadJson];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspInboxMessage].[MessageLastData_ReadJson] (@MessageLastData TJSON)
RETURNS TABLE
AS
RETURN (   SELECT   MsgKey, MsgValue
             FROM
                OPENJSON(@MessageLastData)
                WITH (MsgKey TSTRING, MsgValue TSTRING));
GO
