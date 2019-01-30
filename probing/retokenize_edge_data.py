#!/usr/bin/env python

# Helper script to retokenize edge-probing data.
# Uses the given tokenizer, and saves results alongside the original files
# as <fname>.retokenized.<tokenizer_name>
#
# Supported tokenizers:
# - MosesTokenizer
# - OpenAI.BPE: byte-pair-encoding model for OpenAI transformer LM;
#     see https://github.com/openai/finetune-transformer-lm)
# - bert-*: wordpiece models for BERT; see https://arxiv.org/abs/1810.04805
#     and https://github.com/huggingface/pytorch-pretrained-BERT#usage
#
# Usage:
#  python retokenize_edge_data.py <tokenizer_name> /path/to/data/*.json
#
# Speed: takes around 2.5 minutes to process 90000 sentences on a single core.
#
# Note: for OpenAI.BPE, this requires the `spacy` and `ftfy` packages.
# These should only be needed for this script - main.py shouldn't need to do
# any further preprocessing.
#
# Note: for BERT tokenizers, this requires the 'pytorch_pretrained_bert'
# package.

import sys
import os
import argparse
import json
from tqdm import tqdm

import logging as log
log.basicConfig(format='%(asctime)s: %(message)s',
                datefmt='%m/%d %I:%M:%S %p', level=log.INFO)

from src.utils import utils
from src.utils import retokenize

from src.openai_transformer_lm import utils as openai_utils

from typing import Tuple, List, Text

# For now, this module expects MosesTokenizer as the default.
# TODO: change this once we have better support in core utils.
assert utils.TOKENIZER.__class__.__name__ == "MosesTokenizer"
MosesTokenizer = utils.TOKENIZER

def space_tokenize_with_eow(sentence):
    """Add </w> markers to ensure word-boundary alignment."""
    return [t + "</w>" for t in sentence.split()]

##
# Aligner functions. These take a raw string and return a tuple
# of a TokenAligner instance and a list of tokens.
def align_moses(text: Text) -> Tuple[retokenize.TokenAligner, List[Text]]:
    moses_tokens = MosesTokenizer.tokenize(text)
    cleaned_moses_tokens = utils.unescape_moses(moses_tokens)
    ta = retokenize.TokenAligner(text, cleaned_moses_tokens)
    return ta, moses_tokens

def align_openai(text: Text) -> Tuple[retokenize.TokenAligner, List[Text]]:
    eow_tokens = space_tokenize_with_eow(text)
    bpe_tokens = openai_utils.tokenize(text)
    ta = retokenize.TokenAligner(eow_tokens, bpe_tokens)
    return ta, bpe_tokens

def get_aligner_fn(tokenizer_name: Text):
    if tokenizer_name == "MosesTokenizer":
        return align_moses
    elif tokenizer_name == "OpenAI.BPE":
        return align_openai
    else:
        raise ValueError(f"Unsupported tokenizer '{tokenizer_name}'")

def retokenize_record(record, tokenizer_name):
    """Retokenize an edge probing example. Modifies in-place."""
    text = record['text']
    aligner_fn = get_aligner_fn(tokenizer_name)
    ta, new_tokens = aligner_fn(text)
    record['text'] = " ".join(new_tokens)
    for target in record['targets']:
        if 'span1' in target:
            target['span1'] = list(map(int,
                                       ta.project_span(*target['span1'])))
        if 'span2' in target:
            target['span2'] = list(map(int,
                                       ta.project_span(*target['span2'])))
    return record


def retokenize_file(fname, tokenizer_name):
    new_name = fname + ".retokenized." + tokenizer_name
    log.info("Processing file: %s", fname)
    record_iter = list(utils.load_json_data(fname))
    log.info("  saving to %s", new_name)
    with open(new_name, 'w') as fd:
        for record in tqdm(record_iter):
            new_record = retokenize_record(record, tokenizer_name)
            fd.write(json.dumps(new_record))
            fd.write("\n")


def main(args):
    parser = argparse.ArgumentParser()
    parser.add_argument('tokenizer_name', type=str,
                        help="Tokenizer name.")
    parser.add_argument('inputs', type=str, nargs="+",
                        help="Input JSON files.")
    args = parser.parse_args(args)

    for fname in args.inputs:
        retokenize_file(fname, args.tokenizer_name)


if __name__ == '__main__':
    main(sys.argv[1:])
    sys.exit(0)
