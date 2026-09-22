# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
## Unreleased
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security
-->

## Unreleased

### Added
- **SonarQube**: added SonarQube service accessible via Traefik (`https://sonar.episciences.org`) for code quality and security analysis.
- **Mailpit**: added Mailpit container for local email interception (SMTP on port 1025, web UI on port 8025 at `https://mailpit.episciences.org`).
- **Makefile targets**:
  - `make urls`: displays all local service URLs and connected applications.
  - `make network`: manages external shared network `epi-network`.
  - `make db-import`, `make db-import-*`: import scripts for all four MySQL databases (episciences, auth, indexing, citations).
  - `make solr-upload-config`, `make solr-create-collection`, `make solr-setup`: Solr configset upload to ZooKeeper and collection creation.
- **Documentation**: added first-time setup instructions, service URLs table, Makefile command reference, and OAI-PMH Next Gen endpoints to `README.md`.

### Changed
- **Shared infrastructure centralization**: centralized shared Docker services (MySQL, Solr, phpMyAdmin, Traefik) and configured Traefik reverse proxy with HTTPS.
- **Network aliases on `epi-network`**:
  - Added Traefik network alias `citations-dev.episciences.org` to allow dynamic DNS resolution and TLS termination for server-to-server calls.
  - Added `db-episciences` alias for `episciences-api`.
  - Added `db-indexing` and `db-auth` aliases for `episciences-manager-ng`.

### Fixed
- **Traefik TLS routing for citations**: moved alias `citations-dev.episciences.org` from `epi-citations-httpd` container to Traefik, ensuring proper TLS termination for internal calls.
- **SonarQube startup**: added healthcheck and `vm.max_map_count` check in Makefile to prevent Bad Gateway errors during Elasticsearch startup.
- **Citations database initialization**: added missing `doctrine_migration_versions` table and seeded initial version in `citations.sql` to avoid table creation without primary keys on import.
- **phpMyAdmin**: switched to `phpmyadmin:5-apache` because the alpine-fpm image does not serve HTTP directly on port 80.

### Removed
- Removed outdated and unused CI workflows (`.github/`).
- Removed IDE tracking (`.idea/`) from Git and added `.gitignore`.
