IF OBJECT_ID('[dspAuth].[SecurityDescriptor_IsParentOf]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[SecurityDescriptor_IsParentOf];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[SecurityDescriptor_IsParentOf]
	@SecurityDescriptorId BIGINT, @ChildSecurityDescriptorId BIGINT, @IsParentOf BIT OUT
AS
BEGIN
	SET @IsParentOf = 0;

	-- SecurityDescriptor_Parents Gets parernts of the SecurityDescriptor including itself
	SELECT	@IsParentOf = 1
	FROM	dspAuth.SecurityDescriptor_Parents(@ChildSecurityDescriptorId) AS SOPG
	WHERE	SOPG.SecurityDescriptorId = @SecurityDescriptorId;
END;

GO
