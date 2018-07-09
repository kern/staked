FROM ubuntu:16.04
MAINTAINER Alex Kern <alex@kern.io>

COPY install.sh .
RUN chmod +x install.sh && ./install.sh

CMD [ "dcrd" ]
