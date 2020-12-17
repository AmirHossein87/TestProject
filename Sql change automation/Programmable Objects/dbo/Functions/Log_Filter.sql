IF OBJECT_ID('[dbo].[Log_Filter]') IS NOT NULL
	DROP FUNCTION [dbo].[Log_Filter];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Log_Filter] (@ApplicationId INT,
    @CategoryId INT = NULL,
    @SubCategoryId BIGINT = NULL,
    @CustomData TJSON = NULL,
    @RecordCount INT,
    @RecordIndex INT)
RETURNS TABLE
AS
RETURN (   SELECT   L.LogId, L.CategoryId, L.SubCategoryId, L.CustomData, L.CreatedTime
             FROM   dbo.Logs AS L
            WHERE   L.ApplicationId = @ApplicationId --
               AND  (@CategoryId IS NULL OR L.CategoryId = @CategoryId) --
               AND  (@SubCategoryId IS NULL OR  L.SubCategoryId = @SubCategoryId)
            ORDER BY L.LogId DESC OFFSET @RecordIndex ROWS FETCH NEXT @RecordCount ROWS ONLY);
GO
