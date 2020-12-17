IF OBJECT_ID('[dspInboxMessage].[MessagePatternStep_CreateCheckConfirmActivationStep]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePatternStep_CreateCheckConfirmActivationStep];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePatternStep_CreateCheckConfirmActivationStep]
    @MessagePatternId INT
AS
BEGIN
    INSERT INTO dspInboxMessage.MessagePatternStep (MessagePatternId, MessagePatternStepTypeId, [Order])
    VALUES (@MessagePatternId, dspconst.MessagePatternStepType_DoCheckConfirmActivation(), 0);
END;
GO
