IF OBJECT_ID('[dsptest].[AssertEqualsJsonWithValue]') IS NOT NULL
	DROP PROCEDURE [dsptest].[AssertEqualsJsonWithValue];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsptest].[AssertEqualsJsonWithValue]
    @Expected TJSON, @Actual TJSON, @Message NVARCHAR(MAX) = ''
AS
BEGIN

    DECLARE @AreSame BIT;
    EXEC dsp.Json_Compare @Json1 = @Expected, @Json2 = @Actual, @IncludeValue = 1, @IsThrow = 0, @AreSame = @AreSame OUTPUT;

    IF (@AreSame = 1)
        RETURN 0;

    DECLARE @GeneratedMessage NVARCHAR(MAX);
    SELECT  @GeneratedMessage =
        N'Expected: <' + ISNULL(CAST(@Expected AS NVARCHAR(MAX)), 'NULL') + N'> but was: <' + ISNULL(CAST(@Actual AS NVARCHAR(MAX)), 'NULL') + N'>';
    IF ((COALESCE(@Message, '') <> '') AND  (@Message NOT LIKE '% '))
        SET @Message = @Message + ' ';
    EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @Message, @Param0 = @GeneratedMessage;
END;

GO
