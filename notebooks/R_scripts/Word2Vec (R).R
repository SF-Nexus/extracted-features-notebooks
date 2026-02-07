# Loading Word2Vec Libraries -------------------------------------------------------
library(wordVectors)
library(magrittr)
library(tidyverse)

# Loading Files -----------------------------------------------------------
if (!file.exists("1.txt")) prep_word2vec(origin="1.txt",destination="2.txt",lowercase=T,bundle_ngrams=2)
if (!file.exists("1.bin")) {modelGuin = train_word2vec("1.txt","1.bin",vectors=100,threads=4,window=15,iter=4,negative_samples=0)} else modelGuin = read.vectors("Guin.bin")

# Mining the Model --------------------------------------------------------

modelGuin %>% closest_to("computer", n=30)

modelGuin %>% closest_to(~ "france" - "paris" + "london", 50)

top_evaluative_words = modelGuin %>% 
  closest_to(~ "model" + "significance",n=30)
top_evaluative_words

## Extensions
not_that_kind_of_woman = modelGuin[["woman"]] %>%
  reject(modelGuin[["weak"]]) %>% 
  reject(modelGuin[["superficial"]]) %>%   
  reject(modelGuin[["emotional"]])
modelGuin %>% closest_to(not_that_kind_of_woman,n=100)

# Randomized Clusters -----------------------------------------------------
set.seed(11)
centers = 150
clustering = kmeans(modelGuin,centers=centers,iter.max = 40)

sapply(sample(1:centers,10),function(n) {
  names(clustering$cluster[clustering$cluster==n][1:10])
})

# PCA Plots ---------------------------------------------------------------

#PCA Plot Keywords
pcamodel1 = closest_to(modelGuin,modelGuin[[c("machine", "intelligence", "stupidity", "human")]],180)
pcagraph = modelGuin[[pcamodel1$word,average=F]]
plot(pcagraph,method="pca")

## Keyword PCA
modelGuin[[c("paris", "france", "madrid", "spain"), average=F]] %>% 
  plot(method="pca")

## TSNE 
library(tsne)
plot(modelGuin,perplexity=50)


## PCA with Keywords
top_evaluative_words = modelGuin %>% 
  closest_to(~ "europe",n=75)

top_evaluative_words

truth = modelGuin %>% 
  closest_to(~ "boston" + "massachusetts",n=Inf) 
mind = modelGuin %>% 
  closest_to(~ "philadelphia" + "pennsylvania", n=Inf)

library(ggplot2)
library(dplyr)

top_evaluative_words %>%
  inner_join(truth) %>%
  inner_join(mind) %>%
  ggplot() + 
  geom_text(aes(x=`similarity to "boston" + "massachusetts"`,
                y=`similarity to "philadelphia" + "pennsylvania"`,
                label=word))
# Cluster Dendrograms [Huffman Coding Trees]-----------------------------------------------------
ingredients = c("parlor", "kitchen", "chair", "door")
term_set = lapply(ingredients, 
                  function(ingredient) {
                    nearest_words = modelGuin %>% closest_to(modelGuin[[ingredient]],15)
                    nearest_words$word
                  }) %>% unlist

subset1 = modelGuin[[term_set,average=F]]

subset1 %>%
  cosineDist(subset1) %>% 
  as.dist %>%
  hclust %>%
  plot

# Redesigning Dendrograms -------------------------------------------------
cluster1 <- subset1 %>%
  cosineDist(subset1) %>% 
  as.dist %>%
  hclust 


library(ggraph)
library(igraph)
sp.graph <- den_to_igraph(cluster1, even = FALSE)
v1 <- ggraph(sp.graph) + geom_edge_link() + geom_node_point(color = "red") + 
  geom_node_text(aes(label = label), repel = T)

print(v1)

