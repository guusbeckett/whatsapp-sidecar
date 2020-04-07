FROM ubuntu

RUN apt-get update
RUN apt-get install xtail -y

ENTRYPOINT ["/bin/sh", "-c", "((xtail /usr/local/waent/logs/. &) | grep -q \"QSqlError(\\|57P01\") && pkill wa-service"]

