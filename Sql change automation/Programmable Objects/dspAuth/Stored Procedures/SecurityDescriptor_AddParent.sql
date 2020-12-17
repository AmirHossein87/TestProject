IF OBJECT_ID('[dspAuth].[SecurityDescriptor_AddParent]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[SecurityDescriptor_AddParent];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[SecurityDescriptor_AddParent]
    @SecurityDescriptorId BIGINT, @ParentSecurityDescriptorId BIGINT
AS
BEGIN
    -- Checking if the SecurityDescriptorId is parent of ParentSecurityDescriptorId or not
    DECLARE @IsParentOf BIT;
    EXEC dspAuth.SecurityDescriptor_IsParentOf @SecurityDescriptorId = @SecurityDescriptorId, @ChildSecurityDescriptorId = @ParentSecurityDescriptorId,
        @IsParentOf = @IsParentOf OUT;

    IF (@IsParentOf = 1)
        EXEC dsp.ThrowInvalidOperation @ProcId = @@PROCID,
            @Message = N'Invalid operation: SecurityDescriptorAddParent;A SecurityDescriptor: {0} has been already added as the child of security Object {1}',
            @Param0 = @ParentSecurityDescriptorId, @Param1 = @SecurityDescriptorId;

    -- Add SecurityDescriptor to SecurityDescriptorInherit
    BEGIN TRY
        INSERT  dspAuth.SecurityDescriptorParent (SecurityDescriptorId, ParentSecurityDescriptorId)
        VALUES (@SecurityDescriptorId, @ParentSecurityDescriptorId);
    END TRY
    BEGIN CATCH
        IF (ERROR_NUMBER() = 2627 AND   ERROR_MESSAGE() LIKE '%SecurityDescriptor%') -- duplicate unique index error
            EXEC err.ThrowObjectAlreadyExists @ProcId = @@PROCID, @Message = N'SecurityDescriptor: {0}, ParentSecurityId: {1}',
                @Param0 = @SecurityDescriptorId, @Param1 = @ParentSecurityDescriptorId;
        THROW;
    END CATCH;
END;




GO
