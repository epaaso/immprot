library(dplyr)
library(tidyverse)

network1 <- read.csv("data/ccl1_ccl22_ccl20.csv")
network2 <- read.csv("data/ccl19_ccl3l1_ccl4l1_ccl4.csv")
network3 <- read.csv("data/ccl3_ccl2_ccl5.csv")

network <- rbind(network1, network2, network3) %>% filter(rank >= 0.47)
network$CellType <- network$CellType %>% substr(., 1,nchar(.)-1)
network$CellType_2 <- network$CellType_2 %>% substr(., 1,nchar(.)-1)

for(i in 1:nrow(network)) {
  network$Edge[i] <-  paste(pmin(network$Gene.names[i],network$Gene.names_2[i]), 
      pmax(network$Gene.names[i],network$Gene.names_2[i]),sep="-")
}

network_final <- network %>% select(CellType, Edge, CellType_2)

# Construimos una columna que tenga toda la info para ver si se duplica
network_duplis <- network_final
network_duplis %>%  mutate( across(everything()), pasted = paste0(CellType, Edge, CellType_2))

# Al parecer no hay duplicados
duplicated(network_duplis$aller)


write.table(network_final, file = "network_CCLs.sif", row.names = FALSE, sep = "\t", quote = FALSE)
