# Minecraft Paper Server 1.21.4

A Docker-based Paper Minecraft server setup for version 1.21.4, based on the [sems/minecraft-paper-server](https://github.com/sems/minecraft-paper-server) repository.

## Prerequisites

Before you begin, make sure you have Docker installed:
- [Install Docker](https://docs.docker.com/get-docker/)

## Supported Minecraft Versions

- 1.21.4 (214)
- 1.21.3 (82)
- 1.21.1 (132)
- 1.21 (130)
- 1.20.6 (151)
- 1.20.5 (22)
- 1.20.4 (499)
- 1.20.2 (318)
- 1.20.1 (196)
- 1.20 (17)
- 1.19.4 (550)
- 1.19.3 (448)
- 1.19.2 (307)
- 1.19.1 (111)
- 1.19 (81)

## Environment Variables

| Environment Variable | Description | Default Value | Required |
|---------------------|-------------|---------------|----------|
| `MINECRAFT_VERSION` | Minecraft version to use | 1.21.4 | No |
| `ACCEPT_EULA` | Accept Minecraft EULA (set to "true" if you accept them) | false | Yes |
| `MEMORY` | Memory allocation for the server | 2G | No |
| `OP_USERNAME` | Username for the first server operator | - | No |
| `OP_UUID` | UUID of the first server operator | - | No |

## Building and Running

### Build the Docker Image

```bash
docker build -t minecraft-paper-server .
```

### Run the Server

Basic usage (you must accept the EULA):

```bash
docker run -d -p 25565:25565 -p 8123:8123 --name minecraft-paper-server -e ACCEPT_EULA=true minecraft-paper-server
```

With custom memory allocation:

```bash
docker run -d -p 25565:25565 -p 8123:8123 --name minecraft-paper-server -e ACCEPT_EULA=true -e MEMORY=4G minecraft-paper-server
```

With a different Minecraft version:

```bash
docker run -d -p 25565:25565 -p 8123:8123 --name minecraft-paper-server -e ACCEPT_EULA=true -e MINECRAFT_VERSION=1.21.3 minecraft-paper-server
```

With server operator setup (get your UUID from [mcuuid.net](https://mcuuid.net/)):

```bash
docker run -d -p 25565:25565 -p 8123:8123 --name minecraft-paper-server -e ACCEPT_EULA=true -e MEMORY=4G -e OP_USERNAME=YourUsername -e OP_UUID=your-uuid-here minecraft-paper-server
```

### Using Docker Compose (Recommended)

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  minecraft:
    build: .
    container_name: minecraft-paper-server
    ports:
      - "25565:25565"
      - "8123:8123"
    environment:
      - ACCEPT_EULA=true
      - MINECRAFT_VERSION=1.21.4
      - MEMORY=4G
      - OP_USERNAME=YourUsername
      - OP_UUID=your-uuid-here
    volumes:
      - ./world:/minecraft/world
      - ./plugins:/minecraft/plugins
      - ./logs:/minecraft/logs
    restart: unless-stopped
```

Then run:

```bash
docker-compose up -d
```

## Connecting to the Server

1. Open your Minecraft client (version 1.21.4)
2. Go to Multiplayer
3. Add server with address: `localhost:25565` (or your server's IP address)
4. Connect and enjoy!

## Dynmap Access

If you have Dynmap plugin installed, access it at: `http://localhost:8123`

## Managing the Server

### View logs:
```bash
docker logs minecraft-paper-server
```

### Stop the server:
```bash
docker stop minecraft-paper-server
```

### Start the server:
```bash
docker start minecraft-paper-server
```

### Remove the container:
```bash
docker rm minecraft-paper-server
```

### Access server console:
```bash
docker attach minecraft-paper-server
```
(Press `Ctrl+P` then `Ctrl+Q` to detach without stopping the server)

## Adding Plugins

Place plugin JAR files in the `plugins/` directory before building the Docker image, or mount a volume to the plugins directory when running the container.

## Additional Configuration

- **Server settings**: Edit `server.properties` file in the data directory
- **Dynmap settings**: Edit `dynmap_config.txt` file in the `minecraft/plugins/Dynmap` directory

## Features

- **Paper Server**: High-performance Minecraft server software
- **Phantom Spawning Disabled**: By default, Phantoms are disabled (`/gamerule doInsomnia false`)
- **Easy Version Management**: Switch between Minecraft versions using environment variables
- **Docker-based**: Portable and easy to deploy

## Credits

Based on the excellent work by [sems/minecraft-paper-server](https://github.com/sems/minecraft-paper-server)

## License

This project follows the same license as the original repository.
