#Perform GATK hard-filtering of germline SNVs and indels
#reference: https://pmbio.org/module-04-germline/0004/02/02/Germline_SnvIndel_FilteringAnnotationReview/

#WARNING NOT WORKING WITH .gz
germline="/home/yabili/yussab/SomaticLOHCalling/test/HKNPC-076N/HaplotypeCaller/HaplotypeCaller_HKNPC-076N.vcf"
results="/home/yabili/yussab/GermlineFiltering/results"
reference="/home/yabili/storage/references/gatk_bundle/reference/resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta"

# Extract the SNPs from the call set
gatk --java-options '-Xmx60g' SelectVariants -R ${reference}\
    -V ${germline} \
    -select-type SNP\
    -O ${results}/WGS_Norm_HC_calls.snps.vcf

# Extract the indels from the call set
gatk --java-options '-Xmx64g' SelectVariants -R  ${reference}\
    -V ${germline} \
    -select-type INDEL\
    -O  ${results}/WGS_Norm_HC_calls.indels.vcf


# Apply basic filters to the SNP call set
gatk --java-options '-Xmx64g' VariantFiltration -R ${reference}\
    -V ${results}/WGS_Norm_HC_calls.snps.vcf\
    --filter-expression "QD < 2.0" --filter-name "QD_lt_2" --filter-expression "FS > 60.0" --filter-name "FS_gt_60" --filter-expression "MQ < 40.0" --filter-name "MQ_lt_40"\
    --filter-expression "MQRankSum < -12.5" --filter-name "MQRS_lt_n12.5" --filter-expression "ReadPosRankSum < -8.0" --filter-name "RPRS_lt_n8"\
    -O  ${results}/WGS_Norm_HC_calls.snps.filtered.vcf

# Apply basic filters to the INDEL call set
gatk --java-options '-Xmx64g' VariantFiltration -R ${reference}\
    -V ${results}/WGS_Norm_HC_calls.indels.vcf\
    --filter-expression "QD < 2.0" --filter-name "QD_lt_2" --filter-expression "FS > 200.0"\
    --filter-name "FS_gt_200" --filter-expression "ReadPosRankSum < -20.0" --filter-name "RPRS_lt_n20"\
    -O  ${results}/WGS_Norm_HC_calls.indels.filtered.vcf

# Merge filtered SNP and INDEL vcfs back together
gatk --java-options '-Xmx64g' MergeVcfs -I  ${results}/WGS_Norm_HC_calls.snps.filtered.vcf\
    -I  ${results}/WGS_Norm_HC_calls.indels.filtered.vcf\
    -O  ${results}/WGS_Norm_HC_calls.filtered.vcf

# Extract PASS variants only
gatk --java-options '-Xmx64g' SelectVariants -R ${reference} \
    -V  ${results}/WGS_Norm_HC_calls.filtered.vcf\
    -O  ${results}/WGS_Norm_HC_calls.filtered.PASS.vcf\
    --exclude-filtered

