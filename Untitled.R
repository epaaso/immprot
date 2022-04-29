library(dplyr)
library(tidyr)

table <- read.csv("immprot_test.csv")

S_T_unite <- function(x) {
  x %>% unite(S_T, sep = "-", c("Gene.names", "Gene.names.2"), remove = FALSE)
}

table2 <- S_T_unite(table)

table3 <- table2 %>% select("CellType", "S_T", "CellType_2")

write.table(table3, file = "test1.sif", quote = FALSE, row.names = FALSE)

network1 <- read.csv("ccl1_ccl22_ccl20.csv")
network2 <- read.csv("ccl19_ccl3l1_ccl4l1_ccl4.csv")
network3 <- read.csv("ccl3_ccl2_ccl5.csv")

network <- rbind(network1, network2, network3) %>% filter(rank >= 0.47)

for(i in 1:nrow(network)) {
  network$Edge[i] <-  paste(pmin(network$Gene.names[i],network$Gene.names_2[i]), 
      pmax(network$Gene.names[i],network$Gene.names_2[i]),sep="-")
}

network_final <- network %>% select(CellType, Edge, CellType_2)

write.table(network_final, file = "network_CCLs.sif", row.names = FALSE, sep = "\t", quote = FALSE)
