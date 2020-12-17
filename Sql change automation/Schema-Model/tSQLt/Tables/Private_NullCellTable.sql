﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [tSQLt].[Private_NullCellTable]
(
[I] [int] NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [tSQLt].[Private_NullCellTable_StopDeletes] ON [tSQLt].[Private_NullCellTable] INSTEAD OF DELETE, INSERT, UPDATE
AS
BEGIN
  RETURN;
END;
GO
