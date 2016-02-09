#!/usr/bin/env python

# script to parse the train logs generated by nnet-compute-prob
from __future__ import division
import sys, glob, re, numpy, math, datetime, argparse
from subprocess import Popen, PIPE

#exp/chain/cwrnn_trial2_ld5_sp/log/progress.245.log:LOG (nnet3-show-progress:main():nnet3-show-progress.cc:144) Relative parameter differences per layer are [ Cwrnn1_T3_W_r:0.0171537 Cwrnn1_T3_W_x:1.33338e-07 Cwrnn1_T2_W_r:0.048075 Cwrnn1_T2_W_x:1.34088e-07 Cwrnn1_T1_W_r:0.0157277 Cwrnn1_T1_W_x:0.0212704 Final_affine:0.0321521 Cwrnn2_T3_W_r:0.0212082 Cwrnn2_T3_W_x:1.33691e-07 Cwrnn2_T2_W_r:0.0212978 Cwrnn2_T2_W_x:1.33401e-07 Cwrnn2_T1_W_r:0.014976 Cwrnn2_T1_W_x:0.0233588 Cwrnn3_T3_W_r:0.0237165 Cwrnn3_T3_W_x:1.33184e-07 Cwrnn3_T2_W_r:0.0239754 Cwrnn3_T2_W_x:1.3296e-07 Cwrnn3_T1_W_r:0.0194809 Cwrnn3_T1_W_x:0.0271934 ]

def parse_difference_string(string):
    dict = {}
    for parts in string.split():
        sub_parts = parts.split(":")
        dict[sub_parts[0]] = float(sub_parts[1])
    return dict

def parse_progress_logs(exp_dir, pattern):
    progress_log_files = "%s/log/progress.*.log" % (exp_dir)
    progress_per_iter = {}
    component_names = set([])
    progress_log_proc = Popen('grep -e "{0}" {1}'.format(pattern, progress_log_files),
                              shell=True,
                              stdout=PIPE,
                              stderr=PIPE)
    progress_log_lines = progress_log_proc.communicate()[0]
    parse_regex = re.compile(".*progress\.([0-9]+)\.log:LOG.*{0}.*\[(.*)\]".format(pattern))
    for line in progress_log_lines.split("\n") :
        mat_obj = parse_regex.search(line)
        if mat_obj is None:
            continue
        groups = mat_obj.groups()
        iteration = groups[0]
        differences = parse_difference_string(groups[1])
        component_names  = component_names.union(differences.keys())
        progress_per_iter[int(iteration)] = differences

    component_names = list(component_names)
    component_names.sort()
    # rearranging the data into an array
    data = []
    data.append(["iteration"]+component_names)
    max_iter = max(progress_per_iter.keys())
    for iter in range(max_iter + 1):
        try:
            component_dict = progress_per_iter[iter]
        except KeyError:
            continue
        iter_values = []
        for component_name in component_names:
            try:
                iter_values.append(component_dict[component_name])
            except KeyError:
                # the component was not found this iteration, may be because of layerwise discriminative training
                iter_values.append(0)
        data.append([iter] + iter_values)
    
    return data

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Prints accuracy/log-probability across iterations")
  parser.add_argument("--key", type=str, default="relative-difference",
                       help="Value to print out", choices = ["relative-difference", 'difference'])
  parser.add_argument("exp_dir", help="experiment directory, e.g. exp/nnet3/tdnn")

  args = parser.parse_args()
  exp_dir = args.exp_dir
  if args.key == "relative-difference":
      key = "Relative parameter differences"
  else:
      key = "Parameter differences"
  data = parse_progress_logs(exp_dir, key)
  for row in data:
      print " ".join(map(lambda x:str(x),row))