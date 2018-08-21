library(RSQLite)
library(RMySQL)
library(RPostgreSQL)


uid = function(id1,id2) {
  id = paste(id1,id2,sep=" ")
  s = which(id1<id2)
  id[s] =  paste(id2,id1,sep=" ")[s]
  id
}



con2 <- dbConnect(RSQLite::SQLite(), "/media/apo/2TB//garbase.sqlite")
data.frame(dbListTables(con2))
#dbDisconnect(con)

con <- dbConnect(RMySQL::MySQL(), unix.socket = "/tmp/mysqld.sock",
                 user = "root", password = "koko1234",dbname="apo")

dbGetQuery(con,"show table status")[,1:7]


data.frame(dbListTables(con))




getBestClass = function(v) {
  x = class(v)
  na = sum(is.na(v))
  
  s = ""
  if(na == 0) s = "not null"
  
  
  if(x=="character") {
  
    nl = max(stringr::str_length(v),na.rm = T)
    
    ret = sprintf("varchar(%d) %s", nl+5 , s)
    
  }
  
  if(x=="numeric") {
    ret = sprintf("%s %s", "double", s)
  }

  if(x=="integer") {
    ret = sprintf("int(11) %s", s)
  }
  
    
  ret
}



dbGetQuery(con,"create table tmpa engine=archive as select * from tmp")

dbGetQuery(con,"SET default_storage_engine=myisam;")

dbGetQuery(con,"SET default_storage_engine=archive;")












for(i in dbListTables(con2)) {
  print(i)
  i2 = gsub("-","_",i)
  
  if(i2 %in% dbListTables(con)) next()
  a = dbReadTable(con2,i)
  
  cl = sapply(1:ncol(a) , function(x) getBestClass(a[,x])   )
  names(cl) = colnames(a)
  cl["row_names"] = "varchar(100) not null"
  cl
  
  
  try ( dbWriteTable(con,i2,a, overwrite=F,field.types = cl) )
  
  
}




