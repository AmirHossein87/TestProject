IF OBJECT_ID('[dsp].[SplitStringByIndex]') IS NOT NULL
	DROP FUNCTION [dsp].[SplitStringByIndex];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[SplitStringByIndex] (@Exprission NVARCHAR(MAX /*NCQ*/),
    @Seprator NVARCHAR(MAX /*NCQ*/),
    @Index INT)
RETURNS NVARCHAR(MAX /*NCQ*/)
WITH SCHEMABINDING
AS
BEGIN
    RETURN (   SELECT   value
                 FROM   (   SELECT  ROW_NUMBER() OVER (ORDER BY @Seprator) AS RowNumber, value
                              FROM  STRING_SPLIT(@Exprission, @Seprator)
                             WHERE  value <> '') SplitedQ
                WHERE   SplitedQ.RowNumber = @Index);

END;
GO
