IF OBJECT_ID('[dsp].[StoredProcedure_FilterByApiKey]') IS NOT NULL
	DROP FUNCTION [dsp].[StoredProcedure_FilterByApiKey];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[StoredProcedure_FilterByApiKey] (@SchemaName TSTRING,
    @ApiKey TSTRING)
RETURNS TABLE
AS
RETURN SELECT   DSP.StoredProcedureId, DSP.StoredProcedureName
         FROM   dsp.StoredProcedure_List(@SchemaName) AS DSP
        WHERE   DSP.StoredProcedureKey = @ApiKey;

GO
