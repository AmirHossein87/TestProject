IF OBJECT_ID('[dsptest].[AssertEqualsString]') IS NOT NULL
	DROP PROCEDURE [dsptest].[AssertEqualsString];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dsptest].[AssertEqualsString]
    @Expected NVARCHAR(MAX), @Actual NVARCHAR(MAX), @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF ((@Expected = @Actual) OR (@Actual IS NULL AND   @Expected IS NULL))
        RETURN 0;

    DECLARE @Msg NVARCHAR(MAX);
	SELECT  @Msg =
        CHAR(13) + CHAR(10) + N'Expected: ' + ISNULL('<' + @Expected + '>', 'NULL') + CHAR(13) + CHAR(10) + N'but was : ' + ISNULL('<' + @Actual + '>', 'NULL');
		
	EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @Msg;
END;

GO
