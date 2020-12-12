# docker-restic-cron

Docker image for [restic](https://github.com/restic/restic) backup solution plus cron.

It adds the ability to schedule the backup operation running the desired restic command through standard cron lines.

# Usage

Set up the `CRON` variable with a restic command. In this minimalistic example we will just display the restic version:

```
docker run \
  -e "CRON=* * * * * restic version" \
  kedu/docker-restic-cron
```

In one minute you should get something similar to:

```
restic 0.11.0 compiled with go1.15.6 on linux/amd64
```

In real use case scenarios you will map docker host directories to docker container, either because they will be source and/or destination of the bacups:

```
-v /path/docker/host/dir:/path/docker/container/dir
```

# Examples

In this example we will setup a minio bucket and will schedule a task to backup the docker host `/tmp` directory on a daily basis at `3:33 am`.

Requirements:

* A minio server
* Access key and secret access key for the minio server
* Password for the restic repository

1. Initialize the repo. To do we can use the regular [restic/restic](https://hub.docker.com/r/restic/restic) docker image

```
docker run \
  --rm \
  -ti \
  -e AWS_ACCESS_KEY_ID=my_access_key \
  -e AWS_SECRET_ACCESS_KEY=my_secret_access_key \
  -e RESTIC_PASSWORD=my_bucket_password \
  -e RESTIC_REPOSITORY=s3:https://minio.example.com/mybucket \
  restic/restic init
```

Expected output similar to:

```
created restic repository 300f7daf49 at s3:https://minio.example.com/mybucket

Please note that knowledge of your password is required to access
the repository. Losing your password means that your data is
irrecoverably lost.
```

2. Backup each minute the content of docker host `/tmp` to the recently created bucket, `mybucket`:

```
docker run \
  --rm \
  -ti \
  -e AWS_ACCESS_KEY_ID=my_access_key \
  -e AWS_SECRET_ACCESS_KEY=my_secret_access_key \
  -e RESTIC_PASSWORD=my_bucket_password \
  -e RESTIC_REPOSITORY=s3:https://minio.example.com/mybucket \
  -e "CRON=* * * * * restic --verbose backup /tmp" \
  -e TZ=Europe/Madrid \
  -v /tmp:/tmp \
  -d kedu/docker-restic-cron
```

# Environment variables

`CRON`

Cron line to execute the command, that typically will include the `restic` binary. Remember to enclose it in double quotes if executed with `docker run`. Example:

```
-e "33 3 * * *  restic --verbose backup /tmp"
```

`TZ`

Optional variable to setup the docker container timezone. If not supplied it will take `UTC`. Example:

```
-e TZ=Europe/Madrid
``` 

Please check all `restic` specific [environment variables](https://restic.readthedocs.io/en/latest/040_backup.html?highlight=RESTIC_REPOSITORY#environment-variables)
