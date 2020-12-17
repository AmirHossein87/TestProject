IF OBJECT_ID('[dspInboxMessage].[Init_FillLookups]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[Init_FillLookups];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[Init_FillLookups]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TableName TSTRING;

	-- SQL Prompt formatting off

	-- MessagePatternSeprator
    SET @TableName = N'MessagePatternSeprator';
    SELECT  * 
    INTO    #MessagePatternSeprator
      FROM  dspInboxMessage.MessagePatternSeprator AS A
     WHERE  1 = 0;

    INSERT INTO #MessagePatternSeprator
    VALUES 
		(dspconst.MessagePatternSeprator_Blank(), N' '),
		(dspconst.MessagePatternSeprator_Sharp(), N'#'),
		(dspconst.MessagePatternSeprator_Star(), N'*'),
		(dspconst.MessagePatternSeprator_AT(), N'@'),
		(dspconst.MessagePatternSeprator_DollorSign(), N'$');
		
    EXEC dsp.Table_CompareData @DestinationTableName = @TableName, @DestinationSchemaName = 'dspInboxMessage';

	-- MessagePatternSeprator
    SET @TableName = N'MessagePatternState';
    SELECT  * 
    INTO    #MessagePatternState
      FROM  dspInboxMessage.MessagePatternState AS A
     WHERE  1 = 0;
    INSERT INTO #MessagePatternState
    VALUES 
		(dspconst.MessagePatternStateId_Drafted(), N'Drafted'),
		(dspconst.MessagePatternStateId_Started(), N'Started'),
		(dspconst.MessagePatternStateId_Paused(), N'Paused'),
		(dspconst.MessagePatternStateId_Canceled(), N'Canceled');
		
    EXEC dsp.Table_CompareData @DestinationTableName = @TableName, @DestinationSchemaName = 'dspInboxMessage';
	
	-- ProcessState
    SET @TableName = N'InboxMessageProcessState';
    SELECT  * 
    INTO    #InboxMessageProcessState
      FROM  dspInboxMessage.InboxMessageProcessState AS A
     WHERE  1 = 0;
    INSERT INTO #InboxMessageProcessState
    VALUES 
		(dspconst.InboxMessageProcessState_NotProcessed(), N'NotProcessed'),
		(dspconst.InboxMessageProcessState_Processed(), N'Processed'),
		(dspconst.InboxMessageProcessState_ProcessedNotPair(), N'ProceedNotPair'),
		(dspconst.InboxMessageProcessState_ProcessedFailed (), N'ProcessedFailed'),
		(dspconst.InboxMessageProcessState_InProcess(), N'InProcess'),
		(dspconst.InboxMessageProcessState_AddressNotRegistered(), N'AddressNotRegistered'),
		(dspconst.InboxMessageProcessState_ExecResponseProcedureFaild(), N'ExecResponseProcedureFaild'),
		(dspconst.InboxMessageProcessState_CustomConfirmNotActive(), N'CustomConfirmNotActive'),
		(dspconst.InboxMessageProcessState_CustomConfirmFailed(), N'CustomConfirmFailed');
		
    EXEC dsp.Table_CompareData @DestinationTableName = @TableName, @DestinationSchemaName = 'dspInboxMessage';

	-- MessagePatternStepType
    SET @TableName = N'MessagePatternStepType';
    SELECT  * 
    INTO    #MessagePatternStepType
      FROM  dspInboxMessage.MessagePatternStepType AS A
     WHERE  1 = 0;
    INSERT INTO #MessagePatternStepType
    VALUES 
		(dspconst.MessagePatternStepType_InputParam(), N'InputParam'),
		(dspconst.MessagePatternStepType_OutputParam(), N'OutputParam'),
		(dspconst.MessagePatternStepType_InputOutputParam(), N'InputOutputParam'),
		(dspconst.MessagePatternStepType_SendMessage(), N'SendMessage'),
		(dspconst.MessagePatternStepType_Confirm(), N'Confirm'),
		(dspconst.MessagePatternStepType_DoRun(), N'DoRun'),
		(dspconst.MessagePatternStepType_DoCheckConfirmActivation(), N'DoCheckConfirmActivation');

    EXEC dsp.Table_CompareData @DestinationTableName = @TableName, @DestinationSchemaName = 'dspInboxMessage';

	-- MessagePatternStepType
    SET @TableName = N'WaitForReplyMessageState';
    SELECT  * 
    INTO    #WaitForReplyMessageState
      FROM  dspInboxMessage.WaitForReplyMessageState AS A
     WHERE  1 = 0;
    INSERT INTO #WaitForReplyMessageState
    VALUES 
		(dspconst.WaitForReplyMessageState_Processed(), N'Processed'),
		(dspconst.WaitForReplyMessageState_Expired(), N'Expired'),
		(dspconst.WaitForReplyMessageState_NotProcess (), N'NotProcess');

    EXEC dsp.Table_CompareData @DestinationTableName = @TableName, @DestinationSchemaName = 'dspInboxMessage';

	-- ProviderType
    SET @TableName = N'ProviderType';
    SELECT  * 
    INTO    #ProviderType
      FROM  dspInboxMessage.ProviderType AS A
     WHERE  1 = 0;
    INSERT INTO #ProviderType
    VALUES 
		(dspconst.ProviderType_SMS(), N'SMS'),
		(dspconst.ProviderType_Email(), N'Email');

    EXEC dsp.Table_CompareData @DestinationTableName = @TableName, @DestinationSchemaName = 'dspInboxMessage';
	-- SQL Prompt formatting on
END;
GO
