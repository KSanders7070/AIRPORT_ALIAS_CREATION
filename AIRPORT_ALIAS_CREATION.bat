@echo off
setlocal enabledelayedexpansion

	:: Set THIS_VERSION to the version of this batch file script
	set THIS_VERSION=1.1.01

	:: Set SCRIPT_NAME to the name of this batch file script
	set SCRIPT_NAME=AIRPORT ALIAS CREATION

	:: Set GH_USER_NAME to your GitHub username here
	set GH_USER_NAME=KSanders7070

	:: Set GH_REPO_NAME to your GitHub repository name here
	set GH_REPO_NAME=AIRPORT_ALIAS_CREATION

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	TITLE !SCRIPT_NAME! (v!THIS_VERSION!)

:SetUpTempDir

	:: Setting up the Temp Directory
	CD /D "%temp%"
		IF exist "!GH_REPO_NAME!-UDPATE" RD /S /Q "!GH_REPO_NAME!-UDPATE"
		MD "!GH_REPO_NAME!-UDPATE"
		
	CD /D "!GH_REPO_NAME!-UDPATE"

:GetLatestVerNum

	:: URL to fetch JSON data from GitHub API
	set "GH_LATEST_RLS_PAGE=https://api.github.com/repos/!GH_USER_NAME!/!GH_REPO_NAME!/releases/latest"
	set "URL_TO_DOWNLOAD=!GH_LATEST_RLS_PAGE!"
	set "LATEST_VERSION="
	
	:RedirectLooop

		if exist response.json del /Q response.json
		
		:: Use CURL to download the JSON data
		curl -s -o response.json !URL_TO_DOWNLOAD!
		
			if not exist "response.json" (
			
			ECHO.
			ECHO.
			ECHO -------
			ECHO  ERROR
			ECHO -------
			ECHO.
			ECHO Something went wrong with downloading the latest release information.
			ECHO.
			ECHO.
			ECHO Press any key to continue with this version of the batch file or
			ECHO just close this window...
			ECHO NOTE-I will open the releases page for you to see if there is a newer version.
			
			PAUSE>NUL
			START "" "!GH_LATEST_RLS_PAGE!"
			GOTO UpdateCleanUp
			)
		
		::Check if "exceeded" is present in the JSON, if so it likely means the API Call limit has been reached.
		findstr /C:"exceeded" response.json
			if "%errorlevel%"=="0" (
				ECHO.
				ECHO.
				ECHO -------
				ECHO  ERROR
				ECHO -------
				ECHO.
				ECHO While trying to get the latest version number for this batch file from GitHub,
				ECHO I found that the number of requests has been exceeded.
				ECHO You can try again in a while.
				ECHO.
				ECHO.
				ECHO Press any key to continue with this version of the batch file or
				ECHO just close this window...
				ECHO NOTE-I will open the releases page for you to see if there is a newer version.
				
				PAUSE>NUL
				START "" "!GH_LATEST_RLS_PAGE!"
				GOTO UpdateCleanUp
			)
				
		:: Check if "tag_name" is present in the JSON.
		findstr /C:"tag_name" response.json
			if "%errorlevel%"=="0" (
				:: tag_name Found in file which means there was no redirect or this is the final redirect
				:: page and has the version number on it.
				:: Extract the text between the second set of quotes and remove the first character (usually a lower case v).
				for /f "tokens=2 delims=:" %%a in ('findstr /C:"tag_name" response.json') do (
					set "LATEST_VERSION=%%~a"
					set "LATEST_VERSION=!LATEST_VERSION:~3,-2!"
				)
			) else (
				:: tag_name was not found which means that this is likely a redirect page.
				:: Extract the line that has "https://api." and grab the URL between the second set of quotes.
				:: Feed this URL back through the loop to see if this one redirects too. If it does, keep following until tag_name is found.
				for /f "tokens=1,* delims=" %%a in ('findstr /C:"https://api." response.json') do (
					set "URL_TO_DOWNLOAD=%%~a"
					set "URL_TO_DOWNLOAD=!URL_TO_DOWNLOAD:~10,-2!"
				)
				goto RedirectLooop
			)

:DoYouHaveLatest
	
	:: If the current version matches the latest version available, contine on with normal code.
	if /i "!THIS_VERSION!"=="!LATEST_VERSION!" goto UpdateCleanUp

:UpdateAvailablePrompt

	cls
	
	ECHO.
	ECHO.
	ECHO * * * * * * * * * * * * *
	ECHO     UPDATE AVAILABLE
	ECHO * * * * * * * * * * * * *
	ECHO.
	ECHO.
	ECHO GITHUB VERSION: !LATEST_VERSION!
	ECHO YOUR VERSION:   !THIS_VERSION!
	ECHO.
	ECHO.
	ECHO.
	ECHO  CHOICES:
	ECHO.
	ECHO     U   -   MANUALLY DOWNLOAD THE NEWEST BATCH FILE UPDATE AND USE THAT FILE.
	ECHO.
	ECHO     C   -   CONTINUE USING THIS FILE.
	ECHO.
	ECHO.
	ECHO.

	SET UPDATE_CHOICE=NO_CHOICE_MADE

	SET /p UPDATE_CHOICE=Please type either M, or C and press Enter: 
		if /I %UPDATE_CHOICE%==U GOTO UPDATE
		if /I %UPDATE_CHOICE%==C GOTO UpdateCleanUp
		goto UpdateAvailablePrompt
	
:UPDATE
	
	set GH_LATEST_RLS_PAGE=https://github.com/!GH_USER_NAME!/!GH_REPO_NAME!/releases/latest
	
	CLS
	
	START "" "!GH_LATEST_RLS_PAGE!"
	
	ECHO.
	ECHO.
	ECHO GO TO THE FOLLOWING WEBSITE, DOWNLOAD AND USE THE LATEST VERSION OF %~nx0
	ECHO.
	ECHO    !GH_LATEST_RLS_PAGE!
	ECHO.
	ECHO Press any key to exit...
	
	pause>nul
	
	exit

:UpdateCleanUp

	cls
	
	CD /D "%temp%"
		IF exist "!GH_REPO_NAME!-UDPATE" RD /S /Q "!GH_REPO_NAME!-UDPATE"
	
	:: Ensures the directory is back to where this batch file is hosted.
	CD /D "%~dp0"

:RestOfCode

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
echo     CHOICES:
ECHO.
ECHO                HELP = Having trouble or have questions
echo.
ECHO                DONE = Time to combined all of the .txt
echo                       files together.
echo.
echo -----------------------------------------------------------
echo.
echo.

		SET /P SPLASH_US=Type HELP, CL, or DONE. Otherwise press Enter: 
			IF /I "%SPLASH_US%"=="HELP" GOTO HELP
			IF /I "%SPLASH_US%"=="CL" GOTO CHANGE_LOG
			IF /I "%SPLASH_US%"=="DONE" GOTO EXPORT
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
echo        1)   IAP (Instrument Approach Procedures)
echo                    -Note: Not including HI-IAPs
echo.
echo        2)   DP (Departure Procedures - ODP/SID)
echo.
echo        3)   STAR (Standard Terminal Arrival Route)
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
echo      %userprofile%\Desktop
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

:ARTCC

CLS

echo.
echo.
echo ----------------------------
echo.
echo  Type the 3LD of the ARTCC
echo.
echo ---------------------------
echo.
echo.

	set /p ARTCC=Press Enter when done: 

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

set HFR=

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
echo ---------------------------------
echo.
echo  Type the FAA airport identifier
echo.
echo          * NOT ICAO *
echo.
echo ----------------------------------
echo.
echo.
	
	:APT_CHOICE
	
	SET APT=APT_RESET

	set /p APT=Press Enter when done: 
	
		START "" https://www.faa.gov/air_traffic/flight_info/aeronav/digital_products/dtpp/search/results/?cycle=%AIRAC%^&ident=%APT%
		
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO  ------------- >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO ; %APT% AIRPORT >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO  ------------- >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
		ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

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
echo  IAP = Instrument Approach
echo.
echo  DP = Departure Procedure (ODP, SID)
echo.
echo  STAR = Standard Terminal Arrival Route
echo.
echo -------------------------------------------
echo.
echo.
	
	:PUB_TYPE_CHOICE
	
	SET PUB_TYPE=PUB_TYPE_RESET

	set /p PUB_TYPE=Type The Type of Publication (IAP, DP, STAR) and press Enter: 
		IF /I %PUB_TYPE%==DP GOTO TWRD_QUERY
		IF /I %PUB_TYPE%==STAR GOTO TWRD_QUERY
		IF /I %PUB_TYPE%==IAP GOTO TWRD_QUERY
			echo.
			echo.
			echo.
			echo.
			echo  %PUB_TYPE% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO PUB_TYPE_CHOICE
		
:TWRD_QUERY

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

:TWRD_CHOICE

set /p TWRD=Type Y or N and press Enter: 
		IF /I %TWRD%==Y GOTO PROCEDURE_NAME
		IF /I %TWRD%==N GOTO PROCEDURE_NAME
			echo.
			echo.
			echo.
			echo.
			echo  %TWRD% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO TWRD_CHOICE

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
echo      For DPs and STARs, type the 2-5 character code without the version number
echo.
echo -------------------------------------------------------------------------------
echo.
echo.

	:PROC_NAME_CHOICE

	SET PROC_NAME=PROC_NAME_RESET
	
	set /p PROC_NAME=Type the Name of the procedure and press Enter: 
		IF /I %PUB_TYPE%==DP GOTO CREATE_DP_STAR
		IF /I %PUB_TYPE%==STAR GOTO CREATE_DP_STAR
		IF /I %PUB_TYPE%==IAP GOTO CREATE_IAP
		GOTO PROC_NAME_CHOICE

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
echo     Approach Type:       Scratchpad prefix:
echo     Visual               V
echo     Contact              C
echo     ILS                  I
echo     LOC                  L
echo     RNAV                 R
echo     GPS                  G
echo     VOR                  O
echo     VOR/DME              E
echo     NDB                  N
echo     SDF                  S
echo     LDA                  D
echo     TACAN                T
echo     ILS/DME              J
echo     LOC/DME              K
echo     VOR/DME              F
echo     LDA/DME              A
echo     NDB/DME              B
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
echo     RNAV X                    31          RX1
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
		echo ------------------------------------------------------
		echo.
		echo  Type all the points associated with the procedure.
		echo.
		echo  Separate all fixes with a space.
		echo.
		echo ------------------------------------------------------
		echo.
		echo.
		
		SET PROC_FIXES=PROC_FIXES_NotSet
		
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
	ECHO .%APT%%IAP_APP_CODE% .FD %APT%_%PROC_NAME% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%APT%%IAP_APP_CODE%C .OPENURL %URL% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%APT%%IAP_APP_CODE%2C .OPENURL %URL2% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%APT%%IAP_APP_CODE%3C .OPENURL %URL3% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	ECHO .%APT%%IAP_APP_CODE%F .FF %PROC_FIXES% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
	
	echo.
	echo * * * * * * * * * * * * * * * * * * * * * * * *
	echo.
	echo AIRAC CYCLE - %AIRAC%
	echo AIRPORT - %APT%
	echo PUBLICATION TYPE - %PUB_TYPE%
	echo PUBLICATION NAME - %PROC_NAME%
	echo.
	echo * * * * * * * * * * * * * * * * * * * * * * * *
	ECHO.
	ECHO.
	echo ---------------------------------------------------------------------
	echo.
	ECHO  Are there more procedures combined into this same publication (URL)
	echo.
	echo ---------------------------------------------------------------------
	ECHO.
	ECHO.
	
	:MULTI_IAP_655
	
	SET MULTI_IAP=MULTI_IAP_RESET

	set /p MULTI_IAP=Type Y or N and press Enter: 
		CLS
		IF /I  %MULTI_IAP%==Y GOTO PROCEDURE_NAME
		IF /I  %MULTI_IAP%==N GOTO MORE_PROC_675

			echo.
			echo.
			echo.
			echo.
			echo  %MULTI_IAP% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO MULTI_IAP_655
		
CLS

:MORE_PROC_675

SET PROC_FIXES=PROC_FIXES_NotSet

ECHO.
ECHO.
ECHO -----------------------------------------------------
ECHO.
ECHO     Are there more procedures to make for %APT%?
ECHO.
ECHO -----------------------------------------------------
ECHO.
ECHO.

	:MORE_PROC_CHOICE_685
	
	SET MORE_PROC=MORE_PROC_RESET
	
	set /p MORE_PROC=Type Y or N and press Enter: 
		CLS
		IF /I %MORE_PROC%==Y GOTO PUBLICATION_TYPE
		IF /I %MORE_PROC%==N GOTO AIRPORT
			echo.
			echo.
			echo.
			echo.
			echo  %MORE_PROC% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO MORE_PROC_CHOICE_685
			
CLS

:CREATE_DP_STAR

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
	ECHO .%APT%%PROC_NAME% .FD %APT%_%PROC_NAME% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

CLS

:ISR

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
echo ------------------------------------
echo.
echo  WHAT VERSION (#) IS THIS PROCEDURE
echo.
echo ------------------------------------
echo.
echo.

	set /p PROC_VERSION=Type Procedure Version Number and press Enter: 

	IF /I %PUB_TYPE%==DP GOTO DP_ISR
	IF /I %PUB_TYPE%==STAR GOTO STAR_ISR

CLS

:DP_ISR

CLS

SET ODP_PHRASE=

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
echo            A)   ODP
echo.
echo            B)   ODP (RNAV)
echo.
echo            C)   Vectored
echo.
echo            D)   PilotNav
echo.
echo            E)   Hybrid
echo.
echo            F)   PilotNav (RNAV)
echo.
echo            G)   Hybrid (RNAV)
echo.
echo -------------------------------------------
echo.
echo.

	:DP_STAR_TYPE_CHOICE_860

	SET UserSelected=UserSelected_RESET
	
	set /p UserSelected=Type Your Choice (A, B, C, D, E, F, or G) and press Enter: 
		IF /I %UserSelected%==UserSelected_RESET GOTO DP_STAR_TYPE_CHOICE_860
		IF /I %UserSelected%==A SET DP_STAR_TYPE=ODP
		IF /I %UserSelected%==B SET DP_STAR_TYPE=RNAV-ODP
		IF /I %UserSelected%==C SET DP_STAR_TYPE=Vectored
		IF /I %UserSelected%==D SET DP_STAR_TYPE=PilotNav
		IF /I %UserSelected%==E SET DP_STAR_TYPE=Hybrid
		IF /I %UserSelected%==F SET DP_STAR_TYPE=RNAV-PilotNav
		IF /I %UserSelected%==G SET DP_STAR_TYPE=RNAV-Hybrid
		
		IF /I %DP_STAR_TYPE%==ODP SET ODP_PHRASE=Depart via the %PROC_NAME%%PROC_VERSION% Obstacle Departure Procedure.
		IF /I %DP_STAR_TYPE%==RNAV-ODP SET ODP_PHRASE=Depart via the %PROC_NAME%%PROC_VERSION% Obstacle Departure Procedure.
		
		IF /I %UserSelected%==A GOTO WHAT_RWY
		IF /I %UserSelected%==B GOTO WHAT_RWY
		IF /I %UserSelected%==C GOTO WHAT_RWY
		IF /I %UserSelected%==D GOTO WHAT_RWY
		IF /I %UserSelected%==E GOTO WHAT_RWY
		IF /I %UserSelected%==F GOTO WHAT_RWY
		IF /I %UserSelected%==G GOTO WHAT_RWY
		
			ECHO.
			ECHO.
			ECHO  %UserSelected% IS NOT A RECOGNIZED RESPONSE. Try again.
			goto DP_STAR_TYPE_CHOICE_860


:WHAT_RWY

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

SET DP_TRANS=DP_TRANS_NotSet

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

	:INI_CLB_CHOICE
	
	SET userselected=userselected_RESET

	set /p userselected=Type your letter choice and press Enter: 
		IF /I  %userselected%==A SET DEL_Climb_Method=CVS
		IF /I  %userselected%==A GOTO CRZ_ALT
		IF /I  %userselected%==B SET DEL_Climb_Method=CVS Exct Maint
		IF /I  %userselected%==C SET DEL_Climb_Method=Maint
		
		IF /I  %userselected%==B GOTO INPUT_ALT
		IF /I  %userselected%==C GOTO INPUT_ALT
		
			echo.
			echo.
			echo.
			echo.
			echo  %UserSelected% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO INI_CLB_CHOICE

CLS

:INPUT_ALT

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

	:EXP_CRZ_YN
	
	set /p UserSelected=Is the expected cruise altitude time published? Type Y or N and press Enter: 
		IF /I %UserSelected%==Y SET EXP_CRZ_LISTED=(Listed)
		IF /I %UserSelected%==N SET EXP_CRZ_LISTED=(Not-Listed)
		
		IF /I %UserSelected%==Y GOTO EXP_CRZ_NUM
		IF /I %UserSelected%==N GOTO EXP_CRZ_NUM

			echo.
			echo.
			echo.
			echo.
			echo  %UserSelected% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO EXP_CRZ_YN

echo.

:EXP_CRZ_NUM

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

	set GND_INFO=GND_INFO_NotSet

	set /p GND_INFO=Type the appropriate GND information and press Enter: 
		IF "%GND_INFO%"=="GND_INFO_NotSet" SET GND_INFO=

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

SET TWR_DP_INS=TWR_DP_INS_Not_Set

	set /p TWR_DP_INS=Type the appropriate TWR information and press Enter: 
		IF "%TWR_DP_INS%"=="TWR_DP_INS_Not_Set" SET TWR_DP_INS=

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

	:DP_PUB_ALT_YN
	
	set userselected=userselected_reset

	set /p UserSelected=Does the DP have a published Top Altitude? Type Y or N and press Enter: 
		IF /I %UserSelected%==userselected_reset GOTO DP_PUB_ALT_YN
		IF /I %UserSelected%==Y GOTO TOPALT_PUB
		IF /I %UserSelected%==N GOTO TOPALT_NotPUB
		
			echo.
			echo.
			echo.
			echo.
			echo  %UserSelected% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO DP_PUB_ALT_YN

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

	set DEP_INS=DEP_INS_NotSet

	set /p DEP_INS=Type the DEP CTRL instructions/info and press enter: 
		IF "%DEP_INS%"=="DEP_INS_NotSet" SET DEP_INS=

CLS

:PRINT_DP_ISR

CLS

ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%APT%%PROC_NAME%DEL .MSG %ARTCC%_ISR ***%PROC_NAME% %PROC_VERSION% ::: %DP_STAR_TYPE% ::: RWY %RWYS% ::: %DP_TRANS% ::: %DEL_Climb_Method% %DEL_Climb_ALT% ::: CRZ-%EXP_CRZ_TIME%min%EXP_CRZ_LISTED% ::: DEP FREQ %DEP_FREQ% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%APT%%PROC_NAME%GND .MSG %ARTCC%_ISR ***%PROC_NAME% %PROC_VERSION% ::: RWY %RWYS% ::: %GND_INFO% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%APT%%PROC_NAME%TWR .MSG %ARTCC%_ISR ***%PROC_NAME% %PROC_VERSION% ::: %DP_STAR_TYPE% ::: %TWR_DP_INS% ::: DEP FREQ %DEP_FREQ% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%APT%%PROC_NAME%DEP .MSG %ARTCC%_ISR ***%PROC_NAME% %PROC_VERSION% ::: %DP_STAR_TYPE% ::: %DEL_Climb_Method% %DEL_Climb_ALT% issued by DEL ::: CRZ-%EXP_CRZ_TIME%min%EXP_CRZ_LISTED% ::: TopAlt %TopAlt% ::: %DEP_INS% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%APT%%PROC_NAME%CTR .MSG %ARTCC%_ISR ***%PROC_NAME% %PROC_VERSION% ::: CRZ-%EXP_CRZ_TIME%min%EXP_CRZ_LISTED% ::: TopAlt %TopAlt% >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

CLS

:DP_PILOT_TEXT

IF /I "%DEL_Climb_Method%"=="CVS" SET DEL_Climb_Method_TEXT=Climb Via SID

IF /I "%DEL_Climb_Method%"=="CVS Exct Maint" SET DEL_Climb_Method_TEXT=Climb Via SID Except Maintain

IF /I "%DEL_Climb_Method%"=="Maint" SET DEL_Climb_Method_TEXT=Maintain

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

set TEXT_DEP_INS=TEXT_DEP_INS_not_set

set /p TEXT_DEP_INS=Type the special departure instructions (if any) and press Enter: 
	IF "%TEXT_DEP_INS%"=="TEXT_DEP_INS_not_set" SET TEXT_DEP_INS=

CLS

:DP_PILOT_TEXT_CRAFT

ECHO.>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO .TCRAFT%APT%%PROC_NAME% Cleared to $arr. %ODP_PHRASE% $route. %DEL_Climb_Method_TEXT% %DEL_Climb_ALT%. Expect $cruise %EXP_CRZ_TIME%min after departure. Departure frequency $freq($1), squawk $squawk %TEXT_DEP_INS%. %HFR%>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO.>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO .TCRAFT%APT%%PROC_NAME%U Cleared to $arr. %ODP_PHRASE% $route. %DEL_Climb_Method_TEXT% %DEL_Climb_ALT%. Expect $cruise %EXP_CRZ_TIME%min after departure. Departure OFFLINE, squawk $squawk %TEXT_DEP_INS%. %HFR%>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

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

:PDC_QUERY

set PDC=PDC_RESET

set /p PDC=Does this airport issue clearances via PDC? Type Y or N and press Enter: 
	CLS
	IF /I  %PDC%==N GOTO QUERY_MORE_PROC_AFTER__DP_PDC
	IF /I  %PDC%==Y GOTO WRITE_PDC
	
			echo.
			echo.
			echo.
			echo.
			echo  %PDC% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO PDC_QUERY

:WRITE_PDC

ECHO.>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO .TPDC%APT%%PROC_NAME% .msg $aircraft *** PRE-DEPARTURE CLEARANCE *** CALLSIGN: $aircraft ^| DEP APT: $dep ^| CRUISE ALTITUDE: $cruise ^| ROUTE: $route ^| CLEARANCE LIMIT: $arr ^| DEP INSTRUCTIONS: %DEL_Climb_Method_TEXT% %DEL_Climb_ALT%, %TEXT_DEP_INS% ^| DEP FREQ: $freq($1) ^| BEACON: $squawk ^| REMARKS: EXPECT CLOSEST ACTIVE RWY FOR DEP, ATC MAY CHANGE. DO NOT REPLY UNLESS YOU HAVE QUESTIONS.>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO.>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO .TPDC%APT%%PROC_NAME%CHG .msg $aircraft *** WARNING: THIS PDC CONTAINS CHANGES FROM WHAT YOU FILED. PLEASE READ IT THOROUGHLY. *** PRE-DEPARTURE CLEARANCE *** CALLSIGN: $aircraft ^| DEP APT: $dep ^| CRUISE ALTITUDE: $cruise ^| ROUTE: $route ^| CLEARANCE LIMIT: $arr ^| DEP INSTRUCTIONS: %DEL_Climb_Method_TEXT% %DEL_Climb_ALT%, %TEXT_DEP_INS% ^| DEP FREQ: $freq($1) ^| BEACON: $squawk ^| REMARKS: EXPECT CLOSEST ACTIVE RWY FOR DEP, ATC MAY CHANGE. DO NOT REPLY UNLESS YOU HAVE QUESTIONS.>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO.>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO .TPDC%APT%%PROC_NAME%U .msg $aircraft *** PRE-DEPARTURE CLEARANCE *** CALLSIGN: $aircraft ^| DEP APT: $dep ^| CRUISE ALTITUDE: $cruise ^| ROUTE: $route ^| CLEARANCE LIMIT: $arr ^| DEP INSTRUCTIONS: %DEL_Climb_Method_TEXT% %DEL_Climb_ALT%, %TEXT_DEP_INS% ^| DEP FREQ: OFFLINE ^| BEACON: $squawk ^| REMARKS: EXPECT CLOSEST ACTIVE RWY FOR DEP, ATC MAY CHANGE. DO NOT REPLY UNLESS YOU HAVE QUESTIONS.>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO.>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO .TPDC%APT%%PROC_NAME%UCHG .msg $aircraft *** WARNING: THIS PDC CONTAINS CHANGES FROM WHAT YOU FILED. PLEASE READ IT THOROUGHLY. *** PRE-DEPARTURE CLEARANCE *** CALLSIGN: $aircraft ^| DEP APT: $dep ^| CRUISE ALTITUDE: $cruise ^| ROUTE: $route ^| CLEARANCE LIMIT: $arr ^| DEP INSTRUCTIONS: %DEL_Climb_Method_TEXT% %DEL_Climb_ALT%, %TEXT_DEP_INS% ^| DEP FREQ: OFFLINE ^| BEACON: $squawk ^| REMARKS: EXPECT CLOSEST ACTIVE RWY FOR DEP, ATC MAY CHANGE. DO NOT REPLY UNLESS YOU HAVE QUESTIONS.>>"%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

CLS

:QUERY_MORE_PROC_AFTER__DP_PDC

ECHO.
ECHO.
ECHO -----------------------------------------------------
ECHO.
ECHO     Are there more procedures to make for %APT%?
ECHO.
ECHO -----------------------------------------------------
ECHO.
ECHO.

	:MORE_PROC_CHOICE_1367
	
	SET MORE_PROC=MORE_PROC_RESET
	
	set /p MORE_PROC=Type Y or N and press Enter: 
		CLS
		IF /I %MORE_PROC%==Y GOTO PUBLICATION_TYPE
		IF /I %MORE_PROC%==N GOTO AIRPORT
			echo.
			echo.
			echo.
			echo.
			echo  %MORE_PROC% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO MORE_PROC_CHOICE_1367

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

	:START_TYPE_CHOICE

	set /p UserSelected=Type Your Choice (R or NR) and press Enter: 
		IF /I %UserSelected%==R SET DP_STAR_TYPE=RNAV
		IF /I %UserSelected%==NR SET DP_STAR_TYPE=Non-RNAV

		IF /I %UserSelected%==R GOTO CTR_INS
		IF /I %UserSelected%==NR GOTO CTR_INS
		
			echo.
			echo.
			echo.
			echo.
			echo  %UserSelected% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO START_TYPE_CHOICE

:CTR_INS

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
echo  CTR (ISR) INSTRUCTIONS
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

set CTR_INS=CTR_INS_not_set

set /p CTR_INS=Type the appropriate CTR instructions (if any) and press Enter: 
	IF "%CTR_INS%"=="CTR_INS_not_set" SET CTR_INS=






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
echo  APP (ISR) INSTRUCTIONS
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

set APP_INS=APP_INS_not_set

set /p APP_INS=Type the appropriate APP instructions (if any) and press Enter: 
	IF "%APP_INS%"=="APP_INS_not_set" SET APP_INS=


ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%APT%%PROC_NAME%CTR .MSG %ARTCC%_ISR *** %PROC_NAME% %PROC_VERSION% ::: %DP_STAR_TYPE% ::: %CTR_INS% ::: A$altim(K%APT%) >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .%APT%%PROC_NAME%APP .MSG %ARTCC%_ISR *** %PROC_NAME% %PROC_VERSION% ::: %DP_STAR_TYPE% ::: %APP_INS% ::: A$altim(K%APT%) >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

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
ECHO  Now we will create the Text-2-Pilots commands
ECHO.
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

:OPS_CHOICE

SET OPS=OPS_RESET

set /p OPS=Type the corresponding letter for the OPS direction and press Enter: 

	IF /I  %OPS%==OPS_RESET GOTO OPS_CHOICE

	IF /I  %OPS%==N SET OPS_Text=North
	IF /I  %OPS%==S SET OPS_Text=South
	IF /I  %OPS%==E SET OPS_Text=East
	IF /I  %OPS%==W SET OPS_Text=West
	
	IF /I  %OPS%==N GOTO STAR_PILOT_TEXT_CTR
	IF /I  %OPS%==S GOTO STAR_PILOT_TEXT_CTR
	IF /I  %OPS%==E GOTO STAR_PILOT_TEXT_CTR
	IF /I  %OPS%==W GOTO STAR_PILOT_TEXT_CTR
	
			echo.
			echo.
			echo.
			echo.
			echo  %OPS% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO OPS_CHOICE

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
echo For Reference, this is what is in your ISR for CTR for this STAR:
echo.
echo %CTR_INS%
echo.
echo --------------------------------------------------
echo.
echo  TEXT-TO-PILOT
echo  CTR ARRIVAL INSTRUCTIONS PER %OPS%-OPS
echo.
echo.
echo   EXAMPLE:
echo.
echo      Cross SPANE at and maintain FL190 and 280kts
echo.
echo --------------------------------------------------
echo.
echo.

set CTR_ARR_INS=CTR_ARR_INS_not_set

set /p CTR_ARR_INS=Type the special arrival instructions by CTR (if any) and press Enter: 
	IF "%CTR_ARR_INS%"=="CTR_ARR_INS_not_set" SET CTR_ARR_INS=

CLS

ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .T%APT%%PROC_NAME%CTR%OPS% %CTR_ARR_INS%. %APT% Landing %OPS_Text%. Altimeter A$altim(K%APT%) >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

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
echo For Reference, this is what is in your ISR for APP for this STAR:
echo.
echo %APP_INS%
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

set APP_ARR_INS=APP_ARR_INS_not_set

set /p APP_ARR_INS=Type the special arrival instructions by APP (if any) and press Enter: 
	IF "%APP_ARR_INS%"=="APP_ARR_INS_not_set" SET APP_ARR_INS=

CLS

ECHO. >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"
echo .T%APT%%PROC_NAME%APP%OPS% %APP_ARR_INS%. Altimeter A$altim(K%APT%) >> "%userprofile%\Desktop\BAT ALIASES\%APT%_ALIAS_COMMANDS.TXT"

CLS

:MORE_OPS_CHOICE

SET UserSelected=UserSelected_RESET

set /p userselected=Are there more OPS conditions for this STAR? Type Y or N and press Enter: 

	IF /I  %userselected%==UserSelected_RESET GOTO MORE_OPS_CHOICE

	IF /I  %userselected%==Y GOTO STAR_PILOT_TEXT
	IF /I  %userselected%==N GOTO MORE_PROC_1652
	
			echo.
			echo.
			echo.
			echo.
			echo  %userselected% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO MORE_OPS_CHOICE

:MORE_PROC_1652

CLS

ECHO.
ECHO.
ECHO -----------------------------------------------------
ECHO.
ECHO     Are there more procedures to make for %APT%?
ECHO.
ECHO -----------------------------------------------------
ECHO.
ECHO.

	:MORE_PROC_CHOICE_1652
	
	SET MORE_PROC=MORE_PROC_RESET
	
	set /p MORE_PROC=Type Y or N and press Enter: 
	
	IF /I %MORE_PROC%==MORE_PROC_RESET GOTO MORE_PROC_CHOICE_1652
		CLS
		IF /I %MORE_PROC%==Y GOTO PUBLICATION_TYPE
		IF /I %MORE_PROC%==N GOTO AIRPORT
			echo.
			echo.
			echo.
			echo.
			echo  %MORE_PROC% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO MORE_PROC_CHOICE_1652

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

	set /p userselected=Type Your Response (A - H) and Press Enter: 
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

:EXPORT

CLS

ECHO.
ECHO.
ECHO  SELECT THE FOLDER THAT HOLDS ALL OF THE INDIVIDUAL AIRPORT ALIAS FILES.
ECHO.
ECHO.

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Where are the files that need to be combined?',0,0).self.path""

	for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "FILES_DIR=%%I"

CLS

ECHO.
ECHO.
ECHO  PRESS ANY KEY TO COMBINED THE .TXT FILES FOUND IN THE FOLLOWING DIRECTORY:
ECHO.
ECHO  %FILES_DIR%
ECHO.
ECHO.

PAUSE

CD /D "%FILES_DIR%"
type *_ALIAS_COMMANDS.TXT >> 000_COMBINED.TXT

CLS

ECHO.
ECHO.
ECHO -----------------------------------------------
ECHO.
ECHO  All the .txt files found in this location:
ECHO  %FILES_DIR%
ECHO.
ECHO  Have been combined into a single file
ECHO  000_COMBINED.txt found in the same location.
ECHO -----------------------------------------------
ECHO.
ECHO.

PAUSE
CLS
GOTO HELLO