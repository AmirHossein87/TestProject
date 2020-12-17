IF OBJECT_ID('[dbo].[Init_FillExceptions]') IS NOT NULL
	DROP PROCEDURE [dbo].[Init_FillExceptions];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Init_FillExceptions]
AS
BEGIN
    SET NOCOUNT ON;

	-- delclare your application exceptions here. NOTE: ExceptionId must be started from 56000
	INSERT	dsp.Exception (ExceptionId, ExceptionName, Description)
	VALUES (56001, N'Error1', N'Error1 description'),
		(56002, N'Error2', N'Error2 description');

END
		
GO
