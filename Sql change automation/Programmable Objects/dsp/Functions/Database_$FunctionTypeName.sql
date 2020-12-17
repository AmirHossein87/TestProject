IF OBJECT_ID('[dsp].[Database_$FunctionTypeName]') IS NOT NULL
	DROP FUNCTION [dsp].[Database_$FunctionTypeName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Database_$FunctionTypeName] (@Type TSTRING)
RETURNS TABLE
AS
RETURN SELECT   (CASE
                     WHEN @Type = 'IF'
                         THEN 'InlineFunction'
                     WHEN @Type = 'TF'
                         THEN 'TableValueFunction'
                     WHEN @Type = 'FN'
                         THEN 'Function'
                 END) TypeName;
GO
