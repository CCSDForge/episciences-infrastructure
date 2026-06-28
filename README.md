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

*   **Traefik Dashboard:** [https://traefik.episciences.org/dashboard/](https://traefik.episciences.org/dashboard/)
*   **Solr:** [https://solr.episciences.org](https://solr.episciences.org)
*   **phpMyAdmin:** [https://pma.episciences.org](https://pma.episciences.org)

> **Note:** Ensure these domains map to `127.0.0.1` in your `/etc/hosts` file.

---


**Developed by the [Center for Direct Scientific Communication (CCSD)](https://www.ccsd.cnrs.fr/en/)**
