# 1000genomes
Analysis Scripts for 1000 genomes


## Thin and convert to smaller vcf files
```sh
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22; do  

   zcat ../ALL.chr$i.ph*.vcf.gz|node ../fq-thin-vcf-file.js --out chr$i.vcf & 
   
done

bcftools concat chr1.vcf chr2.vcf chr3.vcf chr4.vcf chr5.vcf chr6.vcf chr7.vcf chr8.vcf chr9.vcf chr10.vcf chr11.vcf chr12.vcf chr13.vcf chr14.vcf chr15.vcf chr16.vcf chr17.vcf chr18.vcf chr19.vcf chr20.vcf chr21.vcf chr22.vcf > combined.vcf
```



## Generate a subset file for reading with R

```sh
node ../fq-thin-vcf-file.js --out vt.vcf --in chr2.vcf --thin 0.7
bcftools view -s NA20317,NA20318,NA20334,NA20355 vt.vcf|grep -v '^##' > vt2.vcf



```

