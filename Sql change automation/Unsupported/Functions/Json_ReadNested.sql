/*
	Unsupported Programmable Object
	-------------------------------
	This script was placed in the Unsupported folder during the initial import process as it
	contains a type of object that requires special handling. This has been done to prevent
	the script from failing during the script-generation and database deployment processes.

	In order to include the script within the Programmable Objects folder, some modifications
	will need to be made to ensure that it executes successfully. For more information,
	please refer to the documentation:
	https://www.red-gate.com/sca/dev/unsupported-programmable-objects
*/

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Json_ReadNested] (@RootPath NVARCHAR(MAX),
    @JsonToRead NVARCHAR(MAX))
RETURNS TABLE
WITH SCHEMABINDING
AS
-- SQL Prompt Formatting Off
RETURN (WITH Root_Json 
		AS (
			SELECT	OJ.[key] AS JKey
					,OJ.value AS JValue
					,OJ.type AS JType
					,JPath = @RootPath COLLATE DATABASE_DEFAULT
					,JAddress = @RootPath COLLATE DATABASE_DEFAULT
					,JIndex = IIF(ISNUMERIC(OJ.[key]) = 1, OJ.[key], NULL)
			FROM	OPENJSON( @JsonToRead, @RootPath) OJ
			UNION ALL
			SELECT	Sub_Json.[key] AS JKey
					,Sub_Json.value AS JValue
					,Sub_Json.type AS JType
					,JPath = (Root_Json.JPath + IIF(ISNUMERIC( Root_Json.JKey ) = 1, '', '.' + Root_Json.JKey))
					,JAddress = (Root_Json.JAddress + IIF(ISNUMERIC( Root_Json.JKey ) = 1, '[' + Root_Json.JKey + ']', '.' + Root_Json.JKey))
					,JIndex = IIF(ISNUMERIC( Root_Json.JKey ) = 1, Root_Json.JKey , NULL)
			FROM	Root_Json
			CROSS APPLY OPENJSON( JValue ) Sub_Json
			WHERE	Root_Json.JType IN (4, 5)
		)
	SELECT	Root_Json.JKey
			,Root_Json.JValue
			,Root_Json.JType
			,Root_Json.JPath
			,Root_Json.JAddress + IIF(ISNUMERIC(Root_Json.JKey) = 1, '[' + Root_Json.JKey + ']', '.' + Root_Json.JKey) AS JAddress
			,Root_Json.JIndex
	FROM	Root_Json
	WHERE Root_Json.JType <> 5);
GO
