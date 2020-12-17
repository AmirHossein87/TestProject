IF OBJECT_ID('[dsp].[DaysOfTheWeek_FromString]') IS NOT NULL
	DROP FUNCTION [dsp].[DaysOfTheWeek_FromString];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsp].[DaysOfTheWeek_FromString] (@Days NVARCHAR(MAX /*NCQ*/))
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
	-- SQL Prompt Formatting Off
	DECLARE @ret INT = 0;
	IF ( @Days LIKE '%sun%' COLLATE Latin1_General_CI_AI) SET @ret = @ret  | 0x01;
	IF ( @Days LIKE '%mon%' COLLATE Latin1_General_CI_AI) SET @ret = @ret  | 0x02;
	IF ( @Days LIKE '%tue%' COLLATE Latin1_General_CI_AI) SET @ret = @ret  | 0x04;
	IF ( @Days LIKE '%wed%' COLLATE Latin1_General_CI_AI) SET @ret = @ret  | 0x08;
	IF ( @Days LIKE '%thu%' COLLATE Latin1_General_CI_AI) SET @ret = @ret  | 0x10;
	IF ( @Days LIKE '%fri%' COLLATE Latin1_General_CI_AI) SET @ret = @ret  | 0x20;
	IF ( @Days LIKE '%sat%' COLLATE Latin1_General_CI_AI) SET @ret = @ret  | 0x40;
	RETURN @ret
END
GO
