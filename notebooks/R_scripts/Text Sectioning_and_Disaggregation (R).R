#@ PackageList
#install.packages("beepr")             # this beeps!
#install.packages(c("RCurl", "XML"))   #XML stuff
#install.packages(c("dplyr", "ggplot2"))
#install.packages("githubinstall")
#install.packages("stringr")
### githubinstall("htmlToText") ### appear to be multiple packages named this

library(beepr)   #@ this library is needed to use the beeps that indicate progress!

#@ these other libraries are helpful for extending this project
#library(RCurl)
#library(XML)
#library(dplyr)
#library(ggplot2)
#library(githubinstall)
#library(stringr)






######################################################################
#Library R Work-File updated 6/4/2019         ## Converting data
##### clean your workspace        __ rm(list=ls())
#



########################################################################
##   This creates the most important function: IMPORT THE TEXTS!  ######
########################################################################
##### this function takes a vector of filenames and a directory path ###
###    and returns a list of each item in the list as ordered words ####
########################################################################

make.file.word.v.l <- function(files.v, input.dir){
  text.word.vector.l <- list()
  for(i in 1:length(files.v)){
    #@ read the files in the directory
    text.v <- scan(paste(input.dir, files.v[i], sep="/"), what="character", sep="\n")
    #@ convert to a single string
    text.v <- paste(text.v, collapse=" ")
    #@ we're making it one big line here - then taking it to lowercase, split on nonword chars
          #@text.lower.v <- tolower(text.v)                ## we do NOT want to 'tolower' this yet,
          #@text.words.v <- strsplit(text.lower.v, "\\W")  ##   because we need uppercase 'CHAPTER's
    text.words.v <- strsplit(text.v, "\\W")
    #@ "\\W" finds everything that is a word
    text.words.v <- unlist(text.words.v)
    text.words.v <- text.words.v[which(text.words.v!="")]
    #@ use index id as name of list
    text.word.vector.l[[files.v[i]]] <- text.words.v
  }
  return(text.word.vector.l)}




########################################################################
########################################################################
############ The Text Processing Itself begins here:
########################################################################
#
#
########################################################################
############ Set your INITIAL PARAMETERS 
## the initial directory calls work with SciFiPipeline folder located in DESKTOP directory
########################################################################


############################ SET THE INITIAL PARAMETERS  
#### NOTE!!  these three choices are your most CRITICAL 
#@ decison making points!  

use_subchapter <- TRUE
#@ this is a BOOLEAN value, to tell the code if you WANT subchapters or NOT
#@ if this is set as FALSE, the code will return disaggregated / bag of words
#@ text at the delimiter / chapter level

#@ if it is set as TRUE, the code will further break down delimiter sections /
#@ chapters into SMALLER sections of text, before then disordering the words
#@ in that subsection alphabetically

subch_threshold <- 1000
#@ the subch.thresh (subchapter LENGTH threshold)
#@ describes the longest chapter permitted (roughly) before sub-chapters will be created

sec_delimiter <- "CHAPTER"
#@ this is the initial delimiter for your sections - in standard BOOK projects,
#@ it is often by chapter, best (if possible) demarcated by *ALL CAPS* **CHAPTER**
######  !!!! be careful!!!  If you need to use a delimiter other than the preset,
# be careful about any delimiter that might be used out of the delimiting context, 
#@ or  for random other reasons in the text itself!  this will cause bad, mucked up output sections!


#
#
#
############################################ finally, remember(if you need) to (re) SET YOUR DIRECTORIES
proj.dir <- "~/Desktop/Extracted-Features-master/"  
#@ where your project itself is (the parent folder for all others)
#@ This lin makes an object with the name of your directory,
#@ so that the directory can be reset to original location later on.  
#@ working from the correct directories (folders) on your computer matter a lot for reading and writing files!

input.dir <- "text_data/"     #@ change this if your data is in a differently named folder
#@ your input directory is the location of the raw data, starting from 
#@ your project directory (since that's where the working directory is currently located)
#@ you are setting initial working directory to project directory, so this should be just inside
#@ the project directory 



setwd(proj.dir)
#@ this sets our working directory (where R looks for and puts stuff) to the project directory

#@ Run the code as-is from your desktop (RECOMMENDED!!!)
#@ OR change the directory object to point to the 
#@ location of the "SciFiPipeline" folder (replace 'Desktop' below as appropriate)
#@ NOTE!!  Because of directories calls work differently.  
#@   This is a platform interoperability issue, not an R issue

#dir.create("newFolder")  
#@ this command creates new folders in the current directory (just in case that would help)


########################################################################
############       LOADING IN RAW DATA                    ##############
########################################################################



setwd(proj.dir)           ### some lines of code (like this one) look redundant but 
###                           are included to improve clarity
files.v <- dir(input.dir, "\\.txt$")
files.v     #@ make sure you have the correct files - you can un-comment these lines to check your work
####@ **below is optional **   PICK JUST A FEW FILES instead of EVERY file  (if you only want a subset)
###       _   files.v <- files.v[c(2: 3)] ; files.v    




#################  'my.corpus.l' is a LIST object is what contains THE TEXTS THEMSELVES
my.corpus.l <- make.file.word.v.l(files.v, input.dir)
beep("complete")


# files.v[1]
# my.corpus.l[[1]][1:20]

#@ view the first part of the first entry of your my.corpus.l


######### this loop uses a regular expression to remove '.txt' from file names 
#@ (must do this **AFTER** reading data files, or you won't be able to read them!)
for(book in 1:length(files.v)){
  files.v[book] <- gsub('.{4}$', '', files.v[book])}
#files.v
names(my.corpus.l) <- files.v
# names(my.corpus.l[1])
#@ DO NOT run this more than once!  It will remove 4 characters EACH TIME!
#@ this could be improved for future code




########################################################################
####### Begin the proper DATA CLEANING       ###########################
########################################################################
##########Starting with identifying instances of  "CHAPTER"   ##########
########################################################################


CH_inst.v <- c(1:200)   #@ expected greatest # of chapters/book (no harm over-shooting this)  
#files.v                 #@ your vector of file names 
#  (note that the files appear in your corpus in the same order
#   so files.v will point to correct locations in your corpus)
CH_inst.a <- array(NA, dim=c(length(files.v), length(CH_inst.v)), dimnames=list(files.v, CH_inst.v))
#@ this is a (thusfar empty) matrix which will be used to store instances of CHAPTER in each book  
#CH_inst.a[1:5,1:5]     #@ code to visualize the corner of this to make sure it's ok

#### This portion actually Fills In the positions of each instance of a "CHAPTER" token
for (book in 1:length(files.v)){
  beep("coin")  # you get a beep for each book, as the loop starts on it
  
  for (inst in 1:length(CH_inst.v)){
    holder <- NA
    holder <- which(my.corpus.l[[book]][] == sec_delimiter)
    if (is.na(holder[1])){
      holder <- 1}
    CH_inst.a[book, 1:length(holder)] <- holder
    }
  if (length(holder) > 1){
  print(paste(length(holder), "instances of Your Delimiter in", files.v[book]))}
  else if (length(holder) == 1 & holder[1]==1){
    print(paste("probably 0 instances of Your Delimiter in", files.v[book]))}
  else{
    print(paste("there is probably 1 Your Delimiter in", files.v[book]))}
}
beep("complete")
# CH_inst.a[,1:10]       


#@ NOTES:
#@ if there are ZERO instances of CHAPTER in a book, the ENTIRE BOOK will be captured
#@ the code always gathers data through the last word at the end of the document
#@ if there is metadata at the END of a book, it should be put 
#######@ at the beginning before **CHAPTER 1** instead OR removed entirely


########################################################################
########################################################################
############################# isolate CONSUMABLE CHAPTER contents  #####
####### here we are "chunking out" the chapters based on the above #####
########################################################################

CH_id.v <- c("book", "ch#", "CHtext") #@ the header for data being stored
#CH_inst.v  #@ (re-using this object from above) - expected greatest # chapters/book
#files.v    #@ (re-using this object again, from the beginning) -- the vector of book titles
chapters.a <- array(NA, 
                    dim=c(length(CH_id.v), length(CH_inst.v), length(files.v)),
                    dimnames=list(CH_id.v, CH_inst.v, files.v))

#@ remember, CH_inst.a (array data object created above) 
#@ holds the positon of each "CHAPTER" token from each book

#@ we will be working from these data to actually isolate the chapters themselves



########## This multi-loop command determines (for each chapter within each book)
########## the start and end points of each chapter
########## and then isolates and stores the contents of each chapter
for(book in 1:length(files.v)){
  beep("coin")
  for(ch in 1:length(CH_inst.v)){
    if(!is.na(CH_inst.a[book,ch])){
      start<-NA
      start <- CH_inst.a[book,ch]+2
        if(!is.na(CH_inst.a[book,(ch+1)])){
        end<-NA
        end <- CH_inst.a[book, (ch+1)]-1
        }else{
        end<-NA
        end <- length(my.corpus.l[[book]])
        }  
    }else{break()}
  #@ at this point we should have the start and end of the chapter of interest
    chapters.a[1,ch,book] <- files.v[book]
    chapters.a[2,ch,book] <- paste("ch", ch, sep="_")
    holder <- NA
    holder <- my.corpus.l[[book]][start:(end)]
    holder <- tolower(holder)
    ch_contents <- NA
    ch_contents <- paste (holder, collapse=" ")
    chapters.a[3,ch,book] <- ch_contents
  }}
beep("complete")

#@ test to make sure the object was created correctly
#@ (the indexing here avoids printing chapter contents, which will fill the console!)
# chapters.a[1:2,1:3,1:2]

#@ see [book and chapter (NOT chapter contents), for first 3 chapters, for first 2 books]
## if you WANT to see a chapter (first one first book), use this:    _  chapters.a[3,1,1]





####

########################################################################
############## isolate "Extracted Features" Bag of Words contents  #####
### here we are "chunking out" bags of words based on the above ########
## this is almost the same loop as above, with a few small differences #
########################################################################
########################################################################

CH_id.v <- c("book", "ch#", "CHtext")
CH_inst.v  #@ (again, re-using this) - expected greatest # chapters/book
files.v    #@ (again, the vector of book titles)
disag.a <- array(NA,    ## this new data object will store disaggregated contents
                    dim=c(length(CH_id.v), length(CH_inst.v), length(files.v)),
                    dimnames=list(CH_id.v, CH_inst.v, files.v))

####### The loop to isolate and capture bags of words per chapter
for(book in 1:length(files.v)){
  beep("coin")
  for(ch in 1:length(CH_inst.v)){
    if(!is.na(CH_inst.a[book,ch])){
      start<-NA
      start <- CH_inst.a[book,ch]+2
      if(!is.na(CH_inst.a[book,(ch+1)])){
        end<-NA
        end <- CH_inst.a[book, (ch+1)]
      }else{
        end<-NA
        end <- length(my.corpus.l[[book]])
      }  
    }else{break()}
    #@ at this point we should have the start and end of the chapter of interest
    disag.a[1,ch,book] <- files.v[book]
    disag.a[2,ch,book] <- paste("ch", ch, sep="_")
    holder <- NA
    holder <- my.corpus.l[[book]][start:(end-1)]
    low_holder <- tolower(holder)
    alpha_holder <- sort(low_holder)
    disag_contents <- NA
    disag_contents <- paste (alpha_holder, collapse=" ")
    disag.a[3,ch,book] <- disag_contents
  }}
beep("complete")

# disag.a[1:2,1:3,1:2]   #@ same indexing above; this should look identical
## if you WANT to see a bag of words (again, 1st book 1st chapter) :
####                                                    _    disag.a[3,1,1]





########################################################################
########################################################################
######################## change 3d arrays to printable 2d matrices  ####
########################################################################
########################################################################
# 3d arrays initially used because they are more flexible for capturing 3-dimensional data
# however, 2d matricies are needed if we want to print out a .csv
# file giving each book/chapter's name and its corresponding bag of words
# either would work for printing individual chapter bag of words files,
# we just do both using the 2d matrix for convenience


#@ the 3D Arrays we draw from (created above_:
#     chapters.a
#     disag.a

#@ 2D chapter matricies, listing book title and chapter # as a single string:
d2.chapters.a <- c("Book Title + Chapter #", "Consumable Content")
names(d2.chapters.a) <- c("Book+ch", "text")
d2.disag.a <- c("Book Title + Chapter #", "Disag Bag of Words")
names(d2.disag.a) <- c("Book+ch", "text")              


#@ Filling out those 2d matrices 
for(book in 1:length(files.v)){
  beep("coin")
  for(ch in 1:length(CH_inst.v)){
    if(!is.na(chapters.a[1,ch,book])){
      ch.holder <- NA
      ch.holder <- chapters.a[,ch,book]
      ch.holdera <- c(paste(ch.holder[1], ch.holder[2], sep="_"), ch.holder[3])   #@ put explanation of why 2 columns
      d2.chapters.a <- rbind(d2.chapters.a, ch.holdera[])
    }
    if(!is.na(disag.a[1,ch,book])){
      dg.holder <- NA
      dg.holder <- disag.a[,ch,book]
      dg.holdera <- c(paste(dg.holder[1], dg.holder[2], sep="_"), dg.holder[3])
      d2.disag.a <- rbind(d2.disag.a, dg.holdera[])
    }
  }}
beep("complete")


#@ a good way to check that everythign worked correctly; ensure the dimensions are the same
# dim(d2.chapters.a); dim(d2.disag.a)

# d2.chapters.a[1:5,1] # this give the first 5 entries of the book+chapter# data
# d2.disag.a[1:5,1]
# dim(d2.chapters.a)
# dim(d2.disag.a)  ## this is the TOTAL NUMBER OF CHAPTERS identified
# nrow(d2.disag.a)  #@ contains one extra row -- the header!







########################################################################
########################################################################
############## take printable 2d CHAPTER matrix, makes subchapters ####
########################################################################
########################################################################
# View(head(d2.disag.a)) - for some reason, some 'text' may not display here in view setting.  it's ok
maxSubCh <- 1000   #@ the maximum expected number of subchapters with wiggle room - make it big! 
subch.a <- array(NA, dim=c(nrow(d2.disag.a), 2, maxSubCh))
subch.a[,,1] <- d2.chapters.a
subch.a <- subch.a[-1,,]   #@ remove the unwanted "headers" from the 3dim data frame

##################################### Subchapter Chunk Loop
# using 
#use_subchapter ### this only runs if TRUE
#@ this is a BOOLEAN value, to tell the code if you WANT subchapters or NOT
#subch_threshold    #@ default value (above) is 1000, you can optimize this for your own needs
#@  NOTE -- we are only subsectioning chapters longer than **4/3 the threshold value**
#@  this works better for mathematical purposes, and means that subchapter lengths *fluctiate around*
#@  the length threshold, rather than always being lower than the threshold


if(use_subchapter){
for(ch in 1:nrow(subch.a)){
  contents.l <- NA; cont.v <- NA
  contents.l <- strsplit(subch.a[ch,2,1], "\\W")
  cont.v <- unlist(contents.l)
    if(length(cont.v) < (4/3)*subch_threshold){
      print(paste(subch.a[ch,1,1] ,"is Shorter than", floor(subch_threshold*4/3), "words"),sep=" ")  
              #@ a 'short chapter' is one short enough that (based on threshold) will NOT be split
      subch.a[ch,1,2] <- paste(subch.a[ch,1,1], "0", sep="_")  ## NEW NAME, _0 indc. only subCh
      cont.v <- sort(cont.v)## full contents
      cont.v <- paste(cont.v, collapse = " ")
      subch.a[ch,2,2] <- cont.v
      
    }else{
      print(paste(subch.a[ch,1,1] ,"is a ~~~~~~ Longer ~~ chapter"),sep=" ") 
      #@ longer chapters WILL be split into subsections
      ch_leng <- NA; n_ss <- NA   #chapter length; number subsections;
      subsec <- NA                # subsection sequence (used for chunking subsections)
      ss_pos.a <- NA              # will be a n_ss by 2 array of subsect start and stop points
      subsec.v <- NA; alpha_subsec.v <- NA; subsection <- NA
      ch_leng <- length(cont.v)
      n_ss <- ceiling(ch_leng / subch_threshold)
          subsec <- seq(1:n_ss)
          ss_pos.a <- array(NA, dim=c(n_ss,2))
          ss_pos.a[,1] <- ( (subsec-1)*ch_leng/n_ss )+1
          ss_pos.a[,2] <- ( subsec*ch_leng/n_ss)  #@ this and prior line fill in subsec start and stop vals
        for(ss in 1:n_ss){
          subsect.v <- NA; subsection <- NA   # subsect.v - vector of words, subsection - pasted back together
          subsect.v <- cont.v[ss_pos.a[ss,1]:ss_pos.a[ss,2]]
          alpha_subsect.v <- sort(subsect.v)
          subsection <- paste(alpha_subsect.v, collapse=" ")  
          subch.a[ch,1,ss+1] <- paste(subch.a[ch,1,1], ss, sep="_")  ##NEW NAME, _ss#
          subch.a[ch,2,ss+1] <- subsection   ## the subsection contents
            print(paste("   ssec", ss, "is named", subch.a[ch,1,ss+1], sep=" "))
    }}
}}
# dim(subch.a[,,])


########################################################################
############## take new 3D subchapter matrix, make printable 2D form ####
########################################################################
disag_subsec.a <- c("Book Title, Chapter & SubSec #", "Disaggregated BOW Content")
names(disag_subsec.a) <- c("Book+ch+ss", "text")

for(ch in 1:nrow(subch.a)){
  for(ss in 2:maxSubCh){      #@ this loop starts at 2 because the first layer is the ORIGINAL chapters
    if(!is.na(subch.a[ch, 1, ss])){
      ss.holder <- NA
      ss.holder <- subch.a[ch,,ss]
      disag_subsec.a <- rbind(disag_subsec.a, ss.holder)
    }
  }}
# nrow(disag_subsec.a)
# disag_subsec.a[2,]




########################################################################
########################################################################
######################## Write the Outputs! Both matrices and BOWs  ####
########################################################################
########################################################################

dir.create("matrix_output", showWarnings = F)
?dir.create
matrix.dir <- "/matrix_output"
dir.create("bags_of_words", showWarnings = F)
BoW.dir <- "/bags_of_words"

setwd(paste(proj.dir,matrix.dir, sep=""))

############# The Outputs, based on if you are using subsections or not

if(use_subchapter){   #@ if we are using subchapters, give subchapters, otherwise give disag chapters
  write.csv(disag_subsec.a,    "Corpus_ExtractedFeatures_SUBSECTIONS_BagsOfWords.csv", row.names=F)
  setwd(paste(proj.dir, BoW.dir, sep=""))

  for(ss in 1:nrow(disag_subsec.a)){
    write.table(disag_subsec.a[ss,2], file=paste(disag_subsec.a[ss, 1],"_SSExtFeat.txt",sep=""))}
  
}else{
#write.csv(d2.chapters.a, "Corpus_Chapters_Consumable.csv", row.names=F)  #@ this writes in-order chapters!
write.csv(d2.disag.a,    "Corpus_ExtractedFeatures_BagsOfWords.csv", row.names=F)
  setwd(paste(proj.dir, BoW.dir, sep=""))

  for(book_ch in 2:nrow(d2.disag.a)){
  write.table(d2.disag.a[book_ch,2], file=paste(d2.disag.a[book_ch, 1],"_ExtFeat.txt",sep=""))}
}





#@ THE END
