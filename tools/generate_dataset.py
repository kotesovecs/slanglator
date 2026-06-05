#!/usr/bin/env python3
"""Generates assets/data/slang_dataset.json from curated, real slang data.

Each entry is a tuple: (english, literalCzech, actualMeaningCzech, exampleEn, exampleCz)
grouped by category. Run from the repo root:

    python3 tools/generate_dataset.py
"""

import json
import os

# category key -> list of (english, literalCzech, actualMeaningCzech, exampleEn, exampleCz)
DATA: dict[str, list[tuple[str, str, str, str, str]]] = {}

from data_idioms import IDIOMS
from data_phrasal import PHRASAL_VERBS
from data_daily import DAILY_SPEECH
from data_genz import GEN_Z
from data_internet import INTERNET
from data_social import SOCIAL_MEDIA
from data_gaming import GAMING
from data_dating import DATING
from data_workplace import WORKPLACE
from data_business import BUSINESS
from data_british import BRITISH_SLANG
from data_american import AMERICAN_SLANG

DATA["idioms"] = IDIOMS
DATA["phrasal_verbs"] = PHRASAL_VERBS
DATA["daily_speech"] = DAILY_SPEECH
DATA["gen_z"] = GEN_Z
DATA["internet"] = INTERNET
DATA["social_media"] = SOCIAL_MEDIA
DATA["gaming"] = GAMING
DATA["dating"] = DATING
DATA["workplace"] = WORKPLACE
DATA["business"] = BUSINESS
DATA["british_slang"] = BRITISH_SLANG
DATA["american_slang"] = AMERICAN_SLANG


def main() -> None:
    here = os.path.dirname(os.path.abspath(__file__))
    out_path = os.path.normpath(
        os.path.join(here, "..", "assets", "data", "slang_dataset.json")
    )

    entries = []
    seen = set()
    next_id = 1
    for category, items in DATA.items():
        for english, literal, meaning, ex_en, ex_cz in items:
            key = english.strip().lower()
            if key in seen:
                # Skip accidental duplicates so search stays clean.
                continue
            seen.add(key)
            entries.append(
                {
                    "id": next_id,
                    "english": english,
                    "literalCzech": literal,
                    "actualMeaningCzech": meaning,
                    "category": category,
                    "exampleEn": ex_en,
                    "exampleCz": ex_cz,
                }
            )
            next_id += 1

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(entries, f, ensure_ascii=False, indent=2)
        f.write("\n")

    print(f"Wrote {len(entries)} entries to {out_path}")


if __name__ == "__main__":
    main()
