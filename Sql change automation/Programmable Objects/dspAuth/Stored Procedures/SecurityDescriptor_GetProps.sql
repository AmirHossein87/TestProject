IF OBJECT_ID('[dspAuth].[SecurityDescriptor_GetProps]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[SecurityDescriptor_GetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[SecurityDescriptor_GetProps]
    @SecurityDescriptorId BIGINT, @ObjectId BIGINT = NULL OUT, @ObjectTypeId INT = NULL OUT
AS
BEGIN
    SET @ObjectId = NULL;
    SET @ObjectTypeId = NULL;

    SELECT  @ObjectId = SD.ObjectId, @ObjectTypeId = SD.ObjectTypeId
      FROM  dspAuth.SecurityDescriptor AS SD
     WHERE  SD.SecurityDescriptorId = @SecurityDescriptorId;

    IF (@ObjectId IS NULL) --
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID;
END;
GO
