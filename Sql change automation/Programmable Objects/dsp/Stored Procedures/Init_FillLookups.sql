IF OBJECT_ID('[dsp].[Init_FillLookups]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_FillLookups];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dsp].[Init_FillLookups]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TableName TSTRING;

    -- Init lookup tables in this format

    -- This is sample
    -- please don't remove this code

    -- InboxMessage
    EXEC dspInboxMessage.Init_FillLookups;

    -- DatabaseVersioning
    EXEC DatabaseVersioning.Init_FillLookups;

	-- SQL Prompt formatting on
END;
GO
