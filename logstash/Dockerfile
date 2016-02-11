FROM ubuntu:14.04
MAINTAINER Thomas Sachse <thomas.sachse@ottogroup.com>
ENV REFRESHED_AT 2016-01-30

RUN apt-get -yqq update
RUN apt-get -yqq install wget
RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch |  apt-key add -
RUN echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' > /etc/apt/sources.list.d/logstash.list
RUN apt-get -yqq update
RUN apt-get -yqq install logstash

# ADD logstash.conf /etc/
# RUN mkdir /data
VOLUME ["/data"]
VOLUME ["/config"]

WORKDIR /opt/logstash

ENTRYPOINT [ "bin/logstash" ]
CMD [ "--config=/config/logstash.conf" ]
