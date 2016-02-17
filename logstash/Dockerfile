# FROM ubuntu:14.04
FROM java:8-jre
MAINTAINER Thomas Sachse <thomas.sachse@ottogroup.com>
ENV REFRESHED_AT 2016-01-30

RUN apt-get -yqq update
RUN apt-get -yqq install wget
RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch |  apt-key add -
# RUN echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' > /etc/apt/sources.list.d/logstash.list
RUN echo 'deb http://packages.elasticsearch.org/logstash/2.2/debian stable main' > /etc/apt/sources.list.d/logstash.list
RUN apt-get -yqq update
RUN apt-get -yqq install logstash

# ADD logstash.conf /etc/
VOLUME ["/data"]
VOLUME ["/config"]

RUN mkdir /plugins
COPY plugins/* /plugins
RUN /opt/logstash/bin/plugin install /plugins/logstash-filter-errlog-0.1.0.gem


WORKDIR /opt/logstash

ENTRYPOINT [ "bin/logstash" ]
CMD [ "--config=/config/logstash.conf" ]
