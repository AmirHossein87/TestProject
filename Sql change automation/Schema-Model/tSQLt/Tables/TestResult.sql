﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [tSQLt].[TestResult]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Class] [nvarchar] (max) NOT NULL,
[TestCase] [nvarchar] (max) NOT NULL,
[TranName] [nvarchar] (max) NOT NULL,
[Result] [nvarchar] (max) NULL,
[Msg] [nvarchar] (max) NULL,
[TestStartTime] [datetime] NOT NULL CONSTRAINT [DF:TestResult(TestStartTime)] DEFAULT (getdate()),
[TestEndTime] [datetime] NULL,
[Name] AS ((quotename([Class])+'.')+quotename([TestCase]))
)
GO
ALTER TABLE [tSQLt].[TestResult] ADD CONSTRAINT [PK__TestResu__3214EC077DDA1951] PRIMARY KEY CLUSTERED  ([Id])
GO