

#### Extract exome from 1000 genomes #####


system("cat ../CEU.txt ../CHS.txt ../GBR.txt  ../TSI.txt  > pop.txt")


library(ggplot2)
options(stringsAsFactors=F)
options(width=500)

if(file.exists("../../genes.txt")) genefile = "../../genes.txt"
if(file.exists("../genes.txt")) genefile = "../genes.txt"
if(file.exists("genes.txt")) genefile = "genes.txt"
genes = read.table(genefile, as=T)


## Generate exome target list

# genes = genes[1:50,]

## Maybe add 1-2kb windows around genes? 
t = sprintf("%s\t%s\t%s",genes[,1],genes[,2],genes[,3])
t = paste(t,sep="\n",collapse="\n")
cat(t,"\n",file="regions.txt",sep="")


chr = 1
#bcftools view -T regions.txt -S individuals.txt --force-samples ../ALL.chr1.*.vcf.gz > /tmp/2.vcf &
#plink --vcf /tmp/2.vcf --make-bed --maf 0.00001 --out /tmp/chr1-exome






n = 1000
n = nrow(genes)
i=3

system("mkdir -p genes/")


for(i in 1:n) {
print(i)  
chr = genes[i,1]
pos1 = genes[i,2]-1000
pos2 = genes[i,3]+1000
genename = genes[i,7]

vcffile = sprintf("../ALL.chr%s.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz",chr)
outfile = sprintf("/tmp/genes/gene-%s.vcf.gz",genename)

cmd=(sprintf("bcftools view -r %s:%d-%d -O z %s -o %s " ,
       chr,pos1,pos2,vcffile,outfile) )

z=system(cmd,intern=T);cat("\n\n")


cmd = sprintf("plink --vcf %s --out /tmp/genes/g-%s --maf 0.00001 --make-bed --keep pop.txt", outfile, genename)
system(cmd)

  
}
