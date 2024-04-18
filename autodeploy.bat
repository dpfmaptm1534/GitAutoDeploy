@echo off
echo '자동 배포 시작'
rem ------------------------------<변수 선언>---------------------------------

rem 프로젝트명 설정
set PROJECT_NAME=Myproject

rem 서버폴더명 설정
set SERVER_NAME=Myfoler

rem 서비스명 설정
set SERVICE_NAME=Tomcat8

rem -------------------------------------------------------------------------------

rem Git프로젝트 디렉토리로 이동
cd C:\Project\%PROJECT_NAME%

rem Git pull 명령 실행 및 실행결과를 변수에 담기
for /f %%A in ('git pull') do set "pull_result=%%A"

rem Git pull 결과 확인
echo %pull_result% | findstr /c:"Already up to date." > nul

rem Git pull 결과 확인
if "%pull_result%"=="Already" (
     echo No changes found. No further action required.
) else (
    echo Changes found. Proceeding with Maven build and Tomcat restart.
    
    rem Maven build 실행
    call mvn clean package
    echo Maven build completed.
    
    REM 서비스 중지
    sc stop %SERVICE_NAME%

    REM 5초대기
    timeout /t 5

    rem 배포실행
    cd target
    ren %PROJECT_NAME%-1.0.0.war ROOT.war
    
    rem 기존 톰캣폴더에 ROOT 폴더 삭제
    rmdir /s /q C:\SERVICE\apache-tomcat\8.5.57-%SERVER_NAME%\webapps\ROOT

    rem 새로 생성된 ROOT.war파일을 강제 덮어씌우기
    move /Y ROOT.war C:\SERVICE\apache-tomcat\8.5.57-%SERVER_NAME%\webapps

    rem 톰캣 work폴더 삭제(톰캣찌꺼기)
    rmdir /s /q C:\SERVICE\apache-tomcat\8.5.57-%SERVER_NAME%\work

    rem 서비스 시작
    sc start %SERVICE_NAME%
) 


