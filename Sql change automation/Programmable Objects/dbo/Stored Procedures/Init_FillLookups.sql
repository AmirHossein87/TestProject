IF OBJECT_ID('[dbo].[Init_FillLookups]') IS NOT NULL
	DROP PROCEDURE [dbo].[Init_FillLookups];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Init_FillLookups]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TableName TSTRING;

	-- SQL Prompt formatting off
    -- Application
    SET @TableName = N'Application';
    SELECT  *
    INTO    #Application
      FROM  dbo.Application
     WHERE  1 = 0;
    INSERT INTO #Application (ApplicationId, ApplicationName)
    VALUES (const.Application_IcLoyalty(), N'Loyalty')
        

    EXEC dsp.Table_CompareData @DestinationTableName = @TableName;
END
		
GO
