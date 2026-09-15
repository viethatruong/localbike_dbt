# 🚲 Local Bike 

Projet réalisé dans le cadre de la formation **Analytics Engineer — DataBird** 

Objectif : construire, pour l'enseigne **Local Bike** (Santa Cruz, Baldwin, Rowlett), une plateforme de données fiable permettant à l'équipe *Opérations* de suivre les ventes, les stocks et la performance des magasins, afin d'**optimiser les processus et maximiser le revenu**.

---

## 📌 Contexte métier

Local Bike est un réseau de 3 magasins de vélos aux États-Unis, fondé par Alexander Anthony. L'entreprise vend historiquement via des systèmes disparates (ventes, stocks, clients, staff) et souhaite se lancer dans une démarche **data-driven** : premier tableau de bord, premiers indicateurs, premières bonnes pratiques de modélisation.

En tant qu'**Analytics Engineer**, la mission est de :
1. Définir des axes d'analyse utiles aux opérations (ventes, revenu, stocks, performance magasins/employés).
2. Modéliser les données brutes dans BigQuery via dbt (staging → intermediate → marts).
3. Tester et documenter les modèles, en particulier ceux exposés aux dashboards.
4. Héberger le projet sur GitHub (peer-review) et le connecter à un outil de BI.

---

## 🏗️ Architecture du projet

```
Google Sheets (CSV)  →  Airbyte  →  BigQuery (raw)  →  dbt  →  BigQuery (marts)  →  Power BI
```

| Étape | Outil | Rôle |
|---|---|---|
| **Source** | Google Sheets | Données brutes exportées en fichiers CSV (customers, orders, order_items, products, stores, staffs, stocks, brands, categories) |
| **Ingestion** | Airbyte | Upload des CSV vers BigQuery, dans un dataset `raw` / `local_bike` (aucune transformation, copie fidèle de la source) |
| **Transformation** | dbt | Modélisation en couches successives : `staging` → `intermediate` → `marts`, avec tests et documentation |
| **Visualisation** | Power BI | Connexion aux tables `marts` pour construire les dashboards (ventes, revenu, stocks, performance) |

### Schéma des couches dbt

```
sources (raw.local_bike)
        │
        ▼
   staging (vues)
   stg_brands, stg_categories, stg_customers, stg_orders,
   stg_order_items, stg_products, stg_staffs, stg_stocks, stg_stores
        │
        ▼
   intermediate (vues)
   int_order_items_calculated   → calcul montant brut / remise / net par ligne
   int_orders_enriched          → commandes enrichies avec totaux agrégés
        │
        ▼
   marts (tables)
   dim_customers, dim_products, dim_stores, dim_staffs
   fct_orders, fct_order_items
        │
        ▼
   Power BI (dashboards)
```

---

## 🗂️ Modèle de données source

Le dataset couvre deux domaines :

- **Sales** : `customers`, `orders`, `order_items`, `staffs`, `stores`
- **Production** : `products`, `categories`, `brands`, `stocks`



---

## 🧱 Structure du projet dbt

```
localbike_dbt/
├── models/
│   ├── staging/
│   │   ├── _sources.yml          # déclaration des sources BigQuery (raw)
│   │   ├── _staging.yml          # documentation + tests génériques
│   │   ├── stg_brands.sql
│   │   ├── stg_categories.sql
│   │   ├── stg_customers.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_order_items.sql
│   │   ├── stg_products.sql
│   │   ├── stg_staffs.sql
│   │   ├── stg_stocks.sql
│   │   └── stg_stores.sql
│   ├── intermediate/
│   │   ├── _intermediate.yml
│   │   ├── _unit_tests.yml       # unit tests dbt sur la logique de calcul
│   │   ├── int_order_items_calculated.sql
│   │   └── int_orders_enriched.sql
│   └── marts/
│       ├── _marts.yml
│       ├── dim_customers.sql
│       ├── dim_products.sql
│       ├── dim_stores.sql
│       ├── dim_staffs.sql
│       ├── fct_orders.sql
│       └── fct_order_items.sql
├── tests/
│   ├── assert_order_total_non_negative.sql
│   └── assert_valid_shipping_dates.sql
├── macros/
├── snapshots/
├── seeds/
├── analyses/
└── dbt_project.yml
```

### Détail des couches

**Staging** (matérialisé en `view`)
Nettoyage et renommage 1:1 des tables sources (`raw.local_bike`). Chaque colonne clé est testée (`not_null`, `unique`, `relationships`).

**Intermediate** (matérialisé en `view`)
- `int_order_items_calculated` : calcule le montant brut, la remise et le montant net de chaque ligne de commande.
- `int_orders_enriched` : agrège les lignes de commande pour obtenir le total, le nombre d'articles et le nombre de lignes par commande.

**Marts** (matérialisé en `table`)
- **Dimensions** : `dim_customers`, `dim_products` (enrichi marque + catégorie), `dim_stores`, `dim_staffs`
- **Faits** :
  - `fct_orders` (grain = commande, partitionnée par `order_date`)
  - `fct_order_items` (grain = ligne de commande)

Ces modèles marts sont ceux exposés à l'outil de BI.

---

## ✅ Qualité des données

- **Tests génériques dbt** (`not_null`, `unique`, `relationships`) sur toutes les clés primaires/étrangères, du staging jusqu'aux marts.
- **Tests métier custom** :
  - `assert_order_total_non_negative` : aucune commande ne doit avoir un total négatif.
  - `assert_valid_shipping_dates` : une commande ne peut pas être expédiée avant sa date de commande.
- **Unit tests dbt** sur la couche intermediate, pour valider la logique de calcul (montant net après remise, agrégation du total de commande) indépendamment des données réelles.
- **Documentation** (`dbt docs`) générée sur l'ensemble des modèles, colonnes et tests.

---

## 🚀 Utilisation du projet dbt

```bash
# Installer les dépendances
dbt deps

# Vérifier la connexion à BigQuery
dbt debug

# Lancer l'ensemble des modèles
dbt run

# Lancer les tests (génériques + custom + unit tests)
dbt test

# Générer et consulter la documentation
dbt docs generate
dbt docs serve
```

> Configuration de connexion BigQuery à renseigner dans `profiles.yml` (non versionné), sous le profil `default`.

---

## 🔗 Visualisation

Les tables `marts` (`dim_*`, `fct_*`) sont connectées à **Power BI** pour construire les dashboards de suivi des ventes, du revenu et des stocks à destination de l'équipe Opérations.

### Vue d'ensemble des ventes

![Dashboard Ventes](dashboard/dashboard_remise.png")

Ce dashboard présente une vue globale de l'activité commerciale : revenu total, panier moyen, produits vendus, nombre de commandes et de clients, ainsi que l'évolution des ventes par mois, par magasin, par catégorie et le top 5 des produits par chiffre d'affaires.

### Analyse des remises et du chiffre d'affaires

![Dashboard Remises]("dashboard/dashboard_remise.png")

Ce dashboard détaille le CA net, le CA brut, le montant des remises et le taux de remise global, avec une analyse du taux de remise et du CA par marque.
---

## 🛠️ Stack technique

- **Stockage brut / entrepôt de données** : Google BigQuery
- **Ingestion** : Airbyte
- **Transformation** : dbt (dbt-bigquery)
- **Visualisation** : Power BI
- **Versioning / Peer-review** : GitHub

---

## 👤 Viet Ha TRUONG


