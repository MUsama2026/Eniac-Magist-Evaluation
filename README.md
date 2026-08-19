# Eniac × Magist Partnership Evaluation

A data analysis project evaluating whether **Magist** is a suitable distribution partner for **Eniac** to expand its premium, Apple-compatible accessories business into Brazil.

## Business Context

Eniac is considering contracting Magist, a Brazilian e-commerce marketplace, to distribute its products in Brazil. Before committing, Eniac raised two core concerns:

1. **Product fit** — Eniac's catalogue is 100% high-end tech (Apple-compatible accessories). Is Magist a credible channel for premium tech products, or is its marketplace built for a different price tier?
2. **Delivery speed** — Fast delivery is central to Eniac's customer experience. Magist's low shipping cost comes from a deal with Brazil's public Post Office — but is that delivery actually fast and reliable enough?

This project answers both questions using SQL analysis of Magist's full order history, visualized in Tableau and summarized in a business-facing presentation.

## Key Findings (summary)

- Tech products make up ~10–14% of Magist's platform activity (products, sellers, revenue) — established, but not a specialty.
- The median tech transaction is **R$48**; only **4.6%** of tech sales exceed R$300 — Magist's tech buyers skew budget/mid-tier, a mismatch with Eniac's premium pricing.
- ~89% of tech orders arrive on time (~11 days), but delayed orders take **~31 days on average** — nearly 3x longer.
- A delayed delivery drops the average review score from **4.13 to 2.61** (out of 5) — the strongest driver of customer dissatisfaction found in the data.
- Delivery times are not uniform: **Rio de Janeiro customers wait ~48% longer** than São Paulo customers even on-time, tied to seller concentration (268 tech sellers in SP vs. 22 in RJ).
- Delay rates spike under demand (Black Friday, and Brazil's Jan–Feb "Volta às Aulas" back-to-school season), suggesting a scaling/capacity issue rather than a stable delivery guarantee.

**Recommendation:** Conditional yes — enter via a pilot program with tech-specific delivery SLAs and a phased, region-by-region rollout, rather than a full national launch.

## Repository Structure

```
eniac-magist-evaluation/
├── README.md
├── sql/
│   └── Eniac_case.sql          # All analysis queries, organized by question
├── tableau/
│   └── Magist_dashboard.twbx   # Tableau workbook with all charts (packaged with data extract)
└── presentation/
    └── Magist_Evaluation.pptx
```

## Data Source

This project uses the **Magist database** (Brazilian e-commerce order data, ~99,441 orders spanning September 2016 – October 2018), covering orders, order items, products, sellers, customers, geography, reviews, and payments.

## Tools Used

- **MySQL / MySQL Workbench** — data querying and analysis
- **Tableau** — data visualization and interactive dashboards
- **PowerPoint** — final stakeholder presentation
