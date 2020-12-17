IF OBJECT_ID('[dspInboxMessage].[MessagePattern_Search]') IS NOT NULL
	DROP FUNCTION [dspInboxMessage].[MessagePattern_Search];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspInboxMessage].[MessagePattern_Search] (@RecordCount INT,
    @RecordIndex INT,
    @FilterResponseProcedureName TSTRING,
    @FilterPatternName TSTRING,
    @FilterStartTimeFrom DATETIME,
    @FilterStartTimeTo DATETIME,
    @FilterExpirationTimeFrom DATETIME,
    @FilterExpirationTimeTo DATETIME,
    @FilterMessagePatternStateId INT,
    @FilterPatternKey TSTRING)
RETURNS TABLE
AS
RETURN (
-- SQL Prompt formatting off
	SELECT   MP.MessagePatternId, MP.PatternName, MP.StartTime, MP.ExpirationTime, MessagePatternSeprator = MPSP.MessagePatternSeprator
		, MP.PatternKey, MessagePatternState = MPS.MessagePatternStateName, MP.Description
	FROM   dspInboxMessage.vw_MessagePattern MP
	INNER JOIN dspInboxMessage.MessagePatternState MPS ON MPS.MessagePatternStateId = MP.MessagePatternStateId
	INNER JOIN dspInboxMessage.MessagePatternSeprator MPSP ON MPSP.MessagePatternSepratorId = MP.MessagePatternSepratorId
    WHERE  (@FilterPatternName IS NULL OR MP.PatternName LIKE '%' + @FilterPatternName + '%')
		AND (@FilterStartTimeFrom IS NULL OR MP.StartTime >= @FilterStartTimeFrom)
		AND (@FilterStartTimeTo IS NULL OR MP.StartTime <= @FilterStartTimeTo)
		AND (@FilterExpirationTimeFrom IS NULL OR MP.ExpirationTime >= @FilterExpirationTimeFrom)
		AND (@FilterExpirationTimeTo IS NULL OR MP.ExpirationTime <= @FilterExpirationTimeTo)
		AND (@FilterMessagePatternStateId IS NULL OR MP.MessagePatternStateId = @FilterMessagePatternStateId)
		AND (@FilterPatternKey IS NULL OR MP.PatternKey LIKE '%' + @FilterPatternKey + '%')
		AND (@FilterResponseProcedureName IS NULL OR MP.ResponseProcedureName LIKE '%' + @FilterResponseProcedureName + '%')
    ORDER BY MP.MessagePatternId DESC OFFSET @RecordIndex ROWS FETCH NEXT @RecordCount ROWS ONLY);

-- SQL Prompt formatting on
GO
