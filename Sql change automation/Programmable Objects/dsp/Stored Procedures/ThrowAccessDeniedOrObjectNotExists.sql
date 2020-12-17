IF OBJECT_ID('[dsp].[ThrowAccessDeniedOrObjectNotExists]') IS NOT NULL
	DROP PROCEDURE [dsp].[ThrowAccessDeniedOrObjectNotExists];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[ThrowAccessDeniedOrObjectNotExists]
    @ProcId INT, @ObjectTypeName TSTRING, @ObjectId TSTRING, @Message TSTRING = NULL, @Param0 TSTRING = '<notset>', @Param1 TSTRING = '<notset>',
    @Param2 TSTRING = '<notset>', @Param3 TSTRING = '<notset>'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ArgMessage TSTRING;
    EXEC @ArgMessage = dsp.Formatter_FormatMessage @Message = N'{"ObjectName": "{0}", "ObjectId": "{1}"}', @Param0 = @ObjectTypeName, @Param1 = @ObjectId;

    IF (@Message IS NOT NULL)
        SET @ArgMessage = JSON_MODIFY(@ArgMessage, '$.Message', @Message);

    DECLARE @ExceptionId INT = /* err.AccessDeniedOrObjectNotExistsId() */ 55002;
    EXEC dsp.ThrowAppException @ProcId = @ProcId, @ExceptionId = @ExceptionId, @Message = @ArgMessage, @Param0 = @Param0, @Param1 = @Param1, @Param2 = @Param2,
        @Param3 = @Param3;
END;









GO
