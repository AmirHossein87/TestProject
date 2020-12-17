IF OBJECT_ID('[dspInboxMessage].[Message_$BuildByDynamicExpression]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[Message_$BuildByDynamicExpression];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[Message_$BuildByDynamicExpression]
    @Message TSTRING, @DefaultValue TSTRING, @ConfirmHasCustomValidation BIT, @ResultMessage TSTRING = NULL OUTPUT, @ConfirmValue TSTRING OUTPUT
AS
BEGIN
    -- Parameters
    DECLARE @InboxMessageProcessSendMessageTag_RandomString TSTRING = dspInboxMessage.InboxMessageProcessSendMessageTag_RandomString();
    DECLARE @InboxMessageProcessSendMessageTag_RandomNumber TSTRING = dspInboxMessage.InboxMessageProcessSendMessageTag_RandomNumber();
    DECLARE @InboxMessageProcessSendMessageTag_DefaultValue TSTRING = dspInboxMessage.InboxMessageProcessSendMessageTag_DefaultValue();

    -- Buiild corresponding message
    IF CHARINDEX(@InboxMessageProcessSendMessageTag_RandomString, @Message) > 0
    BEGIN
        EXEC dsp.String_CreateRandom @Length = 4, @RandomString = @ConfirmValue OUTPUT, @IncludeLetter = 1, @IncludeDigit = 1;
        SET @ResultMessage = REPLACE(@Message, @InboxMessageProcessSendMessageTag_RandomString, @ConfirmValue);
    END;
    -- Prpare @@RandomNumber
    ELSE IF CHARINDEX(@InboxMessageProcessSendMessageTag_RandomNumber, @Message) > 0
    BEGIN
        EXEC dsp.String_CreateRandom @Length = 4, @RandomString = @ConfirmValue OUTPUT, @IncludeLetter = 0, @IncludeDigit = 1;
        SET @ResultMessage = REPLACE(@Message, @InboxMessageProcessSendMessageTag_RandomNumber, @ConfirmValue);
    END;
    -- Prepare @@DefaultValue
    ELSE IF CHARINDEX(@InboxMessageProcessSendMessageTag_DefaultValue, @Message) > 0
    BEGIN
        SET @ConfirmValue = ISNULL(@DefaultValue, '');
        SET @ResultMessage = REPLACE(@Message, @InboxMessageProcessSendMessageTag_DefaultValue, @ConfirmValue);
    END;
END;
GO
