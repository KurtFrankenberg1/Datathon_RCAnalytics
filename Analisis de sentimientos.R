
# Carga los paquetes
library(syuzhet)
library(RColorBrewer)
library(wordcloud)
library(tm)
library(readxl)
library(RMySQL)

datos=dbConnect(MySQL(),user="uogyrhllhrne0biy",host="b0ccsqviazxzwkmkzomm-mysql.services.clever-cloud.com",password="tpcKoaoPyafspPmvDxbt",dbname="b0ccsqviazxzwkmkzomm")
texto_cadena=dbGetQuery(datos,statement = "select * from R_DB")


texto_palabras = get_tokens(texto_cadena$tweet)
head(texto_palabras)
oraciones_vector = get_sentences(texto_cadena$tweet)
length(oraciones_vector)
head(oraciones_vector)

sentimientos_df = get_nrc_sentiment(texto_palabras, lang="spanish")
head(sentimientos_df)
summary(sentimientos_df)

barplot(
  colSums(prop.table(sentimientos_df[, 1:8])),
  space = 0.2,
  horiz = FALSE,
  las = 1,
  cex.names = 0.7,
  col = brewer.pal(n = 8, name = "Set3"),
  main = "Analisis de sentimientos",
  sub = "Analisis realizado por RC Analytics",
  xlab="emociones", ylab = NULL)


sentimientos_valencia = (sentimientos_df$negative *-1) + sentimientos_df$positive
simple_plot(sentimientos_valencia)
