"""
WORKFLOW TO EVALUATE RESSOURCES NECESSARY TO PLACEMENTS
This top snakefile loads all necessary modules and operations.
CPU/RAM/disk measurements are done via SnakeMake "benchmark" functions.
"""

__author__ = "Benjamin Linard, Nikolai Romashchenko"
__license__ = "MIT"

# this config file is set globally for all subworkflows
configfile: "config.yaml"

config["mode"] = "resources"

# explicitly set config as if there was a single pruning which in fact represents the full (NOT pruned) tree.
# this allow to use the same config file for both 'accuracy' and 'resources' modes of PEWO worflow
# NOTE: this statement MUST be set BEFORE the "includes"
config["pruning_count"] = 1
config["read_length"] = [0]

#utils
include:
    "modules/utils/workflow.smk"
include:
    "modules/utils/etc.smk"
#prepare input files
include:
    "modules/op/operate_inputs.smk"
include:
    "modules/op/operate_optimisation.smk"
#phylo-kmer placement, e.g.: rappas
include:
    "modules/op/ar.smk"
include:
    "modules/placement/rappas.smk"
#alignment (for distance-based and ML approaches)
include:
    "modules/alignment/hmmer.smk"
#ML-based placements, e.g.: epa, epang, pplacer
include:
    "modules/placement/epa.smk"
include:
    "modules/placement/pplacer.smk"
include:
    "modules/placement/epang.smk"
#distance-based placements, e.g.: apples
include:
    "modules/placement/apples.smk"
#results and plots
include:
    "modules/op/operate_plots.smk"

rule all:
    input:
        build_resources_workflow()
