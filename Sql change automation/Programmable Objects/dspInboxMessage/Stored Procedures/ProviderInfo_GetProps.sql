IF OBJECT_ID('[dspInboxMessage].[ProviderInfo_GetProps]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[ProviderInfo_GetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[ProviderInfo_GetProps]
    @ProviderInfoId INT, @ProviderId INT = NULL OUTPUT, @ContactInfo TSTRING = NULL OUTPUT, @IsEnable BIT = NULL OUTPUT, @Description TSTRING = NULL OUTPUT,
    @ProviderTypeId TINYINT = NULL OUTPUT
AS
BEGIN
    DECLARE @ActualId INT;

    -- Get props
    SELECT  @ActualId = PI.ProviderInfoId, @ProviderId = PI.ProviderId, @ContactInfo = PI.ContactInfo, @IsEnable = PI.IsEnable, @Description = PI.Description,
        @ProviderTypeId = P.ProviderTypeId
      FROM  dspInboxMessage.ProviderInfo PI
            INNER JOIN dspInboxMessage.Provider P ON P.ProviderId = PI.ProviderId
     WHERE  PI.ProviderInfoId = @ProviderInfoId;

    -- Validate data existance
    IF @ActualId IS NULL
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID, @Message = 'ProviderInfoId';

END;


GO
