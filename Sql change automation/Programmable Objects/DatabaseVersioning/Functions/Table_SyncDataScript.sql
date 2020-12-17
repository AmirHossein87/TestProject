IF OBJECT_ID('[DatabaseVersioning].[Table_SyncDataScript]') IS NOT NULL
	DROP FUNCTION [DatabaseVersioning].[Table_SyncDataScript];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [DatabaseVersioning].[Table_SyncDataScript] (@SchemaName NVARCHAR(MAX), /*NQC*/
    @TableName NVARCHAR(MAX), /*NQC*/
    @TemporalTypeIdValue INT,
    @SrcJson NVARCHAR(MAX)/*NQC*/

)
RETURNS NVARCHAR(MAX) /*NQC*/
AS
BEGIN
    DECLARE @Script NVARCHAR(MAX)/*NQC*/;
    DECLARE @OBJECT_ID INT = OBJECT_ID(@SchemaName + '.' + @TableName);
    DECLARE @DeleteScript TSTRING = '';
    IF @TemporalTypeIdValue = dspconst.TemporalType_Lookup()
        SET @DeleteScript = ' WHEN NOT MATCHED BY SOURCE THEN DELETE ';

    WITH MyClustered -- this tables have a primary key
        AS (SELECT  value COLUMN_NAME
              FROM  dsp.SplitString(
                        IIF(@TableName LIKE '%History',
                            N'VersioningStartTime,VersioningEndTime',
                        (   SELECT  s.ClusterColumnsName
                              FROM  dsp.SystemTable s
                             WHERE s.SchemaName = @SchemaName AND s.TableName = @TableName)), ',') ), --
    MyColumns
        AS (SELECT  name AS COLUMN_NAME
              FROM  sys.columns
             WHERE  object_id = @OBJECT_ID AND  is_computed = 0)
    SELECT  @Script =
        IIF(EXISTS (SELECT  1 FROM  sys.identity_columns IC WHERE   IC.object_id = @OBJECT_ID),
        'SET IDENTITY_INSERT ' + @SchemaName + '.' + @TableName + ' ON;',
        '') + N'MERGE INTO ' + @SchemaName + N'.' + @TableName + N' AS TGT USING (' + dsp.Json_GetSelectScript(@SrcJson) + N') AS Merge_Source ON '
        +   (SELECT STUFF((   SELECT    CAST( --
                                  IIF((SELECT   COUNT(*) FROM   MyClustered) = 1, ' ', ' and ') AS VARCHAR(MAX)) --
                                        + 'Merge_Source.' + clm.COLUMN_NAME + '= TGT.' + clm.COLUMN_NAME
                                FROM    MyColumns clm
                               WHERE EXISTS (SELECT 1 FROM  MyClustered WHERE   MyClustered.COLUMN_NAME = clm.COLUMN_NAME)
                              FOR XML PATH('')), 1, IIF((SELECT COUNT(*) FROM   MyClustered) = 1, 1, 4), ''))
        + N' WHEN MATCHED AND EXISTS( SELECT Merge_Source.* EXCEPT SELECT TGT.* )     
THEN   UPDATE     SET ' + -- in this case check updated data and choosing columns of table without primary key
            (SELECT STUFF((   SELECT    CAST(',' AS VARCHAR(MAX)) + 'TGT.' + clm.COLUMN_NAME + '= Merge_Source.' + clm.COLUMN_NAME
                                FROM    MyColumns clm
                               WHERE NOT EXISTS (SELECT 1 FROM  MyClustered WHERE   MyClustered.COLUMN_NAME = clm.COLUMN_NAME)
                              FOR XML PATH('')), 1, 1, '')) + N' WHEN
NOT MATCHED THEN  INSERT (' + --in this case for insert.
            (SELECT STUFF((   SELECT    CAST(',' AS VARCHAR(MAX)) + clm.COLUMN_NAME
                                FROM    MyColumns clm
                              FOR XML PATH('')), 1, 1, '')) + N') VALUES ('
        +   (SELECT     STUFF((   SELECT    CAST(',' AS VARCHAR(MAX)) + 'Merge_Source.' + clm.COLUMN_NAME
                                    FROM    MyColumns clm
                                  FOR XML PATH('')), 1, 1, '')) + N')
'                     + @DeleteScript + N'
;'
        + IIF(EXISTS (SELECT    1 FROM  sys.identity_columns IC WHERE   IC.object_id = @OBJECT_ID),
          'SET IDENTITY_INSERT ' + @SchemaName + '.' + @TableName + ' OFF;',
          '');

    RETURN @Script;

END;

GO
