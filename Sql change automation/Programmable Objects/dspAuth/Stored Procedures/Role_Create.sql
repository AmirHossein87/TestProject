IF OBJECT_ID('[dspAuth].[Role_Create]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[Role_Create];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[Role_Create]
    @AuditUserId BIGINT, @OwnerSecurityDescriptorId BIGINT, @RoleName TSTRING, @IsSystem BIT = 0, @RoleTypeId INT, @RoleId INT = NULL OUT
AS
BEGIN
    SET @RoleId = NULL;
    SET @IsSystem = ISNULL(@IsSystem, 0);     
	
    DECLARE @TranCount INT = @@TRANCOUNT;
    IF (@TranCount = 0)
        BEGIN TRANSACTION;
    BEGIN TRY
        -- Insert
        INSERT  dspAuth.Role (RoleName, OwnerSecurityDescriptorId, RoleTypeId, ModifiedByUserId, IsSystem)
        VALUES (@RoleName, @OwnerSecurityDescriptorId, @RoleTypeId, @AuditUserId, @IsSystem);
        SET @RoleId = SCOPE_IDENTITY();

        -- Validate inserted record
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'RoleId', @ArgumentValue = @RoleId;

        -- Create SecurityDescriptor for Role
        DECLARE @SecurityDescriptorId BIGINT;
        DECLARE @ObjectType_Role INT = dspAuth.ObjectType_Role();
        EXEC dspAuth.SecurityDescriptor_Create @ObjectId = @RoleId, @ObjectTypeId = @ObjectType_Role;

        IF (@TranCount = 0) COMMIT;
    END TRY
    BEGIN CATCH
        IF (@TranCount = 0)
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;




















GO
