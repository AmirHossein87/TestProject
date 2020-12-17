IF OBJECT_ID('[dsp].[SplitString]') IS NOT NULL
	DROP FUNCTION [dsp].[SplitString];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dsp].[SplitString] (@Exprission TSTRING,
    @Seprator NCHAR(1))
RETURNS TABLE
AS
RETURN (   SELECT   [value]
             FROM   STRING_SPLIT(@Exprission, @Seprator)
            WHERE  [value] <> ''
			);

GO
