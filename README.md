## 디클 (Decl)

### 1. 프로젝트 소개
- 디클(Department class)은 전국의 대학생들이 학과를 중심으로 모여 소통할 수 있는 학과별 커뮤니티 서비스입니다. 모든 유저가 자신의 소속 학교나 동아리가 아닌 학과별로 자유롭게 모여 같은 학과끼리만 이해할 수 있는 깊은 고민과 전공 관련 정보를 공유할 수 있게 돕고자 합니다.

### 2. 소개 영상

### 3. 팀 소개

|                                                                         Frontend                                                                          |                                                                         Frontend                                                                          |                                                                          Backend                                                                          |                                                                          Backend                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/kookmin-sw/capstone-2024-07/assets/83686088/20e5982d-d7b3-4dda-8762-74059308bb9c" width="200px;" height="200px;" alt="권지아"/> | <img src="https://github.com/kookmin-sw/capstone-2024-07/assets/83686088/ac277479-2e56-481a-ae39-196fea859597" width="200px;" height="200px;" alt="윤홍현"/> | <img src="https://github.com/kookmin-sw/capstone-2024-07/assets/83686088/e1e3d13b-7835-4d93-9f9d-89656ea54a4f" width="200px;" height="200px;" alt="윤웅배"/> | <img src="https://github.com/kookmin-sw/capstone-2024-07/assets/83686088/ad14a84b-6c9e-4866-92f0-2546c6be63d5" width="200px;" height="200px;" alt="김동윤"/> |
|                                                          [권지아(팀장)](https://github.com/jia5232/)                                                           |                                                            [윤홍현](https://github.com/hongbuly)                                                             |                                                            [윤웅배](https://github.com/devbelly)                                                             |                                                           [김동윤](https://github.com/zkxmdkdltm)                                                            |

```
✨ Name : 권지아
👩‍🎓 Student ID : 20190155
📌 Role: 팀장, 기획, 프론트엔드
```

```
✨ Name : 윤홍현
👩‍🎓 Student ID : 20213032
📌 Role: UI, 프론트엔드
```

```
✨ Name : 윤웅배
👩‍🎓 Student ID : 20171659
📌 Role: 백엔드, 인프라
```

```
✨ Name : 김동윤
👩‍🎓 Student ID : 20212674
📌 Role: 백엔드, 인프라
```

### 4. 서비스 구조도

![image](https://github.com/kookmin-sw/capstone-2024-07/assets/67682840/77daf964-e42f-4075-bb41-3f1b76fc7d08)


### 5. 사용법

#### Backend

- Prerequisite
  - Java 17
  - docker compose


- 로컬 MYSQL 설치하기(M1 기준)
  - `backend` 에서 `docker-compose up -d`를 실행
  - `backend/src/main/resources/application.yml`에서 `spring.datasource.url` 포트를 `docker-compose.yml`에 따라 수정


- AWS 설정하기
  - `backend/src/main/resources`에 `application-security.yml` 파일 생성 후 아래 내용 작성

  ```yml
  aws:
    access-key: <YOUR_AWS_ACCESS_KEY>
    secret-key: <YOUR_AWS_SECRET_KEY>
      
    s3:
        bucket: <YOUR_BUCKET_NAME>
        region: "ap-northeast-2" 
  ```


- 로컬 실행하기
  - `backend`에서 `./gradlew bootRun —args='—spring.profiles.active=local'`실행

