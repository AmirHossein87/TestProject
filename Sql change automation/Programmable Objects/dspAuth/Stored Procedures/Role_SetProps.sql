IF OBJECT_ID('[dspAuth].[Role_SetProps]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[Role_SetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[Role_SetProps]
    @AuditUserId INT, @RoleId INT, @RoleName TSTRING = '<notset>'
AS
BEGIN
    -- Fetch Old Data
    DECLARE @OldRoleName TSTRING;
    SELECT  @OldRoleName = R.RoleName
      FROM  dspAuth.Role AS R
     WHERE  R.RoleId = @RoleId;

    -- Detect if there are any changes
    DECLARE @IsUserUpdated BIT = 0;
    EXEC dsp.SetIfChanged_String @ProcId = @@PROCID, @PropName = 'RoleName', @IsUpdated = @IsUserUpdated OUT, @OldValue = @OldRoleName OUT,
        @NewValue = @RoleName;

    -- Update table Role if neccassary
    IF (@IsUserUpdated = 1)
        UPDATE  dspAuth.Role
           SET  RoleName = @OldRoleName, ModifiedByUserId = @AuditUserId
         WHERE  RoleId = @RoleId;
END;



GO
