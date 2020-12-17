IF OBJECT_ID('[dsp].[GetTemporalTablesList]') IS NOT NULL
	DROP FUNCTION [dsp].[GetTemporalTablesList];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dsp].[GetTemporalTablesList]()
RETURNS TABLE
RETURN SELECT --
            SCHEMA_NAME(t.schema_id) AS temporal_table_schema, --
           t.name AS temporal_table_name, --
           SCHEMA_NAME(h.schema_id) AS history_table_schema, --
           h.name AS history_table_name, --
           (CASE
                WHEN t.history_retention_period = -1
                    THEN 'INFINITE' ELSE CAST(t.history_retention_period AS VARCHAR) + ' ' + t.history_retention_period_unit_desc + 'S'
            END) AS retention_period
         FROM   sys.tables t
                LEFT OUTER JOIN sys.tables h ON t.history_table_id = h.object_id
        WHERE   t.temporal_type = 2;
GO
