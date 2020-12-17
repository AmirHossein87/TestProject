IF OBJECT_ID('[dspInboxMessage].[MessagePattern_DeleteMessagePatternSteps]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePattern_DeleteMessagePatternSteps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePattern_DeleteMessagePatternSteps]
    @MessagePatternId INT
AS
BEGIN
    DECLARE @StepType_DoCheckConfirmActivation TINYINT = dspconst.MessagePatternStepType_DoCheckConfirmActivation();

    DELETE  FROM dspInboxMessage.MessagePatternStep
     WHERE  MessagePatternId = @MessagePatternId --
        AND MessagePatternStepTypeId <> @StepType_DoCheckConfirmActivation;
END;


GO
