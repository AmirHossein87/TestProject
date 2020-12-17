IF OBJECT_ID('[dsp].[Init_FillData]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_FillData];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Init_FillData]
AS
BEGIN
    SET NOCOUNT ON;

    -- TODO: Initialize the app 
    EXEC dsp.Setting_SetProps @AppName = 'MyAppName', @AppVersion = '1.0.*';

    -- Fill SystemTable
    EXEC dsp.Init_FillSystemTableData;
END;

GO
