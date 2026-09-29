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

## Consultas

### Reporte por cliente

```bash
GET http://localhost:3000/reportes/clientes_resumen
```

### Reporte facturas vencidas con saldo

```bash
GET http://localhost:3000/reportes/facturas_vencidas
```

## Pregunta de diseño

Si el job que timbra una factura se ejecuta dos veces por accidente (por ejemplo, un reinicio
del worker a mitad del proceso), ¿cómo evitarías que la factura se timbre dos veces? Describe
tu enfoque en un párrafo."

```
La protección la pongo en la base de datos y no en el job. Cada intento lleva un `external_id` con índice único, y antes de llamar al PAC el servicio toma un lock de fila sobre la factura (`with_lock`, es decir `SELECT ... FOR UPDATE`). Si el job corre dos veces en paralelo, la segunda ejecución espera el lock y, al entrar, encuentra el resultado de la primera por su `external_id` y lo devuelve sin llamar al PAC. Además, el `uuid_fiscal` se guarda en la factura y esta se considera timbrada si ya lo tiene, así que un reintento con otro `external_id` tampoco vuelve a timbrarla. El registro del intento y el UUID se guardan en la misma transacción, por lo que si el worker se reinicia a mitad del proceso, antes del commit, no queda un estado a medias y el reintento empieza limpio. El caso que este diseño no cubre es que el PAC llegue a timbrar y el proceso muera antes del commit: en un sistema real, antes de reintentar habría que consultar el estado en el PAC.
```

```
### Idempotencia ante reinicio del worker

Para evitar un doble timbrado si el worker se reinicia durante el proceso, el `external_id` se utiliza como identificador único del intento de timbrado. Antes de realizar el timbrado se verifica si ya existe un registro con ese `external_id`. Además, el proceso se ejecuta dentro de un `with_lock` sobre la factura, evitando que dos procesos concurrentes realicen el timbrado al mismo tiempo. Finalmente, se agrega una restricción `UNIQUE` sobre `timbrados.external_id` como protección a nivel de base de datos.
```