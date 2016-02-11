FROM java:8-jre

RUN wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.1.1/elasticsearch-2.1.1.deb

RUN apt-get update
RUN dpkg -i elasticsearch-2.1.1.deb

ENV PATH /usr/share/elasticsearch/bin:$PATH

RUN set -ex \
	&& for path in \
		/usr/share/elasticsearch/data \
		/usr/share/elasticsearch/logs \
		/usr/share/elasticsearch/config \
		/usr/share/elasticsearch/config/scripts \
	; do \
		mkdir -p "$path"; \
		chown -R elasticsearch:elasticsearch "$path"; \
	done

RUN plugin install mobz/elasticsearch-head 

COPY config /usr/share/elasticsearch/config

VOLUME /usr/share/elasticsearch/data
VOLUME /usr/share/elasticsearch/config


USER elasticsearch

EXPOSE 9200 9300

CMD ["elasticsearch"]

# docker build -t elasticsearch .
# docker run -P -d --name es1 elasticsearch 
