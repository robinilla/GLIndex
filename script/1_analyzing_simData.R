# ---------------------------------------------
#  Calculate GL and LL index
#  author: Sonia Illanas
#  institution: Institute of Game and Wildlife Research
#  date of last modification: 06/10/2024
# ---------------------------------------------
## R version 4.4.2
## tidyverse version: 2.0.0
## sf version: 1.0-16
## grid version: 4.4.2
## ggpubr version: 0.6.0
## spdep version: 1.3-10
## cowplot version: 1.1.3

# devtools::install_version("tidyverse", version = "2.0.0")
# devtools::install_version("sf", version = "1.0-16")
# devtools::install_version("grid", version = "4.4.2")
# devtools::install_version("ggpubr", version = "0.6.0")
# devtools::install_version("spdep", version = "1.3-10")
# devtools::install_version("cowplot", version = "1.1.3")

library(tidyverse)
library(sf)
library(grid)
library(ggpubr)
library(spdep)
rm(list=ls()) # clears R workspace

# 1 load your simulated data and connectivity matrices
load(file="dataSim.Rdata")

# 1.1 Visualize your variables
ggarrange(ggplot(data.sim)+ geom_sf(aes(fill=A))   + theme_minimal(),
          ggplot(data.sim)+ geom_sf(aes(fill=A_p)) + theme_minimal(), 
          ggplot(data.sim)+ geom_sf(aes(fill=B))   + theme_minimal(),
          ggplot(data.sim)+ geom_sf(aes(fill=B_p)) + theme_minimal(), 
          nrow=2, ncol=2)

# 2 load lee and lee.mc modified functions
load("load_GL_LL_functions.Rdata")

# 4 calculate lee index with the load modified function
data.sim<-data.sim %>% mutate(LiBB=lee(data.sim$B, data.sim$B, con.one.neig, con.one.neig, nrow(data.sim))$localL, 
                              LiBBp=lee(data.sim$B, data.sim$B_p, con.one.neig, con.one.neig, nrow(data.sim))$localL, 
                              LiBB_nn=lee(data.sim$B, data.sim$B, con.itself, con.itself, nrow(data.sim))$localL,
                              LiBBp_nn=lee(data.sim$B, data.sim$B_p, con.itself, con.itself, nrow(data.sim))$localL,
                              LiBB3=lee(data.sim$B, data.sim$B, con.one.neig, con.two.neig, nrow(data.sim))$localL,
                              LiBBp3=lee(data.sim$B, data.sim$B_p, con.one.neig, con.two.neig, nrow(data.sim))$localL,
                              LiAA=lee(data.sim$A, data.sim$A, con.one.neig, con.one.neig, nrow(data.sim))$localL,
                              LiAAp=lee(data.sim$A, data.sim$A_p, con.one.neig, con.one.neig, nrow(data.sim))$localL,
                              LiAA_nn=lee(data.sim$A, data.sim$A, con.itself, con.itself, nrow(data.sim))$localL,
                              LiAAp_nn=lee(data.sim$A, data.sim$A_p, con.itself, con.itself, nrow(data.sim))$localL,
                              LiAA3=lee(data.sim$A, data.sim$A, con.one.neig, con.two.neig, nrow(data.sim))$localL,
                              LiAAp3=lee(data.sim$A, data.sim$A_p, con.one.neig, con.two.neig, nrow(data.sim))$localL
)


# 5 visualize results
library("cowplot")
ggdraw()+
  draw_plot(ggplot(cbind(data.sim, "cij"=nb2mat(con.itself$neighbours, style="B")[,19]))+ geom_sf(aes(fill=cij)) + #geom_sf_label(aes(label = ID2))+
              theme_minimal()+ scale_fill_gradient(low = "white", high = "black")+theme(legend.position = "none") +rremove("axis.text"), x=0.35, y=.82, width=0.13, height=0.13)+
  draw_plot(ggplot(cbind(data.sim, "cij"=nb2mat(con.itself$neighbours, style="B")[,19]))+ geom_sf(aes(fill=cij)) + #geom_sf_label(aes(label = ID2))+
              theme_minimal()+ scale_fill_gradient(low = "white", high = "black")+theme(legend.position = "none")+rremove("axis.text"), x=0.45, y=.82, width=0.13, height=0.13)+
  draw_plot(ggplot(cbind(data.sim, "cij"=nb2mat(con.one.neig$neighbours, style="B")[,19]))+ geom_sf(aes(fill=cij)) + #geom_sf_label(aes(label = ID2))+
              theme_minimal()+ scale_fill_gradient(low = "white", high = "black")+theme(legend.position = "none")+rremove("axis.text"), x=0.565, y=.82, width=0.13, height=0.13)+
  draw_plot(ggplot(cbind(data.sim, "cij"=nb2mat(con.one.neig$neighbours, style="B")[,19]))+ geom_sf(aes(fill=cij)) + #geom_sf_label(aes(label = ID2))+
              theme_minimal()+ scale_fill_gradient(low = "white", high = "black")+theme(legend.position = "none")+rremove("axis.text"), x=0.665, y=.82, width=0.13, height=0.13)+
  
  draw_plot(ggplot(cbind(data.sim, "cij"=nb2mat(con.one.neig$neighbours, style="B")[,19]))+ geom_sf(aes(fill=cij)) + #geom_sf_label(aes(label = ID2))+
              theme_minimal()+ scale_fill_gradient(low = "white", high = "black")+theme(legend.position = "none")+rremove("axis.text"), x=0.78, y=.82, width=0.13, height=0.13)+
  draw_plot(ggplot(cbind(data.sim, "cij"=nb2mat(con.two.neig$neighbours, style="B")[,19]))+ geom_sf(aes(fill=cij)) + #geom_sf_label(aes(label = ID2))+
              theme_minimal()+ scale_fill_gradient(low = "white", high = "black")+theme(legend.position = "none")+rremove("axis.text"), x=0.88, y=.82, width=0.13, height=0.13)+
  annotate(geom = 'text', x=0.46, y=0.97, label="Scenario A", fontface = "bold") +
  annotate(geom = 'text', x=0.66, y=0.97, label="Scenario B", fontface = "bold") +
  annotate(geom = 'text', x=0.86, y=0.97, label="Scenario B", fontface = "bold") +
  
  draw_plot(ggplot(data.sim %>% rename(A=A))+        geom_sf(aes(fill= A)) + theme_minimal() + theme(axis.text.x=element_blank(), axis.text.y=element_blank())+ scale_fill_gradient(low = "white", high="black")+ labs(fill = "1"),   x=0.0, y=.63, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(A=A))+        geom_sf(aes(fill= A)) + theme_minimal() + theme(axis.text.x=element_blank(), axis.text.y=element_blank())+ scale_fill_gradient(low = "white", high="black")+ labs(fill = "1"),   x=0.2, y=.63, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiAA_nn))+ geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high= "black"), x=0.4, y=.63, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiAA))+    geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high= "black"), x=0.6, y=.63, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiAA3))+   geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high= "black"), x=0.8, y=.63, width=0.2, height=0.2)+
  
  annotate(geom = 'text', x=0.06, y=0.83, label="Spatial Pattern", fontface = "bold") +
  annotate(geom = 'text', x=0.26, y=0.83, label="Spatial Pattern", fontface = "bold") +
  
  draw_plot(ggplot(data.sim %>% rename(A=A))+        geom_sf(aes(fill= A)) + theme_minimal() + theme(axis.text.x=element_blank(), axis.text.y=element_blank())+ scale_fill_gradient(low = "white", high="black")+ labs(fill = "1"),   x=0.0, y=.43, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(A_prima=A_p))+ geom_sf(aes(fill= A_prima)) + theme_minimal() + theme(axis.text.x=element_blank(), axis.text.y=element_blank())+ scale_fill_gradient(low = "white", high="black")+ labs(fill = "1'"),   x=0.2, y=.43, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiAAp_nn))+ geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high = "black"), x=0.4, y=.43, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiAAp))+    geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high = "black"), x=0.6, y=.43, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiAAp3))+   geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high = "black"), x=0.8, y=.43, width=0.2, height=0.2)+
  
  draw_plot(ggplot(data.sim %>% rename(B=B))+        geom_sf(aes(fill= B)) + theme_minimal() + theme(axis.text.x=element_blank(), axis.text.y=element_blank())+ scale_fill_gradient(low = "white", high="black")+ labs(fill = "2"),   x=0.0, y=.23, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(B=B))+        geom_sf(aes(fill= B)) + theme_minimal() + theme(axis.text.x=element_blank(), axis.text.y=element_blank())+ scale_fill_gradient(low = "white", high="black")+ labs(fill = "2"),   x=0.2, y=.23, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiBB_nn))+ geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high = "black"), x=0.4, y=.23, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiBB))+    geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high = "black"), x=0.6, y=.23, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiBB3))+   geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high = "black"), x=0.8, y=.23, width=0.2, height=0.2)+
  
  draw_plot(ggplot(data.sim %>% rename(B=B))+        geom_sf(aes(fill= B)) + theme_minimal() + theme(axis.text.x=element_blank(), axis.text.y=element_blank())+ scale_fill_gradient(low = "white", high="black")+ labs(fill = "2"),   x=0.0, y=.03, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(B_prima=B_p))+ geom_sf(aes(fill= B_prima)) + theme_minimal() + theme(axis.text.x=element_blank(), axis.text.y=element_blank())+ scale_fill_gradient(low = "white", high="black") + labs(fill = "2'"), x=0.2, y=.03, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiBBp_nn))+ geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high = "black"), x=0.4, y=.03, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiBBp))+    geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high = "black"), x=0.6, y=.03, width=0.2, height=0.2)+
  draw_plot(ggplot(data.sim %>% rename(Li=LiBBp3))+   geom_sf(aes(fill=Li)) + theme_minimal()+ theme(axis.text.x=element_blank(), axis.text.y=element_blank()) + scale_fill_gradient(low = "white", high = "black"), x=0.8, y=.03, width=0.2, height=0.2)


# 6 Global L p-values after monte carlo permutation
lee.mc(data.sim$A, data.sim$A, con.itself, con.itself, nsim=10000)
lee.mc(data.sim$A, data.sim$A, con.one.neig, con.one.neig, nsim=10000)
lee.mc(data.sim$A, data.sim$A, con.one.neig, con.two.neig, nsim=10000)

lee.mc(data.sim$A, data.sim$A_p, con.itself, con.itself, nsim=10000)
lee.mc(data.sim$A, data.sim$A_p, con.one.neig, con.one.neig, nsim=10000)
lee.mc(data.sim$A, data.sim$A_p, con.one.neig, con.two.neig, nsim=10000)

lee.mc(data.sim$B, data.sim$B, con.itself, con.itself, nsim=10000)
lee.mc(data.sim$B, data.sim$B, con.one.neig, con.one.neig, nsim=10000) 
lee.mc(data.sim$B, data.sim$B, con.one.neig, con.two.neig, nsim=10000)

lee.mc(data.sim$B, data.sim$B_p, con.itself, con.itself, nsim=10000)
lee.mc(data.sim$B, data.sim$B_p, con.one.neig, con.one.neig, nsim=10000) 
lee.mc(data.sim$B, data.sim$B_p, con.one.neig, con.two.neig, nsim=10000)
