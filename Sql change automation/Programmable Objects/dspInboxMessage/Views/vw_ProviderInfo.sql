IF OBJECT_ID('[dspInboxMessage].[vw_ProviderInfo]') IS NOT NULL
	DROP VIEW [dspInboxMessage].[vw_ProviderInfo];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  VIEW [dspInboxMessage].[vw_ProviderInfo]
WITH SCHEMABINDING
AS
SELECT  PI.ProviderInfoId, PI.ProviderId, PI.ContactInfo, PI.IsEnable, PI.Description, P.ProviderName, P.ProviderTypeId, P.IsEnable AS ProviderIsEnable
  FROM  dspInboxMessage.ProviderInfo PI
        INNER JOIN dspInboxMessage.Provider P ON P.ProviderId = PI.ProviderId;
GO
