# local_bike_dbt

Projet dbt pour transformer les 9 tables du dataset `local_bike` chargées par Airbyte dans BigQuery.

## Architecture

- `models/staging/local_bike/` : nettoyage et typage des sources Airbyte
- `models/intermediate/` : logique métier intermédiaire
- `models/marts/` : tables analytiques finales
- `tests/` : tests SQL singuliers
- `models/**/_unit_tests.yml` : 2 tests unitaires
- `macros/` : macros réutilisables

## Commandes

```bash
dbt debug
dbt deps
dbt source freshness
dbt build
dbt docs generate
dbt docs serve
```

Ne jamais versionner `profiles.yml` ni les secrets.
