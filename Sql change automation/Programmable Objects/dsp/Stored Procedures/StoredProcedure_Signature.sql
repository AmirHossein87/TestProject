IF OBJECT_ID('[dsp].[StoredProcedure_Signature]') IS NOT NULL
	DROP PROCEDURE [dsp].[StoredProcedure_Signature];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[StoredProcedure_Signature]
    @SchemaName TSTRING, @StoredProcedureName AS TSTRING, @Json TJSON = NULL OUTPUT
AS
BEGIN

    DECLARE @ObjectId INT;

    SELECT  @ObjectId = P.object_id
      FROM  sys.procedures AS P
     WHERE  P.name = @StoredProcedureName --
        AND P.schema_id = SCHEMA_ID(@SchemaName);

    DECLARE @Params TABLE (ParamName TSTRING,
        IsOutput BIT,
        TypeName TSTRING,
        Length INT,
        object_id INT);

    INSERT INTO @Params (ParamName, IsOutput, TypeName, Length, object_id)
    SELECT  Params.name AS ParamName, Params.is_output, TYPE_NAME(Type.system_type_id) AS TypeName, Params.max_length AS Length, Params.object_id
      FROM  sys.parameters AS Params
            INNER JOIN sys.types AS Type ON Type.user_type_id = Params.user_type_id
     WHERE  Params.object_id = @ObjectId;

    -- Check if params table is empty
    IF NOT EXISTS (SELECT   TOP 1 1 FROM    @Params AS P)
    BEGIN
        SET @Json = (   SELECT  @StoredProcedureName AS StoredProcedureName
                        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        RETURN;
    END;

    SET @Json = (   SELECT  SP.name StoredProcedureName, Params.ParamName, Params.TypeName, Params.Length, Params.IsOutput
                      FROM  @Params AS Params
                            INNER JOIN sys.procedures AS SP ON SP.object_id = Params.object_id
                    FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER, INCLUDE_NULL_VALUES);

END;






GO
