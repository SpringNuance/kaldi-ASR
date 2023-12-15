#!/usr/bin/env bash


# Set this to somewhere where you want to put your data, or where
# someone else has already put it.  You'll want to change this
# if you're not on the CLSP grid.

data=export

# base url for downloads.
data_url=www.openslr.org/resources/12
lm_url=www.openslr.org/resources/11
mfccdir=mfcc
stage=1

. ./cmd.sh
. ./path.sh
. parse_options.sh

# you might not want to do this for interactive shells.
set -e

# print current working directory
echo "Current working directory: $(pwd)"


# format the data as Kaldi data directories
for part in dev-clean test-clean dev-other test-other; do
  # use underscore-separated names in data directories.
  local/data_prep.sh $data/LibriSpeech/$part data/$(echo $part | sed s/-/_/g)
done

# format the data as Kaldi data directories
for part in dev-clean-male test-clean-male dev-other-male test-other-male; do
  # use underscore-separated names in data directories.
  local/data_prep.sh $data/LibriSpeech/$part data/$(echo $part | sed s/-/_/g)
done

# format the data as Kaldi data directories
for part in dev-clean-female test-clean-female dev-other-female test-other-female; do
  # use underscore-separated names in data directories.
  local/data_prep.sh $data/LibriSpeech/$part data/$(echo $part | sed s/-/_/g)
done

