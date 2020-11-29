FROM postgres:11.9
MAINTAINER jujin <jujin@daum.net>

ADD init-system-settings.sql /docker-entrypoint-initdb.d/