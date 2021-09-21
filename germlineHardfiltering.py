#!/bin/bash/python

import os
import argparse
import string

parser = argparse.ArgumentParser(description="Perform GATK hard-filtering of germline SNVs and indels")
parser.add_argument("-v", "--vcf" ,help="Input VCF file", required=True)
parser.add_argument("-o", "--folder", help="Output folder", required=True)
parser.add_argument("-r", "--reference", help="Reference genome", required=True)
args = parser.parse_args()

if not args.folder.endswith("/"):
        args.folder = args.folder + "/"

os.system("bash ./germlineHardfiltering.sh " + args.vcf + " " +  args.reference + " " +  args.folder )

