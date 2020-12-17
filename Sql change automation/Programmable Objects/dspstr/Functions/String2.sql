IF OBJECT_ID('[dspstr].[String2]') IS NOT NULL
	DROP FUNCTION [dspstr].[String2];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

				CREATE FUNCTION [dspstr].[String2]() 
				RETURNS TSTRING
				AS 
				BEGIN
					RETURN dsp.StringTable_Value('String2');
				END
						
GO
