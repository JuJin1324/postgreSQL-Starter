# postgreSQL-Starter
> postgreSQL 정리
 
## 설치 및 실행
### 설치 - 11버전
> macOS : `brew install postgresql@11`  
> Ubuntu
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

### postgreSQL 서버 버전 확인
> 터미널 명령어: `/usr/lib/postgresql/11/bin/postgres -V`

## 접속
### macOS
> 기본 루트 계정인 <b>postgres</b>를 통해서 psql 접속: `psql postgres`  

### Ubuntu
> 기본 루트 계정인 <b>postgres</b>를 통해서 psql 접속: `sudo -u postgres psql`  

## 설정 변경
### SQL
> 아래 Ubuntu 섹션에서 설정 변경에 사용하는 `postgresql.conf` 파일을 수정하는 대신 SQL 레벨에서 설정을 변경할 수 있다.  
> 원하는 스펙을 입력하고 설정 변경 쿼리를 생성하는 사이트: [PGTune](https://pgtune.leopard.in.ua/#/)  
>
> 설정 값 확인 쿼리  
> ```sql
> SELECT name, context, unit, setting, boot_val, reset_val
> FROM pg_settings
> WHERE name in('max_connections', 'shared_buffers', 'effective_cache_size', 'maintenance_work_mem',
>               'checkpoint_completion_target', 'wal_buffers', 'default_statistics_target', 'random_page_cost',
>               'effective_io_concurrency', 'work_mem', 'min_wal_size', 'max_wal_size', 'max_worker_processes',
>               'max_parallel_workers_per_gather', 'max_parallel_workers', 'max_parallel_maintenance_workers')
> ;
> ```  


### Ubuntu 
> 설정 파일 <b>postgresql.conf</b>의 위치: /etc/postgresql/11/main  
> vi 를 통한 설정 변경  
> `sudo vi /etc/postgresql/11/main/postgresql.conf`

### 설정 값
> <b>listen_addresses</b>: 외부 접속 허용 설정 - 'localhost'(내부만 허용) -> '*' (외부 접속까지 모두 허용)  
> <b>port</b>: postgres가 사용할 포트 - 5432(default)   
> <b>shared_buffers</b>: 쿼리 실행시 사용하는 메모리 공간 같음 - 128MB(default)  
>
> 설정 값 확인 쿼리  
> ```sql
> SELECT name, context, unit, setting, boot_val, reset_val 
> FROM pg_settings 
> WHERE name in('listen_addresses', 'max_connections', 'shared_buffers', 'effective_cache_size', 'work_mem', 'maintenance_work_mem') 
> ORDER BY context, name;
> ```  
> <b>setting</b> : 현재 적용된 값  
> <b>boot_val</b> : 디폴트값  
> <b>reset_val</b> : restart/reload 하면 적용될 값  
> 출처: [PostgresDBA](https://www.postgresdba.com/bbs/board.php?bo_table=B12&wr_id=3)

### 외부 접속 허용하기
> postgresql.conf 변경  
> `sudo vi /etc/postgresql/11/main/postgresql.conf`  
> `listen_addresses: '*'` 으로 변경  
> 
> pg_hba.conf 변경  
> `sudo vi /etc/postgresql/11/main/pg_hba.conf`  
> `host    all             all             127.0.0.1/32            md5` 부분을 지우고  
> `host    all             all             0.0.0.0/0               md5` 로 변경  
> `sudo systemctl restart postgresql`

### 데이터 저장 디렉터리 변경하기
> postgres 의 데이터 저장 디렉터리 확인은 `sudo -u postgres psql` 로 root 접속 후 `SHOW data_directory;` 명령어를 통해서 알 수 있다.  
> 보통 `/var/lib/postgresql/11/main`  
> 
> 디렉터리 변경 전 DB 서비스 종료: `sudo systemctl stop postgresql`  
> 
> rsync 를 통해서 데이터를 담고 있는 디렉터리를 변경할 디렉터리로 복붙: `sudo rsync -av /var/lib/postgresql /mydatabase/postgres-data`  
> 
> vi 를 통한 설정 변경  
> `sudo vi /etc/postgresql/11/main/postgresql.conf`
> ```bash
> ...
> data_directory = '/mydatabase/postgres-data/postgresql/11/main'
> ...
> ```
> DB 서비스 시작: `sudo systemctl start postgresql`

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

