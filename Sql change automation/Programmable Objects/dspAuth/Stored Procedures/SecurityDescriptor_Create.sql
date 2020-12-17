IF OBJECT_ID('[dspAuth].[SecurityDescriptor_Create]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[SecurityDescriptor_Create];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dspAuth].[SecurityDescriptor_Create]
    @ObjectId BIGINT, @ObjectTypeId INT, @SecurityDescriptorId BIGINT = NULL OUT
AS
BEGIN
    INSERT  dspAuth.SecurityDescriptor (ObjectId, ObjectTypeId)
    VALUES (@ObjectId, @ObjectTypeId);

    SET @SecurityDescriptorId = SCOPE_IDENTITY();
END;



GO
