import argparse
import pandas as pd
import os

def merge_tsv_files(input_files, output_file):
    # Read the first TSV file into a DataFrame
    df = pd.read_csv(input_files[0], sep='\t')

    # Loop through the rest of the input files and concatenate each DataFrame
    for input_file in input_files[1:]:
        df_temp = pd.read_csv(input_file, sep='\t')
        df = pd.concat([df, df_temp], axis=0, ignore_index=True)

    # Write the combined DataFrame to a new TSV file
    df.to_csv(output_file, sep='\t', index=False)
    print(f'Merged TSV files saved as: {output_file}')

def main():
    parser = argparse.ArgumentParser(description='Merge a list of TSV files using Pandas.')
    parser.add_argument('input_files', nargs='+', help='List of input TSV files to merge.')
    parser.add_argument('-o', '--output', default='merged.tsv', help='Output TSV file (default: merged.tsv).')

    args = parser.parse_args()

    if not args.input_files:
        parser.error('Please provide at least one TSV file.')

    for input_file in args.input_files:
        if not os.path.exists(input_file):
            parser.error(f'Input file "{input_file}" does not exist.')

    merge_tsv_files(args.input_files, args.output)

if __name__ == '__main__':
    main()