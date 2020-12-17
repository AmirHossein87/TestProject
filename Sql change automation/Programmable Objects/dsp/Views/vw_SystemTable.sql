IF OBJECT_ID('[dsp].[vw_SystemTable]') IS NOT NULL
	DROP VIEW [dsp].[vw_SystemTable];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dsp].[vw_SystemTable]
AS
SELECT  T.name TableName, T.object_id, T.principal_id, T.schema_id, T.parent_object_id, T.type, T.type_desc, T.create_date, T.modify_date, T.is_ms_shipped,
    T.is_published, T.is_schema_published, T.lob_data_space_id, T.filestream_data_space_id, T.max_column_id_used, T.lock_on_bulk_load, T.uses_ansi_nulls,
    T.is_replicated, T.has_replication_filter, T.is_merge_published, T.is_sync_tran_subscribed, T.has_unchecked_assembly_data, T.text_in_row_limit,
    T.large_value_types_out_of_row, T.is_tracked_by_cdc, T.lock_escalation, T.lock_escalation_desc, T.is_filetable, T.is_memory_optimized, T.durability,
    T.durability_desc, T.temporal_type, T.temporal_type_desc, T.history_table_id, T.is_remote_data_archive_enabled, T.is_external, T.history_retention_period,
    T.history_retention_period_unit, T.history_retention_period_unit_desc, T.is_node, T.is_edge, S.name SchemaName, ST.TemporalTypeId, ST.LevelPriority
  FROM  dsp.SystemTable AS ST
        INNER JOIN sys.tables T ON T.object_id = OBJECT_ID(ST.SchemaName + '.' + ST.TableName)
        INNER JOIN sys.schemas S ON S.schema_id = T.schema_id;
GO
