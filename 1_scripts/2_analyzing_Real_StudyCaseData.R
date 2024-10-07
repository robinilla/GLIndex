# -----------------------------------------------------------
#  Calculate GL and LL index from hunting yields statistics
#  author: Sonia Illanas
#  institution: Institute of Game and Wildlife Research
#  date of last modification: 03/08/2024
# -----------------------------------------------------------
# library(tidyverse)
library(spdep)
rm(list=ls())
options(scipen=999)

# 1 load the data
load(file="/mnt/wwn-0x5000c500a8d29c86-part2/IREC/PhD/D/Docs/Sonia/0_PhD/1_Cap1/1_WIP/1_scripts/df_analizar_variables.Rdata")

# 2 load lee modified functions and calculate global and local values of L index
# introduce a forth parameter in lee function, listwy, to consider the 
# posibility of a different connectivity matrices for y variable
load("/mnt/wwn-0x5000c500a8d29c86-part2/IREC/PhD/D/Docs/Sonia/0_PhD/1_Cap1/1_WIP/1_scripts/script_github/load_GL_LL_functions.Rdata")

a<-lee(Rabbit, WB, lw_Rabbit, lw_WB, n=length(Rabbit)) 
b<-lee(Rabbit, Fox, lw_Rabbit, lw_Fox, n=length(Rabbit))
c<-lee(Rabbit, Hare, lw_Rabbit, lw_Hare, n=length(Rabbit))
d<-lee(Fox, WB, lw_Fox, lw_WB, n=length(Fox))
e<-lee(Hare, WB, lw_Hare, lw_WB, n=length(Hare))
f<-lee(Fox, Hare, lw_Fox, lw_Hare, n=length(Hare))

# 3 save results in a geopackage
library(sf)
# st_write(layer_to_save, dsn="file_path/package_name.gpkg", layer="layer_name", driver = "GPKG", append=FALSE)