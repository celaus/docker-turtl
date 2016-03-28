## -*- docker-image-name: "clma/docker-turtl" -*-
#
# turtl.it unofficial API Dockerfile
#

FROM nfnty/arch-mini:latest
MAINTAINER clma <claus@crate.io>

RUN pacman -Sy sbcl git libuv --noconfirm
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp && sbcl --load quicklisp.lisp <<< '(quicklisp-quickstart:install)'

RUN git clone https://github.com/turtl/api.git --depth 1 /turtl
RUN mkdir /data

VOLUME ["/turtl/config", "/data"]

# auto link default config (?)
#ADD /turtl/config/config.default.lisp /turtl/config/config.lisp


WORKDIR /turtl

EXPOSE 8181

CMD ["/usr/bin/sbcl --load start.lisp"]
