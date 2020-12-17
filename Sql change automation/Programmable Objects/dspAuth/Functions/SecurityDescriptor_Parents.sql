IF OBJECT_ID('[dspAuth].[SecurityDescriptor_Parents]') IS NOT NULL
	DROP FUNCTION [dspAuth].[SecurityDescriptor_Parents];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspAuth].[SecurityDescriptor_Parents] (@SecurityDescriptorId BIGINT)
RETURNS TABLE
AS
RETURN (WITH SecurityDescriptorParents
			AS (SELECT	SOI.ParentSecurityDescriptorId AS SecurityDescriptorId
				FROM	dspAuth.SecurityDescriptorParent AS SOI
				WHERE	SOI.SecurityDescriptorId = @SecurityDescriptorId
				UNION ALL
				SELECT	SOI.ParentSecurityDescriptorId AS SecurityDescriptorId
				FROM	dspAuth.SecurityDescriptorParent AS SOI
						INNER JOIN SecurityDescriptorParents AS PSO ON PSO.SecurityDescriptorId = SOI.SecurityDescriptorId)
		SELECT	SOP.SecurityDescriptorId
		FROM	SecurityDescriptorParents AS SOP
		UNION
		SELECT	@SecurityDescriptorId);

GO
