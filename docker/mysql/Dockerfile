# FROM mysql:8.0
FROM arm64v8/mariadb

COPY ./my.cnf /etc/mysql/conf.d/my.cnf
COPY ./initdb.d/* /docker-entrypoint-initdb.d/

RUN chown -R mysql.mysql /var/lib/mysql

CMD ["mysqld"]