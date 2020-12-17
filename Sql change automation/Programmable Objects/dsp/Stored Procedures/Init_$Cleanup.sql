IF OBJECT_ID('[dsp].[Init_$Cleanup]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_$Cleanup];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Init_$Cleanup]
    @IsProductionEnvironment BIT OUT, @IsWithCleanup BIT OUT
AS
BEGIN
    -- Set IsProductionEnvironment after creating Setting and Initializing Exceptions and Strings 
    DECLARE @OldIsProductionEnvironment INT;
    EXEC dsp.Setting_GetProps @IsProductionEnvironment = @OldIsProductionEnvironment OUTPUT;

    -- Find IsProductionEnvironment and IsWithCleanup default depending of current state
    SET @IsProductionEnvironment = ISNULL(@IsProductionEnvironment, @OldIsProductionEnvironment); -- Don't change IsProductionEnvironment if it is not changed
    IF (@IsWithCleanup IS NULL)
        SET @IsWithCleanup = IIF(@IsProductionEnvironment = 1, 0, 1);

    -- validate arguments    
    IF (@IsProductionEnvironment = 0 AND @OldIsProductionEnvironment = 1) --
        EXEC dsp.ThrowGeneralException @ProcId = @@PROCID, @Message = 'dsp.Init cannot unset IsProductionEnvironment setting!';

    IF (@IsProductionEnvironment = 1 AND @IsWithCleanup = 1) --
        EXEC dsp.ThrowGeneralException @ProcId = @@PROCID, @Message = 'Could not execute Cleanup in production environment!';

    -- Update IsProductionEnvironment
    EXEC dsp.Setting_SetProps @IsProductionEnvironment = @IsProductionEnvironment;

    -- Raise error in production environment if IsWithCleanup is set
    IF (@IsWithCleanup = 0) --
        RETURN;

    -- Make sure dbo.Init_Cleanup has production protection
    DECLARE @TranCount INT = @@TRANCOUNT;
    IF (@TranCount = 0)
        BEGIN TRANSACTION;

    SAVE TRANSACTION Test;
    BEGIN TRY
        EXEC dsp.Setting_SetProps @IsProductionEnvironment = 1;
        EXEC dsp.[Init_$ImpCleanup];
        EXEC dsp.ThrowGeneralException @ProcId = @@PROCID, @Message = 'Could not detect dsp.Init_Cleanup protection control for production environment';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION Test;
        IF (@TranCount = 0)
            ROLLBACK TRANSACTION;

        IF (ERROR_NUMBER() = dspconst.Exception_ProductionEnvironmentId() AND
            CHARINDEX('This operation can not be executed in ProductionEnvironment', ERROR_MESSAGE()) > 0)
            THROW;
    END CATCH;

    -- Read CleanUp
    DECLARE @DataBaseName TSTRING = DB_NAME();
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Cleaning "{1}" database of "{0}"', @Param0 = @@SERVERNAME, @Param1 = @DataBaseName;

    -- Cleanup dbo
    EXEC dsp.[Init_$ImpCleanup];

    -- CleanUp dspAuth if exists
    IF (dsp.Metadata_IsObjectExists('dspAuth', 'Init_Cleanup', 'P') = 1) EXEC ('EXEC dspAuth.Init_Cleanup');
END;














GO
