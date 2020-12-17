IF OBJECT_ID('[dsp].[Table_ExtendedProperty]') IS NOT NULL
	DROP FUNCTION [dsp].[Table_ExtendedProperty];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dsp].[Table_ExtendedProperty] (@TableId INT)
RETURNS TJSON
AS
BEGIN
    DECLARE @ExtendedProperties TJSON = (   SELECT  EP.name AS ExtendedPropertyKey, EP.value AS ExtendedPropertyValue
                                              FROM  sys.extended_properties EP
                                             WHERE  EP.major_id = @TableId --
                                                AND EP.class = 1 --
                                                AND EP.minor_id = 0
                                            FOR JSON AUTO);

    RETURN @ExtendedProperties;
END;
GO
