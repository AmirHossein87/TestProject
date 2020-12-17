IF OBJECT_ID('[dspconst].[InboxMessageProcessState_ExecResponseProcedureFaild]') IS NOT NULL
	DROP FUNCTION [dspconst].[InboxMessageProcessState_ExecResponseProcedureFaild];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[InboxMessageProcessState_ExecResponseProcedureFaild]()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 7;
END;
GO
