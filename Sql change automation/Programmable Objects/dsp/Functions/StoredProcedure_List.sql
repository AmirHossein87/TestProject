IF OBJECT_ID('[dsp].[StoredProcedure_List]') IS NOT NULL
	DROP FUNCTION [dsp].[StoredProcedure_List];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[StoredProcedure_List] (@SchemaName TSTRING)
RETURNS TABLE
RETURN SELECT --
            P.object_id StoredProcedureId, --
           JSON_VALUE(SPM.Metadata, '$.ApiKey') StoredProcedureKey, --
           CONVERT(DATETIME, JSON_VALUE(SPM.Metadata, '$.CreatedTime')) CreatedTime, --
           SCHEMA_NAME(P.schema_id) AS StoredProcedureSchemaName, --
           P.name AS StoredProcedureName, --
           OBJECT_DEFINITION(P.object_id) AS StoredProcedureDefinitionCode, --
           SPM.Metadata StoredProcedureMetadata --
         FROM   sys.procedures AS P
                OUTER APPLY dsp.StoredProcedure_Metadata(SCHEMA_NAME(P.schema_id), P.name) AS SPM
        WHERE   P.type <> 'PC' --
           AND  (@SchemaName IS NULL OR P.schema_id = SCHEMA_ID(@SchemaName));









GO
