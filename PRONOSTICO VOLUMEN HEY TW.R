
# Importar Librerias ------------------------------------------------------

library(readxl)
library(prophet)
library(forecast)
library(ggplot2)
library(Metrics)

# Cargar base de datos ----------------------------------------------------

df = read_excel("G:/Unidades compartidas/Business Analytics 2/Datathon/Volumen Diario HEY BANCO.xlsx")

# idenitificacion y sustitucion de Outliers -------------------------------

vol_con_outliers=ts(df$y,start = c(2023,1),frequency = 365)
boxplot(vol_con_outliers)
tsoutliers(vol_con_outliers)
autoplot(vol_con_outliers)
vol_sin_outliers=ts(tsclean(vol_con_outliers),start = c(2023,1), frequency = 365)
autoplot(vol_sin_outliers)
autoplot(vol_con_outliers)+autolayer(vol_sin_outliers)

# Arreglo de informacion para aplicar el prophet --------------------------

ds_original = df$ds
values = as.numeric(vol_sin_outliers)
df = data.frame(ds = ds_original, y = values)

# Modelo de pronostico Prophet --------------------------------------------

m = prophet(df,yearly.seasonality=TRUE,weekly.seasonality = TRUE,growth = "flat")
future = make_future_dataframe(m, periods = 100)
tail(future)

forecast = predict(m, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])


plot(m, forecast)
prophet_plot_components(m, forecast)

# Evaluacion del modelo ---------------------------------------------------

volumen_real=df$y
Volumen_pronosticado=forecast$yhat
Volumen_pronosticado_periodo = Volumen_pronosticado[1:(length(Volumen_pronosticado) - 100)]
mae(volumen_real,Volumen_pronosticado_periodo)
mse(volumen_real,Volumen_pronosticado_periodo)


# Resultados Finales ------------------------------------------------------

plot(m, forecast,ylabel = "Volumen tw", xlabel = "")
prophet_plot_components(m, forecast)




