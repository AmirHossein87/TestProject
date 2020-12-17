IF OBJECT_ID('[dspconst].[RequestRuleObjectPattern]') IS NOT NULL
	DROP FUNCTION [dspconst].[RequestRuleObjectPattern];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   FUNCTION [dspconst].[RequestRuleObjectPattern] ()
RETURNS TJSON
AS
BEGIN
    RETURN '{
			"IntervalTypeId": 1,
			"IntervalValue": "",
			"StartTime": "",
			"ExpireTime": "",
			"ExecutionTime": ""
			}';
END;
GO
