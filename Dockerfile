FROM persistentss13/byond:513-latest as compile
COPY . /persistent
WORKDIR /persistent
RUN scripts/dm.sh nebula.dme


FROM persistentss13/byond:513-latest as test_setup
ENV LANG=C.UTF-8 \
	DEBIAN_FRONTEND=noninteractive \
	PYENV_ROOT=/pyenv \
	PYENV_COMMIT="1487135415d53d47fa8e6686ee34111b31b34c24" \
	PYENV_VERSION=3.6.7
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
	&& apt-get update \
	&& apt-get install -y git make build-essential libssl-dev \
	zlib1g-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
	xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libbz2-dev \
	uchardet default-jdk \
	&& git clone --recursive https://github.com/pyenv/pyenv.git $PYENV_ROOT \
	&& curl -o /wait.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
	&& chmod u+x /wait.sh
WORKDIR $PYENV_ROOT
ENV PATH=$PATH:$PYENV_ROOT/bin:$PYENV_ROOT/shims
RUN git reset --hard $PYENV_COMMIT \
	&& pyenv install $PYENV_VERSION \
	&& pyenv global $PYENV_VERSION


FROM test_setup as code_test
COPY --from=compile /persistent /persistent
WORKDIR /persistent
ENV TEST=CODE CI=true
ENTRYPOINT ["test/run-test.sh"]


FROM persistentss13/byond:513-latest as ss13
RUN mkdir -p /persistent/data /persistent/config
COPY .git/HEAD /persistent/.git/HEAD
COPY .git/logs/HEAD /persistent/.git/logs/HEAD
COPY --from=test_setup /wait.sh /wait.sh
COPY --from=compile /persistent/config/example/* /persistent/config/
COPY --from=compile /persistent/config/names/* /persistent/config/names/
COPY --from=compile /persistent/nebula.rsc /persistent/nebula.dmb \
	/persistent/

WORKDIR /persistent
VOLUME /persistent/data/
VOLUME /persistent/config/

RUN apt-get update \
	&& apt-get install -y libmariadb-client-lgpl-dev-compat
ENTRYPOINT [ "/wait.sh", "-h", "db", "-p", "3306", "-t", "30", "--", "DreamDaemon", "nebula.dmb", "-port", "8000", "-trusted", "-verbose" ]
