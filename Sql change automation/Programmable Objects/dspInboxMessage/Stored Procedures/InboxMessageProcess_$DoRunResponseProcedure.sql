IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$DoRunResponseProcedure]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$DoRunResponseProcedure];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
	Sample Data
	ParameterSpecification	[{"ParamName":"Input","ParamType":"Input","ParameterValue":"Sended_InputParameterValue_from_consumer"}]
	ParameterSpecification	[{"ParamName":"InputOutput","ParamType":"Output","ParameterValue":"Sended_InputOutputParameterValue_from_consumer"}]
	ParameterSpecification	[{"ParamName":"Output","ParamType":"Output"}]
	ParameterSpecification	[{"ParamName":"DefaultValue","ParamType":"Input","ParameterValue":"DefaultValue"}]
	*/
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$DoRunResponseProcedure]
    @MessageLastData TJSON, @ProviderInfoId INT, @Address TSTRING, @SendMessageValue TSTRING, @MessagePatternStepId INT,
    @InboxMessageProcessStateId INT = NULL OUTPUT, @ErrorMessage TSTRING = NULL OUTPUT
AS
BEGIN
    -- Consts
    DECLARE @Tag_ParameterSpecification TSTRING = dspInboxMessage.InboxMessageProcessKeyTag_ParameterSpecification();
    DECLARE @NullExpression TSTRING = dspInboxMessage.InboxMessageProcessKeyTag_NullExpression();

    DECLARE @SQL TSTRING;
    DECLARE @ResponseProcedureSchemaName TSTRING;
    DECLARE @ResponseProcedureName TSTRING;
    DECLARE @DeclarePart TSTRING = '';
    DECLARE @CallParameterPart TSTRING = '';
    DECLARE @SelectParamAfterExec TSTRING = '';

    -- Generate DeclarePart, CallParameterPart, SelectParamAfterExec
    SELECT  @DeclarePart =
        @DeclarePart + ' DECLARE @' + JSON_VALUE(MsgValue, '$.ParamName') + ' TSTRING '
        + CASE
              WHEN JSON_VALUE(MsgValue, '$.ParamValue') IS NOT NULL
                  THEN ' = ' + CASE JSON_VALUE(MsgValue, '$.ParamValue')
                                   WHEN @NullExpression
                                       THEN 'NULL' ELSE QUOTENAME(JSON_VALUE(MsgValue, '$.ParamValue'), '''')
                               END ELSE ''
          END + CHAR(13),
        @CallParameterPart =
            @CallParameterPart + ', @' + JSON_VALUE(MsgValue, '$.ParamName') + ' = @' + JSON_VALUE(MsgValue, '$.ParamName')
            + CASE
                  WHEN JSON_VALUE(MsgValue, '$.ParamType') = 'Output'
                      THEN ' OUTPUT' ELSE ''
              END,
        @SelectParamAfterExec =
            @SelectParamAfterExec + CASE
                                        WHEN JSON_VALUE(MsgValue, '$.ParamType') = 'Output'
                                            THEN ', @' + JSON_VALUE(MsgValue, '$.ParamName') + ' AS ' + JSON_VALUE(MsgValue, '$.ParamName') ELSE ''
                                    END
      FROM  dspInboxMessage.MessageLastData_ReadJson(@MessageLastData)
     WHERE  MsgKey = @Tag_ParameterSpecification;

    -- Prepare @CallParameterPart
    SET @CallParameterPart = LTRIM(RTRIM(@CallParameterPart));
    SET @CallParameterPart = RIGHT(@CallParameterPart, LEN(@CallParameterPart) - 1);

    -- Prepare @CallParameterPart
    SET @SelectParamAfterExec = LTRIM(RTRIM(@SelectParamAfterExec));
    IF @SelectParamAfterExec <> ''
        SET @SelectParamAfterExec = RIGHT(@SelectParamAfterExec, LEN(@SelectParamAfterExec) - 1);
    IF @SelectParamAfterExec <> ''
        SET @SelectParamAfterExec = CHAR(13) + ' SELECT ' + @SelectParamAfterExec;

    -- Get ResponseProcedureSchemaName and ResponseProcedureName
    DECLARE @MessagePatternId INT;
    EXEC dspInboxMessage.MessagePatternStep_GetProps @MessagePatternStepId = @MessagePatternStepId, @MessagePatternId = @MessagePatternId OUTPUT;
    EXEC dspInboxMessage.MessagePattern_GetProps @MessagePatternId = @MessagePatternId, @ResponseProcedureSchemaName = @ResponseProcedureSchemaName OUTPUT,
        @ResponseProcedureName = @ResponseProcedureName OUTPUT;

    -- Prepare query for call response procedure with last data and call it
    SET @SQL = @DeclarePart + 'EXECUTE ' + @ResponseProcedureSchemaName + '.' + @ResponseProcedureName + @CallParameterPart; --+ @SelectParamAfterExec;

    IF LTRIM(RTRIM(ISNULL(@SQL, ''))) = ''
    BEGIN
        SET @ErrorMessage = 'Do not valid SQL command generated';
        SET @InboxMessageProcessStateId = dspconst.InboxMessageProcessState_ExecResponseProcedureFaild();
        RETURN;
    END;

    BEGIN TRY
        EXEC (@SQL);
    END TRY
    BEGIN CATCH
        SET @ErrorMessage = dsp.Message_CommonExceptionFormat(@@PROCID, ERROR_MESSAGE());
        SET @InboxMessageProcessStateId = dspconst.InboxMessageProcessState_ExecResponseProcedureFaild();
        RETURN;
    END CATCH;

    -- Send message if exec successfuly and step has send message expression
    IF (@SendMessageValue IS NOT NULL)
        EXEC dspInboxMessage.[InboxMessageProcess_$SendReplyMessage] @ProviderInfoId = @ProviderInfoId, @Address = @Address,
            @SendMessageValue = @SendMessageValue, @MessagePatternStepId = @MessagePatternStepId;

END;

GO
