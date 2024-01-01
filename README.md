# docker-sshfs

Experimental repo to provide SSHFS to Mac w/o installing Mac Fuse and patching the kernel.

Remote filesystem is mounted in container via SSHFS and exposed to Mac via Samba.

----

Use OrbStack (haven't tested via Docker Desktop)

## Build the container

```bash
docker build -t docker-sshfs . 
```


## Start the container

In one terminal shell, run:

```bash
docker run --privileged --name docker-sshfs -p 139:139 -p 445:445 docker-sshfs
```

## Mounting/Unmounting Remote Filesystem

In another terminal:

```bash
docker exec -it docker-sshfs bash
```

You'll be dropped into the container at this point.

Run (replacing `user@host:path` with your SSHFS endpoint).

```bash
sshfs -o allow_other,uid=1000,gid=1000 user@host:path /samba-share
```

allow-other is needed to be able to access via mac samba
uid=1000,gid=1000 is needed for write-access (otherwise, it will be read-only if omitted)

If wanting to unmount the SSHFS endpoint (without stopping the container):

```bash
fusermount -u /samba-share
```

If getting message: fusermount: failed to unmount /samba-share: Device or resource busy, unmount the drive from Finder

## Connecting to Samba share in container

### Find Docker IP of container (localhost doesn't seem to work for this)

```bash
docker inspect --format '{{ .NetworkSettings.IPAddress }}' docker-sshfs
```

Navigate to Finder -> Go -> Connect to Server

Enter smb://ip-of-docker-container

If all goes well, connect as Guest

Open Finder, navigate to Network tab, find the IP of the Docker container, and you should now have access to remote files