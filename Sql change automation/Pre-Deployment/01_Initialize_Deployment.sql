alter database current set trustworthy on
go
EXEC sp_configure 'clr enabled', 1;  
RECONFIGURE;  
GO  