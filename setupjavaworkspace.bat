@echo off

powershell -command "Invoke-WebRequest -Uri 'https://builds.openlogic.com/downloadJDK/openlogic-openjdk/21.0.4+7/openlogic-openjdk-21.0.4+7-windows-x64.zip' -OutFile 'jdk21.zip'"
powershell -command "Expand-Archive -Path 'jdk21.zip' -DestinationPath 'java'"
cd java
for /d %%i in (*) do ren %%i "jdk21" 
cd ..
for %%A in ("%~dp0.\java\jdk21") Do set "_JAVA21=%%~fA"
set JAVA_HOME=%_JAVA21%
if "%~1" == "java-21" set JAVA_HOME=%_JAVA21%
if "%~2" == "perm" (
  setx JAVA_HOME "%JAVA_HOME%" /M
)
set Path=%JAVA_HOME%\bin;%Path%
echo JAVA_HOME:%JAVA_HOME% activated.

echo --setting up maven
powershell -command "Invoke-WebRequest -Uri 'https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.zip' -OutFile 'maven.zip'"
powershell -command "Expand-Archive -Path 'maven.zip' -DestinationPath 'maven'"
cd maven
for /d %%i in (*) do ren %%i "maven3_9_9" 
cd ..

for %%A in ("%~dp0.\maven\maven3_9_9") Do set "_MAVEN=%%~fA"
set M2_HOME=%_MAVEN%
set M2=%_MAVEN%\bin
if "%~1" == "maven" set M2_HOME=%_MAVEN%
if "%~2" == "perm" (
  setx M2_HOME "%M2_HOME%" /M
  setx M2 "%M2%" /M
)
set Path=%M2%;%Path%
echo Maven:%M2% activated.

for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /r /C:"IPv4 Address"') do (
	set "ipAdress=%%i"
)
echo ip is::%ipAdress%
