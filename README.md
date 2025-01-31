# Global and Local revisited L index (GL' and LL')

This repository brings the opportunity to calculate the global L index (GL') and local L index (LL'; Lee, 2001) by incorporating variable-specific connectivity matrices for each of the variables to study their spatial pattern.

The below image summarises the idea and equations of incorporating variable-specific connectivity matrices.

![GL_LL_revised_Lindex](https://github.com/robinilla/PhD_GLIndex/blob/main/GL_LL_revised_Lindex.png)

## R scripts and data

In the script folder there is provided:

- the [load_GL_LL_functions.Rdata](https://github.com/robinilla/PhD_GLIndex/blob/main/1_scripts/load_GL_LL_functions.Rdata) file which provides the modificated lee() function for the global and local index as well as the lee.mc() modificated function found in Bivand et al. 2013.

- the data used for the simulation case study as [dataSim.Rdata](https://github.com/robinilla/PhD_GLIndex/blob/main/1_scripts/dataSim.Rdata) file and the [1_analyzing_simData.R](https://github.com/robinilla/PhD_GLIndex/blob/main/1_scripts/1_analyzing_simData.R) script used for doing the analysis and plots.

- the file [data_example_StudyCase.Rdata](https://github.com/robinilla/PhD_GLIndex/blob/main/1_scripts/data_example_StudyCase.Rdata) which contains a simulated example of real data for applying the [1_analyzing_Invented_StudyCAseData.R](https://github.com/robinilla/PhD_GLIndex/blob/main/1_scripts/1_analyzing_Invented_StudyCaseData.R) script. We cannot share the data used in the real case study due to data confidentiality agreement, but the analyzing script is the same one that we used for analyzing that data.


## References

- R Core Team. R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria (2022).
- Wickham, H. et al. Welcome to the Tidyverse. J Open Source Softw 4, 1686 (2019).
- Pebesma, E. Simple Features for R: Standardized Support for Spatial Vector Data. R J 10, 439–446 (2018).
- Bivand, R. S., Pebesma, E., & Gómez-Rubio, V. Applied Spatial Data Analysis with R (2nd Edition). Springer. http://www.springer.com/series/6991. (2013).
- Lee, S. Il.. Developing a bivariate spatial association measure: An integration of Pearson’s r and Moran’s I. Journal of Geographical Systems, 3(4), 369–385. https://doi.org/10.1007/s101090100064. (2001)
