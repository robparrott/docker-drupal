FROM orchardup/mysql:latest@sha256:d5abef23d5afc4f46ee9e886ca0482d08dbfee4f060c85ce3fb23b975a1457c6

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

EXPOSE 3306
CMD ["/usr/local/bin/run"]