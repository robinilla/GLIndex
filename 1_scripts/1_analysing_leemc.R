library(sf)
library(tidyverse)
library(spdep)
rm(list=ls()) # remove all objects from your global environment

options(scipen=999) # do not allow scientific notation 

# load(url("https://raw.githubusercontent.com/robinilla/gridPresence/main/script/grid5km.Rdata"))  #low study data
load("/mnt/wwn-0x5000c500a8d29c86-part2/IREC/PhD/D/Docs/Sonia/0_PhD/1_Cap1/1_WIP/1_scripts/script_github/data_example_StudyCase.Rdata")
# load("F:/IREC/PhD/D/Docs/Sonia/0_PhD/1_Cap1/1_WIP/1_scripts/script_github/data_example_StudyCase.Rdata")

# Select the species for Lee index
Rabbit<-st.data$densRabbit  #choose the variables you want to analyse
WB<-st.data$densWB     #choose the variables you want to analyse
Fox<-st.data$densRedFox     #choose the variables you want to analyse
Hare<-st.data$densHare     #choose the variables you want to analyse


# -----------------------------------------------------------------
# Neighbour distances
# -----------------------------------------------------------------
table(st_is_valid(st.data)) #pay attention with geometry validation, if there are some issues make them valids

# 2)	#Make a nb object from sf with distance near neighbours
sf_val_ct <- st_centroid(st_geometry(st.data), of_largest_polygon=TRUE); st_is_longlat(sf_val_ct) #no planar coordinates, projected ones

reps <- 10

# Distance neighbours: dnearneigh 
# dnearneigh: identifies neighbours of region points by Euclidean distance in the metric of the points between 
# lower (greater than or equal to (changed from version 1.1-7)) and upper (less than or equal to) bounds, or with 
# longlat = TRUE, by Great Circle distance in kilometers. If x is an "sf" object and use_s2= is TRUE, spherical 
# distances in km are used.

system.time(for (i in 1:reps) sf_1_dk_na_wb<- dnearneigh(sf_val_ct, d1=0, d2= 7.8*1000))/reps
system.time(for (i in 1:reps) sf_1_dk_na_fox<- dnearneigh(sf_val_ct, d1=0, d2= 17*1000))/reps
system.time(for (i in 1:reps) sf_1_dk_na_hare<- dnearneigh(sf_val_ct, d1=0, d2= 4.069*1000))/reps
system.time(for (i in 1:reps) sf_1_dk_na_rabbit<- dnearneigh(sf_val_ct, d1=0, d2= 3*1000))/reps #note that I increased the distance in relation to the paper one because polygons here are bigger and it the distance was kept, it could not calculate the connectivity matrix

# Adjacency Matrix: Create the spatial weight neighbourhood needed for Lee index
library(spatialreg)

#converting nb oject to listw for lee index weight neighbours!!! (not binary)
lw_WB<-spdep::nb2listw(sf_1_dk_na_wb, style = "W", zero.policy = TRUE); print(lw_WB, zero.policy=TRUE)
lw_Fox<-spdep::nb2listw(sf_1_dk_na_fox, style = "W", zero.policy = TRUE) ; print(lw_Fox, zero.policy=TRUE)
lw_Hare<-spdep::nb2listw(sf_1_dk_na_hare, style = "W", zero.policy = TRUE); print(lw_Hare, zero.policy=TRUE)
lw_Rabbit<-spdep::nb2listw(sf_1_dk_na_rabbit, style = "W", zero.policy = TRUE) ; print(lw_Rabbit, zero.policy=TRUE)

# include each location i th in the connectivity matrix
lw_WB<-include.self(lw_WB$neighbours)
lw_Fox<-include.self(lw_Fox$neighbours)
lw_Rabbit<-include.self(lw_Rabbit$neighbours)
lw_Hare<-include.self(lw_Hare$neighbours)

#transform the binary connectivity matrix into a weighted connectivity matrix
lw_WB<-nb2listw(lw_WB, style = "W", zero.policy = TRUE)
lw_Fox<-nb2listw(lw_Fox, style = "W", zero.policy = TRUE)
lw_Rabbit<-nb2listw(lw_Rabbit, style = "W", zero.policy = TRUE)
lw_Hare<-nb2listw(lw_Hare, style = "W", zero.policy = TRUE)



# ---------------------------------------------------------------------------
# Calculate the index for global and local values
# ---------------------------------------------------------------------------

# Note: if you want to consider two different connectivity matrices, do not use 
# the spedep lee.mc function (spdep version 1.3-5). It would not allow you to have two differents!

# 1) load lee and lee.mc modified functions
load("/mnt/wwn-0x5000c500a8d29c86-part2/IREC/PhD/D/Docs/Sonia/0_PhD/1_Cap1/1_WIP/1_scripts/script_github/load_GL_LL_functions.Rdata")

a.lee<-lee(x=Rabbit, y=WB, listwx=lw_WB, listwy=lw_WB, n=length(Rabbit))
b.lee<-lee(x=Rabbit, y=Fox, listwx=lw_Rabbit, listwy=lw_Fox,, n=length(Rabbit))
c.lee<-lee(x=Fox, y=Hare, listwx=lw_Fox, listwy=lw_Hare, n=length(Fox))


#Visualize your results
library(ggpubr)
ggarrange(ggarrange(ggplot(st.data)+
                      geom_sf(aes(fill=densWB), lwd=0)+theme_bw()+ggtitle("Wild boar"),
                    ggplot(st.data)+
                      geom_sf(aes(fill=densRedFox), lwd=0)+theme_bw()+ggtitle("Red fox"),
                    ggplot(st.data)+
                      geom_sf(aes(fill=densHare), lwd=0)+theme_bw()+ggtitle("Hare"),
                    ggplot(st.data)+
                      geom_sf(aes(fill=densRabbit), lwd=0)+theme_bw()+ggtitle("Rabbit"), 
                    nrow=1, common.legend = TRUE, legend = "right"),
          ggarrange(st.data %>% mutate(a.lee=a.lee$localL) %>% 
                    ggplot()+
                        geom_sf(aes(fill=a.lee), lwd=0)+theme_bw()+ggtitle("Rabbit-WB"),
                  st.data %>% mutate(b.lee=b.lee$localL) %>% 
                    ggplot()+
                    geom_sf(aes(fill=b.lee), lwd=0)+theme_bw()+ggtitle("Rabbit-Red fox"),
                  st.data %>% mutate(c.lee=c.lee$localL) %>% 
                    ggplot()+
                    geom_sf(aes(fill=c.lee), lwd=0)+theme_bw()+ggtitle("Red fox-Hare"),
                  nrow=1, common.legend = TRUE, legend = "right"), 
          nrow=2)
