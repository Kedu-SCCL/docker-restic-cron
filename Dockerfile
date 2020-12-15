FROM restic/restic:latest

MAINTAINER info@kedu.coop

RUN apk add --update --no-cache \
  # Needed by entrypoint regexp in sed command
  bash \
  # Needed to support TZ environment variable
  tzdata

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
