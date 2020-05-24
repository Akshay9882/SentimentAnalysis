#Versions used for development.

#CMD sessionInfo used to get these version information
#R version 3.6.3 (2020-02-29)
#Platform: x86_64-w64-mingw32/x64 (64-bit)
#Running under: Windows 10 x64 (build 18363)

#Matrix products: default

#locale:
#[1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252   
#[3] LC_MONETARY=English_United States.1252 LC_NUMERIC=C                          
#[5] LC_TIME=English_United States.1252    

#attached base packages:
#[1] stats     graphics  grDevices utils     datasets  methods   base     

#other attached packages:
# [1] httr_1.4.1      bit64_0.9-7     bit_1.1-15.2    rjson_0.2.20    ggplot2_3.3.0  
# [6] stringr_1.4.0   RCurl_1.98-1.2  plyr_1.8.6      base64enc_0.1-3 mongolite_2.2.0
#[11] rmongodb_1.8.0  ROAuth_0.9.6    twitteR_1.1.9   shiny_1.4.0.2  

#loaded via a namespace (and not attached):
# [1] Rcpp_1.0.4.6     pillar_1.4.4     compiler_3.6.3   later_1.0.0     
# [5] bitops_1.0-6     tools_3.6.3      digest_0.6.25    tibble_3.0.0    
# [9] jsonlite_1.6.1   lifecycle_0.2.0  gtable_0.3.0     pkgconfig_2.0.3 
#[13] rlang_0.4.5      rstudioapi_0.11  cli_2.0.2        DBI_1.1.0       
#[17] fastmap_1.0.1    withr_2.1.2      askpass_1.1      vctrs_0.2.4     
#[21] grid_3.6.3       glue_1.4.0       R6_2.4.1         fansi_0.4.1     
#[25] magrittr_1.5     ellipsis_0.3.0   scales_1.1.0     promises_1.1.0  
#[29] htmltools_0.4.0  assertthat_0.2.1 mime_0.9         xtable_1.8-4    
#[33] colorspace_1.4-1 httpuv_1.5.2     stringi_1.4.6    openssl_1.4.1   
#[37] munsell_0.5.0    crayon_1.3.4   

#R studio 1.3.959
#R tools 4.0.0.26

#Checkout existing packages installed in R
available.packages()

#Installing required packages 

install.packages("shiny")
install.packages("twitteR")
install.packages("ROAuth")
install.packages("mongolite")
install.packages("base64enc")
install.packages("plyr")
install.packages("stringr")
install.packages("ggplot2")
install.packages("rjson")
install.packages("bit64")
install.packages("httr")


##devtools dependencies
install.packages("rematch2")
install.packages("pillar")
install.packages("usethis")
#was facing lazyloading isssue while installing devtools but fresh start(restart) of R studio fixed it
install.packages("devtools")
#Check if library is installed and loaded into R
library(devtools)

library(devtools)
install_github("mongosoup/rmongodb")

install.packages("bitops")
#Unable to install from github so installed manually by providing zip path
#install_github("omegahat/RCurl") 

setwd("C:\\Users\\Akshay\\Documents\\SentimentAnalysis")
install.packages("RCurl_1.98-1.2.zip", repos=NULL, type="source") 