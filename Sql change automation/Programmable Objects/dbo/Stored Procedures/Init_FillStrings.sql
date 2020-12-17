IF OBJECT_ID('[dbo].[Init_FillStrings]') IS NOT NULL
	DROP PROCEDURE [dbo].[Init_FillStrings];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Init_FillStrings]
AS
BEGIN
    SET NOCOUNT ON;

	-- Delclare your application strings here
	INSERT	dsp.StringTable (StringId, StringValue)
	VALUES 
		(N'String1', N'string 1'),
		(N'String2', N'string 2');

END
		
GO
