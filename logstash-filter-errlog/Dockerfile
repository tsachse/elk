FROM java:8-jre

RUN apt-get update && apt-get install -y --no-install-recommends tar curl && apt-get autoremove -y && apt-get clean

ENV JRUBY_VERSION 1.7.24

RUN curl http://jruby.org.s3.amazonaws.com/downloads/$JRUBY_VERSION/jruby-bin-$JRUBY_VERSION.tar.gz | tar xz -C /opt

ENV PATH /opt/jruby-$JRUBY_VERSION/bin:$PATH

RUN echo gem: --no-document >> /etc/gemrc

RUN gem update --system
RUN gem install bundler

VOLUME ["/Code"]

RUN useradd -m -d /home/devel -s /bin/bash -c "the development user" -g users devel
RUN chown -R devel:users /opt/jruby-$JRUBY_VERSION

USER devel

RUN echo 'export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/opt/jruby-1.7.24/bin' >>/home/devel/.profile
