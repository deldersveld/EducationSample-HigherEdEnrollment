/*    ==Scripting Parameters==

    Source Database Engine Edition : Microsoft Azure SQL Database Edition
    Source Database Engine Type : Microsoft Azure SQL Database

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO
/****** Object:  Database [HigherED_Staging] ******/
CREATE DATABASE [HigherED_Staging]
GO
ALTER DATABASE [HigherED_Staging] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HigherED_Staging].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HigherED_Staging] SET ANSI_NULL_DEFAULT ON 
GO
ALTER DATABASE [HigherED_Staging] SET ANSI_NULLS ON 
GO
ALTER DATABASE [HigherED_Staging] SET ANSI_PADDING ON 
GO
ALTER DATABASE [HigherED_Staging] SET ANSI_WARNINGS ON 
GO
ALTER DATABASE [HigherED_Staging] SET ARITHABORT ON 
GO
ALTER DATABASE [HigherED_Staging] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HigherED_Staging] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HigherED_Staging] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HigherED_Staging] SET CONCAT_NULL_YIELDS_NULL ON 
GO
ALTER DATABASE [HigherED_Staging] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HigherED_Staging] SET QUOTED_IDENTIFIER ON 
GO
ALTER DATABASE [HigherED_Staging] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HigherED_Staging] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HigherED_Staging] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HigherED_Staging] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HigherED_Staging] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HigherED_Staging] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HigherED_Staging] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [HigherED_Staging] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HigherED_Staging] SET  MULTI_USER 
GO
ALTER DATABASE [HigherED_Staging] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HigherED_Staging] SET ENCRYPTION ON
GO
ALTER DATABASE [HigherED_Staging] SET QUERY_STORE = ON
GO
ALTER DATABASE [HigherED_Staging] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
USE [HigherED_Staging]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [HigherED_Staging]
GO
/****** Object:  User [HigherEDProxyUser]    Script Date: 9/13/2017 4:21:12 PM ******/
CREATE USER [HigherEDProxyUser] FOR LOGIN [HigherEDProxyUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [HigherEDProxyUser]
GO
ALTER ROLE [db_datareader] ADD MEMBER [HigherEDProxyUser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [HigherEDProxyUser]
GO
/****** Object:  Table [dbo].[Term]    Script Date: 9/13/2017 4:21:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Term](
	[TermID] [int] IDENTITY(1,1) NOT NULL,
	[Term] [varchar](50) NULL,
	[TermNumber] [int] NULL,
	[SchoolYear] [varchar](50) NULL,
	[StartDate] [varchar](50) NULL,
	[EndDate] [varchar](50) NULL,
	[TermAK] [varchar](50) NULL,
 CONSTRAINT [PK_Term_TermPK] PRIMARY KEY CLUSTERED 
(
	[TermID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [dbo].[EnrollmentSummary] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EnrollmentSummary](
	[EnrollmentSummaryID] [int] IDENTITY(1,1) NOT NULL,
	[Term] [varchar](50) NULL,
	[CRMID] [varchar](50) NULL,
	[Residential_Commuter] [varchar](50) NULL,
	[InState_OutState] [varchar](50) NULL,
	[Term_Credit_Attempted] [varchar](50) NULL,
	[Term_Credits_Earned] [varchar](50) NULL,
	[Term_GPA] [varchar](50) NULL,
	[Transfer_Credit] [varchar](50) NULL,
	[Cum_Credits_Attempted] [varchar](50) NULL,
	[Cum_Credits_Earned] [varchar](50) NULL,
	[Cum_GPA] [varchar](50) NULL,
	[Academic_Level] [varchar](50) NULL,
	[Academic_Standing] [varchar](50) NULL,
 CONSTRAINT [PK_EnrollmentSummary_EnrollmentSummaryID] PRIMARY KEY CLUSTERED 
(
	[EnrollmentSummaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
SET ANSI_PADDING ON
GO
/****** Object:  View [dbo].[Summary] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Summary]
AS
SELECT 
	CAST([CRMID] AS int) StudentAK,
	--CAST([Term] AS int) TermAK,
	CAST(CONVERT( varchar(10),CAST(t.StartDate AS date), 112) AS int) EnrollmentTermDateAK,
	CAST(LEFT([InState_OutState], 1) AS char(1)) ResidencyStatusAK,
	CAST(LEFT([Academic_Level], 2) AS varchar(2)) AcademicLevelAK,
	CAST([Term_Credit_Attempted] AS int) CreditHoursAttempted,
	CAST([Term_Credits_Earned] AS int) CreditHoursEearned,
	CAST([Term_GPA] AS decimal(5,3)) TermGPA,
	CAST([Transfer_Credit] AS decimal(6,3)) TransferCredit,
	CAST([Cum_Credits_Attempted] AS int) CumCreditHoursAttempted,
	CAST([Cum_Credits_Earned] AS int) CumCreditHoursEarned,
	CAST([Cum_GPA] AS decimal(5,3)) CumGPA
FROM dbo.EnrollmentSummary es
INNER JOIN dbo.Term t
	ON es.Term = t.TermAK
GO
/****** Object:  Table [dbo].[EnrollmentDetails] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EnrollmentDetails](
	[EnrollmentDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[Subject] [varchar](50) NULL,
	[Catalog] [varchar](50) NULL,
	[Title] [varchar](50) NULL,
	[Term] [varchar](50) NULL,
	[CRMID] [varchar](50) NULL,
	[Class_Section] [varchar](50) NULL,
	[Course_Credit_Hour] [varchar](50) NULL,
	[Instruction_Mode] [varchar](50) NULL,
	[MidTerm_Grade] [varchar](50) NULL,
	[EndofSem_Grade] [varchar](50) NULL,
	[Enrolled_Dropped] [varchar](50) NULL,
	[Enrolled_Date] [varchar](50) NULL,
	[Dropped_Date] [varchar](50) NULL,
 CONSTRAINT [PK_EnrollmentDetails_EnrollmentDetailID] PRIMARY KEY CLUSTERED 
(
	[EnrollmentDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
SET ANSI_PADDING ON
GO
/****** Object:  View [dbo].[Details] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Details]
AS
SELECT 
	CAST([CRMID] AS int) StudentAK,
	--CAST([Term] AS int) TermAK,
	CAST(CONVERT( varchar(10),CAST(t.StartDate AS date), 112) AS int) EnrollmentTermDateAK,
	CAST([Subject] AS varchar(10)) SubjectAK,
	CAST([Class_Section] AS varchar(5)) ClassSectionAK,
	CAST([Catalog] AS varchar(10)) CatalogAK,
	CONVERT(varchar(10), TRY_CAST([Enrolled_Date] AS date), 112) EnrolledDate,
	CONVERT(varchar(10), TRY_CAST([Dropped_Date] AS date), 112) DropDate,
	CAST([MidTerm_Grade] AS varchar(5)) MidTermGrade,
	CAST([EndofSem_Grade] AS varchar(5)) EndSemesterGrade,
	IIF([Enrolled_Dropped] = 'D', 1, 0) Dropped,
	IIF([Enrolled_Dropped] = 'E', 1, 0) Enrolled
FROM dbo.EnrollmentDetails ed
INNER JOIN dbo.Term t
	ON ed.Term = t.TermAK
WHERE CAST([CRMID] AS int) NOT IN (7148439,7201266,7204322,7270570,7309516,7634219);
GO
/****** Object:  Table [dbo].[StudentProfile] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StudentProfile](
	[StudentProfileID] [int] IDENTITY(1,1) NOT NULL,
	[CRMID] [varchar](50) NULL,
	[LAST_NAME] [varchar](50) NULL,
	[FIRST_NAME] [varchar](50) NULL,
	[MIDDLE_NAME] [varchar](50) NULL,
	[ADMIT_TERM] [varchar](50) NULL,
	[ADMIT_DESCR] [varchar](50) NULL,
	[ACAD_CAREER] [varchar](50) NULL,
	[ADMIT_TYPE] [varchar](50) NULL,
	[ADMIT_TYPE_DESCR] [varchar](50) NULL,
	[APPL_SOURCE] [varchar](50) NULL,
	[ACAD_PROG] [varchar](50) NULL,
	[ACAD_PROG_DESCR] [varchar](50) NULL,
	[ACAD_PLAN] [varchar](50) NULL,
	[ACAD_PLAN_DESCR] [varchar](50) NULL,
	[GENDER] [varchar](50) NULL,
	[AGE_BY_YEARS] [varchar](50) NULL,
	[ADDRESS1] [varchar](50) NULL,
	[ADDRESS2] [varchar](50) NULL,
	[CITY] [varchar](50) NULL,
	[STATE] [varchar](50) NULL,
	[POSTAL] [varchar](50) NULL,
	[CURRENT_PROGRAM] [varchar](50) NULL,
	[CURRENT_PROGRAM_DESCR] [varchar](50) NULL,
	[CURRENT_PLAN] [varchar](50) NULL,
	[CURRENT_PLAN_DESCR] [varchar](50) NULL,
 CONSTRAINT [PK_StudentProfile_StudentProfileID] PRIMARY KEY CLUSTERED 
(
	[StudentProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
SET ANSI_PADDING ON
GO
/****** Object:  View [dbo].[Admission] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Admission]
AS
SELECT 
	CAST(CRMID AS bigint) StudentAK,
	--CAST([ADMIT_TERM] AS int) TermAK,
	CAST(CONVERT( varchar(10),CAST(t.StartDate AS date), 112) AS int) AdmitDateAK,
	CAST([ADMIT_TYPE] AS varchar(5)) AdmitTypeAK,
	LEFT([APPL_SOURCE], 1) ApplicationSourceAK,
	CAST([ACAD_PROG] AS varchar(10)) AcademicProgramAK,
	CAST([ACAD_PLAN] AS varchar(10)) AcademicPlanAK,
	CAST([CURRENT_PROGRAM] AS varchar(10)) CurrentAcademicProgramAK,
	CAST([CURRENT_PLAN] AS varchar(10)) CurrentAcademicPlanAK
FROM dbo.StudentProfile sp
INNER JOIN dbo.Term t
	ON sp.ADMIT_TERM = t.TermAK
GO
/****** Object:  View [dbo].[Student] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Student]
AS
WITH results
AS
(
	SELECT DISTINCT
		ROW_NUMBER() OVER(ORDER BY CRMID) ID,
		CAST(CRMID AS bigint) StudentAK,
		CAST(Gender AS varchar(20)) Gender,
		CAST(AGE_BY_YEARS AS int) Age,
		CAST(CITY AS varchar(75)) City,
		CAST([STATE] AS varchar(3)) StateAbbrev,
		CAST(POSTAL AS varchar(15)) PostalCode,
		CAST(ADMIT_TERM AS int) AdmitTerm,
		First_Name FirstName,
		Last_Name LastName,
		MIDDLE_NAME MiddleName, 
		ADDRESS1 Address1,
		ADDRESS2 Address2
	FROM dbo.StudentProfile
)
SELECT *
FROM results
WHERE
ID IN
(
	SELECT MAX(ID) 
	FROM results GROUP BY StudentAK
)
GO
/****** Object:  View [dbo].[ResidencyStatus] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ResidencyStatus]
AS
SELECT DISTINCT
	CAST(LEFT([InState_OutState], 1) AS char(1)) ResidencyStatusAK,
	CAST(IIF([InState_OutState] = 'NULL', 'Not Available', [InState_OutState]) AS varchar(15)) ResidencyStatus
FROM [dbo].[EnrollmentSummary]
GO
/****** Object:  View [dbo].[Class] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Class]
AS
WITH results
AS
(
	SELECT DISTINCT
		ROW_NUMBER() OVER(ORDER BY [Subject], [Catalog], [Class_Section], [Instruction_Mode]) ID,
		CAST([Subject] AS varchar(10)) SubjectAK,
		CAST([Catalog] AS varchar(10)) CatalogAK,
		CAST([Class_Section] AS varchar(5)) ClassSectionAK,
				CAST(Instruction_Mode AS varchar(35)) InstructionModeAK,
		CAST(Title AS varchar(50)) Title,
		CAST([Course_Credit_Hour] AS int) CourseCreditHours
	FROM [dbo].[EnrollmentDetails]
)
SELECT *
FROM results r
WHERE ID IN
(
	SELECT MAX(ID)
	FROM results
	GROUP BY SubjectAK, ClassSectionAK, CatalogAK, InstructionModeAK
)
GO
/****** Object:  View [dbo].[ApplicationSource] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ApplicationSource]
AS
SELECT DISTINCT
	CAST(LEFT(Appl_Source, 1) AS varchar(3)) ApplicationSourceAK,
	CAST(Appl_Source AS varchar(25)) ApplicationSource
FROM dbo.StudentProfile
GO
/****** Object:  View [dbo].[AdmitType] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AdmitType]
AS
SELECT DISTINCT
	CAST(Admit_Type AS varchar(5)) AdmitTypeAK,
	CAST(Admit_Type_Descr AS varchar(75)) AdmitType
FROM dbo.StudentProfile
GO
/****** Object:  View [dbo].[AcademicLevel] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AcademicLevel]
AS
SELECT DISTINCT 
	CAST(LEFT([Academic_Level], 2) AS varchar(2)) AcademicLevelAK,
	CAST([Academic_Level] AS varchar(25)) AcademicLevel
FROM dbo.EnrollmentSummary
GO
/****** Object:  View [dbo].[AcademicProgram] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[AcademicProgram]
AS
SELECT DISTINCT
	CAST([ACAD_PROG] AS varchar(10)) AcademicProgramAK, 
	CAST([ACAD_PROG_DESCR] AS varchar(50)) AcademicProgram,
	CAST([ACAD_PLAN] AS varchar(10)) AcademicPlanAK, 
	CAST([ACAD_PLAN_DESCR] AS varchar(50)) AcademicPlan
FROM dbo.StudentProfile
WHERE [ACAD_PROG] IS NOT NULL
UNION 
SELECT DISTINCT
	CAST([Current_Program] AS varchar(10)) AcademicProgramAK,  
	CAST([Current_Program_DESCR] AS varchar(50)) AcademicProgram,
	CAST([Current_PLAN] AS varchar(10)) AcademicPlanAK, 
	CAST([Current_PLAN_DESCR] AS varchar(50)) AcademicPlan
FROM dbo.StudentProfile
WHERE [Current_Program] IS NOT NULL
GO
USE [master]
GO
ALTER DATABASE [HigherED_Staging] SET  READ_WRITE 
GO
