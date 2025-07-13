# Docker builds for Velocity Proxy

Provides always the latest Velocity [build](https://papermc.io/downloads/all) for newest available Minecraft release.

## About the image

Image contains PaperMC's Velocity jar and Amazon's [Corretto](https://aws.amazon.com/corretto/) (OpenJDK) runtime.

Build script follows recommendations from official [PaperMC's documentation](https://docs.papermc.io/.).

## Usage

See [example docker-compose.yml](docker-compose.yml) for the reference.

Run container, exposing port `25565` (default Minecraft port):

```bash
docker run -d --name velocity \
  -p 25565:25577 \
  -v /srv/velocity:/velocity \
  ghcr.io/florke-smp/velocity:latest
```

Available enviroment variables listed below:

> TBD

## License

Third party licenses:

- Amazon's [Corretto 21](https://github.com/corretto/corretto-21), licensed under the [GPL-2.0](https://github.com/corretto/corretto-21?tab=GPL-2.0-1-ov-file#readme)
- PaperMC's [Velocity](https://github.com/PaperMC/Velocity), licensed under the [GPL-3.0](https://github.com/PaperMC/Velocity?tab=GPL-3.0-1-ov-file#readme)

Docker build script is licensed under [MIT](https://github.com/Florke-SMP/velocity-docker?tab=MIT-1-ov-file#readme) license.