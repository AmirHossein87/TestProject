IF OBJECT_ID('[tCodeQuality].[test DataAccessMode annotation existance in proc]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test DataAccessMode annotation existance in proc];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tCodeQuality].[test DataAccessMode annotation existance in proc]
AS
BEGIN
    DECLARE @SchemaName TSTRING = 'api';
    DECLARE @msg TBIGSTRING = --
            (   SELECT  CHAR(10) + @SchemaName + '.' + SPM.StoredProcedureName
                  FROM  dsp.StoredProcedure_List(@SchemaName) AS SPM
                 WHERE  JSON_VALUE(SPM.StoredProcedureMetadata, '$.DataAccessMode') IS NULL
                FOR XML PATH(''));

    DECLARE @msg2 TBIGSTRING = --
            (   SELECT  CHAR(10) + @SchemaName + '.' + SPM.StoredProcedureName
                  FROM  dsp.StoredProcedure_List(@SchemaName) AS SPM
                 WHERE  JSON_VALUE(SPM.StoredProcedureMetadata, '$.DataAccessMode') IS NOT NULL --
                    AND JSON_VALUE(SPM.StoredProcedureMetadata, '$.DataAccessMode') NOT IN ( 'Read', 'Write', 'ReadSnapshot' )
                FOR XML PATH(''));

    IF (@msg IS NOT NULL) --		
        EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @msg;

    IF (@msg2 IS NOT NULL) --
        EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = N'Procedures with wrong value of DataAccessMode {0}', @Param0 = @msg2;
END;
GO
