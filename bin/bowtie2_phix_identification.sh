reads='/Users/asmakhimani/Desktop/bioinformatics/BIOL_7210/Group1/root_2/comgenomics2024/QAQC/fastp_results/files/'
bowtie2_index="/Users/asmakhimani/Desktop/bioinformatics/BIOL_7210/Group1/Bowtie2Index/genome" # bowtie2 index obatined from illumina igenome phix genome files(https://support.illumina.com/sequencing/sequencing_software/igenome.html)
output_folder="/Users/asmakhimani/Desktop/bioinformatics/BIOL_7210/Group1/new_flagstat_results"

# Make folder for samtools flagstat results
mkdir -p "${output_folder}"

# List all read pairs in the specified folder
read_pairs=("${reads}"*_R1.fastq.gz)

# Iterate over all read pairs
for R1 in "${read_pairs[@]}"; do
    # Replacing _R1 with _R2 in the filename
    R2="${R1/_R1/_R2}"
    
    # Run bowtie2 and pipe the output directly to samtools flagstat
    bowtie2 \
        -x "${bowtie2_index}" \
        -1 "${R1}" \
        -2 "${R2}" \
        --very-sensitive-local \
        -p 16 | samtools flagstat - > "${output_folder}/$(basename -s _R1.fastq.gz -a $R1)Flagstat.txt"
done
