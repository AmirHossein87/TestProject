IF OBJECT_ID('[dsp].[Util_ProtectProductionEnvironment]') IS NOT NULL
	DROP PROCEDURE [dsp].[Util_ProtectProductionEnvironment];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dsp].[Util_ProtectProductionEnvironment]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IsProductionEnvironment BIT;
    EXEC dsp.Setting_GetProps @IsProductionEnvironment = @IsProductionEnvironment OUTPUT;

    -- Validate IsProductionEnvironment
    IF (@IsProductionEnvironment = 1) --
        EXEC dsperr.ThrowProductionEnvinronmentIsTurnedOn @ProcId = @@PROCID, @Message = 'This operation can not be executed in ProductionEnvironment';
END;
GO
