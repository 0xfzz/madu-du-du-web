FROM debian:bookworm-slim

WORKDIR /app

# Install dependencies required by deploy-agent.sh AND lighttpd
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    gnupg \
    lsb-release \
    ca-certificates \
    lighttpd lighttpd-mod-magnet lua-cjson \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration and static files
COPY app/lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY app/headers.lua /etc/lighttpd/headers.lua
COPY app/static_html/ /app/static_html/
COPY app/static/ /app/static_html/static/
COPY entrypoint.sh /entrypoint.sh

# Create logs directory for Lighttpd and ensure www-data can write to it
RUN mkdir -p /app/logs && chown -R www-data:www-data /app/logs /app/static_html

# Declare the logs directory as a volume so the IDS agent can mount it
VOLUME ["/app/logs"]

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
# Run Lighttpd in foreground
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
