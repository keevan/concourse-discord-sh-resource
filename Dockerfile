FROM dwdraju/alpine-curl-jq

COPY resource/ /opt/resource
COPY discord.sh/ /discord.sh
RUN chmod +x /opt/resource/* \
 && chmod +x /discord.sh/discord.sh
