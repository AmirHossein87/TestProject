IF OBJECT_ID('[dsp].[Init_$RecreateStringFunctions]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_$RecreateStringFunctions];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Create Procedure RecreateStringFunctions
CREATE PROCEDURE [dsp].[Init_$RecreateStringFunctions]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @FunctionBody TSTRING =
						'
				CREATE FUNCTION @SchemaName.@KeyColumnValue() 
				RETURNS TSTRING
				AS 
				BEGIN
					RETURN dsp.StringTable_Value(''@KeyColumnValue'');
				END
						';

    EXEC dsp.Init_RecreateEnumFunctions @SchemaName = 'dspstr', @TableSchemaName = 'dsp', @TableName = 'StringTable', @KeyColumnName = 'StringId',
        @TextColumnName = 'StringValue', @FunctionBody = @FunctionBody;
END;
GO
