IF OBJECT_ID('[dsptest].[AssertNotEquals]') IS NOT NULL
	DROP PROCEDURE [dsptest].[AssertNotEquals];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dsptest].[AssertNotEquals]
    @Expected SQL_VARIANT, @Actual SQL_VARIANT, @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF (@Expected = @Actual) OR (@Expected IS NULL AND  @Actual IS NULL)
    BEGIN
        DECLARE @Msg NVARCHAR(MAX);
        SET @Msg = N'Expected actual value to not ' + COALESCE('equal <' + tSQLt.Private_SqlVariantFormatter(@Expected) + '>', 'be NULL') + N'.';
        EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @Message, @Param0 = @Msg;
    END;
    RETURN 0;
END;
GO
