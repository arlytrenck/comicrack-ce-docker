# comicrack-ce-docker

[ComicRack Community Edition](https://github.com/maforget/ComicRackCE) (a Windows/.NET app) running under Wine, served in the browser through KasmVNC. There is no upstream container, so this one follows the approach of [pezhore/comicrack-docker](https://github.com/pezhore/comicrack-docker).

![ComicRack Community Edition](https://github.com/maforget/ComicRackCE/assets/11904426/4748925c-662f-4ccd-bfb7-62ec46ae881e)

*Screenshot from the [ComicRackCE](https://github.com/maforget/ComicRackCE) project, linked from its README.*

Image: `ghcr.io/arlytrenck/comicrack-ce` (tags: `latest` and the CE version, for example `v0.9.184`). amd64 only.

## Run

```yaml
services:
  comicrack-ce:
    image: ghcr.io/arlytrenck/comicrack-ce:latest
    container_name: comicrack-ce
    shm_size: "1gb"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - ./config:/config
      - /path/to/comics:/comics
    ports:
      - "127.0.0.1:3000:3000"
    restart: unless-stopped
```

Open `http://127.0.0.1:3000`.

## First start

The first start builds the Wine prefix and installs .NET 4.8. It takes 10-20 minutes and the desktop is blank meanwhile. It is done once and kept in `/config`. A healthcheck should allow a long `start_period` (900s).

## Security

KasmVNC has no auth by default. Bind to localhost or put it behind a reverse proxy with authentication. Do not expose port 3000 directly.

## Build

```bash
docker build --build-arg CRCE_VERSION=v0.9.184 -t comicrack-ce .
```

MIT licensed. ComicRack CE is a separate project with its own license.
