# sshfs-mac-docker

Experimental repo to provide SSHFS to Mac *WITHOUT* installing macFUSE and patching the kernel with a custom kext.

Remote filesystem is mounted in container via SSHFS and exposed to Mac via Samba.

----

Highly recommended to use [OrbStack](https://orbstack.dev/) (haven't yet tested via Docker Desktop).

## Build the container

```bash
docker build -t docker-sshfs . 
```


## Start the container

In one terminal shell, run:

```bash
docker run --privileged --name docker-sshfs -p 127.0.0.1:139:139 -p 127.0.0.1:445:445 docker-sshfs
```

Samba is configured to listen on ports 139 and 445 and is accessible only from localhost.

## Mounting Remote Filesystem

In another terminal:

```bash
docker exec -it docker-sshfs bash
```

You'll be dropped into the container at this point.

Run (replacing `user@host:path` with your SSHFS endpoint):

```bash
sshfs -o allow_other,uid=1000,gid=1000 user@host:path /samba-share
```

allow-other is needed to be able to access via mac samba
uid=1000,gid=1000 is needed for write-access (otherwise, it will be read-only if omitted)

## Connecting to Samba share in container

1. Find Docker IP of container (localhost doesn't seem to work for this)

```bash
docker inspect --format '{{ .NetworkSettings.IPAddress }}' docker-sshfs
```

2. Navigate to Finder -> Go -> Connect to Server

3. Enter `smb://ip-of-docker-container``

    If all goes well, connect as `Guest`.

4. Open `Finder`, navigate to `Network` tab, find the IP of the Docker container, and you should now have access to remote files

## Unmounting Remote Filesystem

If wanting to unmount the SSHFS endpoint (without stopping the container):

```bash
fusermount -u /samba-share
```

If getting message

```bash
fusermount: failed to unmount /samba-share: Device or resource busy
```

...unmount the drive from Finder (or just stop the container)

## Not wanting Docker?

Maybe this will work instead: https://github.com/macos-fuse-t/fuse-t
