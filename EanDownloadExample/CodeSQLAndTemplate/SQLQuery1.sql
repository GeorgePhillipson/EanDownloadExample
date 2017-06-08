USE [EAN]
GO
/****** Object:  StoredProcedure [dbo].[spActivePropertyList]    Script Date: 08/06/2017 12:39:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spActivePropertyList]
AS
BEGIN
SET ANSI_WARNINGS OFF

MERGE tblactivepropertylist AS Target
USING (SELECT * FROM OPENROWSET(BULK 'F:\EAN\ActivePropertyList.txt',
	  FORMATFILE='F:\EAN\ActivePropertyList.xml', FIRSTROW = 2) AS BCP) AS Source
-- primary key to find matching records
ON Target.EANHotelID = Source.EANHotelID
-- UPDATE RECORD
WHEN MATCHED THEN UPDATE SET 
	 Target.SequenceNumber		= Source.SequenceNumber, 
	 Target.Name				= Source.Name, 
	 Target.Address1			= Source.Address1, 
	 Target.Address2			= Source.Address2, 
	 Target.City				= Source.City, 
	 Target.StateProvince		= Source.StateProvince, 
	 Target.PostalCode			= Source.PostalCode,
	 Target.Country				= Source.Country, 
	 Target.Latitude			= Source.Latitude, 
	 Target.Longitude			= Source.Longitude, 
	 Target.AirportCode			= Source.AirportCode, 
	 Target.PropertyCategory	= Source.PropertyCategory, 
	 Target.PropertyCurrency	= Source.PropertyCurrency, 
	 Target.StarRating			= Source.StarRating, 
	 Target.Confidence			= Source.Confidence, 
	 Target.SupplierType		= Source.SupplierType, 
	 Target.Location			= Source.Location,
	 Target.ChainCodeID			= Source.ChainCodeID, 
	 Target.RegionID			= Source.RegionID, 
	 Target.HighRate			= Source.HighRate, 
	 Target.LowRate				= Source.LowRate,
	 Target.CheckInTime			= Source.CheckInTime, 
	 Target.CheckOutTime		= Source.CheckOutTime 
-- INSERT RECORD
WHEN NOT MATCHED BY Target 
	THEN INSERT(EANHotelID, 
				SequenceNumber, 
				Name, 
				Address1, 
				Address2, 
				City,
				StateProvince, 
				PostalCode, 
				Country, 
				Latitude, 
				Longitude, 
				AirportCode,
				PropertyCategory, 
				PropertyCurrency, 
				StarRating, 
				Confidence, 
				SupplierType,
				Location, 
				ChainCodeID, 
				RegionID, 
				HighRate, 
				LowRate, 
				CheckInTime, 
				CheckOutTime) 
	VALUES(	Source.EANHotelID, 
			Source.SequenceNumber, 
			Source.Name, 
			Source.Address1, 
			Source.Address2, 
	        Source.City, 
			Source.StateProvince, 
			Source.PostalCode, 
			Source.Country, 
			Source.Latitude, 
		    Source.Longitude, 
			Source.AirportCode, 
			Source.PropertyCategory, 
			Source.PropertyCurrency,
		    Source.StarRating, 
			Source.Confidence, 
			Source.SupplierType, 
			Source.Location, 
			Source.ChainCodeID,
		    Source.RegionID, 
			Source.HighRate, 
			Source.LowRate, 
			Source.CheckInTime, 
			Source.CheckOutTime)
-- DELETE RECORD
WHEN NOT MATCHED BY Source THEN DELETE
-- report UPDATE, DELETE and INSERT operations
OUTPUT $action, 
DELETED.EANHotelID AS TargetEANHotelID,  
INSERTED.EANHotelID AS SourceEANHotelID; 
SELECT @@ROWCOUNT
;
END


USE [EAN]
GO
/****** Object:  StoredProcedure [dbo].[spInsertAreaAttractionsList]    Script Date: 08/06/2017 12:40:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[spInsertAreaAttractionsList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here


TRUNCATE TABLE [dbo].[tblAreaAttractionsList]

INSERT INTO [dbo].[tblAreaAttractionsList] (EANHotelID,[LanguageCode],[AreaAttractions])
	SELECT EANHotelID,LanguageCode,AreaAttractions
	 FROM OPENROWSET(BULK 'F:\EAN\AreaAttractionsList.txt',
	                         FORMATFILE='F:\EAN\AreaAttractionsList.xml', FIRSTROW = 2) as BCP
							 
SET ANSI_WARNINGS ON
END

USE [EAN]
GO
/****** Object:  StoredProcedure [dbo].[spInsertCountryList]    Script Date: 08/06/2017 12:40:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spInsertCountryList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

MERGE [dbo].[tblCountrylist] AS Target
USING (SELECT * FROM OPENROWSET(BULK 'F:\EAN\countrylist.txt',
	  FORMATFILE='F:\EAN\countrylist.xml', FIRSTROW = 2) AS BCP) AS Source
-- primary key to find matching records
ON Target.CountryID = Source.CountryID
-- UPDATE RECORD
WHEN MATCHED THEN UPDATE SET 
	 Target.LanguageCode		= Source.LanguageCode, 
	 Target.CountryName			= Source.CountryName,
	 Target.CountryCode			= Source.CountryCode,
	 Target.Transliteration		= Source.Transliteration,
	 Target.ContinentID			= Source.ContinentID
-- INSERT RECORD
WHEN NOT MATCHED BY Target 
	THEN INSERT(CountryID, 
				LanguageCode, 
				CountryName,
				CountryCode,
				Transliteration,
				ContinentID) 
	VALUES(	Source.CountryID, 
			Source.LanguageCode, 
			Source.CountryName,
			Source.CountryCode,
			Source.Transliteration,
			Source.ContinentID)
-- DELETE RECORD
WHEN NOT MATCHED BY Source THEN DELETE
-- report UPDATE, DELETE and INSERT operations
OUTPUT $action, 
DELETED.CountryID AS TargetCountryID,  
INSERTED.CountryID AS SourceCountryID;
SELECT @@ROWCOUNT;
END 

USE [EAN]
GO
/****** Object:  StoredProcedure [dbo].[spInsertDiningDescriptionList]    Script Date: 08/06/2017 12:41:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spInsertDiningDescriptionList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

TRUNCATE TABLE [dbo].[tblDiningDescriptionList]
--WAITFOR DELAY '00:00:10';

INSERT INTO [dbo].[tblDiningDescriptionList] (EANHotelID,[LanguageCode],[PropertyDiningDescription])
	SELECT EANHotelID,LanguageCode,PropertyDiningDescription
	 FROM OPENROWSET(BULK 'F:\EAN\DiningDescriptionList.txt',
	                         FORMATFILE='F:\EAN\DiningDescriptionList.xml', FIRSTROW = 2) as BCP
							 
SET ANSI_WARNINGS ON
END

USE [EAN]
GO
/****** Object:  StoredProcedure [dbo].[spInsertEanImages]    Script Date: 08/06/2017 12:41:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[spInsertEanImages]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

TRUNCATE TABLE [dbo].[tblHotelImageList]
--WAITFOR DELAY '00:00:10';

 INSERT INTO [dbo].[tblHotelImageList] (EANHotelID, Caption, URL, Width, Height, ByteSize,
	        ThumbnailURL,DefaultImage)
	SELECT EANHotelID, Caption, URL, Width, Height, ByteSize,
	        ThumbnailURL,DefaultImage
	 FROM OPENROWSET(BULK 'F:\EAN\HotelImageList.txt',
	                         FORMATFILE='F:\EAN\HotelImageList.xml', FIRSTROW = 2) as BCP
SET ANSI_WARNINGS ON
END

USE [EAN]
GO
/****** Object:  StoredProcedure [dbo].[spInsertPolicyDescriptionList]    Script Date: 08/06/2017 12:41:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[spInsertPolicyDescriptionList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/********************************************************************/
/* Query to Refresh the activepropertylist Table					*/
/* will set ANSI_WARNINGS OFF to avoid truncation errors, as they	*/
/* reffer to datafiles containing WIDECHARACTERS					*/
/********************************************************************/
TRUNCATE TABLE [dbo].[tblPolicyDescriptionList]
INSERT INTO [dbo].[tblPolicyDescriptionList] (EANHotelID,[LanguageCode],[PolicyDescription])
	SELECT EANHotelID,LanguageCode,PolicyDescription
	 FROM OPENROWSET(BULK 'F:\EAN\PolicyDescriptionList.txt',
	                         FORMATFILE='F:\EAN\PolicyDescriptionList.xml', FIRSTROW = 2) as BCP
							 
SET ANSI_WARNINGS ON
END

USE [EAN]
GO
/****** Object:  StoredProcedure [dbo].[spInsertPropertyDescriptionList]    Script Date: 08/06/2017 12:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spInsertPropertyDescriptionList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
TRUNCATE TABLE [dbo].[tblPropertyDescriptionList]
INSERT INTO [dbo].[tblPropertyDescriptionList] (EANHotelID,[LanguageCode],[PropertyDescription])
	SELECT EANHotelID,LanguageCode,PropertyDescription
	 FROM OPENROWSET(BULK 'F:\EAN\PropertyDescriptionList.txt',
	                         FORMATFILE='F:\EAN\PropertyDescriptionList.xml', FIRSTROW = 2) as BCP
							 
SET ANSI_WARNINGS ON
END

USE [EAN]
GO
/****** Object:  StoredProcedure [dbo].[spInsertPropertyList]    Script Date: 08/06/2017 12:42:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[spInsertPropertyList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

INSERT INTO tblactivepropertylist (EANHotelID, SequenceNumber, Name, Address1, Address2, City,
	        StateProvince, PostalCode, Country, Latitude, Longitude, AirportCode,
			PropertyCategory, PropertyCurrency, StarRating, Confidence, SupplierType,
			Location, ChainCodeID, RegionID, HighRate, LowRate, CheckInTime, CheckOutTime)
	SELECT EANHotelID, SequenceNumber, Name, Address1, Address2, City,
	        StateProvince, PostalCode, Country, Latitude, Longitude, AirportCode,
			PropertyCategory, PropertyCurrency, StarRating, Confidence, SupplierType,
			Location, ChainCodeID, RegionID, HighRate, LowRate, CheckInTime, CheckOutTime
	 FROM OPENROWSET(BULK 'F:\EAN\activepropertylist.txt',
	                         FORMATFILE='F:\EAN\activepropertylist.xml', FIRSTROW = 2) as BCP
							 
SET ANSI_WARNINGS ON
END

USE [EAN]
GO
/****** Object:  StoredProcedure [dbo].[spInsertRecreationDescriptionList]    Script Date: 08/06/2017 12:43:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spInsertRecreationDescriptionList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

TRUNCATE TABLE [dbo].[tblRecreationDescriptionList] 
INSERT INTO [dbo].[tblRecreationDescriptionList] (EANHotelID,[LanguageCode],[RecreationDescription])
	SELECT EANHotelID,LanguageCode,RecreationDescription
	 FROM OPENROWSET(BULK 'F:\EAN\RecreationDescriptionList.txt',
	                         FORMATFILE='F:\EAN\RecreationDescriptionList.xml', FIRSTROW = 2) as BCP
							 
SET ANSI_WARNINGS ON
END

USE [EAN]
GO
/****** Object:  StoredProcedure [dbo].[spInsertSpaDescriptionList]    Script Date: 08/06/2017 12:43:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spInsertSpaDescriptionList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

TRUNCATE TABLE [dbo].[tblSpaDescriptionList] 
INSERT INTO [dbo].[tblSpaDescriptionList] (EANHotelID,[LanguageCode],[SpaDescription])
	SELECT EANHotelID,LanguageCode,SpaDescription
	 FROM OPENROWSET(BULK 'F:\EAN\SpaDescriptionList.txt',
	                         FORMATFILE='F:\EAN\SpaDescriptionList.xml', FIRSTROW = 2) as BCP
							 
SET ANSI_WARNINGS ON
END

USE [EAN]
GO
/****** Object:  StoredProcedure [dbo].[spInsertWhatToExpectList]    Script Date: 08/06/2017 12:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spInsertWhatToExpectList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
TRUNCATE TABLE [dbo].[tblWhatToExpectList]
INSERT INTO [dbo].[tblWhatToExpectList] (EANHotelID,[LanguageCode],[WhatToExpect])
	SELECT EANHotelID,LanguageCode,WhatToExpect
	 FROM OPENROWSET(BULK 'F:\EAN\WhatToExpectList.txt',
	                         FORMATFILE='F:\EAN\WhatToExpectList.xml', FIRSTROW = 2) as BCP
							 
SET ANSI_WARNINGS ON
END

USE [EAN]
GO

/****** Object:  Table [dbo].[tblactivepropertylist]    Script Date: 08/06/2017 12:44:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblactivepropertylist](
	[EANHotelID] [int] NOT NULL,
	[SequenceNumber] [int] NULL,
	[Name] [nvarchar](70) NULL,
	[Address1] [nvarchar](50) NULL,
	[Address2] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[StateProvince] [nchar](2) NULL,
	[PostalCode] [nvarchar](15) NULL,
	[Country] [nchar](2) NULL,
	[Latitude] [numeric](8, 5) NULL,
	[Longitude] [numeric](8, 5) NULL,
	[AirportCode] [nchar](3) NULL,
	[PropertyCategory] [int] NULL,
	[PropertyCurrency] [nchar](3) NULL,
	[StarRating] [numeric](2, 1) NULL,
	[Confidence] [int] NULL,
	[SupplierType] [nchar](3) NULL,
	[Location] [nvarchar](80) NULL,
	[ChainCodeID] [nchar](5) NULL,
	[RegionID] [int] NULL,
	[HighRate] [numeric](19, 4) NULL,
	[LowRate] [numeric](19, 4) NULL,
	[CheckInTime] [nchar](10) NULL,
	[CheckOutTime] [nchar](10) NULL,
	[TimeStamp] [timestamp] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EANHotelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblactivepropertylist]  WITH CHECK ADD  CONSTRAINT [FK_tblactivepropertylist_tblCountrylist] FOREIGN KEY([Country])
REFERENCES [dbo].[tblCountrylist] ([CountryCode])
GO

ALTER TABLE [dbo].[tblactivepropertylist] CHECK CONSTRAINT [FK_tblactivepropertylist_tblCountrylist]
GO

USE [EAN]
GO

/****** Object:  Table [dbo].[tblAreaAttractionsList]    Script Date: 08/06/2017 12:45:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblAreaAttractionsList](
	[EANHotelID] [int] NOT NULL,
	[LanguageCode] [nvarchar](5) NULL,
	[AreaAttractions] [nvarchar](4000) NULL
) ON [PRIMARY]

GO

USE [EAN]
GO

/****** Object:  Table [dbo].[tblCountrylist]    Script Date: 08/06/2017 12:45:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblCountrylist](
	[CountryID] [int] NOT NULL,
	[LanguageCode] [nvarchar](5) NULL,
	[CountryName] [nvarchar](246) NULL,
	[CountryCode] [nchar](2) NOT NULL,
	[Transliteration] [nvarchar](256) NULL,
	[ContinentID] [int] NULL,
 CONSTRAINT [PK_tblCountrylist_1] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [EAN]
GO

/****** Object:  Table [dbo].[tblDiningDescriptionList]    Script Date: 08/06/2017 12:46:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblDiningDescriptionList](
	[EANHotelID] [int] NOT NULL,
	[LanguageCode] [nvarchar](5) NULL,
	[PropertyDiningDescription] [nvarchar](4000) NULL
) ON [PRIMARY]

GO

USE [EAN]
GO

/****** Object:  Table [dbo].[tblHotelImageList]    Script Date: 08/06/2017 12:46:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblHotelImageList](
	[EANHotelID] [int] NOT NULL,
	[Caption] [nvarchar](70) NULL,
	[URL] [nvarchar](150) NOT NULL,
	[Width] [int] NULL,
	[Height] [int] NULL,
	[ByteSize] [int] NULL,
	[ThumbnailURL] [nvarchar](300) NULL,
	[DefaultImage] [int] NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK__tblHotel__C5B1000885643819] PRIMARY KEY CLUSTERED 
(
	[URL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [EAN]
GO

/****** Object:  Table [dbo].[tblPolicyDescriptionList]    Script Date: 08/06/2017 12:46:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblPolicyDescriptionList](
	[EANHotelID] [int] NULL,
	[LanguageCode] [nvarchar](5) NULL,
	[PolicyDescription] [nvarchar](4000) NULL
) ON [PRIMARY]

GO

USE [EAN]
GO

/****** Object:  Table [dbo].[tblPropertyDescriptionList]    Script Date: 08/06/2017 12:46:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblPropertyDescriptionList](
	[EANHotelID] [int] NOT NULL,
	[LanguageCode] [nvarchar](5) NULL,
	[PropertyDescription] [nvarchar](4000) NULL
) ON [PRIMARY]

GO

USE [EAN]
GO

/****** Object:  Table [dbo].[tblRecreationDescriptionList]    Script Date: 08/06/2017 12:47:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblRecreationDescriptionList](
	[EANHotelID] [int] NULL,
	[LanguageCode] [nvarchar](5) NULL,
	[RecreationDescription] [nvarchar](4000) NULL
) ON [PRIMARY]

GO

USE [EAN]
GO

/****** Object:  Table [dbo].[tblSpaDescriptionList]    Script Date: 08/06/2017 12:47:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblSpaDescriptionList](
	[EANHotelID] [int] NULL,
	[LanguageCode] [nvarchar](5) NULL,
	[SpaDescription] [nvarchar](4000) NULL
) ON [PRIMARY]

GO

USE [EAN]
GO

/****** Object:  Table [dbo].[tblWhatToExpectList]    Script Date: 08/06/2017 12:47:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblWhatToExpectList](
	[EANHotelID] [int] NULL,
	[LanguageCode] [nvarchar](5) NULL,
	[WhatToExpect] [nvarchar](4000) NULL
) ON [PRIMARY]

GO


