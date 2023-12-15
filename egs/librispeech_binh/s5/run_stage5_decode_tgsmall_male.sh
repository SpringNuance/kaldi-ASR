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


export dir=exp/chain_cleaned/tdnn_1d_sp
export graph_dir=$dir/graph_tgsmall
utils/mkgraph.sh --self-loop-scale 1.0 --remove-oov \
                data/lang_test_tgsmall $dir $graph_dir

export decode_cmd="utils/parallel/run.pl --mem 2G"

for part in test_clean_male test_other_male; do
  steps/nnet3/decode.sh --acwt 1.0 --post-decode-acwt 10.0 \
    --nj 8 --cmd "$decode_cmd" \
    --online-ivector-dir exp/nnet3_cleaned/ivectors_${part} \
    $graph_dir data/${part} $dir/decode_${part}_tgsmall
done

echo "Done decoding for all datasets"


