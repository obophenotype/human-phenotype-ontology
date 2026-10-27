#!/usr/bin/env python3
"""
Pre-merge cleanup for a *_updates.tsv ROBOT template that uses new_* columns
as the trigger, plus preservation of old labels as exact synonyms.

For each data row of the template:
  - If `new_def` is non-empty → strip the term's existing IAO:0000115 axiom
    so the new definition does not collide with the old one on merge.
  - If `new_parents` is non-empty → strip the SubClassOf axioms listed in
    `old_parents` (pipe-separated HP IDs) so the new parents replace them.
  - If `new_name` is non-empty (label is being renamed) → capture the term's
    current rdfs:label, strip that label axiom, and emit a row to
    <synonyms_out> so the old label can be merged back in as an
    oboInOwl:hasExactSynonym (preserving discoverability under the old name).

Required template columns: hpo_id, new_name, new_def, new_parents, old_parents.
Any of new_* / old_parents may be absent or empty per row; missing columns
are skipped.

rdfs:label and IAO:0000115 are singletons per term, so matching by ID alone
is sufficient — the literal old text is not consulted for stripping. Parents
are not singletons, so per-parent ID matching against `old_parents` is used.

Usage:
    python3 process_merged_updates.py <template.tsv> <ontology.owl> <synonyms_out.tsv>

The OWL file is rewritten in place. The synonyms_out.tsv is a ROBOT template
TSV (header + directive row) that can be passed to `robot template` alongside
the *_updates.tsv to add the captured labels as exact synonyms.
"""

import csv
import re
import sys
from pathlib import Path

HP_ID_RE = re.compile(r"HP:\d{7}|HP_\d{7}")
LABEL_LINE_RE = re.compile(
    r'rdfs:label\s+<[^>]*/(HP_\d{7})>\s+"((?:[^"\\]|\\.)*)"'
)


def to_underscore(curie: str) -> str:
    return curie.strip().replace(":", "_")


def parse_template(tsv_path: Path):
    """Yield (hpo_underscore, strip_label, strip_def, [parent_underscore]) per data row."""
    with tsv_path.open(newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh, delimiter="\t")
        for row in reader:
            # ROBOT templates have a second header row with directives like
            # "A IAO:0000115". Skip it: it has no real HP id.
            hpo = (row.get("hpo_id") or "").strip()
            if not hpo or not HP_ID_RE.fullmatch(hpo):
                continue
            strip_label = bool((row.get("new_name") or "").strip())
            strip_def = bool((row.get("new_def") or "").strip())
            new_parents_set = bool((row.get("new_parents") or "").strip())
            old_parents_raw = (row.get("old_parents") or "").strip()
            parents = (
                [to_underscore(tok) for tok in HP_ID_RE.findall(old_parents_raw)]
                if new_parents_set
                else []
            )
            yield to_underscore(hpo), strip_label, strip_def, parents


def capture_old_labels(lines, label_targets):
    """Return {hp_underscore: label_text} for each target found in the OWL lines."""
    labels = {}
    for line in lines:
        stripped = line.lstrip()
        if not stripped.startswith("AnnotationAssertion"):
            continue
        if "rdfs:label" not in stripped:
            continue
        m = LABEL_LINE_RE.search(stripped)
        if not m:
            continue
        hpo = m.group(1)
        if hpo in label_targets and hpo not in labels:
            labels[hpo] = m.group(2)
    return labels


def build_strip_predicate(label_targets, def_targets, parent_targets):
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

    return should_drop


def write_synonym_template(out_path: Path, captured_labels):
    """Write a ROBOT template TSV with the captured labels as exact synonyms."""
    with out_path.open("w", newline="", encoding="utf-8") as fh:
        writer = csv.writer(fh, delimiter="\t", lineterminator="\n")
        writer.writerow(["hpo_id", "synonym"])
        writer.writerow(["ID", "A oboInOwl:hasExactSynonym"])
        for hpo, label in sorted(captured_labels.items()):
            writer.writerow([hpo.replace("_", ":"), label])


def main():
    if len(sys.argv) != 4:
        print(__doc__, file=sys.stderr)
        sys.exit(2)

    tsv_path = Path(sys.argv[1])
    owl_path = Path(sys.argv[2])
    syn_out = Path(sys.argv[3])

    rows = list(parse_template(tsv_path))

    label_targets = set()
    def_targets = set()
    parent_targets = set()
    for hpo, strip_label, strip_def, parents in rows:
        if strip_label:
            label_targets.add(hpo)
        if strip_def:
            def_targets.add(hpo)
        for p in parents:
            parent_targets.add((hpo, p))

    with owl_path.open(encoding="utf-8") as fh:
        lines = fh.readlines()

    # Capture labels BEFORE stripping so we can preserve them as synonyms.
    captured_labels = capture_old_labels(lines, label_targets)

    should_drop = build_strip_predicate(label_targets, def_targets, parent_targets)

    kept = [line for line in lines if not should_drop(line)]
    dropped = len(lines) - len(kept)

    owl_path.write_text("".join(kept), encoding="utf-8")
    write_synonym_template(syn_out, captured_labels)

    missing = sorted(label_targets - set(captured_labels.keys()))
    if missing:
        print(
            "process_merged_updates: WARNING — rdfs:label not found in OWL for: "
            + ", ".join(missing),
            file=sys.stderr,
        )

    print(
        f"process_merged_updates: template={tsv_path} owl={owl_path} "
        f"synonyms={syn_out} rows={len(rows)} label_targets={len(label_targets)} "
        f"def_targets={len(def_targets)} parent_targets={len(parent_targets)} "
        f"labels_captured={len(captured_labels)} lines_dropped={dropped}",
        file=sys.stderr,
    )


if __name__ == "__main__":
    main()
