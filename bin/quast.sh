for f in $(ls *R1*.fastq.gz | sed -r 's/_R1[.]fastq.gz//' | uniq)
do
quast.py spades_${f}/contigs.fa skesa_${f}/contigs.fa megahit_${f}/contigs.fa -1 ${f}_R1.fastq.gz -2 ${f}_R2.fastq.gz -o ${f}_quast_output
done
