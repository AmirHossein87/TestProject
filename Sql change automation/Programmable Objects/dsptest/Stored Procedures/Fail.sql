IF OBJECT_ID('[dsptest].[Fail]') IS NOT NULL
	DROP PROCEDURE [dsptest].[Fail];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsptest].[Fail]
    @ProcId INT, @Message0 TSTRING = NULL, @Param0 TSTRING = '<notset>', @Param1 TSTRING = '<notset>', @Param2 TSTRING = '<notset>',
    @Param3 TSTRING = '<notset>'
AS
BEGIN
    EXEC dsptest.[ThrowFail] @ProcId = @ProcId, @Message = @Message0, @Param0 = @Param0, @Param1 = @Param1, @Param2 = @Param2, @Param3 = @Param3;
END;
GO
