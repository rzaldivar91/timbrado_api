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
Para evitar el doble timbrado tenemos a la factura con with_lock, lo que evita que se ejecuten dos peticiones de timbrado al mismo tiempo sobre esa misma factura. Así, al terminar la primera petición, la segunda verifica el external_id y al detectar que ya existe un intento con ese external_id, devolvemos la respuesta del primer intento.
En dado caso que llegue un segundo intento con otro external_id para la misma factura y que éste ya esté timbrada, guardamos el uuid_fiscal en la factura y nos regresa la misma respuesta del primer intento exitoso, sin volver a llamar al pac.
Si el worker se reincia a la mitad del proceso y la transacción se revierte, o sea que no se guarda nada, el reintento vuelve a hacer todo desde cero. Y si el pac ya había timbrado, el external_id serviría como clave de idempotencia hacia el pac, al reintentar con la misma clave regresaría el cfdi que ya tiene.
```