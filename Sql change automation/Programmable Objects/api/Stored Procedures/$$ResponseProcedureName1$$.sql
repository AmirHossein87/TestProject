IF OBJECT_ID('[api].[$$ResponseProcedureName1$$]') IS NOT NULL
	DROP PROCEDURE [api].[$$ResponseProcedureName1$$];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

		CREATE   PROCEDURE [api].[$$ResponseProcedureName1$$] 
			@Contect TCONTEXT = NULL, @Input TSTRING, @InputOutput TSTRING OUTPUT, @Output TSTRING OUTPUT, @DefaultValue TSTRING OUTPUT 
		AS 
		BEGIN 
			PRINT 'Succefully test procedure excute ;)' 
			PRINT '	@Input: ' + ISNULL(@Input,'NULL')
			PRINT '	@InputOutput: ' + ISNULL(@InputOutput,'NULL')
			PRINT '	@Output: ' + ISNULL(@Output,'NULL')
			PRINT '	@DefaultValue: ' + ISNULL(@DefaultValue,'NULL')
		END
GO
