IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$ProcessNotRegisteredAddress]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessNotRegisteredAddress];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessNotRegisteredAddress]
    @MaxInboxMessageId BIGINT
AS
BEGIN
    DECLARE @AddressRegistrationIsActive BIT;
    EXEC dspInboxMessage.Setting_GetProps @AddressRegistrationIsActive = @AddressRegistrationIsActive OUTPUT;

    -- Check address registration activation
    IF (@AddressRegistrationIsActive = 1)
    BEGIN
        -- Get distinct of addresses
        DECLARE @MessageAddress TJSON = (   SELECT  IM.Address, P.ProviderTypeId
                                              FROM  dspInboxMessage.InboxMessage IM
                                                    INNER JOIN dspInboxMessage.ProviderInfo PI ON PI.ProviderInfoId = IM.ProviderInfoId
                                                    INNER JOIN dspInboxMessage.Provider P ON P.ProviderId = PI.ProviderId
                                             WHERE  IM.InboxMessageProcessStateId = /*dspconst.InboxMessageProcessState_NotProcessed()*/ 1 --
                                                AND IM.InboxMessageId <= @MaxInboxMessageId
                    
					                        FOR JSON AUTO);

        -- Call client api to get registered address
        EXEC InboxMessage.InboxMessageProcess_ProcessAddressRegistration @MessageAddress = @MessageAddress, @ResultAddress = @MessageAddress OUTPUT;

        -- Update state that not contain in registered address
        ;WITH RegisteredAddress
            AS (SELECT  Address, ProviderTypeId
                  FROM
                    OPENJSON(@MessageAddress)
                    WITH (Address TSTRING, ProviderTypeId INT, UserId INT)
                 WHERE  UserId IS NOT NULL)
        UPDATE  IM
           SET  InboxMessageProcessStateId = /*dspconst.InboxMessageProcessState_AddressNotRegistered() */ 6, --
            IM.ProcessStartTime = GETDATE(), --
            IM.ProcessEndTime = GETDATE()
          FROM  dspInboxMessage.InboxMessage IM
                INNER JOIN dspInboxMessage.ProviderInfo PI ON PI.ProviderInfoId = IM.ProviderInfoId
                INNER JOIN dspInboxMessage.Provider P ON P.ProviderId = PI.ProviderId
                LEFT JOIN RegisteredAddress RA ON RA.Address = IM.Address AND   RA.ProviderTypeId = P.ProviderTypeId
         WHERE  IM.InboxMessageProcessStateId = /*dspconst.InboxMessageProcessState_NotProcessed()*/ 1 --
            AND RA.Address IS NULL --
            AND IM.InboxMessageId <= @MaxInboxMessageId;


    -- TODO: Need perfomance tunning
    --UPDATE  IM
    --   SET  InboxMessageProcessStateId = dspconst.InboxMessageProcessState_AddressNotRegistered()
    --  FROM  InboxMessage.InboxMessage IM
    -- WHERE  IM.InboxMessageProcessStateId = /*dspconst.InboxMessageProcessState_NotProcessed()*/ 1 --
    --    AND NOT EXISTS (   SELECT   1
    --                         FROM   InboxMessage.RegisteredAddress RA
    --                        WHERE   RA.Address = IM.Address) --
    --    AND IM.InboxMessageId <= @MaxInboxMessageId;
    END;
END;
GO
