IF OBJECT_ID('[dspAuth].[SecurityDescriptor_SecurityDescriptorByObject]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[SecurityDescriptor_SecurityDescriptorByObject];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[SecurityDescriptor_SecurityDescriptorByObject]
    @ObjectId INT, @ObjectTypeId INT, @ThrowIfNotExists BIT = 1, @SecurityDescriptorId BIGINT = NULL OUT
AS
BEGIN
    SET @ThrowIfNotExists = ISNULL(@ThrowIfNotExists, 1);
    SET @SecurityDescriptorId = NULL;

    -- Find SecurityDescriptorId
    SELECT  @SecurityDescriptorId = SD.SecurityDescriptorId
      FROM  dspAuth.SecurityDescriptor AS SD
     WHERE  SD.ObjectTypeId = @ObjectTypeId AND SD.ObjectId = @ObjectId;

    -- 
    IF (@SecurityDescriptorId IS NULL AND   @ThrowIfNotExists = 1)
    BEGIN
        DECLARE @ObjectTypeName TSTRING;
        SELECT  @ObjectTypeName = OT.ObjectTypeName
          FROM  dspAuth.ObjectType AS OT
         WHERE  OT.ObjectTypeId = @ObjectTypeId;

        EXEC dsp.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID, @ObjectTypeName = @ObjectTypeName, @ObjectId = @ObjectId;
    END;

END;




GO
