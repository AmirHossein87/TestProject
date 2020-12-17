IF OBJECT_ID('[dspInboxMessage].[MessagePatternStep_HasCustomConfirmValidation]') IS NOT NULL
	DROP FUNCTION [dspInboxMessage].[MessagePatternStep_HasCustomConfirmValidation];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dspInboxMessage].[MessagePatternStep_HasCustomConfirmValidation] (@MessagePatternId INT)
RETURNS BIT
WITH SCHEMABINDING
AS
BEGIN
    IF EXISTS (   SELECT    1
                    FROM    dspInboxMessage.MessagePatternStep
                   WHERE MessagePatternId = @MessagePatternId --
                      AND   MessagePatternStepTypeId = dspconst.MessagePatternStepType_Confirm() --
                      AND   ConfirmHasCustomValidation = 1)
        RETURN (1);
    ELSE
        RETURN (0);

    RETURN (0);
END;

GO
