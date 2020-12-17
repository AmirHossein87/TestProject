IF OBJECT_ID('[dspInboxMessage].[MessagePatternStep_$Validate]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePatternStep_$Validate];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePatternStep_$Validate]
    @MessagePatternId INT, @MessagePatternStepId INT = -1, @MessagePatternStepTypeId INT = -1, @ParameterName TSTRING = '<notset>',
    @SendMessageValue TSTRING = '<notset>', @DefaultValue TSTRING = '<notset>', @ConfirmHasCustomValidation INT = -1, @HasCustomValue INT = -1, @Order INT = -1
AS
BEGIN
    SET NOCOUNT ON;

    /* MessagePatternStepType behavior table
	MessagePatternStepTypeId	MessagePatternStepType		CanHasDefaultValue	IsProcedureParam	CanSendMessage	ConfirmHasCustomValidation	HasCustomValue
						1		InputParam					1					1					0				0							1
						2		OutputParam					0					1					0				0							0
						3		InputOutputParam			1					1					0				0							1
						4		SendMessage					0					0					1				0							0
						5		Confirm						0					0					1				1							0
						6		DoRun						0					0					1				0							0
						7		DoCheckConfirmActivation	0					0					0				0							0
	*/

    --consts
    DECLARE @TypeIs_Input TINYINT = dspconst.MessagePatternStepType_InputParam();
    DECLARE @TypeIs_Output TINYINT = dspconst.MessagePatternStepType_OutputParam();
    DECLARE @TypeIs_InputOutput TINYINT = dspconst.MessagePatternStepType_InputOutputParam();
    DECLARE @TypeIs_Confirmation TINYINT = dspconst.MessagePatternStepType_Confirm();
    DECLARE @TypeIs_SendMessage TINYINT = dspconst.MessagePatternStepType_SendMessage();
    DECLARE @TypeIs_DoRun TINYINT = dspconst.MessagePatternStepType_DoRun();
    DECLARE @TypeIs_DoCheckConfirmActivation TINYINT = dspconst.MessagePatternStepType_DoCheckConfirmActivation();

    --Validate Call Mode
    --Is Better to Create dspconst Function
    DECLARE @State_Create INT = 1;
    DECLARE @State_SetProp INT = 2;
    DECLARE @ValidateState INT = CASE
                                     WHEN ISNULL(@MessagePatternStepId, 0) > 0
                                         THEN @State_SetProp ELSE @State_Create
                                 END;

    -- call GetProps for required data in validation
    DECLARE @OldMessagePatternStepTypeId INT;
    DECLARE @OldParameterName TSTRING;
    DECLARE @OldSendMessageValue TSTRING;
    DECLARE @OldDefaultValue TSTRING;
    DECLARE @OldConfirmHasCustomValidation BIT;
    DECLARE @OldHasCustomValue BIT;
    DECLARE @OldOrder INT;

    IF @ValidateState = @State_SetProp
    BEGIN
        EXEC dspInboxMessage.MessagePatternStep_GetProps @MessagePatternStepId = @MessagePatternStepId,
            @MessagePatternStepTypeId = @OldMessagePatternStepTypeId OUTPUT, @ParameterName = @OldParameterName OUTPUT,
            @SendMessageValue = @OldSendMessageValue OUTPUT, @DefaultValue = @OldDefaultValue OUTPUT,
            @ConfirmHasCustomValidation = @OldConfirmHasCustomValidation OUTPUT, @HasCustomValue = @OldHasCustomValue OUTPUT, @Order = @OldOrder OUTPUT;
    END;

    -- Validate MessagePatternId
    IF (@ValidateState = @State_Create) --
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'MessagePatternId', @ArgumentValue = @MessagePatternId;

    -- Validate MessagePatternStepTypeId
    EXEC dsp.SetIfChanged_String @ProcId = @@PROCID, @PropName = 'MessagePatternStepTypeId', @OldValue = @OldMessagePatternStepTypeId OUT,
        @NewValue = @MessagePatternStepTypeId;
    EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'MessagePatternStepTypeId', @ArgumentValue = @OldMessagePatternStepTypeId;

    -- Validate ParameterName
    EXEC dsp.SetIfChanged_String @ProcId = @@PROCID, @PropName = 'ParameterName', @OldValue = @OldParameterName OUT, @NewValue = @ParameterName;
    IF @OldMessagePatternStepTypeId IN ( @TypeIs_Input, @TypeIs_Output, @TypeIs_InputOutput )
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'ParameterName', @ArgumentValue = @OldParameterName;
    ELSE IF @OldParameterName IS NOT NULL
        EXEC dsperr.ThrowInvalidArgument @ProcId = @@PROCID, @Message = 'ParameterName can not assign';

    -- Validate SendMessageValue
    EXEC dsp.SetIfChanged_String @ProcId = @@PROCID, @PropName = 'SendMessageValue', @OldValue = @OldSendMessageValue OUT, @NewValue = @SendMessageValue;
    IF @OldMessagePatternStepTypeId IN ( @TypeIs_SendMessage, @TypeIs_Confirmation )
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'SendMessageValue', @ArgumentValue = @OldSendMessageValue;
    ELSE IF (@OldMessagePatternStepTypeId NOT IN ( @TypeIs_DoRun ) AND  @OldSendMessageValue IS NOT NULL) --
        EXEC dsperr.ThrowInvalidArgument @ProcId = @@PROCID, @Message = 'SendMessageValue can not assign';

    -- Validate HasCustomValue
    EXEC dsp.SetIfChanged_Int @ProcId = @@PROCID, @PropName = 'HasCustomValue', @OldValue = @OldHasCustomValue OUT, @NewValue = @HasCustomValue;
    IF @OldMessagePatternStepTypeId IN ( @TypeIs_Input, @TypeIs_InputOutput )
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'HasCustomValue', @ArgumentValue = @OldHasCustomValue;
    ELSE IF @OldHasCustomValue IS NOT NULL AND  @OldHasCustomValue = 1
        EXEC dsperr.ThrowInvalidArgument @ProcId = @@PROCID, @Message = 'HasCustomValue can not assign';

    -- Validate ConfirmHasCustomValidation
    EXEC dsp.SetIfChanged_Int @ProcId = @@PROCID, @PropName = 'ConfirmHasCustomValidation', @OldValue = @OldConfirmHasCustomValidation OUT,
        @NewValue = @ConfirmHasCustomValidation;
    IF (@OldMessagePatternStepTypeId IN ( @TypeIs_Confirmation )) --
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'ConfirmHasCustomValidation', @ArgumentValue = @OldConfirmHasCustomValidation;
    ELSE IF (ISNULL(@OldConfirmHasCustomValidation,0) <> 0) --
        EXEC dsperr.ThrowInvalidArgument @ProcId = @@PROCID, @Message = 'ConfirmHasCustomValidation can not assign';

    -- Validate DefaultValue
    EXEC dsp.SetIfChanged_String @ProcId = @@PROCID, @PropName = 'DefaultValue', @OldValue = @OldDefaultValue OUT, @NewValue = @DefaultValue;

    IF (   @OldMessagePatternStepTypeId IN ( @TypeIs_SendMessage, @TypeIs_Output, @TypeIs_DoRun, @TypeIs_DoCheckConfirmActivation ) --
           AND  @OldDefaultValue IS NOT NULL)
        EXEC dsperr.ThrowInvalidArgument @ProcId = @@PROCID, @Message = 'DefaultValue can not assign';

    -- Validate Order
    EXEC dsp.SetIfChanged_Int @ProcId = @@PROCID, @PropName = 'Order', @OldValue = @OldOrder OUT,
        @NewValue = @Order;
    EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'Order', @ArgumentValue = @OldOrder;
	IF @OldMessagePatternStepTypeId = @TypeIs_DoCheckConfirmActivation AND @OldOrder <> 0
        EXEC dsperr.ThrowInvalidArgument @ProcId = @@PROCID, @Message = 'Order can not change';


    -- Validate ParameterName Existance
    IF @OldMessagePatternStepTypeId IN ( @TypeIs_Input, @TypeIs_Output, @TypeIs_InputOutput )
    BEGIN
        -- call GetProps for get @ResponseProcedureName
        DECLARE @ResponseProcedureName TSTRING;
        DECLARE @ResponseProcedureSchemaName TSTRING;
        EXEC dspInboxMessage.MessagePattern_GetProps @MessagePatternId = @MessagePatternId, @ResponseProcedureSchemaName = @ResponseProcedureSchemaName OUTPUT,
            @ResponseProcedureName = @ResponseProcedureName OUTPUT;
        SET @ResponseProcedureName = @ResponseProcedureSchemaName + '.' + @ResponseProcedureName;

        IF NOT EXISTS (   SELECT    'Parameter_name' = name
                            FROM    sys.parameters
                           WHERE object_id = OBJECT_ID(@ResponseProcedureName) AND  REPLACE(name, '@', '') = REPLACE(@ParameterName, '@', ''))
            EXEC dsperr.ThrowInvalidArgument @ProcId = @@PROCID, @Message = 'ParameterName is invalid';

        -- Validate Output ParameterName is define OUTPUT in Response procedure
        IF (@OldMessagePatternStepTypeId IN ( dspconst.MessagePatternStepType_OutputParam(), dspconst.MessagePatternStepType_InputOutputParam())) AND
           NOT EXISTS (   SELECT    'Parameter_name' = name
                            FROM    sys.parameters
                           WHERE   object_id = OBJECT_ID(@ResponseProcedureName) AND   REPLACE(name, '@', '') = REPLACE(@ParameterName, '@', '') AND
                                   is_output = 1)
            EXEC dsperr.ThrowInvalidArgument @ProcId = @@PROCID, @Message = 'ParameterName is not output parameter';
    END;

END;
GO
