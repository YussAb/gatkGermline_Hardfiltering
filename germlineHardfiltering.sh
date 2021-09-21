#Perform GATK hard-filtering of germline SNVs and indels
#reference: https://pmbio.org/module-04-germline/0004/02/02/Germline_SnvIndel_FilteringAnnotationReview/

#WARNING NOT WORKING WITH .gz
#germline="/home/yabili/germtest/1_IIT_P01_T0274-1_S10_R1_001_CNN.vcf"
#results="/home/yabili/yussab/germlineHardfiltering/results"
#reference="/data/storage/databases/gatk_bundle/reference/resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta"

germline=${1}
reference=${2}
folder_path_output=${3}

#check per fare la directory di output  
if [ ! -d ${folder_path_output} ] ; then 
    mkdir ${folder_path_output}
fi

function extractname() {
    fullname=$1
    filename=$(basename -- "$fullname")
    name="${filename%%.*}"
    echo $name
}

########################################################
##### OUTPUT
########################################################
nname=$( extractname $germline )
noutput=${folder_path_output}${nname}

#STEP1
# Extract the SNPs from the call set
gatk --java-options '-Xmx60g' SelectVariants -R ${reference}\
    -V ${germline} \
    -select-type SNP\
    -O ${noutput}.snps.vcf

# Extract the indels from the call set
gatk --java-options '-Xmx64g' SelectVariants -R  ${reference}\
    -V ${germline} \
    -select-type INDEL\
    -O  ${noutput}.indels.vcf

#STEP2
# Apply basic filters to the SNP call set
gatk --java-options '-Xmx64g' VariantFiltration -R ${reference}\
    -V ${noutput}.snps.vcf \
    --filter-expression "QD < 2.0" --filter-name "QD_lt_2" --filter-expression "FS > 60.0" --filter-name "FS_gt_60" --filter-expression "MQ < 40.0" --filter-name "MQ_lt_40"\
    --filter-expression "MQRankSum < -12.5" --filter-name "MQRS_lt_n12.5" --filter-expression "ReadPosRankSum < -8.0" --filter-name "RPRS_lt_n8"\
    -O  ${noutput}.snps.filtered.vcf

# Apply basic filters to the INDEL call set
gatk --java-options '-Xmx64g' VariantFiltration -R ${reference}\
    -V ${noutput}.indels.vcf\
    --filter-expression "QD < 2.0" --filter-name "QD_lt_2" --filter-expression "FS > 200.0"\
    --filter-name "FS_gt_200" --filter-expression "ReadPosRankSum < -20.0" --filter-name "RPRS_lt_n20"\
    -O  ${noutput}.indels.filtered.vcf

#STEP3
# Merge filtered SNP and INDEL vcfs back together
gatk --java-options '-Xmx64g' MergeVcfs -I  ${noutput}.snps.filtered.vcf\
    -I  ${noutput}.indels.filtered.vcf\
    -O  ${noutput}.filtered.vcf

# Extract PASS variants only
gatk --java-options '-Xmx64g' SelectVariants -R ${reference} \
    -V  ${noutput}.filtered.vcf\
    -O  ${noutput}.filtered.PASS.vcf\
    --exclude-filtered

rm ${noutput}.snps.vcf ${noutput}.indels.vcf ${noutput}.snps.filtered.vcf ${noutput}.indels.filtered.vcf
rm ${noutput}.snps.vcf.idx ${noutput}.indels.vcf.idx ${noutput}.snps.filtered.vcf.idx ${noutput}.indels.filtered.vcf.idx
