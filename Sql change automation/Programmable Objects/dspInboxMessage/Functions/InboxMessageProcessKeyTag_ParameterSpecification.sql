IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcessKeyTag_ParameterSpecification]') IS NOT NULL
	DROP FUNCTION [dspInboxMessage].[InboxMessageProcessKeyTag_ParameterSpecification];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspInboxMessage].[InboxMessageProcessKeyTag_ParameterSpecification] ()
RETURNS NVARCHAR(50)
WITH SCHEMABINDING
AS
BEGIN
    RETURN 'ParameterSpecification';
END;
GO
