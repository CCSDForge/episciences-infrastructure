# Episciences Infrastructure

[![Tests](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/tests.yml/badge.svg)](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/tests.yml)
[![Lint](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/lint.yml/badge.svg)](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/lint.yml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Renovate](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com)

This repository contains the shared infrastructure configuration for the [Episciences](https://www.episciences.org/) platform.

## Project Structure

*   **`infra-system/`**: Docker Compose configuration for shared infrastructure (Traefik, Solr, MySQL, phpMyAdmin).
*   **`.github/workflows/`**: Global CI/CD pipelines (Tests, Lint, CodeQL).

## Infrastructure (Root)

The root directory contains shared infrastructure configuration managed via a global `Makefile`.

### First-time Setup

```bash
make up          # creates epi-network, starts all containers
make db-import   # import all four MySQL databases from SQL init files
make solr-setup  # upload configset to ZooKeeper + create Solr collection
```

### Key Commands

| Command | Description |
| :--- | :--- |
| `make up` | Create `epi-network` if absent, start all containers |
| `make network` | Create shared `epi-network` only |
| `make down` | Stop and remove containers |
| `make build` | Pull or rebuild infrastructure services |
| `make restart` | Restart infrastructure containers |
| `make logs` | View output from containers |
| `make ps` | List running containers |
| `make urls` | Show local service URLs |
| `make db-import` | Import all four MySQL databases |
| `make db-import-episciences` | Import episciences DB only |
| `make db-import-auth` | Import auth (cas_users) DB only |
| `make db-import-indexing` | Import Solr indexing queue DB only |
| `make db-import-citations` | Import citations DB only |
| `make solr-upload-config` | Upload episciences configset to ZooKeeper |
| `make solr-create-collection` | Create Solr collection `episciences` |
| `make solr-setup` | Upload configset + create collection |

### Service URLs (Local Development)

All URLs use HTTPS with Traefik's auto-signed certificate (browser will show a security warning — click "Advanced > Proceed").

| Service | URL | Notes |
| :--- | :--- | :--- |
| Traefik Dashboard | https://traefik.episciences.org/dashboard/ | Proxy routing overview |
| Solr | https://solr.episciences.org | Search index admin |
| phpMyAdmin | https://pma.episciences.org | MySQL admin (all 4 DBs) |

### Connected Applications

The following projects connect to this infrastructure via the shared `epi-network` Docker network.
Start this infra first (`make up`) before starting any application.

| Application | Repository | Dev URL | Description |
| :--- | :--- | :--- | :--- |
| episciences-gpl | CCSDForge/episciences | https://dev.episciences.org | Main journal platform |
| episciences-gpl | CCSDForge/episciences | https://oai-dev.episciences.org | OAI-PMH endpoint |
| episciences-gpl | CCSDForge/episciences | https://data-dev.episciences.org | Portal / data site |
| episciences-citations | CCSDForge/episciences-citations | https://citations-dev.episciences.org | Bibliographic references service |
| episciences-api | CCSDForge/episciences-api | https://api-dev.episciences.org | Platform REST API |
| episciences-manager-ng | CCSDForge/episciences-manager-ng | https://manager-ng-dev.episciences.org | Journal manager front-end |

### `/etc/hosts` entries

Add all of the following to `/etc/hosts` to resolve local dev domains:

```
127.0.0.1 traefik.episciences.org
127.0.0.1 solr.episciences.org
127.0.0.1 pma.episciences.org
127.0.0.1 dev.episciences.org
127.0.0.1 oai-dev.episciences.org
127.0.0.1 data-dev.episciences.org
127.0.0.1 citations-dev.episciences.org
127.0.0.1 api-dev.episciences.org
127.0.0.1 manager-ng-dev.episciences.org
```

---


**Developed by the [Center for Direct Scientific Communication (CCSD)](https://www.ccsd.cnrs.fr/en/)**
