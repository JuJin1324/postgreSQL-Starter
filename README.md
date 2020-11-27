# postgreSQL-Starter
> postgreSQL 정리
 
## 설치 및 실행
### 설치 - 11버전
> macOS : `brew install postgresql@11`  
> Ubuntu:  
> ```bash
> $ sudo vi /etc/apt/sources.list.d/pgdg.list
> # vi에 아래 내용 추가 후 :wq 
> deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main
> 
> $ wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
> $ sudo apt-get update
> $ sudo apt-get install postgresql-11
> ```

### 서버 실행
> macOS  
> ```bash
> # 실행
> pg_ctl -D /usr/local/var/postgres start
> 
> # 서비스 등록
> brew services start postgresql
> 
> # 실행 확인
> postgres -V
> ```
> Ubuntu  
> ```bash
> # 실행
> sudo systemctl start postgresql@11-main
> 
> # 서비스 등록
> sudo systemctl enable postgresql@11-main
> ```

## 접속
### macOS
> 기본 루트 계정인 <b>postgres</b>를 통해서 psql 접속: `psql postgres`  

### Ubuntu
> 기본 루트 계정인 <b>postgres</b>를 통해서 psql 접속: `psql postgres`  

## [macOS] 설정 변경

## 사용자 등록 및 권한 추가
### 사용자 등록
> 생성되어 있는 계정 확인: postgres=# `\du`  
> 루트 계정인 <b>postgres</b> 비밀번호 설정: postgres=# `\password postgres`  
> 계정명이 <b>jujin</b>인 계정 생성 postgres=# `CREATE ROLE jujin WITH LOGIN PASSWORD 'jujin';`  
> 생성되어진 계정 확인: postgres=# `\du`  

### 권한 추가
> <b>jujin</b> 계정에 데이터베이스 생성 권한 추가: postgres=# `ALTER ROLE jujin CREATEDB;`  
> 권한 변경 확인: postgres=# `\du`  

### 데이터베이스 생성
> 데이터베이스 생성: postgres=# `CREATE DATABASE mydb;`   
> postgres client 종료: postgres=# `\q`  

## 백업 - macOS / Ubuntu 공통
### 형식
> `time pg_dump -j [스레드 갯수] -d [Database 이름] -Fd -f [dump 디렉터리 이름]`  

### time
> time 이후의 명령어가 얼마나 걸렸는지 출력

### pg_dump
> -j : 동시로 처리하기 위해서 사용할 스레드의 갯수 보통 코어 갯수 혹은 쓰레드 갯수로 지정
> -d : dump를 통해 백업할 데이터베이스 이름
> -Fd -f : dump 파일들을 저장할 디렉터리 이름, -Ft -f 로 하면 tgz 압축파일로 저장이 가능하지만 pg_restore 에서도 동시 처리를 하려면 
디렉터리로 dump을 내보내야 한다.

### 예시
> <b>8개의 쓰레드</b>로 동시성 확보   
> 데이터베이스 이름은 <b>mydb</b> 이며   
> /var/lib/postgresql/data 아래 있는 <b>mydb_dump.dir</b> 이름의 디렉터리에  
> <b>dump 디렉터리</b> 생성  
`time pg_dump -j 8 -d mydb -Ft -f /var/lib/postgresql/data/mydb_dump.dir`


## 복원 - macOS / Ubuntu 공통
### 형식
> `time pg_restore -h [호스트 명] -U [Username] -Fd -d [Database 이름] [덤프 디렉터리 이름]`  

### time
> time 이후의 명령어가 얼마나 걸렸는지 출력  

### pg_restore
> -j : 동시로 처리하기 위해서 사용할 스레드의 갯수 보통 코어 갯수 혹은 쓰레드 갯수로 지정  
> -d : dump를 통해 백업할 데이터베이스 이름  
> -Fd -f : dump 디렉터리 이름  

### 예시
> <b>8개의 쓰레드</b>로 동시성 확보  
> <b>localhost</b> 호스트 명에  
> Username이 <b>jujin</b> 이며  
> 데이터베이스 이름은 <b>mydb</b> 이며  
> 현재 디렉터리 아래 <b>mydb_dump.dir</b> 이름의 덤프 디렉터리로  
> 복원  
> `time pg_restore -j 8 -h localhost -U jujin -Fd -d mydb mydb_dump.dir`

### 출처
> https://reseaux.tistory.com/13 
