IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$AppendToMessageLastData]') IS NOT NULL
	DROP FUNCTION [dspInboxMessage].[InboxMessageProcess_$AppendToMessageLastData];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspInboxMessage].[InboxMessageProcess_$AppendToMessageLastData] (@MessageLastData NVARCHAR(MAX /*NCQ*/),
    @MsgKey NVARCHAR(MAX /*NCQ*/),
    @MsgValue NVARCHAR(MAX /*NCQ*/))
RETURNS NVARCHAR(MAX /*NCQ*/)
WITH SCHEMABINDING
AS
BEGIN
    RETURN (JSON_MODIFY(ISNULL(@MessageLastData, '[]'), 'append $', JSON_QUERY((   SELECT   @MsgKey AS MsgKey, @MsgValue AS MsgValue
                                                                                   FOR JSON PATH, WITHOUT_ARRAY_WRAPPER))));
END;
GO
