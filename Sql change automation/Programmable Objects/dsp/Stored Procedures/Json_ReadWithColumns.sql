IF OBJECT_ID('[dsp].[Json_ReadWithColumns]') IS NOT NULL
	DROP PROCEDURE [dsp].[Json_ReadWithColumns];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Json_ReadWithColumns]
    @Json NVARCHAR(MAX) /*NQC*/
AS
BEGIN
    DECLARE @Query NVARCHAR(MAX) /*NQC*/ = dsp.Json_GetSelectScript(@Json);
    EXEC (@Query);
END;
GO
