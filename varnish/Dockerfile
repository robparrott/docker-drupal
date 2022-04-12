FROM jacksoncage/varnish:latest@sha256:c3a8496f4a6c30bd1b7ccd4c4de648f9e3e28f65dcc1de8bb2f1915d6717c217

ADD default.vcl /etc/varnish/default.vcl
ADD ./start.sh /start
RUN chmod +x /start 

ENV VARNISH_PORT 80

EXPOSE 80
CMD ["/start"]

