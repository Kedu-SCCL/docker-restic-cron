FROM restic/restic:latest

MAINTAINER info@kedu.coop

RUN apk add --update --no-cache \
  # Needed by entrypoint regexp in sed command
  bash

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
