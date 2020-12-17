IF OBJECT_ID('[dspAuth].[Context_Permissions]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[Context_Permissions];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[Context_Permissions]
    @Context TCONTEXT OUT, @ObjectId BIGINT, @ObjectTypeId INT, @Permissions TSTRING = NULL OUT
AS
BEGIN
    DECLARE @ContextUserId INT = dsp.Context_UserId(@Context);

    EXEC dspAuth.SecurityDescriptor_UserPermissionObject @ObjectId = @ObjectId, @ObjectTypeId = @ObjectTypeId, @UserId = @ContextUserId,
        @Permissions = @Permissions OUTPUT;
END;
GO
