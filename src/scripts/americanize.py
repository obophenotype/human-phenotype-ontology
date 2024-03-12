import csv
import re
import sys

replacements = {}

input = sys.argv[1]
dictionary = sys.argv[2]

with open(dictionary, "r") as f:
    reader = csv.reader(f)
    next(reader)  # skip header
    replacements = {rows[0]: rows[1] for rows in reader}

with open(input, "r") as f:
    text = f.read()


def replace_words_from_dict(text, word_dict):
    """Replace words in text based on dictionary, ignoring lines with 'uk-spelling'."""

    def replacement(match):
        word = match.group(0)
        clean_word = word.strip('.,!?()[]{}":;')
        return word.replace(clean_word, word_dict.get(clean_word, clean_word))

    # Process the text line by line.
    result_lines = []
    for line in text.split('\n'):
        if 'uk_spelling' in line:
            # Skip replacement for this line.
            result_lines.append(line)
        else:
            # This regex will capture words and preserve punctuations.
            new_line = re.sub(r"\b[\w\'-]+\b", replacement, line)
            # Special case for 'optic disk' -> 'optic disc'; this contradicts the dictionary.
            new_line = new_line.replace('optic disk', 'optic disc')
            new_line = new_line.replace('gasses', 'gases')
            result_lines.append(new_line)

    return '\n'.join(result_lines)


content = replace_words_from_dict(text, replacements)

with open(input, "w") as f:
    f.write(content)
