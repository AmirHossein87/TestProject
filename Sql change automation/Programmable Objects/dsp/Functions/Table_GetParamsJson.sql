IF OBJECT_ID('[dsp].[Table_GetParamsJson]') IS NOT NULL
	DROP FUNCTION [dsp].[Table_GetParamsJson];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dsp].[Table_GetParamsJson] (@TableId INT)
RETURNS TJSON
AS
BEGIN
    DECLARE @Params TJSON = (   SELECT  TP.ColumnId, TP.ColumnName, TP.IsIdentity, TP.DataType, TP.IsNullable, TP.MaxLength, TP.CollationName, TP.IsUserDefined
                                  FROM  dsp.Table_Params(@TableId) AS TP
                                FOR JSON AUTO);
    RETURN @Params;
END;
GO
