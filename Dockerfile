## -*- docker-image-name: "clma/docker-turtl" -*-
#
# turtl.it unofficial API Dockerfile
#

FROM nfnty/arch-mini:latest
MAINTAINER clma <claus@crate.io>

RUN mkdir /quicklisp /data

RUN pacman -Sy git libuv gcc --noconfirm
RUN curl -O ftp://ftp.clozure.com/pub/release/1.11/ccl-1.11-linuxx86.tar.gz && tar xfz
RUN curl -s ftp://ftp.clozure.com/pub/release/1.11/ccl-1.11-linuxx86.tar.gz | tar xvf - -C /ccl 
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp && /ccl/lx86cl64 --load quicklisp.lisp <<< $'(quicklisp-quickstart:install :path "/quicklisp/")'

RUN git clone https://github.com/turtl/api.git --depth 1 /turtl

RUN echo $'(load "/quicklisp/setup.lisp")\n(push #p"/turtl/" asdf:*central-registry*)\n(load "start")' > /turtl/cmd.args
RUN echo '/ccl/lx86cl64 < /turtl/cmd.args' > /turtl/run.sh

VOLUME ["/turtl/config", "/data"]

# auto link default config (?)
#ADD /turtl/config/config.default.lisp /turtl/config/config.lisp


WORKDIR /turtl

EXPOSE 8181

CMD ["/usr/bin/bash" , "/turtl/run.sh"]
