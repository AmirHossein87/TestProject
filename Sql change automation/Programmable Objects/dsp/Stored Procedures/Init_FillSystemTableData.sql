IF OBJECT_ID('[dsp].[Init_FillSystemTableData]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_FillSystemTableData];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dsp].[Init_FillSystemTableData]
AS
BEGIN
    -- It should implemnetd by Merg
    --Target is dsp.SystemTable
    MERGE dsp.SystemTable AS target
    USING (
              -- Source is sys.Tables
              SELECT    T.object_id, T.name TableName, S.name SchemaName,
                  ClusterColumnsName = (
                                           -- Get each table clustered columns name in comma seprator format
                                           SELECT   STRING_AGG(c.name, ',')
                                             FROM   sys.indexes i
                                                    JOIN sys.index_columns AS ic ON ic.index_id = i.index_id AND ic.object_id = i.object_id
                                                    JOIN sys.columns AS c ON c.column_id = ic.column_id AND c.object_id = ic.object_id
                                            WHERE  i.object_id = T.object_id AND   ic.is_included_column = 0 AND   i.type_desc = 'CLUSTERED') --
                /*IsHistoryTable = IIF(T.temporal_type = 1, 1, 0)*/
                FROM    sys.tables T
                        INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
               WHERE S.name NOT LIKE 't%' AND   LOWER(T.name) NOT LIKE '%history') AS source (object_id, TableName, SchemaName, ClusterColumnsName)
       ON (target.SystemTableId = source.object_id)

     -- If not exists then insert
     WHEN NOT MATCHED
        THEN INSERT (SystemTableId, TableName, SchemaName, ClusterColumnsName)
             VALUES (source.object_id, source.TableName, source.SchemaName, source.ClusterColumnsName)

     -- If exists but has any change then update
     WHEN MATCHED AND EXISTS (   SELECT source.TableName, source.SchemaName, source.ClusterColumnsName /*, source.IsHistoryTable*/
                                 EXCEPT
                                 SELECT target.TableName, target.SchemaName, target.ClusterColumnsName /*, target.IsHistoryTable*/)
        THEN UPDATE SET --
                 target.SchemaName = source.SchemaName, --
                 target.TableName = source.TableName, --
                 target.ClusterColumnsName = source.ClusterColumnsName --
     /*target.IsHistoryTable = source.IsHistoryTable*/

     -- if not exists in the source then delete from target
     WHEN NOT MATCHED BY SOURCE
        THEN DELETE;
END;
GO
