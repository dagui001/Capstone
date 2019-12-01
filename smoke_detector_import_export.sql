USE Customer
GO

IF OBJECT_ID('Room Name','U') IS NOT NULL
	DROP TABLE RoomInfo;
GO 

CREATE TABLE Room_Info(
	RoomID int primary key identity(1,1),
	Building_Occupancy				VARCHAR(100)	NULL,
	Fire_Sprinkler					VARCHAR(100)	NULL,
	Room_Name						VARCHAR(100)	NULL,
	--RoomNumber					Int			NULL,
	Smoke_Detector					Int			NULL,
	Room_Area						Float		NULL
	--RoomPerimeter					Float		NULL,
);
GO


DECLARE @RoomInfo	VARCHAR(MAX)

SELECT	@RoomInfo	=
	BulkColumn
	FROM OPENROWSET(BULK'C:\Users\dagui\Documents\Capstone\SQL\data1.json', SINGLE_BLOB) JSON

SELECT @RoomInfo as Details;

IF (ISJSON(@RoomInfo)=1)
	BEGIN
		PRINT'JSON File is valid';

		INSERT INTO Room_Info
		SELECT *
		FROM OPENJSON(@RoomInfo)
		WITH (
		    Building_Occupancy					VARCHAR(100)	'$.Building_Occupancy',
			Fire_Sprinkler						VARCHAR(100)	'$.Fire_Sprinkler',
			Room_Name							VARCHAR(100)	'$.Room_Name',
			--RoomNumber						Int			'$.Room_Number',
			Smoke_Detectors						Int			'$.Smoke_Detector',
			Room_Area							Float		'$.Room_Area'
			--RoomPerimeter					Float		'$.Room_Perimeter'
	)	
	END
ELSE
	BEGIN
		PRINT 'JSON File is invalid';
	END

select *
from Room_Info


select Fire_Sprinkler,Building_Occupancy,Room_Name,Room_Area,Smoke_Detector
from  [dbo].[Room_Info]
