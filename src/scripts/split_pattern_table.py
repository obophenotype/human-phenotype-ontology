import click
import pandas as pd
import os

@click.command()
@click.argument('input_tsv', type=click.Path(exists=True))
@click.argument('output_dir', type=click.Path())
def split_tsv_by_pattern(input_tsv, output_dir):
    """
    This script reads a TSV file and splits it into multiple TSV files based on the "pattern" column.
    
    INPUT_TSV is the path to the input TSV file.
    OUTPUT_DIR is the directory where the output TSV files will be saved.
    """
    # Read the input TSV file
    df = pd.read_csv(input_tsv, sep='\t')

    # Ensure the output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Check if the 'pattern' column exists
    if 'pattern' not in df.columns:
        click.echo("Error: The input TSV file does not contain a 'pattern' column.")
        return

    # Group the dataframe by the 'pattern' column and save each group to a separate TSV file
    for pattern, group in df.groupby('pattern'):
        output_file = os.path.join(output_dir, f"{pattern}.tsv")
        group.drop(columns=['pattern']).to_csv(output_file, sep='\t', index=False)
        click.echo(f"Saved {len(group)} records to {output_file}")

if __name__ == '__main__':
    split_tsv_by_pattern()
