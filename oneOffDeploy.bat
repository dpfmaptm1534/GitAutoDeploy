@echo off

rem 프로젝트명 설정
set PROJECT_NAME=MyProject

rem 서버폴더명 설정
set SERVER_NAME=MyServer

rem 서비스명 설정
set SERVICE_NAME=MyService

rem Git프로젝트 디렉토리로 이동
cd /d C:\Project\%PROJECT_NAME%

rem Git master브렌치 변경
git checkout master

rem Git pull 명령 실행 및 실행결과를 변수에 담기
git pull

rem super_master브렌치로 변경
git checkout super_master

rem master 브렌치 내용을 merge
git merge master

rem super_master 원격지에 저장
git push

rem Maven build 실행
call mvn clean package
echo Maven build completed.
    
REM 서비스 중지
sc stop %SERVICE_NAME%
    
REM 5초대기
timeout /t 5 /nobreak > nul
    
rem 배포실행
cd target
ren %PROJECT_NAME%-1.0.0.war ROOT.war
    
rem 기존 톰캣폴더에 ROOT 폴더 삭제
rmdir /s /q C:\SERVICE\apache-tomcat\8.5.57-%SERVER_NAME%\webapps\ROOT 2>nul
    
rem 새로 생성된 ROOT.war파일을 강제 덮어씌우기
move /Y ROOT.war C:\SERVICE\apache-tomcat\8.5.57-%SERVER_NAME%\webapps
    
rem 톰캣 work폴더 삭제(톰캣찌꺼기)
rmdir /s /q C:\SERVICE\apache-tomcat\8.5.57-%SERVER_NAME%\work
    
rem 서비스 시작
sc start %SERVICE_NAME%

