IF OBJECT_ID('[dsp].[Json_Compare]') IS NOT NULL
	DROP PROCEDURE [dsp].[Json_Compare];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Json_Compare]
    @Json1 TJSON, @Json2 TJSON, @TwoSided BIT = NULL, @IncludeValue BIT = NULL, @IsThrow BIT = NULL, @CaseSencitive BIT = NULL,
    @ExceptionMessage TSTRING = NULL, @AreSame BIT = NULL OUTPUT
AS
BEGIN
    -- Call funtion
    SET @TwoSided = ISNULL(@TwoSided, 0);
    SET @IncludeValue = ISNULL(@IncludeValue, 0);
    SET @IsThrow = ISNULL(@IsThrow, 1);
    SET @CaseSencitive = ISNULL(@CaseSencitive, 0);

    SET @AreSame = 1;

    IF (@CaseSencitive = 0) --
    BEGIN
        SET @Json1 = LOWER(@Json1);
        SET @Json2 = LOWER(@Json2);
    END;

    IF (ISNULL(ISJSON(@Json1), 0) <> 1) -- 
        SET @AreSame = 0;

    IF (ISNULL(ISJSON(@Json2), 0) <> 1) -- 
        SET @AreSame = 0;

	-- SQL Prompt Formatting Off
	-- Compare Json2 with Json1
	IF @AreSame = 1
	AND EXISTS (SELECT		TOP 1
							1
				FROM		dsp.Json_ReadNested( '$', @Json2 ) AS JR2
				LEFT JOIN	dsp.Json_ReadNested( '$', @Json1 ) AS JR1 ON JR1.JKey = JR2.JKey
																		AND JR1.JPath = JR2.JPath
																		AND (	@IncludeValue = 0
																				OR (@IncludeValue = 1 AND ISNULL(JR1.JValue, '-1') = ISNULL(JR2.JValue ,'-1'))
																			)
				WHERE		JR1.JKey IS NULL
							AND (@IncludeValue = 1 OR (@IncludeValue = 0 AND ISNUMERIC ( JR2.JKey ) <> 1 AND ISNUMERIC ( JR1.JKey ) <> 1))
			)
		SET @AreSame = 0;

	-- Compare Json1 with Json2
	IF @TwoSided = 1
	AND @AreSame = 1
	AND EXISTS (SELECT		TOP 1
							1
				FROM		dsp.Json_ReadNested( '$', @Json1 ) AS JR1
				LEFT JOIN	dsp.Json_ReadNested( '$', @Json2 ) AS JR2 ON JR2.JKey = JR1.JKey
																		AND JR2.JPath = JR1.JPath
																		AND (	@IncludeValue = 0
																				OR (@IncludeValue = 1 AND ISNULL(JR2.JValue, '-1') = ISNULL(JR1.JValue ,'-1'))
																			)
				WHERE		JR2.JKey IS NULL
							AND (@IncludeValue = 1 OR (@IncludeValue = 0 AND ISNUMERIC ( JR1.JKey ) <> 1 AND ISNUMERIC ( JR2.JKey ) <> 1))
			)
		SET @AreSame = 0;

	-- SQL Prompt formatting on

    IF (@AreSame = 0 AND @IsThrow = 1) --
        EXEC dsperr.ThrowArgumentsAreNotSame @ProcId = @@PROCID, @Message = @ExceptionMessage;
END;


GO
