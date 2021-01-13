FROM mariadb:10.4

COPY migrate/* /docker-entrypoint-initdb.d/
COPY mariadb_custom.cnf /etc/mysql/conf.d/custom.cnf

ENV MYSQL_INITDB_SKIP_TZINFO=1 \
	MYSQL_RANDOM_ROOT_PASSWORD=yes \
	MYSQL_DATABASE=bs12 \
	MYSQL_USER=gamelord \
	MYSQL_PASSWORD=gamelord
