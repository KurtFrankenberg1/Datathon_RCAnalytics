
# Input base de datos y librerias -----------------------------------------

library(tm)
library(tidytext)
library(tidyr)
library(dplyr)
library(ggplot2)
library(stringr)
library(tidytext)
library(wordcloud)
library(textdata)
library(janeaustenr)
library(dslabs)
library(readxl)
library(RMySQL)

datos=dbConnect(MySQL(),user="uogyrhllhrne0biy",host="b0ccsqviazxzwkmkzomm-mysql.services.clever-cloud.com",password="tpcKoaoPyafspPmvDxbt",dbname="b0ccsqviazxzwkmkzomm")
datos=dbGetQuery(datos,statement = "select * from R_DB")
######

# tratamiento de bdd y quitamos stop words --------------------------------

reseñas=datos$tweet
head(reseñas)
reseñas_corpus = Corpus(VectorSource(as.vector(reseñas))) 
reseñas_corpus

tidy_reseñas= datos %>%
  select(fecha,tweet) %>%
  unnest_tokens("word", tweet)
head(tidy_reseñas)

tidy_reseñas %>%
  count(word) %>%
  arrange(desc(n))

stopwords("spanish")
#data("stop_words")
español = stopwords("spanish")
españolnuevo=data.frame(word=español)

top_words=
  tidy_reseñas %>%
  anti_join(españolnuevo,by="word") %>%
  filter(!(word=="n"|
             word=="s"|
             word=="en"|
             word=="la"|
             word=="si"|
             word=="ms"|
             word=="da"|
             word=="tambin"|
             word=="das"|
             word=="est"|
             word=="jorge"|
             word=="manuel"|
             word=="rangel"|
             word=="the"|
             word=="as"|
             word=="dia"|
             word=="dias"|
             word=="ser"|
             word=="the"|
             word=="muy"|
             word=="con"|
             word=="por"|
             word=="los"|
             word=="al"|
             word=="es")) %>%
  count(word) %>%
  arrange(desc(n))

# grafico de barras -------------------------------------------------------

top_words %>%
  slice(1:20) %>%
  ggplot(aes(x=reorder(word, -n), y=n, fill=word))+
  geom_bar(stat="identity")+
  theme_minimal()+
  theme(axis.text.x = 
          element_text(angle = 60, hjust = 1, size=13))+
  theme(plot.title = 
          element_text(hjust = 0.5, size=18))+
  ylab("Frequency")+
  xlab("")+
  ggtitle("Most Frequent Words Hey Banco Tweets")+
  guides(fill=FALSE)


# Grafico de nube ---------------------------------------------------------

tidy_reseñas %>%
  anti_join(españolnuevo,by="word") %>%
  filter(!(word=="n"|
             word=="s"|
             word=="en"|
             word=="la"|
             word=="si"|
             word=="ms"|
             word=="da"|
             word=="tambin"|
             word=="das"|
             word=="est"|
             word=="jorge"|
             word=="manuel"|
             word=="rangel"|
             word=="the"|
             word=="as"|
             word=="ser"|
             word=="the"|
             word=="muy"|
             word=="con"|
             word=="por"|
             word=="los"|
             word=="quedo"|
             word=="hacer"|
             word=="asi"|
             word=="jajaja"|
             word=="ahi"|
             word=="solo"|
             word=="tambien"|
             word=="al"|
             word=="es")) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words =50))


