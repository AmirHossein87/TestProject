IF OBJECT_ID('[DatabaseVersioning].[Validate_Mirroring]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Validate_Mirroring];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE PROCEDURE [DatabaseVersioning].[Validate_Mirroring]
    @CheckForSource BIT = 1
AS
BEGIN
    SET @CheckForSource = ISNULL(@CheckForSource, 1);
    -- Create variables
    DECLARE @Result TABLE (ObjectId INT,
        SchemaName TSTRING,
        TableName TSTRING,
        TemporalTypeId INT,
        LevelPriority INT,
        IsTemporal BIT);

    DECLARE @Message TSTRING;

    -- Get list tables
    INSERT INTO @Result (ObjectId, SchemaName, TableName, TemporalTypeId, LevelPriority, IsTemporal)
    SELECT  SystemTableId ObjectId, SchemaName, TableName, TemporalTypeId, LevelPriority, IsTemporal
      FROM  dsp.SystemTable;
	/*  --
	  IF EXISTS (SELECT * FROM @Result WHERE TemporalTypeId = /*dspconst.TemporalType_Temporal()*/2 AND IsTemporal = 0)
	  EXEC dsp.ThrowFatalError @ProcId = @@PROCID, @Message = ''	  

	  IF EXISTS (SELECT * FROM @Result WHERE TemporalTypeId = /*dspconst.TemporalType_Temporal()*/2 AND IsTemporal = 0)
	  EXEC dsp.ThrowFatalError @ProcId = @@PROCID, @Message = ''	  
	  */
    -- Validate PrimaryKey on tables
    SET @Message = (   SELECT   STRING_AGG(R.SchemaName + '.' + R.TableName, ',')
                         FROM   @Result R
                                OUTER APPLY dsp.Table_HasPrimaryKey(R.SchemaName, R.TableName) THPK
                        WHERE   THPK.HasPrimaryKey = 0 AND  R.TableName NOT LIKE '%History%');

    IF (@Message IS NOT NULL) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Table(s) does not have PrimaryKey: {0}', @Param0 = @Message;

    -- Validate In destination side temporaltype must be off

    /* SET @Message = (   SELECT   STRING_AGG(R.SchemaName + '.' + R.TableName, ',')
                         FROM   @Result AS R
                        WHERE   R.IsTemporal = 1 AND @CheckForSource = 0);*/

    SET @Message = (   SELECT   STRING_AGG(R.SchemaName + '.' + R.TableName, ',')
                         FROM   @Result AS R
                        WHERE   @CheckForSource = 0 AND R.TemporalTypeId = 2);


    IF (@Message IS NOT NULL) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Temporaltype must be off in destination side: {0}', @Param0 = @Message;

    -- Validate TemporalType extended property on all tables
    SET @Message = (   SELECT   STRING_AGG(R.SchemaName + '.' + R.TableName, ',')
                         FROM   @Result R
                        WHERE   R.TemporalTypeId IS NULL);

    IF (@Message IS NOT NULL) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Table(s) does not have TemporalType in extended property: {0}', @Param0 = @Message;

    -- Validate LevelPriority in SystemTable 
    SET @Message = (   SELECT   STRING_AGG(R.SchemaName + '.' + R.TableName, ',')
                         FROM   @Result R
                        WHERE   R.LevelPriority IS NULL);

    IF (@Message IS NOT NULL) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'LevelPriority must be not null in SystemTable: {0}', @Param0 = @Message;

    -- Validate table with transactional TemporalType that does not have CreatedTime
    SET @Message = (   SELECT   STRING_AGG(R.SchemaName + '.' + R.TableName, ',')
                         FROM   @Result AS R
                                OUTER APPLY DatabaseVersioning.Table_HasColumnName(R.ObjectId, 'CreatedTime') AS THC
                        WHERE   R.TemporalTypeId = dspconst.TemporalType_Transactional() AND THC.HasColumn IS NULL);

    IF (@Message IS NOT NULL) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID,
            @Message = 'Table(s) does not have CreatedTime in Transactional temporal type in extended property: {0}', @Param0 = @Message;

    -- Validate table with ordinary TemporalType that does not have CreatedTime
    SET @Message = (   SELECT   STRING_AGG(R.SchemaName + '.' + R.TableName, ',')
                         FROM   @Result AS R
                                OUTER APPLY DatabaseVersioning.Table_HasColumnName(R.ObjectId, 'CreatedTime') AS THC
                        WHERE   R.TemporalTypeId = dspconst.TemporalType_Ordinary() AND THC.HasColumn IS NULL);
    IF (@Message IS NOT NULL) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID,
            @Message = 'Table(s) does not have CreatedTime in ordinary temporal type in extended property: {0}', @Param0 = @Message;

    -- Validate table with ordinary TemporalType that does not have ModifiedTime for detect updated records
    SET @Message = (   SELECT   STRING_AGG(R.SchemaName + '.' + R.TableName, ',')
                         FROM   @Result AS R
                                OUTER APPLY DatabaseVersioning.Table_HasColumnName(R.ObjectId, 'ModifiedTime') AS THC
                        WHERE   R.TemporalTypeId = dspconst.TemporalType_Ordinary() AND THC.HasColumn IS NULL);

    IF (@Message IS NOT NULL) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID,
            @Message = 'Table(s) does not have ModifiedTime in ordinary temporal type in extended property: {0}', @Param0 = @Message;

    -- Validate table with ordinary TemporalType that does not have ModifiedTime for detect updated records
    SET @Message = (   SELECT   STRING_AGG(R.SchemaName + '.' + R.TableName, ',')
                         FROM   @Result AS R
                                OUTER APPLY DatabaseVersioning.Table_HasColumnName(R.ObjectId, 'ModifiedTime') AS THC
                        WHERE   R.TemporalTypeId = dspconst.TemporalType_Ordinary() AND THC.HasColumn IS NULL);

    IF (@Message IS NOT NULL) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID,
            @Message = 'Table(s) does not have ModifiedTime in ordinary temporal type in extended property: {0}', @Param0 = @Message;

-- Set feature enable
--EXEC DatabaseVersioning.Setting_SetProps @IsFeatureEnabled = 1;

END;

GO
