#!/usr/bin/env python3
"""
Find git commit dates for HP terms - resumable version with progress tracking.

Features:
- Saves commit checkpoint to resume from interruption
- Shows progress bar based on terms found vs target
- Incrementally writes results
- Can be run multiple times to complete

Usage:
    python find_term_creation_dates_resumable.py <input_terms_file> <output_tsv>
"""

import subprocess
import sys
import csv
import re
import os
import json
from pathlib import Path


def load_checkpoint(checkpoint_file):
    """Load checkpoint data if it exists."""
    if os.path.exists(checkpoint_file):
        with open(checkpoint_file, 'r') as f:
            return json.load(f)
    return {'last_commit': None, 'processed_commits': 0}


def save_checkpoint(checkpoint_file, commit_hash, processed_commits):
    """Save checkpoint data."""
    with open(checkpoint_file, 'w') as f:
        json.dump({
            'last_commit': commit_hash,
            'processed_commits': processed_commits
        }, f)


def progress_bar(current, total, width=50):
    """Generate a simple progress bar string."""
    pct = current / total if total > 0 else 0
    filled = int(width * pct)
    bar = '█' * filled + '░' * (width - filled)
    return f"[{bar}] {current}/{total} ({pct*100:.1f}%)"


def main():
    if len(sys.argv) != 3:
        print("Usage: find_term_creation_dates_resumable.py <input_terms_file> <output_tsv>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    checkpoint_file = output_file.replace('.tsv', '_checkpoint.json')

    # Read target terms
    with open(input_file, 'r') as f:
        target_terms = set(line.strip() for line in f if line.strip())

    total_target = len(target_terms)
    print(f"Looking for {total_target} terms...")

    # Load already found terms from output file
    found_terms = {}
    if os.path.exists(output_file):
        with open(output_file, 'r') as f:
            reader = csv.reader(f, delimiter='\t')
            next(reader, None)  # Skip header
            for row in reader:
                if len(row) >= 3:
                    found_terms[row[0]] = (row[1], row[2])
        print(f"Loaded {len(found_terms)} already found terms from {output_file}")

    # Remove already found from targets
    remaining_terms = target_terms - set(found_terms.keys())
    print(f"Still looking for {len(remaining_terms)} terms")

    if not remaining_terms:
        print("All terms already found!")
        return

    # Load checkpoint
    checkpoint = load_checkpoint(checkpoint_file)
    skip_until_commit = checkpoint['last_commit']
    if skip_until_commit:
        print(f"Resuming from commit {skip_until_commit[:12]}...")

    # Pattern for declarations
    decl_pattern = re.compile(r'Declaration\(Class\(<http://purl\.obolibrary\.org/obo/(HP_\d+)>\)\)')

    # Open output in append mode
    mode = 'a' if os.path.exists(output_file) else 'w'
    out_fh = open(output_file, mode, newline='')
    writer = csv.writer(out_fh, delimiter='\t')
    if mode == 'w':
        writer.writerow(['ID', 'commit_hash', 'date'])
        out_fh.flush()

    print("Running git log (streaming)...")
    print(f"Progress: {progress_bar(len(found_terms), total_target)}", flush=True)

    process = subprocess.Popen(
        ["git", "log", "--all", "--reverse", "-p", "--format=COMMIT:%H %aI", "--", "hp-edit.owl"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        bufsize=1
    )

    current_commit = None
    current_date = None
    skipping = skip_until_commit is not None
    processed_commits = checkpoint['processed_commits']
    new_found = 0

    try:
        for line in process.stdout:
            line = line.rstrip('\n')

            if line.startswith('COMMIT:'):
                parts = line[7:].split(' ', 1)
                if len(parts) == 2:
                    current_commit = parts[0]
                    date = parts[1]

                    # Check if we should stop skipping
                    if skipping:
                        if current_commit == skip_until_commit:
                            skipping = False
                            print(f"Reached checkpoint, resuming processing...", flush=True)
                        continue

                    processed_commits += 1

                    # Normalize date
                    if '+' in date:
                        date = date.split('+')[0] + 'Z'
                    elif '-' in date[10:]:
                        date = date.rsplit('-', 1)[0] + 'Z'
                    elif not date.endswith('Z'):
                        date = date + 'Z'
                    current_date = date

                    # Save checkpoint every 100 commits
                    if processed_commits % 100 == 0:
                        save_checkpoint(checkpoint_file, current_commit, processed_commits)

            elif not skipping and line.startswith('+') and 'Declaration(Class' in line and 'HP_' in line:
                match = decl_pattern.search(line)
                if match:
                    term_id = match.group(1)
                    if term_id in remaining_terms and term_id not in found_terms:
                        found_terms[term_id] = (current_commit, current_date)
                        remaining_terms.discard(term_id)
                        writer.writerow([term_id, current_commit, current_date])
                        out_fh.flush()
                        new_found += 1

                        # Update progress bar
                        if new_found % 50 == 0:
                            print(f"\rProgress: {progress_bar(len(found_terms), total_target)}", end='', flush=True)

                        # Exit early if we found all terms
                        if not remaining_terms:
                            print(f"\n\nFound all {total_target} terms!")
                            break

    except KeyboardInterrupt:
        print(f"\n\nInterrupted! Saving checkpoint...")
        save_checkpoint(checkpoint_file, current_commit, processed_commits)
        print(f"Found {new_found} new terms this run ({len(found_terms)} total)")
        print(f"Resume by running the same command again.")
    finally:
        process.terminate()
        out_fh.close()

    print(f"\n\nDone! Found {len(found_terms)}/{total_target} terms total ({new_found} new this run)")
    print(f"Results written to {output_file}")

    # Report not found
    if remaining_terms:
        print(f"Could not find dates for {len(remaining_terms)} terms")
        not_found_file = output_file.replace('.tsv', '_not_found.txt')
        with open(not_found_file, 'w') as f:
            for term_id in sorted(remaining_terms):
                f.write(term_id + '\n')
        print(f"Terms not found written to {not_found_file}")

    # Clean up checkpoint on success
    if not remaining_terms and os.path.exists(checkpoint_file):
        os.remove(checkpoint_file)


if __name__ == '__main__':
    main()
