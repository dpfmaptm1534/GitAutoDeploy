# GitAutoDeploy
깃 자동 배포

개발환경
- Windows, 윈도우 batch파일 이용
- 전자정부프레임워크 3.1
- Spring
- Java
- Maven
- Tomcat 8.5

특징&구조
- git을 반드시 사용해야함
- git branch는 공통 master 개인 brnach
- 개인 brnach에서 작업이 다끝난 팀원이 master에 push 한다고 가정
- 최초 실행시 1회 배포 후 반복문 진입
- git pull(master)을 5초(변경가능)마다 함. 무한반복
- 변경사항이 없을경우 5초대기 후 다시 pull
- 변경사항이 생길경우 pull 진행 -> war파일 생성 -> 톰캣에 배포
