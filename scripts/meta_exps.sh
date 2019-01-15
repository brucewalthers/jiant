#!/bin/bash

source user_config.sh
seed=222
cuda=1

### debug ###
#python main.py --config config/meta.conf --overrides "exp_name = metalearn, run_name = debug-meta, max_vals = 3, val_interval = 100, do_train = 1, train_for_eval = 0, train_tasks = \"mnli,snli\", eval_tasks = \"none\", do_eval = 0, cuda = ${cuda}, metatrain = 1, slow_params_approx = 0, sent_enc = conv, d_hid = 512, mnli_pair_attn = 0, snli_pair_attn = 0, multistep_loss = 1"

# ConvLM 
#python -m ipdb main.py --config config/meta.conf --overrides "cuda = ${cuda}, exp_name = metalearn, run_name = debug-convlm, max_vals = 3, val_interval = 100, do_train = 1, train_for_eval = 0, train_tasks = \"wiki2,mnli\", eval_tasks = \"none\", do_eval = 0, cuda = ${cuda}, metatrain = 0, slow_params_approx = 0, sent_enc = convlm, skip_embs = 0, d_hid = 512, mnli_pair_attn = 0, snli_pair_attn = 0, multistep_loss = 1"

# Non-meta, LM tasks
#python main.py --config config/meta.conf --overrides "cuda = ${cuda}, exp_name = metalearn, run_name = debug-convlm-wiki2, val_interval = 1000, do_train = 1, train_for_eval = 0, train_tasks = \"wiki2\", eval_tasks = \"none\", do_eval = 0, cuda = ${cuda}, metatrain = 0, slow_params_approx = 0, sent_enc = convlm, skip_embs = 0, d_hid = 512, mnli_pair_attn = 0, snli_pair_attn = 0, multistep_loss = 1"
#python main.py --config config/meta.conf --overrides "cuda = ${cuda}, exp_name = metalearn, run_name = debug-convlm-wiki103, val_interval = 1000, do_train = 1, train_for_eval = 0, train_tasks = \"wiki103\", eval_tasks = \"none\", do_eval = 0, cuda = ${cuda}, metatrain = 0, slow_params_approx = 0, sent_enc = convlm, skip_embs = 0, d_hid = 512, mnli_pair_attn = 0, snli_pair_attn = 0, multistep_loss = 1"
python main.py --config config/meta.conf --overrides "cuda = ${cuda}, exp_name = metalearn-lm, run_name = preproc-lm, val_interval = 1000, do_train = 1, train_for_eval = 0, train_tasks = \"bwb,wiki103\", eval_tasks = \"none\", do_eval = 0, cuda = ${cuda}, metatrain = 0, slow_params_approx = 0, sent_enc = convlm, skip_embs = 0, d_hid = 512, mnli_pair_attn = 0, snli_pair_attn = 0, multistep_loss = 1"

# Meta, LM tasks
#python main.py --config config/meta.conf --overrides "cuda = ${cuda}, exp_name = metalearn, run_name = debug-meta-convlm, val_interval = 1000, do_train = 1, train_for_eval = 0, train_tasks = \"wiki2,mnli\", eval_tasks = \"none\", do_eval = 0, cuda = ${cuda}, metatrain = 1, slow_params_approx = 0, sent_enc = convlm, skip_embs = 0, d_hid = 512, mnli_pair_attn = 0, snli_pair_attn = 0, multistep_loss = 1"

# MNLI and SNLI
#python main.py --config config/meta.conf --overrides "cuda = ${cuda}, random_seed = ${seed}, run_name = debug-mnli-snli, train_tasks = \"mnli,snli\", metatrain = 1, slow_params_approx = 1, approx_term = cos_sim"

# MNLI and MNLI-alt
#python main.py --config config/meta.conf --overrides "cuda = ${cuda}, random_seed = ${seed}, run_name = debug-mnli-mnli, train_tasks = \"mnli,mnli-alt\", metatrain = 1, slow_params_approx = 1, approx_term = cos_sim"

# Dot product
#python main.py --config config/meta.conf --overrides "cuda = ${cuda}, random_seed = ${seed}, run_name = debug-dot-prod-v2, train_tasks = \"mnli,snli\", metatrain = 1, slow_params_approx = 1, approx_term = dot_product, lr = .00003, sim_lr = .00003, scheduler = cosine, max_sim_grad_norm = 100.0"

# High cosine regularization weight
#python main.py --config config/meta.conf --overrides "cuda = ${cuda}, random_seed = ${seed}, run_name = debug-high-cossim-weight, train_tasks = \"mnli,snli\", metatrain = 1, slow_params_approx = 1, approx_term = cos_sim, lr = .00003, sim_lr = 10.0, scheduler = cosine"

# Optimize cosine similarity
#python main.py --config config/meta.conf --overrides "cuda = ${cuda}, random_seed = ${seed}, train_tasks = \"mnli,snli\", eval_tasks = \"mnli,snli\", run_name = debug-optim-cossim, slow_params_approx = 1, mnli_pair_attn = 0, snli_pair_attn = 0, lr = .00003, sim_lr = .00003, scheduler = cosine, approx_term = only_cos_sim"

## profile ##
#python main_profile.py --config config/debug.conf --overrides "exp_name = metalearn, run_name = prof-exact-nograph, max_vals = 1, val_interval = 10, train_tasks = \"mnli,snli\", metatrain = 1, slow_params_approx = 0, d_hid = 128, batch_size = 4, val_data_limit = 100"
#python main_profile.py --config config/debug.conf --overrides "exp_name = metalearn, run_name = prof-approx, max_vals = 1, val_interval = 10, train_tasks = \"mnli,snli\", metatrain = 1, slow_params_approx = 1, d_hid = 256, val_data_limit = 100"
#python main_profile.py --config config/meta.conf --overrides "cuda = ${cuda}, exp_name = metalearn, run_name = profile-convlm-exact, max_vals = 1, val_interval = 10, val_data_limit = 100, do_train = 1, train_for_eval = 0, train_tasks = \"wiki2,mnli\", eval_tasks = \"none\", do_eval = 0, cuda = ${cuda}, metatrain = 1, slow_params_approx = 0, sent_enc = convlm, skip_embs = 0, d_hid = 512, mnli_pair_attn = 0, snli_pair_attn = 0, multistep_loss = 1"
#python main_profile.py --config config/meta.conf --overrides "cuda = ${cuda}, exp_name = metalearn, run_name = profile-convlm-approx, max_vals = 1, val_interval = 10, val_data_limit = 100, do_train = 1, train_for_eval = 0, train_tasks = \"wiki2,mnli\", eval_tasks = \"none\", do_eval = 0, cuda = ${cuda}, metatrain = 1, slow_params_approx = 1, sent_enc = convlm, skip_embs = 0, d_hid = 512, mnli_pair_attn = 0, snli_pair_attn = 0, multistep_loss = 1"



### FEEL THE METALEARN ###

## Exact ##
#python main.py --config config/meta.conf --overrides "train_tasks = \"mnli,snli\", eval_tasks = \"mnli,snli\", run_name = exact-mnli-snli-schdcos-msl0.01-r0, slow_params_approx = 0, mnli_pair_attn = 0, snli_pair_attn = 0, lr = .00003, sim_lr = .00003, random_seed = ${seed}, scheduler = cosine, multistep_loss = 1, multistep_scale = 0.01" 

## Approx ##
#python main.py --config config/meta.conf --overrides "train_tasks = \"mnli,snli\", eval_tasks = \"mnli,snli\", run_name = approx-mnli-snli-schdcos-r2, slow_params_approx = 1, mnli_pair_attn = 0, snli_pair_attn = 0, lr = .00003, sim_lr = .00003, random_seed = 222, scheduler = cosine" 

## No meta-learning ##
#python main.py --config config/meta.conf --overrides "train_tasks = \"mnli,wiki103\", eval_tasks = \"mnli,wiki103\", run_name = exact-mnli-snli-schdcos-msl0.01-r0, slow_params_approx = 0, mnli_pair_attn = 0, snli_pair_attn = 0, lr = .00003, sim_lr = .00003, random_seed = ${seed}, scheduler = cosine, multistep_loss = 1, multistep_scale = 0.01" 
