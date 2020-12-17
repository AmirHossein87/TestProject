IF OBJECT_ID('[tClass].[test Log_Create]') IS NOT NULL
	DROP PROCEDURE [tClass].[test Log_Create];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tClass].[test Log_Create]
AS
BEGIN
    SET NOCOUNT ON;
    -- Getting SystemContext
    DECLARE @SystemContext TCONTEXT;
    EXEC dsp.Context_CreateSystem @SystemContext = @SystemContext OUTPUT;
    DECLARE @AuditUserId INT = dsp.Context_UserId(@SystemContext);

    -- Declare variable
    DECLARE @CheckingNumber INT = 0;
    DECLARE @LogId BIGINT;
    DECLARE @Application_IcLoyalty INT = const.Application_IcLoyalty();
    DECLARE @Log_FilterRsultList ud_LogFilter;

    --------------------------------
    -- Checking: InvalidArgument exception is expected when ApplicationId is null
    --------------------------------
    SET @CheckingNumber = @CheckingNumber + 1;
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Checking {0}: InvalidArgument exception is expected when ApplicationId is null',
        @Param0 = @CheckingNumber;

    BEGIN TRY
        EXEC api.Log_Create @Context = @SystemContext, @ApplicationId = NULL, @CategoryId = 1, @CustomData = '';
        EXEC tSQLt.Fail @Message0 = N'InvalidArgument exception is expected when ApplicationId is null';
    END TRY
    BEGIN CATCH
        IF (ERROR_NUMBER() <> err.InvalidArgumentId() OR CHARINDEX('ApplicationId is null', ERROR_MESSAGE()) = 0)
            THROW;
    END CATCH;

    --------------------------------
    -- Checking: InvalidArgument exception is expected when ApplicationId is an invalid value
    --------------------------------
    SET @CheckingNumber = @CheckingNumber + 1;
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Checking {0}: InvalidArgument exception is expected when ApplicationId is an invalid value',
        @Param0 = @CheckingNumber;

    BEGIN TRY
        EXEC api.Log_Create @Context = @SystemContext, @ApplicationId = -1, @CategoryId = 1, @CustomData = '';
        EXEC tSQLt.Fail @Message0 = N'InvalidArgument exception is expected when ApplicationId is an invalid value';
    END TRY
    BEGIN CATCH
        IF (ERROR_NUMBER() <> err.InvalidArgumentId() OR CHARINDEX('ApplicationId is an invalid value', ERROR_MESSAGE()) = 0)
            THROW;
    END CATCH;

    --------------------------------
    -- Checking: Successfully create log
    --------------------------------
    SET @CheckingNumber = @CheckingNumber + 1;
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Checking {0}: Successfully create log', @Param0 = @CheckingNumber;

    SAVE TRANSACTION Test;
    SET @LogId = NULL;
    DECLARE @CustomData TJSON = '{"OperationKey": 101010, "OperationValue": "Operation was successfully"}';
    EXEC api.Log_Create @Context = @SystemContext, @ApplicationId = @Application_IcLoyalty, @CategoryId = 1, @SubCategoryId = 1, @CustomData = @CustomData,
        @LogId = @LogId OUTPUT;

    IF (@LogId IS NULL) --
        EXEC tSQLt.Fail @Message0 = N'The log is not saved correctly';

    DELETE @Log_FilterRsultList;
    INSERT INTO @Log_FilterRsultList
    EXEC api.Log_Filter @Context = @SystemContext, @ApplicationId = @Application_IcLoyalty;

    IF NOT EXISTS (SELECT   TOP 1 1 FROM    @Log_FilterRsultList AS LFRL)
        EXEC tSQLt.Fail @Message0 = N'Log_Filter function is not worked correctly';

    DECLARE @ActualCategoryId INT;
    DECLARE @ActualSubCategoryId INT;
    DECLARE @ActualCustomData TJSON;

    SELECT  TOP 1 @ActualCategoryId = LFRL.CategoryId, @ActualSubCategoryId = LFRL.SubCategoryId, @ActualCustomData = LFRL.CustomData
      FROM  @Log_FilterRsultList AS LFRL;

    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @ActualCategoryId, @Message = N'CategoryId is not correctly';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @ActualSubCategoryId, @Message = N'SubCategoryId is not correctly';

    DECLARE @AreSame BIT;
    EXEC dsp.Json_Compare @Json1 = @CustomData, @Json2 = @ActualCustomData, @TwoSided = 0, @IncludeValue = 1,
        @ExceptionMessage = N'Log_Filter function is returned not correctly custom data json';

    ROLLBACK TRANSACTION Test;

END;


GO
