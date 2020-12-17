IF OBJECT_ID('[tClass].[test Log_Filter]') IS NOT NULL
	DROP PROCEDURE [tClass].[test Log_Filter];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tClass].[test Log_Filter]
AS
BEGIN
    SET NOCOUNT ON;
    -- Getting SystemContext
    DECLARE @SystemContext TCONTEXT;
    EXEC dsp.Context_CreateSystem @SystemContext = @SystemContext OUTPUT;
    DECLARE @AuditUserId INT = dsp.Context_UserId(@SystemContext);

    -- Declare variable
    DECLARE @CheckingNumber INT = 0;
    DECLARE @Application_IcLoyalty INT = const.Application_IcLoyalty();
    DECLARE @Log_FilterRsultList ud_LogFilter;

    --------------------------------
    -- Checking: Create logs and get all of them by ApplicationId
    --------------------------------
    SET @CheckingNumber = @CheckingNumber + 1;
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Checking {0}: Create logs and get all of them by just ApplicationId', @Param0 = @CheckingNumber;

    SAVE TRANSACTION Test;

    EXEC api.Log_Create @Context = @SystemContext, @ApplicationId = @Application_IcLoyalty, @CategoryId = 1,
        @CustomData = '{"OperationKey": 101010, "OperationValue": "Operation was successfully"}';
    EXEC api.Log_Create @Context = @SystemContext, @ApplicationId = @Application_IcLoyalty, @CategoryId = 2,
        @CustomData = '{"OperationKey": 101011, "OperationValue": "Operation was not successfully"}';

    DELETE @Log_FilterRsultList;
    INSERT INTO @Log_FilterRsultList
    EXEC api.Log_Filter @Context = @SystemContext OUTPUT, @ApplicationId = @Application_IcLoyalty;

    IF ((SELECT COUNT(1) FROM   @Log_FilterRsultList AS LFRL) <> 2) --
        EXEC tSQLt.Fail @Message0 = N'The function returned incorrect count of result';

    ROLLBACK TRANSACTION Test;

    --------------------------------
    -- Checking: Create logs and get all of them by ApplicationId and CategoryId
    --------------------------------
    SET @CheckingNumber = @CheckingNumber + 1;
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Checking {0}: Create logs and get all of them by ApplicationId and CategoryId',
    @Param0 = @CheckingNumber;

    SAVE TRANSACTION Test;

    DECLARE @LogId1 BIGINT;
    EXEC api.Log_Create @Context = @SystemContext, @ApplicationId = @Application_IcLoyalty, @CategoryId = 1,
        @CustomData = '{"OperationKey": 101010, "OperationValue": "Operation was successfully"}', @LogId = @LogId1 OUTPUT;
    DECLARE @LogId2 BIGINT;
    EXEC api.Log_Create @Context = @SystemContext, @ApplicationId = @Application_IcLoyalty, @CategoryId = 2,
        @CustomData = '{"OperationKey": 101011, "OperationValue": "Operation was not successfully"}', @LogId = @LogId2 OUTPUT;

    DELETE @Log_FilterRsultList;
    INSERT INTO @Log_FilterRsultList
    EXEC api.Log_Filter @Context = @SystemContext OUTPUT, @ApplicationId = @Application_IcLoyalty, @CategoryId = 1;

    IF ((SELECT COUNT(1) FROM   @Log_FilterRsultList AS LFRL) <> 1) --
        EXEC tSQLt.Fail @Message0 = N'The function returned incorrect count of result on Log_1';

    IF ((SELECT LFRL.LogId FROM @Log_FilterRsultList AS LFRL) <> @LogId1) --
        EXEC tSQLt.Fail @Message0 = N'The function returned incorrect result on Log_1';

    DELETE @Log_FilterRsultList;
    INSERT INTO @Log_FilterRsultList
    EXEC api.Log_Filter @Context = @SystemContext OUTPUT, @ApplicationId = @Application_IcLoyalty, @CategoryId = 2;

    IF ((SELECT COUNT(1) FROM   @Log_FilterRsultList AS LFRL) <> 1) --
        EXEC tSQLt.Fail @Message0 = N'The function returned incorrect count of result on Log_2';

    IF ((SELECT LFRL.LogId FROM @Log_FilterRsultList AS LFRL) <> @LogId2) --
        EXEC tSQLt.Fail @Message0 = N'The function returned incorrect result on Log_2';

    ROLLBACK TRANSACTION Test;

    --------------------------------
    -- Checking: Create logs and get all of them by ApplicationId and CategoryId and SubCategory
    --------------------------------
    SET @CheckingNumber = @CheckingNumber + 1;
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Checking {0}: Create logs and get all of them by ApplicationId and CategoryId and SubCategory',
        @Param0 = @CheckingNumber;

    SAVE TRANSACTION Test;

    SET @LogId1 = NULL;
    EXEC api.Log_Create @Context = @SystemContext, @ApplicationId = @Application_IcLoyalty, @CategoryId = 1, @SubCategoryId = 1,
        @CustomData = '{"OperationKey": 101010, "OperationValue": "Operation was successfully"}', @LogId = @LogId1 OUTPUT;

    SET @LogId2 = NULL;
    EXEC api.Log_Create @Context = @SystemContext, @ApplicationId = @Application_IcLoyalty, @CategoryId = 1, @SubCategoryId = 2,
        @CustomData = '{"OperationKey": 101011, "OperationValue": "Operation was not successfully"}', @LogId = @LogId2 OUTPUT;

    DELETE @Log_FilterRsultList;
    INSERT INTO @Log_FilterRsultList
    EXEC api.Log_Filter @Context = @SystemContext OUTPUT, @ApplicationId = @Application_IcLoyalty, @CategoryId = 1, @SubCategoryId = 1;

    IF ((SELECT COUNT(1) FROM   @Log_FilterRsultList AS LFRL) <> 1) --
        EXEC tSQLt.Fail @Message0 = N'The function returned incorrect count of result on Log_1';

    IF ((SELECT LFRL.LogId FROM @Log_FilterRsultList AS LFRL) <> @LogId1) --
        EXEC tSQLt.Fail @Message0 = N'The function returned incorrect result on Log_1';

    DELETE @Log_FilterRsultList;
    INSERT INTO @Log_FilterRsultList
    EXEC api.Log_Filter @Context = @SystemContext OUTPUT, @ApplicationId = @Application_IcLoyalty, @CategoryId = 1, @SubCategoryId = 2;

    IF ((SELECT COUNT(1) FROM   @Log_FilterRsultList AS LFRL) <> 1) --
        EXEC tSQLt.Fail @Message0 = N'The function returned incorrect count of result on Log_2';

    IF ((SELECT LFRL.LogId FROM @Log_FilterRsultList AS LFRL) <> @LogId2) --
        EXEC tSQLt.Fail @Message0 = N'The function returned incorrect result on Log_2';

    ROLLBACK TRANSACTION Test;

END;


GO
