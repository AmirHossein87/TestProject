IF OBJECT_ID('[dspstr].[String1]') IS NOT NULL
	DROP FUNCTION [dspstr].[String1];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

				CREATE FUNCTION [dspstr].[String1]() 
				RETURNS TSTRING
				AS 
				BEGIN
					RETURN dsp.StringTable_Value('String1');
				END
						
GO
