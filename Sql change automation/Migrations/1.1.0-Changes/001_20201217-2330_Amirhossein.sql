-- <Migration ID="6b70d1a8-1699-4a73-8567-af77fd88592c" />
GO

PRINT N'Altering [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD
[FacebookId] [nvarchar] (50) NULL
GO
