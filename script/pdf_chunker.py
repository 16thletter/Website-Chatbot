#!/usr/bin/env python
"""
Extracts semantically-sensible, overlapping chunks from a PDF.
"""

import fitz                 # pip install PyMuPDF
import sys
import json
import re
from pathlib import Path

# Tunables ───────────────────────────────────────────
MAX_WORDS = 200            # words per chunk
OVERLAP = 50               # words of overlap between consecutive chunks

# Utility ────────────────────────────────────────────
_whitespace_re = re.compile(r"\s+")

def clean(text: str) -> str:
    """Collapse whitespace and strip."""
    return _whitespace_re.sub(" ", text).strip()

def split_with_overlap(words, max_words=MAX_WORDS, overlap=OVERLAP):
    """Yield word windows with given overlap."""
    step = max_words - overlap
    for i in range(0, len(words), step):
        yield words[i : i + max_words]

# Main ───────────────────────────────────────────────
def extract_chunks(pdf_path: str):
    doc = fitz.open(pdf_path)
    rows = []

    # Pass 1 - collect text lines + font size
    for page_index, page in enumerate(doc, start=1):
        for block in page.get_text("dict")["blocks"]:
            for line in block.get("lines", []):
                text = clean(" ".join(span["text"] for span in line["spans"]))
                if text:
                    rows.append({
                        "page": page_index,
                        "text": text,
                        "font_size": line["spans"][0]["size"]
                    })

    # Derive heading threshold
    font_sizes = sorted({r["font_size"] for r in rows})
    heading_threshold = font_sizes[-2] if len(font_sizes) > 1 else font_sizes[0]

    # Pass 2 - group text under headings, chunk large bodies with overlap
    chunks = []
    cur_heading = None
    cur_page = None
    cur_text = []

    def flush():
        if not cur_text:
            return
        words = " ".join(cur_text).split()
        for idx, window in enumerate(split_with_overlap(words)):
            chunks.append({
                "page": cur_page,
                "heading": cur_heading,
                "chunk_index": idx,
                "content": " ".join(window),
            })

    for row in rows:
        if row["font_size"] >= heading_threshold:
            flush()
            cur_heading = row["text"]
            cur_page = row["page"]
            cur_text = []
        else:
            cur_page = cur_page or row["page"]
            cur_text.append(row["text"])

    flush()  # flush leftover text

    return chunks

if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Usage: pdf_chunker.py path/to/file.pdf")
    pdf_path = Path(sys.argv[1])
    chunks = extract_chunks(str(pdf_path))
    print(json.dumps(chunks, ensure_ascii=False, indent=2))
