FROM ubuntu:20.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install prerequisites
RUN apt-get update && \
    apt-get upgrade -y --force-yes && \
    apt-get install -y \
    php-cli \
    php-curl \
    curl \
    zip \
    unzip \
    sudo \
    nano \
    dialog \
    apt-utils \
    software-properties-common \
    apt-transport-https \
    lsb-release \
    wget \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Set proper permissions for /tmp
RUN chmod 777 /tmp

# Download and install FOS-Streaming Web Platform
RUN cd /tmp && \
    wget -q https://raw.githubusercontent.com/haco1971/IPTV-MD/master/install_panel.php -O install_panel.php && \
    /usr/bin/php install_panel.php

# Download and execute database installation
RUN cd /tmp && \
    wget -q https://raw.githubusercontent.com/haco1971/IPTV-MD/master/db_install.sh -O db_install.sh && \
    chmod 755 db_install.sh && \
    ./db_install.sh

# Install FFmpeg and FFprobe if not present
RUN if [ ! -f /usr/bin/ffmpeg ]; then \
    cd /tmp && \
    wget -q https://raw.githubusercontent.com/haco1971/IPTV-MD/master/ffmpeg.sh -O ffmpeg.sh && \
    chmod 755 ffmpeg.sh && \
    ./ffmpeg.sh; \
    fi

# Clean up temporary files
RUN rm -rf /tmp/* && \
    rm -rf ~/bin && \
    rm -rf ~/ffmpeg*

# Expose port (adjust as needed for your application)
EXPOSE 8000

# Start command (adjust based on your application's requirements)
CMD ["php", "-S", "0.0.0.0:8000", "-t", "/app"]
