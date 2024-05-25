<div align="center">
<img src="https://github.com/kookmin-sw/capstone-2024-07/assets/67682840/a6255c3f-ff7a-43b7-8e14-7e1199be3ac0" width="250px">

|                                                     Play Store                                                     |                                                     App Store                                                     |
| :----------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------: |
| ![Play store](https://github.com/kookmin-sw/capstone-2024-07/assets/67682840/1d1f1759-112d-4aee-9e56-1ebc678ee82b) | ![App store](https://github.com/kookmin-sw/capstone-2024-07/assets/67682840/b497c251-fa9a-4880-ba53-05d32d3a519a) |

<img width="487" alt="image" src="https://github.com/kookmin-sw/capstone-2024-07/assets/67682840/f3ddec0c-141a-483f-a80c-b87e68dd68c5">

<h1>디클</h1>

</div>

### 1. 프로젝트 소개
- 디클(Department class)은 전국의 대학생들이 학과를 중심으로 모여 소통할 수 있는 학과별 커뮤니티 서비스입니다. 모든 유저가 자신의 소속 학교나 동아리가 아닌 학과별로 자유롭게 모여 같은 학과끼리만 이해할 수 있는 깊은 고민과 전공 관련 정보를 공유할 수 있게 돕고자 합니다.

### 2. 소개 영상
[![소개 영상](http://img.youtube.com/vi/f8lyoE0JIKA/0.jpg)](https://youtu.be/f8lyoE0JIKA?si=rLR_N2X6oFqUPunp)

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

### 4. 기술 스택

![image](https://github.com/kookmin-sw/capstone-2024-07/assets/67682840/b9be449b-ddfe-44b8-99c6-93c1554ae7d3)


### 5. 서비스 구조도

![image](https://github.com/kookmin-sw/capstone-2024-07/assets/67682840/893f626b-ab39-46c2-bd12-a04ec68bbe69)


### 6. 사용법

#### Backend

- Prerequisite
  - Java 17
  - docker compose


- 로컬 MYSQL 설치하기(M1 기준)
  - 백엔드 파일 경로로 진입

    ```
    cd backend
    ```
  - `docker-compose`를 데몬으로 실행
    ```
    docker-compose up -d
    ```
  - `backend/src/main/resources/application.yml` 포트 수정
      ```yml
      spring:
        datasource:
          url: jdbc:mysql://localhost:{HOST_PORT}/dclass?serverTimezone=UTC
      ```

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
  - `backend`에서 아래 명령어 실행

    ```
    ./gradlew bootRun —args='—spring.profiles.active=local'
    ```


#### Frontend

- Prerequisite
  - [Flutter 3.13.0](https://docs.flutter.dev/get-started/install)
  - [Dart 3.1.0](https://dart.dev/get-dart)
  - [안드로이드 스튜디오](https://developer.android.com/codelabs/basic-android-kotlin-compose-install-android-studio?hl=ko#0)

- 에뮬레이터 (혹은 시뮬레이터) 실행
  - 안드로이드 스튜디오에서 device manager → virtual → create device → 실행

- 로컬 실행하기
  - 프론트엔드 파일 경로로 진입

    ```
    cd frontend
    ```
  - 패키지 설치

    ```
    flutter pub get
    ```
  - 프로젝트 실행

    ```
    flutter run
    ```
### 7. Document

- [중간 보고서](https://github.com/kookmin-sw/capstone-2024-07/files/15328640/default.pdf)
- [중간 발표자료](https://github.com/kookmin-sw/capstone-2024-07/files/15328685/default.pdf)
- [최종 포스터](https://github.com/kookmin-sw/capstone-2024-07/files/15368233/default.pdf)
- [최종 발표자료](https://github.com/kookmin-sw/capstone-2024-07/files/15368652/-.pptx)
- [수행결과보고서](https://github.com/kookmin-sw/capstone-2024-07/files/15329735/default.pdf)
- [최종 보고서](https://github.com/kookmin-sw/capstone-2024-07/files/15426987/final.pdf)
