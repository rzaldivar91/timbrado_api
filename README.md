# README

## Requisitos

- Ruby 3.2.2
- PostgreSQL 14+ (probado con 16.15)

# Permisos para crear la base de datos:
```bash
sudo -u postgres psql -c "ALTER USER tu_usuario CREATEDB;"
```

## Setup

```
bundle install
rails db:setup
bundle exec rspec
rails s
```


# timbrado_api
