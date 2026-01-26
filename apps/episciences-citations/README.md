# Episciences Citations Manager

![GPL](https://img.shields.io/github/license/CCSDForge/episciences-infrastructure)
![Language](https://img.shields.io/github/languages/top/CCSDForge/episciences-infrastructure)
![Symfony](https://img.shields.io/badge/Symfony-6.4-black)
![PHP](https://img.shields.io/badge/PHP-8.2--8.4-777BB4)

[![Tests](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/tests.yml)
[![Lint](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/CCSDForge/episciences-infrastructure/actions/workflows/lint.yml)
[![codecov](https://codecov.io/gh/CCSDForge/episciences-infrastructure/branch/main/graph/badge.svg)](https://codecov.io/gh/CCSDForge/episciences-infrastructure)

A modern web application for managing and visualizing citations from [Episciences](https://www.episciences.org/) publications. The software enables automated extraction, processing, and management of bibliographic references from scientific documents.

**This application is part of the [episciences-infrastructure](https://github.com/CCSDForge/episciences-infrastructure) monorepo.**

Developed by the [Center for Direct Scientific Communication (CCSD)](https://www.ccsd.cnrs.fr/en/).

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Requirements](#requirements)
- [Installation & Development](#installation--development)
  - [Docker Setup (Recommended)](#docker-setup-recommended)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [API Documentation](#api-documentation)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Automated Citation Extraction**: Extract bibliographic references from PDF documents using GROBID
- **Multiple Import Sources**: Support for manual entry, BibTeX import, and Semantic Scholar integration
- **Reference Management**: Add, edit, validate, and organize citations
- **Multi-language Support**: Interface available in English and French
- **Export Capabilities**: Export citations in various formats
- **User Authentication**: Secure CAS-based authentication system
- **Modern UI**: Responsive interface built with Tailwind CSS

## Tech Stack

**Backend:**
- PHP 8.2+
- Symfony 6.4
- Doctrine ORM
- MySQL/MariaDB

**Frontend:**
- Tailwind CSS 3.2.7
- Stimulus (Hotwired)
- Webpack Encore
- FontAwesome 6.4.0

**External Services:**
- GROBID (for PDF citation extraction)
- Semantic Scholar API
- CAS Authentication

## Requirements

- PHP 8.2 or higher
- Composer
- Node.js 16+ and npm/yarn
- MySQL 5.7+ or MariaDB 10.3+
- Docker & Docker Compose (for containerized setup)

## Installation & Development

### Docker Setup (Recommended)

1.  **Clone the monorepo**
    ```bash
    git clone https://github.com/CCSDForge/episciences-infrastructure.git
    cd episciences-infrastructure/apps/episciences-citations
    ```

2.  **Configure environment**
    ```bash
    cp .env .env.local
    # Edit .env.local with your configuration
    ```

3.  **Start Docker containers**
    ```bash
    make up
    ```

4.  **Install dependencies**
    ```bash
    make install-deps
    ```

5.  **Run database migrations**
    ```bash
    docker exec epi-citations-php-fpm php bin/console doctrine:migrations:migrate --no-interaction
    ```

6.  **Build frontend assets**
    ```bash
    make npm-build
    ```

7.  **Access the application**
    *   Application: `https://citations-dev.episciences.org` (ensure this maps to `127.0.0.1` in your hosts file)

## Configuration

### Environment Variables

Key configuration variables in `.env.local`:

```env
# Application
APP_ENV=dev
APP_SECRET=your-secret-key-here

# Database
DATABASE_URL="mysql://user:password@episciences-db-citations:3306/epi-citations?serverVersion=8.0"

# External Services
GROBID_URL=http://grobid-server:8070
SEMANTIC_SCHOLAR_API_URL=https://api.semanticscholar.org/

# CAS Authentication
CAS_SERVER_URL=your-cas-server-url
CAS_SERVICE_URL=your-service-url
```

## Project Structure

This application is located in `apps/episciences-citations` within the monorepo.

```
episciences-citations/
├── assets/                 # Frontend assets
├── config/                 # Symfony configuration
├── docker/                 # Application specific Docker configuration
├── migrations/             # Database migrations
├── public/                 # Web server document root
├── src/
│   ├── Command/            # Console commands
│   ├── Controller/         # HTTP controllers
│   ├── Entity/             # Doctrine entities
│   ├── Repository/         # Doctrine repositories
│   ├── Service/            # Business logic services
│   └── Twig/               # Twig extensions
├── templates/              # Twig templates
├── tests/                  # PHPUnit tests
└── translations/           # i18n files (EN/FR)
```

## API Documentation

The application provides both a web interface and API endpoints:

- **Web Interface**: `/` - Main application interface
- **View References**: `/en/viewref/{docId}` or `/fr/viewref/{docId}`
- **Public API**: Various endpoints for citation retrieval and management

For detailed API documentation, refer to the controller annotations in `src/Controller/`.

## Testing

Tests are run via the `Makefile` in the application directory:

```bash
# Run all tests (PHP + JS)
make test

# Run PHP tests only
make test-php

# Run JavaScript tests only
make test-js
```

## Deployment

### Production Deployment Steps

1.  **Install dependencies (production mode)**
    ```bash
    composer install --no-dev --optimize-autoloader
    npm install --production
    ```

2.  **Build assets**
    ```bash
    npm run build
    ```

3.  **Set environment to production**
    ```bash
    APP_ENV=prod
    ```

4.  **Clear and warm up cache**
    ```bash
    php bin/console cache:clear --env=prod
    php bin/console cache:warmup --env=prod
    ```

5.  **Run migrations**
    ```bash
    php bin/console doctrine:migrations:migrate --no-interaction
    ```

## Contributing

Please refer to the root `README.md` and contribution guidelines of the `episciences-infrastructure` repository.

## License

This project is licensed under the **GNU General Public License v3.0** - see the [LICENSE](../../LICENSE) file in the root directory for details.

## Support

For issues, questions, or contributions:
- Open an issue on [GitHub](https://github.com/CCSDForge/episciences-infrastructure/issues)
- Contact: [CCSD](https://www.ccsd.cnrs.fr/en/)

---

**Developed by [CCSD](https://www.ccsd.cnrs.fr/en/)**
