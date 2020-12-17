IF OBJECT_ID('[dsptest].[AssertEquals]') IS NOT NULL
	DROP PROCEDURE [dsptest].[AssertEquals];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsptest].[AssertEquals]
    @Expected SQL_VARIANT, @Actual SQL_VARIANT, @Message NVARCHAR(MAX /*NCQ*/) = ''
AS
BEGIN
    IF ((@Expected = @Actual) OR (@Actual IS NULL AND   @Expected IS NULL))
        RETURN 0;

    DECLARE @GeneratedMessage NVARCHAR(MAX /*NCQ*/);
    SET @GeneratedMessage =
        N'Expected: <' + ISNULL(CAST(@Expected AS NVARCHAR(MAX /*NCQ*/)), 'NULL') + N'> but was: <' + ISNULL(CAST(@Actual AS NVARCHAR(MAX /*NCQ*/)), 'NULL')
        + N'>';

    IF ((COALESCE(@Message, '') <> '') AND  (@Message NOT LIKE '% '))
        SET @Message = @Message + ' ';

    EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @Message, @Param0 = @GeneratedMessage;
END;
GO
