IF OBJECT_ID('[dspAuth].[SecurityDescriptor_Roles]') IS NOT NULL
	DROP FUNCTION [dspAuth].[SecurityDescriptor_Roles];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspAuth].[SecurityDescriptor_Roles] (@SecurityDescriptorId BIGINT)
RETURNS TABLE
RETURN (   SELECT   R.RoleId, R.RoleName
             FROM   dspAuth.Role AS R
            WHERE   R.OwnerSecurityDescriptorId = @SecurityDescriptorId);
GO
