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


# # Begin configuration section.
# nj=4
# cmd=run.pl
# mfcc_config=conf/mfcc.conf
# compress=true
# write_utt2num_frames=true  # If true writes utt2num_frames.
# write_utt2dur=true
# # End configuration section.


# for part in dev_clean test_clean dev_other test_other; do
#   steps/make_mfcc.sh --cmd "$train_cmd" --nj 40 data/$part exp/make_mfcc/$part $mfccdir
#   steps/compute_cmvn_stats.sh data/$part exp/make_mfcc/$part $mfccdir
# done

for part in dev_clean test_clean dev_other test_other; do
  steps/make_mfcc.sh --nj 4 --cmd "$train_cmd" \
                     --mfcc-config conf/mfcc_hires.conf \
                      data/$part exp/make_mfcc/$part $mfccdir
  steps/compute_cmvn_stats.sh data/$part exp/make_mfcc/$part $mfccdir
  utils/fix_data_dir.sh data/${part}
done

for part in dev_clean_male test_clean_male dev_other_male test_other_male; do
  steps/make_mfcc.sh --nj 4 --cmd "$train_cmd" \
                     --mfcc-config conf/mfcc_hires.conf \
                      data/$part exp/make_mfcc/$part $mfccdir
  steps/compute_cmvn_stats.sh data/$part exp/make_mfcc/$part $mfccdir
  utils/fix_data_dir.sh data/${part}
done


for part in dev_clean_female test_clean_female dev_other_female test_other_female; do
  steps/make_mfcc.sh --nj 4 --cmd "$train_cmd" \
                     --mfcc-config conf/mfcc_hires.conf \
                      data/$part exp/make_mfcc/$part $mfccdir
  steps/compute_cmvn_stats.sh data/$part exp/make_mfcc/$part $mfccdir
  utils/fix_data_dir.sh data/${part}
done
