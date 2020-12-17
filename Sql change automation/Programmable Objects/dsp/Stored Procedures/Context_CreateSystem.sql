IF OBJECT_ID('[dsp].[Context_CreateSystem]') IS NOT NULL
	DROP PROCEDURE [dsp].[Context_CreateSystem];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Context_CreateSystem]
    @SystemContext TCONTEXT OUT
AS
BEGIN
    EXEC dsp.Context_Create @UserId = '$', @Context = @SystemContext OUT, @IsCaptcha = 1;
END;
GO
