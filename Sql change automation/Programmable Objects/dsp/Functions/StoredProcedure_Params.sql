IF OBJECT_ID('[dsp].[StoredProcedure_Params]') IS NOT NULL
	DROP FUNCTION [dsp].[StoredProcedure_Params];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[StoredProcedure_Params] (@StoredProcedureId INT)
RETURNS TABLE
AS
RETURN (   SELECT --
                P.name ParamName, --
               P.is_output IsOutput, --
               TYPE_NAME(T.system_type_id) AS SystemTypeName, --
               TYPE_NAME(T.user_type_id) AS UserTypeName, --
               P.max_length AS Length
             FROM   sys.parameters AS P
                    INNER JOIN sys.types AS T ON T.user_type_id = P.user_type_id
            WHERE   P.object_id = @StoredProcedureId);
GO
