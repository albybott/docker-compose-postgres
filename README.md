# Docker Compose with PostgreSQL ready to use

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/felipewom)

This tutorial teaches you how to create a Postgres Docker Compose file.

>Last updated May 28, 2026 </br>
Time to read 3m

## Context

### Why using Docker Compose to a create Postgres database

PostgreSQL is one of the most used database engines nowadays. If you're here today, it's because you probably need it in your project!

When I'm working on a new project, I like to have a clean environment. One of the things I dislike the most is installing "big" tools on my computers (for example, a database engine).

I like to use containers for some of my tools. I'm not going to lie, I'm not constantly moving all my environments to Docker, but I like to have a part of it in a dedicated one.

One command is enough to set up a Postgres database in Docker from scratch with new parameters. With one command, you can also shut down all the environment and free your computer from work.

## Quick Start

Clone this repo and run the setup script:

```shell
git clone <repo-url> my-project && cd my-project
./setup.sh
docker compose up -d
```

The setup script will prompt you for configuration with sensible auto-generated defaults:

- **User**: `postgres`
- **Password**: a random 24-character alphanumeric string
- **Database**: `postgres`
- **Port**: a random port in the range 41860–41870
- **Host**: auto-detected LAN IP (macOS and Linux), falls back to `localhost`

All values are read from the existing `.env` on re-runs, so running `./setup.sh` again is non-destructive — current values are shown as defaults.

### Connection string

After setup, a connection string is printed:

```
postgresql://postgres:<password>@<host>:<port>/postgres
```

You can regenerate it at any time:

```shell
./connection-string.sh
```

## File structure

```
.
├── compose.yml      # Docker Compose config
├── setup.sh         # Interactive .env setup
├── connection-string.sh  # Generate a connection string from .env
├── init.sql         # Runs on first database launch
├── .env             # Created by setup.sh (gitignored)
└── db-data/         # Persisted database data (gitignored)
```

## How it works

### compose.yml

Uses the official [PostgreSQL image](https://hub.docker.com/_/postgres) pinned to version 17. Configuration is read from `.env` via the `env_file` directive, and the host port is set via `${PORT:-5432}`.

```yaml
services:
  database:
    image: 'postgres:17'
    ports:
      - ${PORT:-5432}:5432
    env_file:
      - .env
    volumes:
      - ${PWD}/db-data/:/var/lib/postgresql/data/
      - ${PWD}/init.sql:/docker-entrypoint-initdb.d/init.sql
```

### .env variables

| Variable | Description | Default |
|---|---|---|
| `POSTGRES_USER` | Database user | `postgres` |
| `POSTGRES_PASSWORD` | Database password | Random 24-char string |
| `POSTGRES_DB` | Default database name | `postgres` |
| `PORT` | Host port mapped to container | Random in 41860–41870 |
| `HOST` | Host IP for connection string | Auto-detected LAN IP |

### init.sql

An initialization script that runs when the database is first created. You can edit `init.sql` to add your own tables and seed data. It will only run on first launch — to re-run it, delete the `db-data/` folder.

### Data persistence

Database data is stored in the `db-data/` folder on your host via a Docker volume. This survives container restarts. To start fresh, stop the container and delete `db-data/`.

## Usage

### Start the database

```shell
docker compose up -d
```

### Stop the database

```shell
docker compose down
```

### View connection info

```shell
./connection-string.sh
```

### Reconfigure

Run setup again to change any values — existing values are preserved as defaults:

```shell
./setup.sh
```

## Author

- **Felipe Moura** - [felipewom](https://github.com/felipewom)
