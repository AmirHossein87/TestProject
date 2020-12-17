IF OBJECT_ID('[dsp].[Init]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Init]
    @IsProductionEnvironment BIT = NULL, @DoNotDisableTemporalForActiveTemporal BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TranCount INT = @@TRANCOUNT;
    IF (@TranCount = 0)
        BEGIN TRANSACTION;
    BEGIN TRY
        SET @DoNotDisableTemporalForActiveTemporal = ISNULL(@DoNotDisableTemporalForActiveTemporal, 1);
        EXEC dsp.[Init_$Start] @IsProductionEnvironment = @IsProductionEnvironment, @IsWithCleanup = NULL, @Reserved = NULL,
            @DoNotDisableTemporalForActiveTemporal = @DoNotDisableTemporalForActiveTemporal;

        IF (@TranCount = 0) COMMIT;
    END TRY
    BEGIN CATCH
        IF (@TranCount = 0)
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

GO
