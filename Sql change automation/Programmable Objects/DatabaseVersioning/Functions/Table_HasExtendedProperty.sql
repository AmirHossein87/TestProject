IF OBJECT_ID('[DatabaseVersioning].[Table_HasExtendedProperty]') IS NOT NULL
	DROP FUNCTION [DatabaseVersioning].[Table_HasExtendedProperty];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [DatabaseVersioning].[Table_HasExtendedProperty] (@ObjectId INT,
    @ExtendedPropertyName TSTRING,
    @ExtendedPropertyValue NVARCHAR(MAX)/*NQC*/)
RETURNS TABLE
AS
RETURN SELECT TOP 1 1 AS HasExtendedProperty
         FROM   sys.extended_properties AS EP
        WHERE   EP.major_id = @ObjectId --
           AND  EP.name = @ExtendedPropertyName AND CAST(EP.value AS NVARCHAR(MAX)/*NQC*/) = @ExtendedPropertyValue;
GO
