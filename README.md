# Episciences Infrastructure & Applications

[![Tests](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/tests.yml/badge.svg)](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/tests.yml)
[![Lint](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/lint.yml/badge.svg)](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/lint.yml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Renovate](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com)
[![PHP](https://img.shields.io/badge/PHP-8.2--8.4-777BB4.svg)](https://www.php.net/)
[![Symfony](https://img.shields.io/badge/Symfony-6.4-black.svg)](https://symfony.com/)

This repository is a monorepo containing the shared infrastructure configuration and various applications for the [Episciences](https://www.episciences.org/) platform.

## Project Structure

*   **`infra-system/`**: Docker Compose configuration for shared infrastructure (Traefik, Solr, MySQL, phpMyAdmin).
*   **`apps/`**: Individual applications.
    *   **`apps/episciences-citations/`**: A Symfony 6.4 application for managing and visualizing bibliographic citations.
*   **`.github/workflows/`**: Global CI/CD pipelines (Tests, Lint, CodeQL).

## Infrastructure (Root)

The root directory contains shared infrastructure configuration managed via a global `Makefile`.

### Key Commands (Root)

| Command | Description |
| :--- | :--- |
| `make up` | Start all infrastructure containers in detached mode |
| `make down` | Stop and remove containers and networks |
| `make build` | Pull or rebuild infrastructure services |
| `make restart` | Restart infrastructure containers |
| `make logs` | View output from containers |
| `make ps` | List running containers |
| `make urls` | Show local service URLs |

### Service URLs (Local Development)

*   **Traefik Dashboard:** [https://traefik.episciences.org/dashboard/](https://traefik.episciences.org/dashboard/)
*   **Solr:** [https://solr.episciences.org](https://solr.episciences.org)
*   **phpMyAdmin:** [https://pma.episciences.org](https://pma.episciences.org)

> **Note:** Ensure these domains map to `127.0.0.1` in your `/etc/hosts` file.

---

## Applications

### Episciences Citations Manager (`apps/episciences-citations`)

A modern web application for automated extraction and management of bibliographic references.

*   **Tech Stack:** PHP 8.2, Symfony 6.4, Doctrine ORM, MySQL, Tailwind CSS, Stimulus.
*   **Documentation:** See [apps/episciences-citations/README.md](apps/episciences-citations/README.md) for detailed instructions.

#### Quick Start (App)

All application-specific commands should be run from the `apps/episciences-citations/` directory:

```bash
cd apps/episciences-citations
make install-deps  # Install PHP and JS dependencies
make up            # Start app containers
make ci            # Run tests and linting locally
```

## CI/CD and Maintenance

*   **GitHub Actions:** Automated testing and linting workflows are triggered on every push and pull request affecting the application code.
*   **Renovate:** Automated dependency updates are configured to keep the stack secure and up-to-date.
*   **Dependabot:** Monitors GitHub Action versions.

---

**Developed by the [Center for Direct Scientific Communication (CCSD)](https://www.ccsd.cnrs.fr/en/)**