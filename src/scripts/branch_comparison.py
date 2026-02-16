#!/usr/bin/env python3
"""
Compare HPO versions and extract term counts by branch (organ system).

This script:
1. Extracts all HP terms for each top-level branch from two ontology versions
2. Outputs YAML files with terms per branch
3. Computes new terms added to each branch between versions
"""

import argparse
import yaml
from lxml import etree
from collections import defaultdict
from pathlib import Path


# Top-level branches under Phenotypic abnormality (HP:0000118)
BRANCHES = {
    'HP_0000119': 'Abnormality of the genitourinary system',
    'HP_0001871': 'Abnormality of blood and blood-forming tissues',
    'HP_0000152': 'Abnormality of head or neck',
    'HP_0001939': 'Abnormality of metabolism/homeostasis',
    'HP_0000478': 'Abnormality of the eye',
    'HP_0002086': 'Abnormality of the respiratory system',
    'HP_0000707': 'Abnormality of the nervous system',
    'HP_0002664': 'Neoplasm',
    'HP_0040064': 'Abnormality of limbs',
    'HP_0002715': 'Abnormality of the immune system',
    'HP_0000769': 'Abnormality of the breast',
    'HP_0025031': 'Abnormality of the digestive system',
    'HP_0000818': 'Abnormality of the endocrine system',
    'HP_0025142': 'Constitutional symptom',
    'HP_0001197': 'Abnormality of prenatal development or birth',
    'HP_0025354': 'Abnormal cellular phenotype',
    'HP_0001626': 'Abnormality of the cardiovascular system',
    'HP_0001574': 'Abnormality of the integument',
    'HP_0033127': 'Abnormality of the musculoskeletal system',
}

NAMESPACES = {
    'owl': 'http://www.w3.org/2002/07/owl#',
    'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
    'rdfs': 'http://www.w3.org/2000/01/rdf-schema#',
}


def parse_ontology(owl_file: str) -> tuple[dict, dict, set]:
    """
    Parse an OWL file and extract HP class hierarchy.

    Returns:
        parent_child: dict mapping parent ID to set of child IDs
        labels: dict mapping HP ID to label
        deprecated_ids: set of deprecated HP IDs
    """
    tree = etree.parse(owl_file)
    root = tree.getroot()

    parent_child = defaultdict(set)
    labels = {}
    deprecated_ids = set()

    for cls in root.xpath('//owl:Class[starts-with(@rdf:about, "http://purl.obolibrary.org/obo/HP_")]',
                          namespaces=NAMESPACES):
        child_uri = cls.get('{http://www.w3.org/1999/02/22-rdf-syntax-ns#}about')
        child_id = child_uri.replace('http://purl.obolibrary.org/obo/', '')

        # Get label
        label_elem = cls.xpath('.//rdfs:label/text()', namespaces=NAMESPACES)
        if label_elem:
            labels[child_id] = label_elem[0]

        # Check if deprecated
        is_deprecated = cls.xpath('.//owl:deprecated[text()="true"]', namespaces=NAMESPACES)
        if is_deprecated:
            deprecated_ids.add(child_id)
            continue

        # Find parent classes
        for subclass in cls.xpath('.//rdfs:subClassOf[@rdf:resource]', namespaces=NAMESPACES):
            parent_uri = subclass.get('{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource')
            if parent_uri and 'HP_' in parent_uri:
                parent_id = parent_uri.replace('http://purl.obolibrary.org/obo/', '')
                parent_child[parent_id].add(child_id)

    return parent_child, labels, deprecated_ids


def get_all_descendants(node_id: str, parent_child: dict, deprecated_ids: set,
                        visited: set = None) -> set:
    """Recursively get all descendants of a node."""
    if visited is None:
        visited = set()
    if node_id in visited or node_id in deprecated_ids:
        return set()
    visited.add(node_id)

    descendants = set()
    for child in parent_child.get(node_id, set()):
        if child not in deprecated_ids:
            descendants.add(child)
            descendants.update(get_all_descendants(child, parent_child, deprecated_ids, visited.copy()))
    return descendants


def extract_branch_terms(owl_file: str) -> dict[str, dict]:
    """
    Extract all terms for each branch from an ontology file.

    Returns:
        dict mapping branch ID to dict with 'label', 'terms' (list of term IDs)
    """
    parent_child, labels, deprecated_ids = parse_ontology(owl_file)

    branch_data = {}
    for branch_id, branch_label in BRANCHES.items():
        descendants = get_all_descendants(branch_id, parent_child, deprecated_ids)
        branch_data[branch_id] = {
            'label': branch_label,
            'count': len(descendants),
            'terms': sorted(list(descendants))
        }

    return branch_data


def save_branch_yaml(branch_data: dict, output_dir: str, prefix: str):
    """Save branch data to YAML files."""
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    # Save individual branch files
    for branch_id, data in branch_data.items():
        filename = output_path / f"{prefix}_{branch_id}.yaml"
        with open(filename, 'w') as f:
            yaml.dump({branch_id: data}, f, default_flow_style=False, allow_unicode=True)

    # Save summary file
    summary = {branch_id: {'label': data['label'], 'count': data['count']}
               for branch_id, data in branch_data.items()}
    summary_file = output_path / f"{prefix}_summary.yaml"
    with open(summary_file, 'w') as f:
        yaml.dump(summary, f, default_flow_style=False, allow_unicode=True)


def compare_branches(old_data: dict, new_data: dict) -> dict:
    """
    Compare branch data between two versions.

    Returns:
        dict with comparison results including new terms per branch
    """
    comparison = {}

    for branch_id in BRANCHES:
        old_terms = set(old_data.get(branch_id, {}).get('terms', []))
        new_terms = set(new_data.get(branch_id, {}).get('terms', []))

        added = new_terms - old_terms
        removed = old_terms - new_terms

        comparison[branch_id] = {
            'label': BRANCHES[branch_id],
            'old_count': len(old_terms),
            'new_count': len(new_terms),
            'added_count': len(added),
            'removed_count': len(removed),
            'added_terms': sorted(list(added)),
            'removed_terms': sorted(list(removed))
        }

    return comparison


def main():
    parser = argparse.ArgumentParser(
        description='Compare HPO versions and extract term counts by branch'
    )
    parser.add_argument('--old', required=True, help='Path to old HPO OWL file')
    parser.add_argument('--new', required=True, help='Path to new HPO OWL file')
    parser.add_argument('--output-dir', required=True, help='Output directory for YAML files')
    parser.add_argument('--output-comparison', required=True, help='Output file for comparison YAML')
    parser.add_argument('--output-counts', required=True, help='Output file for new term counts')

    args = parser.parse_args()

    print(f"Parsing old ontology: {args.old}")
    old_data = extract_branch_terms(args.old)
    save_branch_yaml(old_data, args.output_dir, 'old')

    print(f"Parsing new ontology: {args.new}")
    new_data = extract_branch_terms(args.new)
    save_branch_yaml(new_data, args.output_dir, 'new')

    print("Comparing versions...")
    comparison = compare_branches(old_data, new_data)

    # Save full comparison
    with open(args.output_comparison, 'w') as f:
        yaml.dump(comparison, f, default_flow_style=False, allow_unicode=True)

    # Save counts summary (markdown format for easy reading)
    with open(args.output_counts, 'w') as f:
        f.write("# New HPO Terms by Branch\n\n")
        f.write(f"Comparison: old vs new\n\n")
        f.write("| Branch | Old Count | New Count | New Terms |\n")
        f.write("|--------|-----------|-----------|----------|\n")

        # Sort by number of new terms descending
        sorted_branches = sorted(comparison.items(),
                                 key=lambda x: x[1]['added_count'],
                                 reverse=True)

        total_old = 0
        total_new = 0
        total_added = 0

        for branch_id, data in sorted_branches:
            f.write(f"| {data['label']} | {data['old_count']:,} | {data['new_count']:,} | {data['added_count']:,} |\n")
            total_old += data['old_count']
            total_new += data['new_count']
            total_added += data['added_count']

        f.write(f"| **Total** | **{total_old:,}** | **{total_new:,}** | **{total_added:,}** |\n")

    print(f"\nResults saved to:")
    print(f"  - Branch YAML files: {args.output_dir}/")
    print(f"  - Comparison YAML: {args.output_comparison}")
    print(f"  - Counts summary: {args.output_counts}")

    # Print summary to stdout
    print("\n" + "="*60)
    print("NEW TERMS BY BRANCH")
    print("="*60)
    for branch_id, data in sorted_branches:
        print(f"{data['label']}: {data['added_count']:,} new terms")
    print("="*60)
    print(f"TOTAL NEW TERMS: {total_added:,}")


if __name__ == '__main__':
    main()
