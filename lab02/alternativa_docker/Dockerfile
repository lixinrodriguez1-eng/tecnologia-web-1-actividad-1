# Laboratorio virtual de Tecnologia Web I - alternativa a la maquina virtual.
# Ubuntu Server 24.04 con systemd (para usar systemctl igual que en una VM).
# MODIFICADO: los repos de Ubuntu por HTTP daban 403 desde Docker; se usa un espejo por HTTPS.
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive TZ=America/La_Paz
RUN sed -i 's|http://archive.ubuntu.com|https://mirrors.edge.kernel.org|g; s|http://security.ubuntu.com|https://mirrors.edge.kernel.org|g' /etc/apt/sources.list.d/ubuntu.sources \
    && apt-get -o Acquire::https::Verify-Peer=false update \
    && apt-get -o Acquire::https::Verify-Peer=false install -y --no-install-recommends \
      systemd systemd-sysv dbus sudo tzdata locales ca-certificates \
      iproute2 iputils-ping net-tools curl wget nano vim less man-db \
      openssh-server openssh-client htop tree dnsutils git ufw \
    && sed -i 's/^# *es_BO.UTF-8/es_BO.UTF-8/' /etc/locale.gen && locale-gen \
    && rm -f /etc/update-motd.d/* \
    && { find /etc/systemd/system /lib/systemd/system -path '*.wants/*' \
         \( -name '*getty*' -o -name 'systemd-logind*' \) -delete || true; } \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
