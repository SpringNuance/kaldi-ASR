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


for part in test_clean test_other dev_clean dev_other; do
    nspk=$(wc -l < data/${part}/spk2utt)
    steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj "${nspk}" \
      data/${part} exp/nnet3_cleaned/extractor \
      exp/nnet3_cleaned/ivectors_${part}
  done

for part in test_clean_male test_other_male dev_clean_male dev_other_male; do
    nspk=$(wc -l < data/${part}/spk2utt)
    steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj "${nspk}" \
      data/${part} exp/nnet3_cleaned/extractor \
      exp/nnet3_cleaned/ivectors_${part}
  done


for part in test_clean_female test_other_female dev_clean_female dev_other_female; do
    nspk=$(wc -l < data/${part}/spk2utt)
    steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj "${nspk}" \
      data/${part} exp/nnet3_cleaned/extractor \
      exp/nnet3_cleaned/ivectors_${part}
  done