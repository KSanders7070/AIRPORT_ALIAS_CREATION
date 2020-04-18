@echo off

TITLE CREATE AIRPORT ALIAS FILES (Beta 1.0)

:HELLO

SET SPLASH_US=SPLASH_US_NotSet

CLS

echo.
echo.
echo -----------------------------------------------------------
echo.
echo       *** RUN THIS FILE IN ADMINISTRATOR MODE ***
echo.
echo   You may want to add an exception to your
echo   virus/malware software for this .bat file.
echo.
echo   It is easier to see all prompts
echo   when this window is full-screen.
echo.
echo   Note: Entries are case-sensative
echo   ALL CAPS is recommended
echo.
echo -----------------------------------------------------------
echo.
echo.

		SET /P SPLASH_US=Type CL to view the change log, or HELP for the help section. Otherwise press Enter: 
			IF /I "%SPLASH_US%"=="HELP" GOTO HELP
			IF /I "%SPLASH_US%"=="CL" GOTO CHANGE_LOG
			GOTO BRIEF

:BRIEF

CLS

echo.
echo.
echo ------------------------------------------------------------------
echo.
echo  The following will take you through easy guided steps
echo  to create all alias commands associated with an airport.
echo.
echo  When done with an airport, go back through the
echo  new alias file and check for errors.
echo.
echo  This system is build with the assumption that all procedures
echo  for an airport will be completed without closing the BATCH File.
echo.
echo  This BATCH File does not take into account two or more airports
echo  using the same procedure (SID/STAR). For those instances, it is
echo  suggested that the user use this BATCH File to make both airports
echo  and then go manually edit the output per your facility methods
echo  for this situation.
echo.
echo  Example:
echo           KBIL and 6S8 both use the BOI DP. As a result,
echo           ZLC would use the following as a response to the
echo           .TCRAFTBIL command:
echo.
echo    This DP serves KBIL and 6S8 airport.
echo    Type the RWY assignment after the command for KBIL such as
echo    {.CRAFTBIL28L}. For 6S8 airport, type {.TCRAFTBIL6S8}.
echo.
echo ------------------------------------------------------------------
echo.
echo.

PAUSE

CLS

echo.
echo.
echo -----------------------------------------------------------
echo.
echo  Create these publications in the order listed below.
echo.
echo  Complete all of one type of publication prior to moving
echo  onto another.
echo.
echo     Example: Complete all IAPs before making
echo              any DPs.
echo.
echo.
echo        1)   APD (airport diagrams)
echo.
echo        2)   IAP (Instrument Approach Procedures)
echo                    -Note: Not including HI-IAPs
echo.
echo        3)   DP (Departure Procedures - ODP/SID)
echo.
echo        4)   STAR (Standard Terminal Arrival Route)
echo.
echo -----------------------------------------------------------
echo.
echo.

PAUSE

CLS

CD "%userprofile%\Desktop"
IF EXIST "%userprofile%\Desktop\BAT ALIASES" GOTO SET_VAR

echo.
echo.
echo -----------------------------------------------------------
echo.
echo  This BATCH File has made a custom directory for exports.
echo.
echo  All exports will be sent here:
echo.
echo.
echo                    Desktop\BAT ALIASES
echo.
echo -----------------------------------------------------------
echo.
echo.

	mkdir "%userprofile%\Desktop\BAT ALIASES"

PAUSE

:SET_VAR

CLS

@REM For testing/debug purposes:

SET PROC_FIXES=PROC_FIXES_NotSet

SET MULTI_IAP=MULTI_IAP_NotSet

SET DP_TRANS=DP_TRANS_NotSet

SET GND_INFO=GND_INFO_NotSet

SET DEP_INS=DEP_INS_NotSet

CLS

:AIRAC

CLS

echo.
echo.
echo -----------------------------------
echo.
echo  Type the 4 digit AIRAC Cycle code
echo.
echo -----------------------------------
echo.
echo.

	set /p AIRAC=Press Enter when done: 

CLS

:AIRPORT

CLS

set TWRD=TWRD_NotSet

set PDC=PDC_NotSet

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo --------------------------------------
echo.
echo  Type the 3 letter airport identifier
echo.
echo --------------------------------------
echo.
echo.

	set /p APT=Press Enter when done: 
	
		START "" https://www.faa.gov/air_traffic/flight_info/aeronav/digital_products/dtpp/search/results/?cycle=%AIRAC%^&ident=%APT%
		
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO  ------ >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO ; K%APT% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO  ------ >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

CLS

:URL

CLS

echo.
echo.
echo -------------------------------------------------------------------
echo.
echo  Open the first page of the first procedure and copy/paste the URL
echo.
echo -------------------------------------------------------------------
echo.
echo  Reminder:
echo            Complete procedures in the following order per airport:
echo            APDs, IAP, DP, then STARs
echo.
echo.

	set /p URL=Copy and Paste the URL for the publication here: 

CLS

:NUM_PAGES

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo -----------------------------------------------
echo.
echo  Are there multiple pages to this publication?
echo.
echo -----------------------------------------------
echo.
echo.

	set /p MULTI_PAGE=Type Y or N and press Enter: 
		IF /I %MULTI_PAGE%==N SET URL2=There Are No Additional Pages for This Procedure
		IF /I %MULTI_PAGE%==N SET URL3=There Are No Additional Pages for This Procedure
		IF /I %MULTI_PAGE%==N GOTO PUBLICATION_TYPE
	
	CLS
	
		set /p URL2=Copy and Paste the URL for the second page here: 
		
		CLS
		
		set /p MULTI_PAGE=Is there a 3rd page to this publication? Type Y or N and press Enter: 
			IF /I %MULTI_PAGE%==N SET URL3=There Are No Additional Pages for This Procedure
			IF /I %MULTI_PAGE%==N GOTO PUBLICATION_TYPE
				
			CLS
	
			set /p URL3=Copy and Paste the URL for the 3rd page here: 

CLS

:PUBLICATION_TYPE

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo -------------------------------------------
echo.
echo  DP = Departure Procedure (ODP, SID)
echo.
echo  STAR = Standard Terminal Arrival Route
echo.
echo  IAP = Instrument Approach PROCEDURE_NAME
echo.
echo  APD = Airport Diagram
echo.
echo -------------------------------------------
echo.
echo.

	set /p PUB_TYPE=Type The Type of Publication (DP, STAR, IAP, APD) and press Enter: 
		IF /I %PUB_TYPE%==APD GOTO CREATE_APD

CLS

IF NOT %TWRD%==TWRD_NotSet GOTO PROCEDURE_NAME

CLS

echo.
echo.
echo -----------------------------------------------
echo.
echo  Does this airport have a Local Control Tower?
echo.
echo -----------------------------------------------
echo.
echo.

set /p TWRD=Type Y or N and press Enter: 

CLS

:PROCEDURE_NAME

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo -------------------------------------------------------------------------------
echo.
echo  Often, you can simply copy and paste the name of the publication but
echo  if not, follow the guidelines below.
echo.
echo.
echo      If the procedure name is VOR A, Type: VOR A
echo.
echo      If the procedure name is RNAV (GPS) Z 19, type exactly that.
echo.
echo      If the publication (same URL) has multiple procedures
echo      such as an ILS OR LOC RWY 12, type just one at a time.
echo          --For example: ILS RWY 12
echo.
echo      After completing the steps for the first of the combined procedures,
echo      the BAT file will prompt you to make the LOC RWY 12 appropriately.
echo.
echo.
echo      For DPs and STARs, type the 3-5 character code without the version number
echo.
echo -------------------------------------------------------------------------------
echo.
echo.

	set /p PROC_NAME=Type the Name of the procedure and press Enter: 
		IF /I %PUB_TYPE%==DP GOTO CREATE_DP_STAR
		IF /I %PUB_TYPE%==STAR GOTO CREATE_DP_STAR
		IF /I %PUB_TYPE%==IAP GOTO CREATE_IAP

CLS

:CREATE_APD

CLS

	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO ;%APT% Airport Diagram >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .K%APT%C .OPENURL %URL% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

CLS

	set /p MORE_PROC=Are there more procedures to make for this airport? Type Y or N and press Enter: 
		CLS
		IF /I  %MORE_PROC%==Y GOTO URL
		GOTO AIRPORT

CLS

:CREATE_IAP

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo  APPROACH ASSIGNMENT SCRATCHPAD STANDARDS
echo.
echo  Approach assignment/request scratch will be placed in the scratchpad
echo  by the controller that is responsible for assigning approach/runway
echo  to pilots.
echo.
echo  Specifics not in the legend below such as HI-ILS/LOC, SA CAT I/II/III,
echo  PRM, Back-course and IAPs alike are not scratched and should be
echo  voice/text coordinated. Variants of the approaches are scracted
echo  such as A/B/C/D/X/Y/Z, if available.
echo.
echo  RNAV GPS vs RNAV RNP are not recognized in the Scratchpad, as their
echo  variant will be different if for the same runway.
echo.
echo  The goal is to keep the scratchpad entry limited to 3 characters.
echo  Therefore, abbreviate the runway assignment to the last digit of the
echo  runway when an approach variant or runway L/R/C designation is present.
echo.
echo       When an approach variant is assigned/requested, along with the
echo       runway having a L/R/C designation, then a 4 character scratchpad
echo       entry is allowed.
echo.
echo  		  Example: Billings (KBIL) RNAV Z 28R approach would be: RZ8R
echo.
echo.
echo -----------------------------------------------------------
echo.
echo     Approach Type:            Scratch:
echo     Visual Approach           V
echo     Contact Approach          C
echo     ILS Approach              I
echo     LOC Approach              L
echo     RNAV Approach             R
echo     VOR Approach              O
echo     NDB Approach              N
echo     SDF Approach              S
echo     LDA Approach              D
echo     TACAN Approach            T
echo.
echo  EXAMPLES:
echo.
echo     Approach Type:      Runway:       Scratchpad Code:
echo     Visual              01            V01
echo     Contact             10R           C0R
echo     ILS                 10            i10
echo     LOC                 10C           L0C
echo     LDA                 10L           D0L
echo.
echo     Approach Type/Variant:    Runway:     Scratchpad Code:
echo     ILS Y                     30          iY0
echo     ILS Y                     30R         iY0R
echo     RNAV Z                    01          RZ1
echo     VOR-A                     n/a         OA
echo.
echo -----------------------------------------------------------
echo.
echo.

	set /p IAP_APP_CODE=Type the Approach Scratchpad Code of the procedure and press Enter: 

CLS
	
	IF /I %MULTI_IAP%==Y GOTO PRINT_IAP
	
		echo.
		echo.
		echo ------------------------------------------------------------------
		echo.
		echo  Type all the five character fixes associated with the procedure.
		echo.
		echo  Separate all fixes with a space.
		echo.
		echo ------------------------------------------------------------------
		echo.
		echo.
		set /p PROC_FIXES=Press Enter when done: 
			IF "%PROC_FIXES%"=="PROC_FIXES_NotSet" SET PROC_FIXES=

CLS

:PRINT_IAP

CLS

SET MULTI_IAP=MULTI_IAP_NotSet

	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO ;%APT% %PROC_NAME% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%APT%%IAP_APP_CODE% .FD %APT% %PROC_NAME% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%APT%%IAP_APP_CODE%C .OPENURL %URL% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%APT%%IAP_APP_CODE%2C .OPENURL %URL2% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%APT%%IAP_APP_CODE%3C .OPENURL %URL3% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%APT%%IAP_APP_CODE%F .FF %PROC_FIXES% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

	set /p MULTI_IAP=Are there more procedures combined into this same publication (URL)? Type Y or N and press Enter: 
		CLS
		IF /I  %MULTI_IAP%==Y GOTO PROCEDURE_NAME
		SET PROC_FIXES=PROC_FIXES_NotSet
		

CLS

	set /p MORE_PROC=Are there more procedures to make for this airport? Type Y or N and press Enter: 
		CLS
		IF /I  %MORE_PROC%==Y GOTO URL
		GOTO AIRPORT

CLS

:CREATE_DP_STAR

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo ----------------------------------------------------------------
echo.
echo  Type all the 5-character fixes associated with the procedure.
echo.
echo  Separate all fixes with a space.
echo.
echo ----------------------------------------------------------------
echo.
echo.

	set /p PROC_FIXES=Press Enter when done: 
		IF "%PROC_FIXES%"=="PROC_FIXES_NotSet" SET PROC_FIXES=

CLS

	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO ;%APT% %PROC_NAME% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%PROC_NAME% .FD %APT% %PROC_NAME% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%PROC_NAME%C .OPENURL %URL% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%PROC_NAME%2C .OPENURL %URL2% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%PROC_NAME%3C .OPENURL %URL3% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%PROC_NAME%F .FF %PROC_FIXES% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

	SET PROC_FIXES=PROC_FIXES_NotSet

CLS

:ISR

	set /p PROC_VERSION=Type Procedure Version Number and press Enter: 

	IF /I %PUB_TYPE%==DP GOTO DP_ISR
	IF /I %PUB_TYPE%==STAR GOTO STAR_ISR

CLS

:DP_ISR

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo -------------------------------------------
echo.
echo  DP TYPE:
echo.
echo.
echo      CHOICES:
echo.
echo            A)   ODP (Non-RNAV)
echo.
echo            B)   ODP (RNAV)
echo.
echo            C)   Vectored (Non-RNAV)
echo.
echo            D)   PilotNav (Non-RNAV)
echo.
echo            E)   Hybrid (Non-RNAV)
echo.
echo            F)   PilotNav (RNAV)
echo.
echo            G)   Hybrid (RNAV)
echo.
echo -------------------------------------------
echo.
echo.

	set /p UserSelected=Type Your Choice (A, B, C, D, E, F, or G) and press Enter: 
		IF /I %UserSelected%==A SET DP_STAR_TYPE=ODP
		IF /I %UserSelected%==B SET DP_STAR_TYPE=RNAV-ODP
		IF /I %UserSelected%==C SET DP_STAR_TYPE=Vectored
		IF /I %UserSelected%==D SET DP_STAR_TYPE=PilotNav
		IF /I %UserSelected%==E SET DP_STAR_TYPE=Hybrid
		IF /I %UserSelected%==F SET DP_STAR_TYPE=RNAV-PilotNav
		IF /I %UserSelected%==G SET DP_STAR_TYPE=RNAV-Hybrid

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo --------------------------------------------
echo.
echo  WHAT RWYs DOES THIS DP SERVE?
echo.
echo.
echo      Response Example if Runways
echo      34L, 34R, and 35 are used by this DP:
echo.
echo                   34L/R, 35
echo.
echo.
echo  Note: "ALL" is an acceptable response.
echo --------------------------------------------
echo.
echo.

	set /p RWYS=Type the runways used by this DP and press Enter: 

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.	
echo.
echo -----------------------------------------------------------------
echo.
echo  DEPARTURE TRANSITIONS
echo.
echo  Place an underscore between each transition instead of a space.
echo.
echo.
echo       EXAMPLE:
echo                KROST_MLF_LO_WINEN
echo.
echo -----------------------------------------------------------------
echo.
echo.

	set /p DP_TRANS=Type the published transitions and press Enter: 
		IF "%DP_TRANS%"=="DP_TRANS_NotSet" SET DP_TRANS=

CLS

:INI_CLB_INS

SET DEL_Climb_ALT= 

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo --------------------------------------------------------------------------
echo.
echo  INITIAL CLIMB INSTRUCTIONS METHOD (issued prior to departure)
echo.
echo         CVS = Climb Via SID
echo.
echo         CVS Exct Maint = Climb Via SID Exept Maintain (# altitude)
echo.
echo         Maintain = Maintain (# altitude)
echo.
echo.
echo  CHOICES:
echo            A)  CVS
echo.
echo            B)  CVS Exct Maint
echo.
echo            C)  Maintain
echo.
echo --------------------------------------------------------------------------
echo.
echo.

	set /p userselected=Type your letter choice and press Enter: 
		IF /I  %userselected%==A SET DEL_Climb_Method=CVS
		IF /I  %userselected%==A GOTO CRZ_ALT
		IF /I  %userselected%==B SET DEL_Climb_Method=CVS Exct Maint
		IF /I  %userselected%==C SET DEL_Climb_Method=Maint

CLS

echo.
echo.
echo ----------------------------------------------------------------------------
echo.
echo  WHAT ALTITUDE IS THE PILOT CLEARED TO INITIALLY PER THE PREVIOUS METHOD?
echo.
echo.    If CVS, just put the highest altitude (Top Altitude) as this altitude.
echo.
echo  EXAMPLES:
echo            FL230, 10k, 9.5k, 12.5k
echo.
echo ----------------------------------------------------------------------------
echo.
echo.

	set /p DEL_Climb_ALT=Type the initial climb altitude (only the number) and press Enter: 

:CRZ_ALT

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo -----------------------------------------------------------------
echo.
echo  EXPECT CRUISE ALTITUDE TIME
echo.
echo     LISTED:
echo              Y = The DP narrative tells the pilot the number of min
echo                  to expect their cruise altitude after departure.
echo.
echo              N = The number of min is stated
echo                  by the ATC providing the DEP CLNC
echo.
echo.
echo       TIME:
echo              # = Number of min after departure.
echo.
echo -----------------------------------------------------------------
echo.
echo.

	set /p UserSelected=Is the expected cruise altitude time published? Type Y or N and press Enter: 
		IF /I %UserSelected%==Y SET EXP_CRZ_LISTED=(Listed)
		IF /I %UserSelected%==N SET EXP_CRZ_LISTED=(Not-LISTED)

echo.

	set /p EXP_CRZ_TIME=Type the number of min the pilot is to expect their cruise altitude after departure and press Enter: 

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo ------------------------------------------------------------------
echo.
echo  STANDARD DEPARTURE FREQUENCY
echo.
echo      It is suggested to use the departure frequency listed on the
echo      DP, as it will allow you to omit that information while
echo      issuing the clearance if that frequency is in use.
echo.
echo      Separate OPS and other conditions by a space, two underscores
echo      and another space.
echo.
echo.
echo      EXAMPLES:
echo                123.45
echo.
echo                (NORTHWEST) 127.20 __ (SOUTHEAST) 124.42
echo.
echo ------------------------------------------------------------------
echo.
echo.

	set /p DEP_FREQ=Type the standard departure frequency listed on the DP and press Enter: 

CLS

		IF /I %TWRD%==Y GOTO LC_INFO
		IF /I %TWRD%==N SET GND_INFO=Airport is not provided Ground Control Services
		IF /I %TWRD%==N SET TWR_DP_INS=Airport is not provided Local (TWR) Control Services
		GOTO DEP_INFO

:LC_INFO

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo -------------------------------------------------------------------
echo.
echo  GROUND INSTRUCTIONS/INFORMATION
echo.
echo  There usually isn't a lot of information to be given to the
echo  ATC providing ground control per a DP except the perferred
echo  RWYs per Local Directives. However, this is a free text response.
echo.
echo    If no specific instructions are needed, simply press enter.
echo.
echo.
echo      EXAMPLES:
echo                PREF-34L
echo.
echo                [Northwestbound] PREF-34R
echo.
echo -------------------------------------------------------------------
echo.
echo.

	set /p GND_INFO=Type the appropriate GND information and press Enter: 
		IF "%GND_INFOS%"=="GND_INFO_NotSet" SET GND_INFO=

CLS

:TWR_INS

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo --------------------------------------------------------------------------
echo.
echo  TOWER INSTRUCTIONS/INFORMATION
echo.
echo       Instructions in parentheses are for situational awareness only.
echo       It is what the pilot is expected to do after departure per the DP.
echo       Instructions not in parentheses are expected to be assigned by TWR.
echo.
echo       Separate OPS and other conditions by a space, two underscores
echo       and another space.
echo.
echo.
echo  EXAMPLE 1:
echo.
echo       (RWY 10L/R)-(Intcpt BOI-098R) __ (RWY 28L/R)-(Intcpt BOI-278R)
echo.
echo.
echo.
echo  EXAMPLE 2:
echo.
echo       (RWY 34L/R, 35) - H280 __ (RWY 16L/R) - RH
echo.
echo --------------------------------------------------------------------------
echo.
echo.

	set /p TWR_DP_INS=Type the appropriate TWR information and press Enter: 

CLS

:DEP_INFO

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo --------------------------------------------------------------------
echo.
echo  TOP ALTITUDE.
echo.
echo.
echo  The Top Altitude of a DP can be ATC Assigned or published
echo  in the graphical or narrative portion of the DP.
echo.
echo  If the Top Altitude is not published, the BAT file will use the
echo  initial climb altitude as the Top Altitude for ISR.
echo.
echo  For the purposes of this BAT File, if the narrative states
echo  something similar to: "Maintain 15,000 or lower assigned",
echo  15k would be the Top Altitude and you should answer
echo  "Y" to this question. 
echo.
echo            Y = The DP has a published Top Altitude
echo.
echo            N = The DP does NOT have a published Top Altitude
echo.
echo --------------------------------------------------------------------
echo.
echo.

	set /p UserSelected=Does the DP have a published Top Altitude? Type Y or N and press Enter: 
		IF /I %UserSelected%==Y GOTO TOPALT_PUB
		IF /I %UserSelected%==N GOTO TOPALT_NotPUB

:TOPALT_PUB

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo ---------------------------------------------------------------------------
echo.
echo  TOP ALTITUDE IS PUBLISHED
echo.
echo.
echo  EXAMPLES:
echo.
echo       FL230
echo.
echo       10k
echo.
echo       7.5k
echo.
echo ---------------------------------------------------------------------------
echo.
echo.

set /p TopAlt=Type the published Top Altitude and press enter: 
	GOTO DEP_INS

CLS

:TOPALT_NotPUB

CLS

SET TopAlt=Not Published

CLS

:DEP_INS

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo -----------------------------------------------------------------
echo.
echo  DEPARTURE CONTROL Instructions/Information.
echo.
echo    If no specific instructions are needed, simply press enter.
echo.
echo.
echo  EXAMPLE:
echo.
echo       Vector to BUBBY AOA 11k / CVS
echo.
echo -----------------------------------------------------------------
echo.
echo.

	set /p DEP_INS=Type the DEP CTRL instructions/info and press enter: 
		IF "%DEP_INS%"=="DEP_INS_NotSet" SET DEP_INS=

CLS

:PRINT_DP_ISR

CLS

ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%PROC_NAME%DEL .MSG ZLC_ISR ***%PROC_NAME% %PROC_VERSION% ::: %DP_STAR_TYPE% ::: RWY %RWYS% ::: %DP_TRANS% ::: %DEL_Climb_Method% %DEL_Climb_ALT% ::: CRZ-%EXP_CRZ_TIME%min%EXP_CRZ_LISTED% ::: DEP FREQ %DEP_FREQ% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%PROC_NAME%GND .MSG ZLC_ISR ***%PROC_NAME% %PROC_VERSION% ::: RWY %RWYS% ::: %GND_INFO% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%PROC_NAME%TWR .MSG ZLC_ISR ***%PROC_NAME% %PROC_VERSION% ::: %DP_STAR_TYPE% ::: %TWR_DP_INS% ::: DEP FREQ %DEP_FREQ% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%PROC_NAME%DEP .MSG ZLC_ISR ***%PROC_NAME% %PROC_VERSION% ::: %DP_STAR_TYPE% ::: %DEL_Climb_Method% %DEL_Climb_ALT% issued by DEL ::: CRZ-%EXP_CRZ_TIME%min%EXP_CRZ_LISTED% ::: TopAlt %TopAlt% ::: %DEP_INS% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%PROC_NAME%CTR .MSG ZLC_ISR ***%PROC_NAME% %PROC_VERSION% ::: CRZ-%EXP_CRZ_TIME%min%EXP_CRZ_LISTED% ::: TopAlt %TopAlt% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

CLS

:DP_PILOT_TEXT

IF /I  %DEL_Climb_Method%==CVS SET DEL_Climb_Method_TEXT=Climb Via SID
IF /I  %DEL_Climb_Method%==CVS Exct Maint SET DEL_Climb_Method_TEXT=Climb Via SID Except Maintain
IF /I  %DEL_Climb_Method%==Maint SET DEL_Climb_Method_TEXT=Maintain

IF /I %TWRD%==N SET HFR=Hold For Release

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo ------------------------------------------------
echo.
echo  TEXT-TO-PILOT DEPARTURE CLEARANCE
echo  SPECIAL INSTRUCTIONS
echo.
echo.
echo   EXAMPLES:
echo.
echo      Maintain 230kts
echo.
echo      Fly Heading 270, expect vectors on course
echo.
echo ------------------------------------------------
echo.
echo.

set /p TEXT_DEP_INS=Type the special departure instructions (if any) and press Enter: 

CLS


:DP_PILOT_TEXT_CRAFT

ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .TCRAFT%PROC_NAME% Cleared to $arr, $route. %DEL_Climb_Method_TEXT% %DEL_Climb_ALT%. Expect $cruise %EXP_CRZ_TIME%min after departure. Departure frequency $freq($1), squawk $squawk. %TEXT_DEP_INS%. %HFR% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

IF /I  %PDC%==N GOTO QUERY_MORE_PROC_AFTER__DP_PDC
IF /I  %PDC%==Y GOTO WRITE_PDC

:DP_PILOT_TEXT_PDC

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.

set /p PDC=Does this airport issue clearances via PDC? Type Y or N and press Enter: 
	CLS
	IF /I  %PDC%==N GOTO QUERY_MORE_PROC_AFTER__DP_PDC

:WRITE_PDC

ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO .TPDC%PROC_NAME% .msg $aircraft *** PRE-DEPARTURE ATC CLEARANCE *** $aircraft $cruise $type($aircraft) TRANSPONDER $squawk ROUTE: $dep $route $arr ******* %DEL_Climb_Method_TEXT% %DEL_Climb_ALT%, %SPEC_DEP_INS% * DEP FREQ $freq($1) * PDC RECEIVED AT $timeZ *** RPLY NOT RQRD.. CTC APPROPRIATE CLNC DEL WITH QUESTIONS *** >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO .TPDC%PROC_NAME%U .msg $aircraft *** PRE-DEPARTURE ATC CLEARANCE *** $aircraft $cruise $type($aircraft) TRANSPONDER $squawk ROUTE: $dep $route $arr ******* %DEL_Climb_Method_TEXT% %DEL_Climb_ALT%, %SPEC_DEP_INS% * DEP FREQ $freq($1) * PDC RECEIVED AT $timeZ *** RPLY NOT RQRD.. CTC APPROPRIATE CLNC DEL WITH QUESTIONS *** >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

CLS

:QUERY_MORE_PROC_AFTER__DP_PDC

set /p MORE_PROC=Are there more procedures to make for this airport? Type Y or N and press Enter: 
	CLS
	IF /I  %MORE_PROC%==Y GOTO URL
	GOTO AIRPORT

CLS

:STAR_ISR

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo -------------------------------------------
echo.
echo  STAR TYPE:
echo.
echo.
echo      CHOICES:
echo.
echo             R = RNAV
echo.
echo            NR = Non-RNAV
echo.
echo -------------------------------------------
echo.
echo.

	set /p UserSelected=Type Your Choice (R or NR) and press Enter: 
		IF /I %UserSelected%==R SET DP_STAR_TYPE=RNAV
		IF /I %UserSelected%==NR SET DP_STAR_TYPE=Non-RNAV

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo --------------------------------------------------------------------------------------
echo.
echo  CTR INSTRUCTIONS
echo.
echo  This is a free text response for notes to the Center ATC concerning
echo  what instructions to issue the pilot per the STAR.
echo.
echo  The amount of variables that can be included in this step
echo  are countless. Therefore, here are a few examples below.
echo.
echo  Separate OPS and other conditions by a space, two underscores
echo  and another space.
echo.
echo.
echo  EXAMPLES:
echo.
echo  JAMMN @ 17k(J)
echo.
echo  FRNZY or NEEBO @15k(J)
echo.
echo  [SOUTH OPS] BEARR @ 17k(J) __ 16k(Other) __ [NORTH OPS] BEARR @ 17k(J) __ 15k(Other)
echo.
echo  [EAST and WEST OPS] Descend via/BOI Landing (East or West)
echo.
echo  [EAST OPS] @ LIBBY Clrd RNAV Z 10R __ [WEST OPS] @ CAMML Clrd RNAV X 28L
echo.
echo --------------------------------------------------------------------------------------
echo.
echo.

	set /p CTR_INS=Type the appropriate CTR instructions and press Enter: 

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo -------------------------------------------------------------------------------------------------
echo.
echo  APP INSTRUCTIONS
echo.
echo  This is a free text response for notes to the APP ATC concerning
echo  what instructions to issue the pilot per the STAR.
echo.
echo  The amount of variables that can be included in this step
echo  are countless. Therefore, here are a few examples below.
echo.
echo  Separate OPS and other conditions by a space, two underscores
echo  and another space.
echo.
echo.
echo  EXAMPLES:
echo.
echo  Descend Via/@ PLAGE Clrd ILS 34R
echo.
echo  Descend via/Expt 16R (210kts midfield prior to HO to Final)
echo.
echo  [EAST OPS] @ EKEME Clrd RNAV Z 10R __ [WEST OPS] @ CELOR Clrd RNAV Z 28L
echo.
echo  [SOUTH OPS] CARTR @ 15k(J). SLC Landing South __ [NORTH OPS] CARTR @ FL190(J) SLC Landing North
echo.
echo.
echo -------------------------------------------------------------------------------------------------
echo.
echo.

	set /p APP_INS=Type the appropriate APP instructions and press Enter: 

ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%PROC_NAME%CTR .MSG ZLC_ISR ***%PROC_NAME% %PROC_VERSION% ::: %DP_STAR_TYPE% ::: %CTR_INS% ::: A$altim(K%APT%) >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%PROC_NAME%APP .MSG ZLC_ISR ***%PROC_NAME% %PROC_VERSION% ::: %DP_STAR_TYPE% ::: %APP_INS% ::: A$altim(K%APT%) >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

CLS

:STAR_PILOT_TEXT

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo -------------------------------------------------
echo.
echo  ARRIVAL AIRPORT OPS DIRECTION
echo.
echo.
echo   EXAMPLE:
echo.
echo      N  =  Landing and Departing North
echo      S  =  Landing and Departing South
echo      E  =  Landing and Departing East
echo      W  =  Landing and Departing West
echo.
echo -------------------------------------------------
echo.
echo.

set /p OPS=Type the corresponding letter for the OPS direction (if any) and press Enter: 

	IF /I  %OPS%==N SET OPS_Text=North
	IF /I  %OPS%==S SET OPS_Text=South
	IF /I  %OPS%==E SET OPS_Text=East
	IF /I  %OPS%==W SET OPS_Text=West

CLS

:STAR_PILOT_TEXT_CTR

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo -------------------------------------------------
echo.
echo  TEXT-TO-PILOT
echo  CTR ARRIVAL INSTRUCTIONS PER %OPS%-OPS
echo.
echo.
echo   EXAMPLE:
echo.
echo      Cross SPANE at and maintain FL190 and 280kts
echo.
echo -------------------------------------------------
echo.
echo.

set /p CTR_ARR_INS=Type the special arrival instructions by CTR (if any) and press Enter: 

CLS

ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .T%PROC_NAME%CTR%OPS% %CTR_ARR_INS%. %APT% Landing %OPS_Text%. Altimeter A$altim(K%APT%) >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

:STAR_PILOT_TEXT_APP

CLS

echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo AIRAC CYCLE - %AIRAC%
echo AIRPORT - %APT%
echo PUBLICATION TYPE - %PUB_TYPE%
echo PUBLICATION NAME - %PROC_NAME%
echo PROCEDURE VERSION - %PROC_VERSION%
echo PROCEDURE TYPE - %DP_STAR_TYPE%
echo.
echo * * * * * * * * * * * * * * * * * * * * * * * *
echo.
echo.
echo --------------------------------------------------------------------------------------
echo.
echo  TEXT-TO-PILOT
echo  APP ARRIVAL INSTRUCTIONS PER %OPS%-OPS
echo.
echo.
echo   EXAMPLES:
echo.
echo      Maintain 210kts. Descend via the LEEHY5 arrival. At PLAGE Clrd ILS 34R approach.
echo.
echo      Descend via the LEEHY5 arrival. Expect Visual Approach RWY 16R.
echo.
echo ---------------------------------------------------------------------------------------
echo.
echo.

set /p APP_ARR_INS=Type the arrival instructions by APP and press Enter: 

CLS

ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .T%PROC_NAME%APP%OPS% %APP_ARR_INS%. Altimeter A$altim(K%APT%) >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

CLS

set /p userselected=Are there more OPS conditions for this STAR? Type Y or N and press Enter: 
	IF /I  %userselected%==Y GOTO STAR_PILOT_TEXT

CLS

set /p MORE_PROC=Are there more procedures to make for this airport? Type Y or N and press Enter: 
	CLS
	IF /I  %MORE_PROC%==Y GOTO URL
	GOTO AIRPORT

:DONE

CLS

TIMEOUT 60
EXIT /B

:HELP

@REM IF THE USER TYPED HELP IN THE :HELLO FUNCTION, THE BATCH FILE SKIPS TO HERE.

CLS

ECHO.
ECHO.
ECHO   CHOOSE YOUR ISSUE:
ECHO.
ECHO         A)   HOW DO I RUN THIS BATCH FILE IN ADMINISTRATOR MODE?
ECHO.
ECHO         B)   MY ANTI-VIRUS/MALWARE SOFTWARE IS BLOCKING THIS BATCH FILE
ECHO.
ECHO         C)   WINDOWS WON'T ALLOW THE BATCH FILE TO RUN
ECHO.
ECHO         D)   HOW DO I EDIT THIS BATCH FILE?
ECHO.
ECHO         E)   IS THIS FILE SAFE TO RUN? WHAT DOES IT DO?
ECHO.
ECHO         F)   I DON'T UNDERSTAND THE OUTPUT SYNTAX.
ECHO.
ECHO         G)   OTHER/STILL HAVING ISSUES/CONTACT ORIGINAL AUTHOR
ECHO.
ECHO         H)   NEVERMIND
ECHO.
ECHO.

@REM USER SELECTS THE LETTER OF THEIR ISSUE AND THE BATCH FILE SKIPS TO THAT FUNCTION.

	set /p userselected=Type Your Response (A - G) and Press Enter: 
		IF /I %userselected%==A GOTO ADMIN_MODE
		IF /I %userselected%==B GOTO ANTI_VIRUS
		IF /I %userselected%==C GOTO WDS_EXCLUSION
		IF /I %userselected%==D GOTO CREATE_BAT
		IF /I %userselected%==E GOTO SAFE_ABOUT
		IF /I %userselected%==F GOTO SYNTAX
		IF /I %userselected%==G GOTO CONTACT_AUTHOR
		IF /I %userselected%==H GOTO HELLO
		
		echo.
		echo.
		echo.
		echo.
		echo  %userselected% IS NOT A RECOGNIZED RESPONSE. Try again.
		echo.
		
		PAUSE
		CLS
		GOTO HELP

:ADMIN_MODE

CLS

START "" https://fossbytes.com/batch-file-run-as-administrator-windows/

ECHO.
ECHO.
ECHO   This is done by simply right clicking the BAT file and selecting:
ECHO   "Run as Administrator"
ECHO.
ECHO   However, this BATCH File should have opened the link just now to
ECHO   the instructions for opening this BATCH file in ADMIN MODE automatically.
ECHO.
ECHO.

PAUSE
CLS
GOTO HELLO

:ANTI_VIRUS

CLS

ECHO.
ECHO.
ECHO What ANTI-VIRUS/MALWARE SOFTWARE DO YOU USE?
ECHO.
ECHO.

@REM THE USER TYPES THE SOFTWARE THEY USE AND THE RESPONSE IS INPUT INTO THE GOOGLE LINK APPROPRIATELY.

	set /p userselected=Type Your Response and Press Enter: 

START "" "https://www.google.com/?gws_rd=ssl#q=ADD+BATCH+FILE+TO+%USERSELECTED%+EXCLUSION+LIST"

CLS

ECHO.
ECHO.
ECHO   This BATCH File should have opened the link just now to
ECHO   the instructions for adding a BATCH file to your
ECHO   anti-virus/malware software exlcusion list.
ECHO.
ECHO.

PAUSE
CLS
GOTO HELLO

:WDS_EXCLUSION

CLS

START "" https://winaero.com/blog/exclusions-windows-defender-windows-10/

ECHO.
ECHO   This BATCH File should have opened the link just now to
ECHO   the instructions for adding a BATCH file to your Windows
ECHO   exclusion list.
ECHO.
ECHO.

PAUSE
CLS
GOTO HELLO

:CREATE_BAT

CLS

START "" "https://www.google.com/?gws_rd=ssl#q=HOW+TO+WRITE+BATCH+FILES"

ECHO.
ECHO.
ECHO   This is done by simply right clicking the BAT file and
ECHO    selecting "EDIT".
ECHO.
ECHO   This BATCH File should have opened the link just now to
ECHO   the instructions for editing a BATCH file.
ECHO.
ECHO   If you are still stuck, consider contacting the
ECHO   original authors.
ECHO.
ECHO.

PAUSE
CLS
GOTO HELLO

:SAFE_ABOUT

CLS

START "" "https://www.google.com/search?q=what+is+a+batch+file&oq=what+is+a+batch+file"

ECHO.
ECHO.
ECHO This is what is called a BATCH File.
ECHO For more information, read/watch the material in the google search
ECHO launched in your default internet browser.
ECHO.
ECHO This BATCH File will do the following:
ECHO.
ECHO     Open your default internet browser to a command reference
ECHO     page that the alias syntax was build from. Use this for
ECHO     referencing how the alias commands will work.
ECHO.
ECHO     Create a folder on your Desktop.
ECHO     This will be used to save the alias files created for you.
ECHO.
ECHO     Create .txt files in VRC alias format with the variables
ECHO     that you input.
ECHO.
ECHO     This BATCH File does not modify ANY of your core computer
ECHO     files or programs. It never touches the registry or any
ECHO     core compentents of your OS.
ECHO.
ECHO     With that being said, there are times that the BATCH File
ECHO     will not work correctly if not ran as "Administrator" and
ECHO     not given exclusions to your windows/custom
ECHO     anti-virus/malware software.
ECHO.
ECHO     If you have any further questions, you may right click on
ECHO     the BATCH File and select "Edit" to read the code yourself,
ECHO     have a knowledgable friend look at it first or contact the
ECHO     original author with any questions.
ECHO.
ECHO.

PAUSE
CLS
GOTO HELLO

:SYNTAX

CLS

START "" "https://rc.zlcartcc.com/tiki-index.php?page=Command_References"

ECHO.
ECHO.
ECHO Your internet browser has been opened to the
ECHO vZLC ARTCC Command Reference page that this
ECHO alias file was based off of.
ECHO.
ECHO.

PAUSE
CLS
GOTO HELLO

:CONTACT_AUTHOR

CLS

echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo   STILL HAVING ISSUES OR HAVE FURTHER QUESTIONS?
echo.
echo   Contact the original author of this BATCH File.
echo.
echo.
echo.
echo -----------------------------------------------------------------------------
echo.
echo             Original Author: Kyle Sanders (VATSIM CID 1187147)
echo.
echo -----------------------------------------------------------------------------
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.

PAUSE
CLS
GOTO HELLO

:CHANGE_LOG

CLS


ECHO * * * * * * * * * * * * *
ECHO    VERSION: BETA 1.0
ECHO    DATE:    17APR2020
ECHO * * * * * * * * * * * * *
ECHO.
ECHO    Initial release and testing
echo.
echo.

pause

GOTO HELLO