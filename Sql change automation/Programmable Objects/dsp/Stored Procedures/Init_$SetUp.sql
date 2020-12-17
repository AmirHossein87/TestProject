IF OBJECT_ID('[dsp].[Init_$SetUp]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_$SetUp];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Init_$SetUp]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Sql TSTRING;
    DECLARE @Schema TSTRING;
    DECLARE @ObjectName TSTRING;

    -------------------------
    -- Schemas
    -------------------------

    -- try to create err schema
    IF SCHEMA_ID('dsperr') IS NULL
    BEGIN
        PRINT 'Creating schema: dsperr ';
        EXEC sys.sp_executesql N'CREATE SCHEMA [dsperr]';
    END;

    -- try to create str schema
    IF SCHEMA_ID('dspstr') IS NULL
    BEGIN
        PRINT 'Creating schema: dspstr';
        EXEC sys.sp_executesql N'CREATE SCHEMA [dspstr]';
    END;

    -- try to create const schema
    IF SCHEMA_ID('dspconst') IS NULL
    BEGIN
        PRINT 'Creating schema: dspconst';
        EXEC sys.sp_executesql N'CREATE SCHEMA [dspconst]';

    END;
END;








GO
