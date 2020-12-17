IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$GetMessagePatternIdByCoding]') IS NOT NULL
	DROP FUNCTION [dspInboxMessage].[InboxMessageProcess_$GetMessagePatternIdByCoding];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspInboxMessage].[InboxMessageProcess_$GetMessagePatternIdByCoding] (@MessageBody TSTRING,
    @MessageTime DATETIME)
RETURNS INT
AS
BEGIN
    -- TODO: Need Index
    RETURN (   SELECT TOP (1)   MP.MessagePatternId
                 FROM   dspInboxMessage.vw_MessagePattern MP
                        INNER JOIN dspInboxMessage.MessagePatternSeprator MPS ON MPS.MessagePatternSepratorId = MP.MessagePatternSepratorId
                WHERE   MP.MessagePatternStateId = /*dspconst.MessagePatternStateId_Started()*/ 2 --
                   AND  ISNULL(@MessageTime, GETDATE()) BETWEEN MP.StartTime AND MP.ExpirationTime --
                   AND  MP.PatternKey = SUBSTRING(
                                            @MessageBody, 1, ISNULL(NULLIF(CHARINDEX(MPS.MessagePatternSeprator, @MessageBody, 2) - 1, -1), LEN(@MessageBody))));
END;
GO
