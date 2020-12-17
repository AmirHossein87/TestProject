IF OBJECT_ID('[dspconst].[InboxMessageProcessState_AddressNotRegistered]') IS NOT NULL
	DROP FUNCTION [dspconst].[InboxMessageProcessState_AddressNotRegistered];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[InboxMessageProcessState_AddressNotRegistered]()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 6;
END;
GO
