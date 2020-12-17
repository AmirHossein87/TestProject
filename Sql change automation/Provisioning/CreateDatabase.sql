PRINT N'CUSTOM: Creating database [$(DatabaseName)]...';
GO
IF SERVERPROPERTY('EngineEdition') = 5
  EXEC sp_executesql N'CREATE DATABASE [$(DatabaseName)] (EDITION = ''Basic'');';
ELSE
begin
  CREATE DATABASE [$(DatabaseName)]  COLLATE Persian_100_CS_AI
  end
GO
