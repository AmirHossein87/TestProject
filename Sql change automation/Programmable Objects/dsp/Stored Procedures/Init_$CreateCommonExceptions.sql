IF OBJECT_ID('[dsp].[Init_$CreateCommonExceptions]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_$CreateCommonExceptions];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Create common exception
CREATE PROCEDURE  [dsp].[Init_$CreateCommonExceptions]
AS
BEGIN
	-- SQL Prompt formatting off
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55002, N'AccessDeniedOrObjectNotExists');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55003, N'ObjectAlreadyExists');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55004, N'ObjectIsInUse');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55005, N'PageSizeTooLarge');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55006, N'InvalidArgument');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55007, N'FatalError');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55008, N'LockFailed');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55009, N'ValidationError');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55010, N'InvalidOperation');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55011, N'NotSupported');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55012, N'NotImplemeted');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55013, N'UserIsDisabled');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55014, N'AmbiguousException');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55015, N'NoOperation');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55016, N'InvalidCaptcha');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55017, N'BatchIsNotAllowed');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55018, N'TooManyRequest');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55019, N'AuthUserNotFound');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55020, N'InvokerAppVersion');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55021, N'Maintenance');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55022, N'MaintenanceReadOnly');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55023, N'InvalidParamSignature');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55024, N'DuplicateRequestException');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55025, N'HasNotSameStrcutre');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55026, N'GeneralException');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55027, N'ArgumentsAreNotSame');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55028, N'UnHandledException');
	INSERT dsp.Exception (ExceptionId, ExceptionName) VALUES (55029, N'ProductionEnvinronmentIsTurnedOn');
END
GO
