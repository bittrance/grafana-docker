FROM debian:jessie

ENV GRAFANA_VERSION 2.5.0

RUN apt-get update && \
    apt-get -y --no-install-recommends install libfontconfig curl ca-certificates && \
    apt-get clean && \
    curl https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb > /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    apt-get remove -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/grafana && \
    mv /var/lib/grafana /opt/grafana/data && \
    mv /var/log/grafana /opt/grafana/log && \
    mv /etc/grafana /opt/grafana/etc

VOLUME ["/opt/grafana/data", "/opt/grafana/log", "/opt/grafana/etc"]

EXPOSE 3000

USER grafana

ENTRYPOINT ["/usr/sbin/grafana-server", "--homepath=/usr/share/grafana", "--config=/opt/grafana/etc/grafana.ini", "cfg:default.paths.data=/opt/grafana/data", "cfg:default.paths.logs=/opt/grafana/log"]
