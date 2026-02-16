#!/usr/bin/env python3
"""
Fast version: Find the git commit date when each HP term was first introduced.

This script processes git log output in a single pass to find when declarations
were first added, rather than searching for each term individually.
"""

import subprocess
import sys
import csv
import re
from collections import defaultdict


def main():
    if len(sys.argv) != 3:
        print("Usage: find_term_creation_dates_fast.py <input_terms_file> <output_tsv>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    # Read terms we're looking for
    with open(input_file, 'r') as f:
        target_terms = set(line.strip() for line in f if line.strip())

    print(f"Looking for {len(target_terms)} terms...")

    # Pattern to match HP term declarations in diff output
    decl_pattern = re.compile(r'Declaration\(Class\(<http://purl\.obolibrary\.org/obo/(HP_\d+)>\)\)')

    # Store first occurrence of each term (oldest commit wins)
    term_dates = {}  # term_id -> (commit_hash, date)

    # Get git log with patches, oldest first
    print("Running git log (this may take a few minutes)...")
    result = subprocess.run(
        ["git", "log", "--all", "--reverse", "-p", "--format=COMMIT:%H %aI", "--", "hp-edit.owl"],
        capture_output=True,
        text=True,
        timeout=600
    )

    if result.returncode != 0:
        print(f"Git log failed: {result.stderr}", file=sys.stderr)
        sys.exit(1)

    print("Processing git log output...")

    current_commit = None
    current_date = None
    found_count = 0

    for line in result.stdout.split('\n'):
        if line.startswith('COMMIT:'):
            # New commit
            parts = line[7:].split(' ', 1)
            if len(parts) == 2:
                current_commit = parts[0]
                date = parts[1]
                # Normalize timezone to Z
                if '+' in date:
                    date = date.split('+')[0] + 'Z'
                elif '-' in date[10:]:
                    date = date.rsplit('-', 1)[0] + 'Z'
                elif not date.endswith('Z'):
                    date = date + 'Z'
                current_date = date

        elif line.startswith('+') and 'Declaration(Class' in line and 'HP_' in line:
            # This is an added line with a Declaration
            match = decl_pattern.search(line)
            if match:
                term_id = match.group(1)
                # Only record if it's a term we're looking for AND we haven't seen it before
                if term_id in target_terms and term_id not in term_dates:
                    term_dates[term_id] = (current_commit, current_date)
                    found_count += 1
                    if found_count % 500 == 0:
                        print(f"Found {found_count} terms so far...")

    print(f"\nFound dates for {len(term_dates)} terms")

    # Find terms we couldn't find
    not_found = target_terms - set(term_dates.keys())
    if not_found:
        print(f"Could not find dates for {len(not_found)} terms")

    # Write output
    with open(output_file, 'w', newline='') as f:
        writer = csv.writer(f, delimiter='\t')
        writer.writerow(['ID', 'commit_hash', 'date'])
        for term_id in sorted(term_dates.keys()):
            commit_hash, date = term_dates[term_id]
            writer.writerow([term_id, commit_hash, date])

    print(f"Results written to {output_file}")

    # Also write not-found terms for debugging
    if not_found:
        not_found_file = output_file.replace('.tsv', '_not_found.txt')
        with open(not_found_file, 'w') as f:
            for term_id in sorted(not_found):
                f.write(term_id + '\n')
        print(f"Terms not found written to {not_found_file}")


if __name__ == '__main__':
    main()
