# gatkGermline_Hardfiltering 
Perform GATK hard-filtering of germline SNVs and indels

## Reference
https://gatk.broadinstitute.org/hc/en-us/articles/360035531112?id=2806

## Example:
```bash
python germlineHardfiltering.py -v /home/germlineHardfiltering/sample.vcf  -r /home/germlineHardfiltering/resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta -o /home/germlineHardfiltering/results
```

## Needed parameters

```bash
python germlineHardfiltering.py --help
```
```bash
usage: germlineHardfiltering.py [-h] -v VCF -o FOLDER -r REFERENCE

Perform GATK hard-filtering of germline SNVs and indels

optional arguments:
  -h, --help            show this help message and exit
  -v VCF, --vcf VCF                     Input VCF file
  -o FOLDER, --folder FOLDER            Output folder
  -r REFERENCE, --reference REFERENCE   Reference genome
```
