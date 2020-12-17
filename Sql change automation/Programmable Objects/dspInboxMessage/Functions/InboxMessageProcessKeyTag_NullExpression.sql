IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcessKeyTag_NullExpression]') IS NOT NULL
	DROP FUNCTION [dspInboxMessage].[InboxMessageProcessKeyTag_NullExpression];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspInboxMessage].[InboxMessageProcessKeyTag_NullExpression] ()
RETURNS NVARCHAR(10)
WITH SCHEMABINDING
AS
BEGIN
    RETURN '<NULL>';
END;
GO
