#!/usr/bin/env python3
"""
Find the git commit date when each HP term was first introduced.

This script searches git history for the first commit that added each term's
Declaration to hp-edit.owl.

Results are flushed incrementally so progress is not lost if interrupted.
"""

import subprocess
import sys
import csv
import os
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from threading import Lock


# Lock for thread-safe file writing
write_lock = Lock()


def find_first_commit(term_id: str, owl_file: str = "hp-edit.owl") -> tuple[str, str, str]:
    """
    Find the first commit that introduced a term's Declaration.

    Returns:
        tuple of (term_id, commit_hash, date) or (term_id, "", "") if not found
    """
    search_string = f"Declaration(Class(<http://purl.obolibrary.org/obo/{term_id}>))"

    try:
        # Use git log -S to find commits that introduced this string
        # --reverse gives us oldest first, so we take the first line
        result = subprocess.run(
            ["git", "log", "--all", "-S", search_string,
             "--format=%H %aI", "--reverse", "--", owl_file],
            capture_output=True,
            text=True,
            timeout=120
        )

        if result.returncode == 0 and result.stdout.strip():
            first_line = result.stdout.strip().split('\n')[0]
            parts = first_line.split(' ', 1)
            if len(parts) == 2:
                commit_hash, date = parts
                # Convert ISO date to the format we need
                # Input: 2023-09-16T17:00:10+02:00
                # Output: 2023-09-16T17:00:10Z (normalize to UTC marker)
                if '+' in date:
                    date = date.split('+')[0] + 'Z'
                elif '-' in date[10:]:  # Negative timezone offset
                    date = date.rsplit('-', 1)[0] + 'Z'
                elif not date.endswith('Z'):
                    date = date + 'Z'
                return (term_id, commit_hash, date)

        return (term_id, "", "")

    except subprocess.TimeoutExpired:
        print(f"Timeout searching for {term_id}", file=sys.stderr)
        return (term_id, "", "")
    except Exception as e:
        print(f"Error searching for {term_id}: {e}", file=sys.stderr)
        return (term_id, "", "")


def main():
    if len(sys.argv) != 3:
        print("Usage: find_term_creation_dates.py <input_terms_file> <output_tsv>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    # Read terms
    with open(input_file, 'r') as f:
        terms = [line.strip() for line in f if line.strip()]

    # Check for existing results to resume from
    processed_terms = set()
    if os.path.exists(output_file):
        with open(output_file, 'r') as f:
            reader = csv.reader(f, delimiter='\t')
            next(reader, None)  # Skip header
            for row in reader:
                if row:
                    processed_terms.add(row[0])
        print(f"Found {len(processed_terms)} already processed terms, resuming...")

    # Filter out already processed terms
    terms_to_process = [t for t in terms if t not in processed_terms]
    print(f"Processing {len(terms_to_process)} remaining terms (out of {len(terms)} total)...")

    if not terms_to_process:
        print("All terms already processed!")
        return

    # Open output file in append mode (or write mode if new)
    mode = 'a' if processed_terms else 'w'
    output_fh = open(output_file, mode, newline='')
    writer = csv.writer(output_fh, delimiter='\t')

    if not processed_terms:
        writer.writerow(['ID', 'commit_hash', 'date'])
        output_fh.flush()

    found_count = 0
    not_found_count = 0
    processed_count = 0

    def write_result(term_id, commit_hash, date):
        nonlocal found_count, not_found_count
        with write_lock:
            if commit_hash and date:
                writer.writerow([term_id, commit_hash, date])
                output_fh.flush()  # Flush after each write
                found_count += 1
            else:
                not_found_count += 1

    # Process in parallel for speed
    with ThreadPoolExecutor(max_workers=8) as executor:
        futures = {executor.submit(find_first_commit, term): term for term in terms_to_process}

        for i, future in enumerate(as_completed(futures)):
            term_id, commit_hash, date = future.result()
            write_result(term_id, commit_hash, date)
            processed_count += 1

            if processed_count % 50 == 0:
                print(f"Processed {processed_count}/{len(terms_to_process)} terms "
                      f"(found: {found_count}, not found: {not_found_count})")

    output_fh.close()

    print(f"\nDone! Found dates for {found_count} terms, {not_found_count} not found.")
    print(f"Results written to {output_file}")


if __name__ == '__main__':
    main()
