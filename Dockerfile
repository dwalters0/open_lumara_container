FROM docker.io/library/python:3.12-slim

# Avoid interactive package prompts and unbuffer Python logs.
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        git \
        ca-certificates \
        openssh-client \
        openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/sshd

RUN echo 'root:root' | chpasswd
# SSH setup
RUN ssh-keygen -A \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

WORKDIR /root
RUN git clone https://github.com/Rose22/openlumara.git

WORKDIR /root/openlumara
RUN ./install.sh
RUN ./run.sh & sleep 15
RUN sed -i 's/network_mode: local/network_mode: internet/' config.yml
RUN sed -i 's/url: http:\/\/API_URL_HERE\/v1/url: http:\/\/pc.dan:11434\/v1/' config.yml
RUN sed -i "s/name: ''/name: Qwen3.5-9B-Q4_0/" config.yml
RUN sed -i 's/if self.config.get("network_mode") == "internet" and not self.auth_enforced:/if self.config.get("network_mode") == "stahpit" and not self.auth_enforced:/' /root/openlumara/channels/webui/channel.py

WORKDIR /root
COPY start.sh .
RUN chmod +x start.sh

EXPOSE 22
EXPOSE 3000
CMD ["/root/start.sh"]