FROM debian:jessie

ENV GRAFANA_VERSION 3.1.1-1470047149

RUN apt-get update && \
    apt-get -y --no-install-recommends install libfontconfig curl ca-certificates && \
    apt-get clean && \
    curl https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb > /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    apt-get remove -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /srv/grafana && \
    mv /var/lib/grafana /srv/grafana/data && \
    mv /var/log/grafana /srv/grafana/log

VOLUME ["/srv/grafana"]

EXPOSE 3000

USER grafana

ENTRYPOINT ["/usr/sbin/grafana-server", "--homepath=/usr/share/grafana", "--config=/etc/grafana/grafana.ini", "cfg:default.paths.data=/srv/grafana/data", "cfg:default.paths.logs=/srv/grafana/log"]
