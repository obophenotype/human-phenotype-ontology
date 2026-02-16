#!/usr/bin/env python3
"""
Streaming version: Find git commit dates by processing output incrementally.
"""

import subprocess
import sys
import csv
import re


def main():
    if len(sys.argv) != 3:
        print("Usage: find_term_creation_dates_stream.py <input_terms_file> <output_tsv>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    # Read terms we're looking for
    with open(input_file, 'r') as f:
        target_terms = set(line.strip() for line in f if line.strip())

    print(f"Looking for {len(target_terms)} terms...", flush=True)

    # Pattern to match HP term declarations
    decl_pattern = re.compile(r'Declaration\(Class\(<http://purl\.obolibrary\.org/obo/(HP_\d+)>\)\)')

    # Store first occurrence of each term
    term_dates = {}

    # Open output file for incremental writes
    out_fh = open(output_file, 'w', newline='')
    writer = csv.writer(out_fh, delimiter='\t')
    writer.writerow(['ID', 'commit_hash', 'date'])
    out_fh.flush()

    print("Running git log (streaming)...", flush=True)

    # Stream git log output
    process = subprocess.Popen(
        ["git", "log", "--all", "--reverse", "-p", "--format=COMMIT:%H %aI", "--", "hp-edit.owl"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        bufsize=1
    )

    current_commit = None
    current_date = None
    found_count = 0
    line_count = 0

    try:
        for line in process.stdout:
            line_count += 1
            line = line.rstrip('\n')

            if line.startswith('COMMIT:'):
                parts = line[7:].split(' ', 1)
                if len(parts) == 2:
                    current_commit = parts[0]
                    date = parts[1]
                    if '+' in date:
                        date = date.split('+')[0] + 'Z'
                    elif '-' in date[10:]:
                        date = date.rsplit('-', 1)[0] + 'Z'
                    elif not date.endswith('Z'):
                        date = date + 'Z'
                    current_date = date

            elif line.startswith('+') and 'Declaration(Class' in line and 'HP_' in line:
                match = decl_pattern.search(line)
                if match:
                    term_id = match.group(1)
                    if term_id in target_terms and term_id not in term_dates:
                        term_dates[term_id] = (current_commit, current_date)
                        writer.writerow([term_id, current_commit, current_date])
                        out_fh.flush()
                        found_count += 1
                        if found_count % 100 == 0:
                            print(f"Found {found_count} terms (processed {line_count:,} lines)...", flush=True)

            if line_count % 1000000 == 0:
                print(f"Processed {line_count:,} lines, found {found_count} terms so far...", flush=True)

    except KeyboardInterrupt:
        print(f"\nInterrupted! Found {found_count} terms so far.")
    finally:
        process.terminate()
        out_fh.close()

    print(f"\nDone! Found dates for {found_count} terms")
    print(f"Results written to {output_file}")

    # Report not found
    not_found = target_terms - set(term_dates.keys())
    if not_found:
        print(f"Could not find dates for {len(not_found)} terms")
        not_found_file = output_file.replace('.tsv', '_not_found.txt')
        with open(not_found_file, 'w') as f:
            for term_id in sorted(not_found):
                f.write(term_id + '\n')
        print(f"Terms not found written to {not_found_file}")


if __name__ == '__main__':
    main()
