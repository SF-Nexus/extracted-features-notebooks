# Extracted Features Notebooks

Updated May 2023

This repository contains notebooks for retrieving and analyzing extracted features from textual corpora. Its intended use is to analyze a collection of science fiction texts at Temple University which are currently under copyright. 

## Contents
This repository contains two folders: 
- **notebooks:** Python and R notebooks for retrieving and analyzing ***extracted features***, or non-consumable, disaggregated versions of copyrighted work for research purposes 
- **data:** Sample texts and outputs 

## Setup

Requires Python 3.9+. Install core dependencies with [uv](https://docs.astral.sh/uv/):

```bash
uv sync
```

Optional dependency groups for specific notebooks:

```bash
uv sync --extra nlp          # BookNLP + spaCy (feature extraction)
uv sync --extra embeddings   # Word2Vec, Atlas, sentence-transformers
uv sync --extra ocr          # Pytesseract OCR
```

Or with pip: `pip install -e ".[nlp,embeddings,ocr]"`

R notebooks require R and RStudio: <https://posit.co/download/rstudio-desktop/>

## Notes

- Files for sectioning/disaggregation must be UTF-8 encoded text (.txt) files
- CSV for LDA topic modeling must contain disaggregated texts; BERTopic works best with aggregated data from which stopwords have NOT been removed
- Parameters (chunk size, number of topics, iterations, passes) are set in the code and documented in comments

## Contributors
**Jeff Antsen:** R notebooks and documentation

**Megan Kane:** Python notebooks and documentation
