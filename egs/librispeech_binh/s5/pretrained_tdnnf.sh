# Download the pre-trained models
# wget http://kaldi-asr.org/models/13/0013_librispeech_v1_chain.tar.gz
# wget http://kaldi-asr.org/models/13/0013_librispeech_v1_extractor.tar.gz
# wget http://kaldi-asr.org/models/13/0013_librispeech_v1_lm.tar.gz

# # Extract the models
# tar -xvzf 0013_librispeech_v1_chain.tar.gz
# tar -xvzf 0013_librispeech_v1_extractor.tar.gz
# tar -xvzf 0013_librispeech_v1_lm.tar.gz

# # Set the directory for the chain model
dir=exp/chain_cleaned/tdnn_1d_sp
graph_dir=$dir/graph_tgsmall

# Create the decoding graph with the small trigram LM
utils/mkgraph.sh --self-loop-scale 1.0 --remove-oov data/lang_test_tgsmall $dir $graph_dir

# Extract i-vectors
for data in test_clean; do
    nspk=$(wc -l <data/${data}/spk2utt)
    steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj "${nspk}" \\
      data/${data} exp/nnet3_cleaned/extractor \\
      exp/nnet3_cleaned/ivectors_${data}
done

# Decode using the small trigram LM
decode_cmd="queue.pl --mem 2G"
for decode_set in test_dev93 test_eval92; do
    steps/nnet3/decode.sh --acwt 1.0 --post-decode-acwt 10.0 \\
        --nj 8 --cmd "$decode_cmd" \\
        --online-ivector-dir exp/nnet3_cleaned/ivectors_${decode_set}_hires \\
        $graph_dir data/${decode_set}_hires $dir/decode_${decode_set}_tgsmall
done

# Score the decoding outputs
for decode_set in test_dev93 test_eval92; do
    steps/score_kaldi.sh --cmd "run.pl" data/${decode_set}_hires $graph_dir $dir/decode_${decode_set}_tgsmall
done

# Rescore with RNNLM
for decode_set in test_dev93 test_eval92; do
    decode_dir=exp/chain_cleaned/tdnn_1d_sp/decode_${decode_set}_tgsmall;
    rnnlm/lmrescore_pruned.sh \\
        --cmd "$decode_cmd --mem 8G" \\
        --weight 0.45 --max-ngram-order 4 \\
        data/lang_test_tgsmall exp/rnnlm_lstm_1a \\
        data/${decode_set}_hires ${decode_dir} \\
        exp/chain_cleaned/tdnn_1d_sp/decode_${decode_set}_rescore
done