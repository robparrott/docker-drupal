FROM jacksoncage/varnish

ADD default.vcl /etc/varnish/default.vcl
ADD ./start.sh /start
RUN chmod +x /start 

ENV VARNISH_PORT 80

EXPOSE 80
CMD ["/start"]

