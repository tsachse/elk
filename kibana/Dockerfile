FROM ubuntu:14.04

RUN apt-get update
RUN apt-get -yqq install wget


RUN wget https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz
RUN tar xfz kibana-4.3.1-linux-x64.tar.gz
RUN mv kibana-4.3.1-linux-x64 kibana

VOLUME /kibana/config

EXPOSE 5601 

ENV PATH kibana/bin:$PATH

CMD ["kibana"]

