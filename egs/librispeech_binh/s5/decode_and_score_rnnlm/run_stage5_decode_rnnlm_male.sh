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


export decode_cmd="utils/parallel/run.pl --mem 2G"

for part in test_clean_male test_other_male; do
    decode_dir=exp/chain_cleaned/tdnn_1d_sp/decode_${part}_tgsmall;
    rnnlm/lmrescore_pruned.sh \
        --cmd "$decode_cmd --mem 8G" \
        --weight 0.45 --max-ngram-order 4 \
        data/lang_test_tgsmall exp/rnnlm_lstm_1a \
        data/${part} ${decode_dir} \
        exp/chain_cleaned/tdnn_1d_sp/decode_${part}_rescore
done
