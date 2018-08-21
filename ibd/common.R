library(RSQLite)
library(RMySQL)
library(RPostgreSQL)


uid = function(id1,id2) {
  id = paste(id1,id2,sep=" ")
  s = which(id1<id2)
  id[s] =  paste(id2,id1,sep=" ")[s]
  id
}



con <- dbConnect(RSQLite::SQLite(), "/media/apo/2TB//garbase.sqlite")
data.frame(dbListTables(con))
#dbDisconnect(con)

ped = dbReadTable(con,"ped")



population_of = function(id) {
  
  ped$Population[ base::match( sub(".*_","",id)  ,  ped$Individual.ID ) ]
  
}

dbListTables(con)

ibd = dbReadTable(con,"ld01_truffle")
#ibd_bk = ibd
#ibd = ibd_bk




ibd$ID1 = sub(".*_","",ibd$ID1)
ibd$ID2 = sub(".*_","",ibd$ID2)
ibd$uid = uid(ibd$ID1  ,   ibd$ID2  )
ibd$pop1 =   population_of(ibd$ID1)
ibd$pop2 =   population_of(ibd$ID2)


library(dplyr)

sum(ibd$IBD1+ibd$IBD2 > 0.02)
ibd[ibd$IBD1+ibd$IBD2 < 0.02,] %>% filter(pop1==pop2) %>% group_by(pop1,pop2) %>% summarize(count=n(),v=100*mean(IBD1 > 0.01/2),v2=10000*mean(IBD1))  %>% as.data.frame




proportionSharing = function(seg, chrom = 6, cc = c("CEU"), type = "IBD1", minLength = 1 , doPlot = 1 ) {
  
  seg = seg[   seg$CHROM  == chrom   ,]
  minpos = min(seg$POS)-0.5
  maxpos = max(seg$POS+seg$LENGTH)+0.5
  
  
  seg = seg[seg[,1]==  type ,]
  seg = seg [ seg$LENGTH > minLength,]
  
  seg$n = runif(nrow(seg),0,1)

  
  if(!is.na(cc)) {
  seg = seg[seg$pop1 %in% cc,]
  seg = seg[seg$pop2 %in% cc,]
  }
  
  
  ibd2 = ibd[ 
    ibd$pop1 %in% cc & (ibd$pop2 %in% cc )
    ,]
  #table(ibd2$pop1,ibd2$pop2)
  
  ntot = nrow(ibd2)
  print(ntot)
  
  
  seg2 = seg
  
  POS = seg2$POS
  LEN = seg2$LENGTH
  
  
  f = function(l1) {
    #v = POS > l1 & POS < l1 + 3
    
    v = l1 > POS & l1 < POS+LEN 
    100*sum(v)/ntot
    
  }
  
  
  
  
  spos = seq(0,max(POS+LEN),by=0.1)
  
  spos = seq(minpos,maxpos,  by=0.1)
  
  y = sapply(spos,f)
  #str(y)
  if(doPlot) plot(spos,y,t="l")
  
  d = data.frame(chrom=chrom,pos=spos,prop=y)
  d
  
}


seg2 = dbReadTable(con,"seg")
seg2$uid = uid(seg2$ID1,seg2$ID2)


tbl(con,"ibd") %>% filter(pop1==pop2) %>% filter (IBD1+IBD2 < 0.02) %>% group_by(pop1,pop2) %>% 
  summarize(count=n(),v=100*mean(IBD1 > 0.01/2),v2=10000*mean(IBD1))  %>% as.data.frame





uok = ibd$uid[ ibd$IBD1 + ibd$IBD2 < 0.02]

seg2[1,]


p = seg2[seg2$uid %in% uok,] %>% filter(pop1==pop2) %>% mutate(pid = uid(pop1,pop2)) %>% group_by(uid) %>% 
  summarize(count=n(), len=mean(NMARKERS), prop = sum(LENGTH)) %>% as.data.frame

p

beagle = dbReadTable(con,"beagle_ibd") %>% mutate(uid = uid(ID1,ID2))




t =ibd %>% filter(IBD1+IBD2 > 0.001)  
nrow(t)
t2=left_join ( t, beagle , by="uid")
nrow(t2)
nrow(t)

t2[1:100,]


t2$IBD = t2$IBD1+t2$IBD2


t2$IBD[is.na(t2$IBD)] = 0
t2$IBD_CM_SUM[is.na(t2$IBD_CM_SUM)] = 0
cor(t2$IBD_CM_SUM,t2$IBD)





plot(t2$IBD_CM_SUM,t2$IBD)







t2[is.na(t2$IBD1),]





library(dplyr)
t=group_by(seg, pop1,pop2)

summarize(t, count= n(),  avg=mean(NMARKERS))

str(t)


filter(seg , pop1 %in% "CHS")

filter(seg,NMARKERS>10000)

range(seg$NMARKERS[seg$TYPE=="IBD1"])
proportionSharing(seg2[seg2$NMARKERS > 1000,],3,cc=c("CEU","TSI"),type="IBD1",minLength = 5)

proportionSharing(seg[seg$NMARKERS > 1000,],3,cc=c("CHS"),type="IBD1",minLength = 5)



proportionSharing(seg2,6,cc=c("TSI"),type="IBD1",minLength = 2)

