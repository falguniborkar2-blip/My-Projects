# Information Retrieval

Two term projects for the information retrieval course (PV211) at Masaryk University. Both use
the course library [`pv211-utils`](https://github.com/MIR-MU/pv211-utils) to load the data and
score systems with Mean Average Precision (MAP).

## 1. Cranfield collection - [`cranfield_baseline.ipynb`](cranfield_baseline.ipynb)

1,400 aerodynamics paper abstracts and their test queries. The notebook loads and inspects the
documents and queries, builds a bag-of-words retrieval system, and evaluates it with MAP.

## 2. CQADupStack - [`cqadupstack_dense_retrieval.ipynb`](cqadupstack_dense_retrieval.ipynb)

Duplicate-question search over 12 StackExchange forums (Android, Unix, TeX, Stats, ...), part of
the BEIR benchmark.

- I built a **dense retriever**: every document is embedded with the SentenceTransformers model
  `all-MiniLM-L6-v2`, and queries are ranked by **cosine similarity** (top 10), on GPU when available.
- Evaluated with MAP@10.

This was my first dense retrieval system. I later used the same idea (embeddings plus cosine
similarity, combined with BM25) in [OpsLens](https://github.com/falguniborkar2-blip/opslens).

## Run it

Both notebooks install `pv211-utils` in the first cells and download the data automatically.
Google Colab with a GPU is recommended for CQADupStack.
