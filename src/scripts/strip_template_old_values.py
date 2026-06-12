#!/usr/bin/env python3
"""
Strip pre-existing label, definition, and parent axioms from an OWL
functional-syntax file based on a ROBOT-style update template TSV.

Use this before merging a "*_updates.tsv" template that supplies new values
for labels, definitions, or parents — it removes the existing axioms so the
merge does not produce duplicates.

The template is expected to have at least these columns:
  - hpo_id        (term ID, e.g. HP:0005381 or HP_0005381)
  - old_name      (presence signals: strip the term's existing rdfs:label)
  - old_def       (presence signals: strip the term's existing IAO:0000115)
  - old_parents   (pipe-separated list; only HP:xxxxxxx tokens are treated as IDs;
                   each listed parent's named SubClassOf axiom is stripped)

rdfs:label and IAO:0000115 are singletons per term, so matching by ID alone
is sufficient — the literal old text is not consulted. Parents are not
singletons, so per-parent ID matching is used.

Any of the columns may be absent or empty per row; missing columns are skipped.

Usage:
    python3 strip_template_old_values.py <template.tsv> <ontology.owl>

The OWL file is rewritten in place.
"""

import csv
import re
import sys
from pathlib import Path

HP_ID_RE = re.compile(r"HP:\d{7}|HP_\d{7}")


def to_underscore(curie: str) -> str:
    return curie.strip().replace(":", "_")


def parse_template(tsv_path: Path):
    """Yield (hpo_underscore, strip_label, strip_def, [parent_underscore]) per data row."""
    with tsv_path.open(newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh, delimiter="\t")
        for row in reader:
            # ROBOT templates have a second header row with directives like "A IAO:0000115"
            # Skip it: it has no real HP id.
            hpo = (row.get("hpo_id") or "").strip()
            if not hpo or not HP_ID_RE.fullmatch(hpo):
                continue
            strip_label = bool((row.get("old_name") or "").strip())
            strip_def = bool((row.get("old_def") or "").strip())
            old_parents_raw = (row.get("old_parents") or "").strip()
            parents = [
                to_underscore(tok)
                for tok in HP_ID_RE.findall(old_parents_raw)
            ]
            yield to_underscore(hpo), strip_label, strip_def, parents


def build_strip_predicates(template_rows):
    """Return a function `should_drop(line)` that returns True for lines to strip."""
    label_targets = set()  # set of hp_underscore
    def_targets = set()  # set of hp_underscore
    parent_targets = set()  # set of (child_underscore, parent_underscore)

    for hpo, strip_label, strip_def, parents in template_rows:
        if strip_label:
            label_targets.add(hpo)
        if strip_def:
            def_targets.add(hpo)
        for p in parents:
            parent_targets.add((hpo, p))

    def should_drop(line: str) -> bool:
        stripped = line.lstrip()

        if stripped.startswith("AnnotationAssertion"):
            if "IAO_0000115" in stripped:
                for hpo in def_targets:
                    if f"/{hpo}>" in stripped:
                        return True
            if "rdfs:label" in stripped:
                for hpo in label_targets:
                    if f"/{hpo}>" in stripped:
                        return True

        if stripped.startswith("SubClassOf"):
            for child, parent in parent_targets:
                # Match: SubClassOf(<.../child> <.../parent>)
                if (
                    f"/{child}>" in stripped
                    and f"/{parent}>" in stripped
                    # avoid matching anonymous expressions; require the simple form
                    and stripped.rstrip().endswith(f"/{parent}>)")
                ):
                    return True

        return False

    return should_drop, len(label_targets), len(def_targets), len(parent_targets)


def main():
    if len(sys.argv) != 3:
        print(__doc__, file=sys.stderr)
        sys.exit(2)

    tsv_path = Path(sys.argv[1])
    owl_path = Path(sys.argv[2])

    rows = list(parse_template(tsv_path))
    should_drop, n_labels, n_defs, n_parents = build_strip_predicates(rows)

    with owl_path.open(encoding="utf-8") as fh:
        lines = fh.readlines()

    kept = []
    dropped = 0
    for line in lines:
        if should_drop(line):
            dropped += 1
            continue
        kept.append(line)

    owl_path.write_text("".join(kept), encoding="utf-8")

    print(
        f"strip_template_old_values: template={tsv_path} owl={owl_path} "
        f"rows={len(rows)} label_targets={n_labels} def_targets={n_defs} "
        f"parent_targets={n_parents} lines_dropped={dropped}",
        file=sys.stderr,
    )


if __name__ == "__main__":
    main()
