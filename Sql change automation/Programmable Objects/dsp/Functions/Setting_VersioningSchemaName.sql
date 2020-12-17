IF OBJECT_ID('[dsp].[Setting_VersioningSchemaName]') IS NOT NULL
	DROP FUNCTION [dsp].[Setting_VersioningSchemaName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Setting_VersioningSchemaName] ()
RETURNS TSTRING
AS
BEGIN
    DECLARE @VersioningSchemaName TSTRING = 'api';

    RETURN @VersioningSchemaName;
END;
GO
