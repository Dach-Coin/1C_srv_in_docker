FROM ubuntu:latest

# Env section
ENV GOSU_VERSION 1.12
ENV LANG ru_RU.utf8
ENV ENTERPRISE_VER 8.3.18.1289
ENV SERV_VER 8.3.18-1289

# add ubuntu repositories
RUN echo "deb http://ru.archive.ubuntu.com/ubuntu/ bionic main universe" >> /etc/apt/sources.list

# make the "ru_RU.UTF-8" locale so 1c-enterprise will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

# grab gosu for easy step-down from root
RUN apt-get -qq update \
  && apt-get -qq install --yes --no-install-recommends ca-certificates wget

RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc"

RUN chmod +x /usr/local/bin/gosu \
  && gosu nobody true

# install the required for 1c-enterprise libraries
RUN apt-get -qq install --yes --no-install-recommends libwebkitgtk-3.0-0 libjavascriptcoregtk-3.0-0 \ 
  && apt-get -qq install --yes --no-install-recommends libmagickwand-6.q16-6 libgsf-1-114 libkrb5-3 libgssapi-krb5-2 \
  && apt-get -qq install --yes --no-install-recommends ttf-mscorefonts-installer

ADD ./1c_distrib/*.deb /tmp/

RUN dpkg --install /tmp/1c-enterprise-${ENTERPRISE_VER}-common_${SERV_VER}_amd64.deb 2> /dev/null \
&& dpkg --install /tmp/1c-enterprise-${ENTERPRISE_VER}-common-nls_${SERV_VER}_amd64.deb 2> /dev/null \
&& dpkg --install /tmp/1c-enterprise-${ENTERPRISE_VER}-server_${SERV_VER}_amd64.deb 2> /dev/null \
&& dpkg --install /tmp/1c-enterprise-${ENTERPRISE_VER}-server-nls_${SERV_VER}_amd64.deb 2> /dev/null \
&& dpkg --install /tmp/1c-enterprise-${ENTERPRISE_VER}-ws_${SERV_VER}_amd64.deb 2> /dev/null \
&& dpkg --install /tmp/1c-enterprise-${ENTERPRISE_VER}-ws-nls_${SERV_VER}_amd64.deb 2> /dev/null \
&& rm /tmp/*.deb \
&& mkdir --parents /var/log/1C /home/usr1cv8/.1cv8/1C/1cv8/conf \
&& chown --recursive usr1cv8:grp1cv8 /var/log/1C /home/usr1cv8

COPY ./docker-entrypoint.sh /
COPY ./logcfg.xml /home/usr1cv8/.1cv8/1C/1cv8/conf

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME /home/usr1cv8
VOLUME /var/log/1C

EXPOSE 2540-2541 2560-2591 2550

CMD ["ragent"]