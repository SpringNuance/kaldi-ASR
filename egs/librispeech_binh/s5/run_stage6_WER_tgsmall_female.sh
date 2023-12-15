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

for part in test_clean_female test_other_female; do
  steps/scoring/score_kaldi_wer.sh --cmd "$decode_cmd" data/${part} $graph_dir $dir/decode_${part}_tgsmall
  cat exp/chain_cleaned/tdnn_1d_sp/decode_${part}_tgsmall/scoring_kaldi/best_wer
done

echo "Done scoring."

