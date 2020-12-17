IF OBJECT_ID('[dspInboxMessage].[MessagePattern_Delete]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePattern_Delete];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePattern_Delete]
    @MessagePatternId INT
AS
BEGIN
    -- Check if tag does not exists
    DECLARE @MessagePatternStateId INT;
    EXEC dspInboxMessage.MessagePattern_GetProps @MessagePatternId = @MessagePatternId, @MessagePatternStateId = @MessagePatternStateId OUTPUT;

    -- Check if Pattern State Is Started Then Throw
    IF (@MessagePatternStateId = dspconst.MessagePatternStateId_Started())
        EXEC dsp.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Pattern With Started State can not Deleted';

    -- Check if Pattern State Is Paused Then Throw
    IF (@MessagePatternStateId = dspconst.MessagePatternStateId_Paused())
        EXEC dsp.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Pattern With Paused State can not Deleted';

    -- Delete from local pattern
    UPDATE  dspInboxMessage.MessagePattern
       SET  IsDeleted = 1
     WHERE  MessagePatternId = @MessagePatternId;
END;
GO
