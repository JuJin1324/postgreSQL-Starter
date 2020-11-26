# postgreSQL-Starter
> postgreSQL 정리

## 로컬 설치
### macOS + brew

## 백업
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


## 복원
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
