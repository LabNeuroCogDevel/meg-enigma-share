#!/usr/bin/env Rscript
# 20210128WF - init. what we have to share with ENIGMA
#    want rest, empty room, and mprage
library(dplyr)
library(tidyr)


dmg <- read.table(text=system('selld8 list|cut -f 1-3',intern=T))
names(dmg) <- c('ld8','age','sex')
restfif <- system("find -L ./ -iname '*rest*_raw.fif'", inter=T)
emptyfif <- system("find -L ./ -iname '*empty*_raw.fif'", inter=T)
mprage <- c(Sys.glob("/Volumes/Zeus/preproc/MM*/MHT1_2mm/*/mprage.nii.gz"),
            Sys.glob("/Volumes/Phillips/MMY4_Switch/subjs/1*_2*/preproc/mprage/mprage.nii.gz"))


ld8 <- function(x) stringr::str_extract(x, '\\d{5}_\\d{8}')
mkdate <- function(d) d %>%
   separate(ld8, c('luna','ymd')) %>%
   mutate(ymd=lubridate::ymd(ymd)) %>%
   filter(!is.na(ymd))

rm_dups <- function(d) d %>% filter(!duplicated(ld8),!is.na(ld8)) %>% distinct

t1 <- data.frame(ld8=ld8(mprage),t1_file=mprage, mprage=T)  %>% rm_dups %>% mkdate
meg <- data.frame(ld8=ld8(restfif),rest_file=restfif, rest=T) %>% rm_dups %>%
     full_join(data.frame(ld8=ld8(emptyfif),empty_file=emptyfif, empty=T)%>% rm_dups) %>%
     full_join(dmg) %>%
     filter(!is.na(rest)) %>%
     rm_dups %>%
     mkdate

imaging <- LNCDR::date_match(meg, t1, 'luna', 'ymd','ymd', all.x=T) %>%
   filter(!(is.na(age) & is.na(mprage)))

have_all <- imaging %>% filter(mprage, rest, empty)

write.table(file='MEG_t1-rest-empty_files.txt',have_all %>% select(-mprage,-rest,-empty), row.names=F,quote=F)

have_all %>% group_by(sex) %>% summarise(n=n(), min=min(age), mean=mean(age), max=max(age),sd=sd(age))
# sex       n   min  mean   max    sd
# F        83  14.4  22.3  31    5.39
# M        76  14.2  21.3  30.8  5.17
# NA       10  NA    NA    NA   NA   


have_all %>% group_by(luna) %>% tally %>% group_by(n) %>% tally
#   n    nn
#   1   142
#   2    12
#   3     1
