IF OBJECT_ID('[tSQLt].[Private_SaveTestNameForSession]') IS NOT NULL
	DROP PROCEDURE [tSQLt].[Private_SaveTestNameForSession];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tSQLt].[Private_SaveTestNameForSession] 
  @TestName NVARCHAR(MAX)
AS
BEGIN
  DELETE FROM tSQLt.Run_LastExecution
   WHERE SessionId = @@SPID;  

  INSERT INTO tSQLt.Run_LastExecution(TestName, SessionId, LoginTime)
  SELECT TestName = @TestName,
         session_id,
         login_time
    FROM sys.dm_exec_sessions
   WHERE session_id = @@SPID;
END
GO