FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DOWNLOAD_DIR=/download
ENV FILEBROWSER_PORT=8081
ENV TRANSMISSION_PORT=8082
ENV NGINX_PORT=8080

# Install required packages
RUN apt-get update && apt-get install -y \
    curl wget nano gnupg ca-certificates \
    transmission-daemon nginx \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Create download folder
RUN mkdir -p ${DOWNLOAD_DIR}

# Install FileBrowser
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
RUN filebrowser config init \
    && filebrowser config set --port ${FILEBROWSER_PORT} --root ${DOWNLOAD_DIR}

# Configure Transmission
RUN mkdir -p /etc/transmission-daemon
COPY transmission-settings.json /etc/transmission-daemon/settings.json

# Nginx setup
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports
EXPOSE ${NGINX_PORT}

# Start all services
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
