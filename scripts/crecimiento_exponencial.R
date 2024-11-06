library(here)
library(tidyverse)
library(lubridate)
library(scales)

# A partir de la gráfica publicada por la Cuenca Hidrográfica del Jucar (CHJ)
# https://x.com/CHJucar/status/1853407411064730011
# se realiza un análisis de cómo impacta el crecimiento exponencial partiendo
# de una representación logarítmica

# Los datos son un archivo CSV facilitado por la CHJ 
# y accesible en el github de Datadista
# Más información en:
# https://x.com/adelgado/status/1853840968736182772
url <- "https://raw.githubusercontent.com/datadista/datasets/refs/heads/master/dana-valencia/cincominutales-rambla-poyo-29102024.csv"

datos_sin_procesar <- read_csv(url)

# se transforman los números decimales y se filtran los datos para quedarse
# con los puntos que tienen caudal
datos <-
  datos_sin_procesar %>%
  mutate(Caudal = as.numeric(gsub(",", ".", Caudal))) %>%
  filter(Caudal > 1) %>%
  filter(is.na(Estado))  # Si la columna Estado es NA indica que el sensor funciona 

# Se toma con referencia de caudal medio del Ebro
# https://es.wikipedia.org/wiki/Ebro
caudal_medio_ebro <- 426

################################################################################
# Gráfica en escala logarítmica del caudal en la Rambla del Poyo. Se resaltan
# las dos áreas donde tiene más impacto el crecimiento exponencial del caudal
# del rio
################################################################################
datos %>%
  ggplot(aes(x = Fecha, y = Caudal)) +
  geom_area(
    data = subset(datos, Fecha >= ymd_hms("2024-10-29 11:00:00") & 
                         Fecha <= ymd_hms("2024-10-29 11:35:00")),
    fill = "blue", alpha = 0.2
  ) +
  geom_area(
    data = subset(datos, Fecha >= ymd_hms("2024-10-29 11:35:00") & 
                         Fecha <= ymd_hms("2024-10-29 16:00:00")),
    fill = "gray", alpha = 0.3
  ) +
  geom_area(
    data = subset(datos, Fecha >= ymd_hms("2024-10-29 16:00:00") & 
                         Fecha <= ymd_hms("2024-10-29 18:00:00")),
    fill = "blue", alpha = 0.2
  ) +
  geom_area(
    data = subset(datos, Fecha >= ymd_hms("2024-10-29 18:00:00")),
    fill = "gray", alpha = 0.3
  ) +
  geom_hline(yintercept = caudal_medio_ebro, 
             color = "darkgray", 
             linetype = "dashed") +
  geom_hline(yintercept = 1, 
             color = "darkgray") +
  # Añadimos una etiqueta explicativa para la línea horizontal
  annotate("text", x = min(datos$Fecha), y = caudal_medio_ebro, 
           label = "Caudal medio del río Ebro", 
           vjust = -1, hjust = -1, 
           color = "black", size = 3) +
  annotate("text", x = ymd_hms("2024-10-29 17:00:00"), y = 10, 
           label = "x28", 
           vjust = -1, hjust = 0, 
           color = "black", size = 8) +
  scale_y_continuous(trans = 'log10',
                     labels = function(x) paste0(x,  " m³/s")) +
  scale_x_datetime(date_breaks = "1 hour", date_labels = "%H:%M") +
  labs(title = "Caudal en la Rambla del Poyo el 29 de octubre de 2024",
       subtitle = "Caudal registrado en intervalos de cinco minutos entre las 11:00 y las 18:55 representado en escala logarítmica.\nSe resaltan las dos áreas donde tuvo más impacto el crecimiento exponencial del caudal del rio.\nEntre las 16:00 y las 18:00 el caudal se multiplico por 28.", 
       caption = "@pablohaya | Datos proporcionados por Cuenca Hidrográfica del Jucar / Datadista",
       x = "", 
       y = "") +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        plot.title = element_text(face = "bold", size = 16),
        plot.subtitle = element_text(size = 12))

ggsave(here("outputs/caudal_escala_logaritmica.png"), 
       width = 25, height = 16, units = "cm", 
       dpi = 300)

ggsave(here("outputs/caudal_escala_logaritmica.jpg"), 
       width = 25, height = 16, units = "cm", 
       dpi = 300)

# Los datos originales vienen cada 5 minutos
# Para visualizar los incrementos nos quedamos con 
# una versión con puntos cada 15 minutos
datos_filtrados <- datos %>%
  filter(format(Fecha, "%M") %in% c("00", "15", "30", "45"))

# Los incrementos entre dos puntos separados 30 minutos (lag n=2)
# Por ejemplo, si a las 17:00 el caudal fue de 200 m3/s y las 16:30 el caudal fue
# de 100 m3/s, el incremento a las 17:00 es de x2
datos_filtrados <- datos_filtrados %>%
  mutate(Diferencia_Caudal = Caudal / lag(Caudal, n=2, default = first(Caudal)))

# Comprobación de que como crece desde las 16:00
datos_filtrados %>%
  filter(Fecha >= ymd_hms("2024-10-29 16:00:00")) %>% print()

################################################################################
# Gráfica que representa el incremento de caudal tomando como referencia los
# últimos 30 minutos. Por ejemplo, a las 17:00 había aproximadamente el doble de
# caudal que a las 16:30
################################################################################
datos_filtrados %>%
  filter(Fecha >= ymd_hms("2024-10-29 16:00:00")) %>% 
  ggplot(aes(x = Fecha, y = Diferencia_Caudal)) +
  geom_line(color="darkblue") +
  geom_point(color = "darkblue",
             size = 2) +
  geom_text(aes(label = paste0("x", round(Diferencia_Caudal, 1))), 
            vjust = -1, size = 3, color = "darkblue") +
  scale_x_datetime(date_breaks = "15 min", date_labels = "%H:%M") +
  scale_y_continuous(labels = function(x) paste0("x", x)) +
  labs(title = "Incrementos de caudal en la Rambla del Poyo entre las 16:00 y las 18:45",
       subtitle = "Cada punto representa cuantas veces iba más deprisa el caudal tomando como referencia los últimos 30 minutos.\nPor ejemplo, a las 17:00 había aproximadamente el doble de caudal que a las 16:30.", 
       caption = "@pablohaya | Datos proporcionados por Cuenca Hidrográfica del Jucar / Datadista",
       x = "", 
       y = "") +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        plot.title = element_text(face = "bold", size = 16),
        plot.subtitle = element_text(size = 12))

ggsave(here("outputs/incrementos_de_caudal.png"), 
       width = 25, height = 16, units = "cm", 
       dpi = 300)

ggsave(here("outputs/incrementos_de_caudal.jpg"), 
       width = 25, height = 16, units = "cm", 
       dpi = 300)