IF OBJECT_ID('[dspInboxMessage].[MessagePatternStep_CreateBulk]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePatternStep_CreateBulk];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePatternStep_CreateBulk]
    @MessagePatternId INT, @StepItems TJSON
AS
BEGIN
    -- Declare variable for step cursor
    DECLARE @MessagePatternStepId INT;
    DECLARE @MessagePatternStepTypeId TINYINT;
    DECLARE @ParameterName TSTRING;
    DECLARE @SendMessageValue TSTRING;
    DECLARE @Order INT;
    DECLARE @DefaultValue TSTRING;
    DECLARE @StepDescription TSTRING;
    DECLARE @ConfirmHasCustomValidation BIT;
	DECLARE @HasCustomValue BIT;

    DECLARE _Cursor CURSOR LOCAL FAST_FORWARD FORWARD_ONLY FOR -- 
    SELECT  MessagePatternStepId, MessagePatternStepTypeId, ParameterName, SendMessageValue, [Order], DefaultValue, Description, ConfirmHasCustomValidation, HasCustomValue
      FROM
        OPENJSON(@StepItems)
        WITH (MessagePatternStepId INT, MessagePatternStepTypeId TINYINT, ParameterName TSTRING, SendMessageValue TSTRING, [Order] INT, DefaultValue TSTRING,
            [Description] TSTRING, ConfirmHasCustomValidation BIT, HasCustomValue BIT);

    OPEN _Cursor;

    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM _Cursor
         INTO @MessagePatternStepId, @MessagePatternStepTypeId, @ParameterName, @SendMessageValue, @Order, @DefaultValue, @StepDescription,
             @ConfirmHasCustomValidation, @HasCustomValue;
        IF (@@FETCH_STATUS <> 0)
            BREAK;

        -- Call create for step
        EXEC dspInboxMessage.MessagePatternStep_Create @MessagePatternId = @MessagePatternId, @MessagePatternStepTypeId = @MessagePatternStepTypeId,
            @ParameterName = @ParameterName, @SendMessageValue = @SendMessageValue, @DefaultValue = @DefaultValue, @Description = @StepDescription,
            @Order = @Order, @ConfirmHasCustomValidation = @ConfirmHasCustomValidation, @HasCustomValue = @HasCustomValue;

    END;
    CLOSE _Cursor;
    DEALLOCATE _Cursor;
END;
GO
