#!/bin/bash

# Define the root directory of the Kaldi project
KALDI_ROOT="./" # Replace with the actual path to your Kaldi root directory

# Find all .sh files and apply dos2unix and chmod +x
# find "$KALDI_ROOT" -type f -name "*.sh" -print0 | xargs -0 -I {} sh -c 'dos2unix "{}" && chmod +x "{}"'

# Find all .pl files and apply dos2unix and chmod +x
find "$KALDI_ROOT" -type f -name "*.pl" -print0 | xargs -0 -I {} sh -c 'dos2unix "{}" && chmod +x "{}"'

echo "Conversion and permission change completed for all .sh and .pl files in $KALDI_ROOT"
