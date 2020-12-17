IF OBJECT_ID('[dspInboxMessage].[vw_MessagePattern]') IS NOT NULL
	DROP VIEW [dspInboxMessage].[vw_MessagePattern];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dspInboxMessage].[vw_MessagePattern]
AS
SELECT  MessagePatternId, PatternName, StartTime, ExpirationTime, MessagePatternSepratorId, PatternKey, MessagePatternStateId, ResponseProcedureSchemaName,
    ResponseProcedureName, Description
  FROM  dspInboxMessage.MessagePattern
 WHERE  IsDeleted = 0;;
GO
