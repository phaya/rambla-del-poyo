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

# Umbrales avisos CHJ
# https://maldita.es/clima/20241107/datos-rambla-poyo-dana-valencia/
umbral_1 <- 30
umbral_2 <- 70
umbral_3 <- 150

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
  #  # Añadimos una etiqueta explicativa caudal medio Ebro
  geom_hline(yintercept = caudal_medio_ebro, 
             color = "blue",
             alpha = 0.3,
             size = 1,
             linetype = "dashed") +
  annotate("text", x = min(datos$Fecha), y = caudal_medio_ebro, 
           label = "Caudal medio del río Ebro", 
           vjust = -1, hjust = 0, 
           color = "black", size = 3.5) +
  geom_hline(yintercept = umbral_1, 
             color = "purple",
             alpha = 0.3,
             size = 0.5,
             linetype = "dashed") +
  annotate("text", x = ymd_hms("2024-10-29 11:40:00"), y = umbral_1, 
           label = "Umbral escenario 1", 
           vjust = -1, hjust = 0, 
           color = "black", size = 3) +
  geom_hline(yintercept = umbral_2, 
             color = "orange",
             alpha = 0.3,
             size = 0.5,
             linetype = "dashed") +
  annotate("text", x = ymd_hms("2024-10-29 11:40:00"), y = umbral_2, 
           label = "Umbral escenario 2", 
           vjust = -1, hjust = 0, 
           color = "black", size = 3) +
  geom_hline(yintercept = umbral_3, 
             color = "red",
             alpha = 0.3,
             size = 0.5,
             linetype = "dashed") +
  annotate("text", x = ymd_hms("2024-10-29 11:40:00"), y = umbral_3, 
           label = "Umbral escenario 3", 
           vjust = -1, hjust = 0, 
           color = "black", size = 3) +
  geom_hline(yintercept = 1, 
             color = "darkgray") +
  # Añadimos los avisos
  # Aviso 1 a las 12:07 sobre caudal de las 11.40
  annotate("point", x = ymd_hms("2024-10-29 12:07:00"), y = 1, 
           color = "darkgray", 
           size = 3) + 
  annotate("text", x = ymd_hms("2024-10-29 12:07:00"), y = 1, 
           label = "Aviso a las 12:07\nsobre el caudal a las 11:40", 
           vjust = -0.5, hjust = 0.75, 
           color = "black", size = 3) +
  annotate("point", x = ymd_hms("2024-10-29 11:40:00"), y = 1, 
           color = "darkgray", 
           size = 3) + 
  annotate("segment", x = ymd_hms("2024-10-29 11:40:00"), y = 1,
                   xend = ymd_hms("2024-10-29 12:07:00"), yend = 1,
               color = "darkgray", size = 1) +
  
  # Aviso 2 13:42 sobre caudal de la 13.20
  annotate("point", x = ymd_hms("2024-10-29 13:42:00"), y = 1, 
           color = "darkgray", 
           size = 3) + 
  annotate("text", x = ymd_hms("2024-10-29 13:42:00"), y = 1, 
           label = "13:42", 
           vjust = -1, hjust = 0.5, 
           color = "black", size = 3) +
  annotate("point", x = ymd_hms("2024-10-29 13:20:00"), y = 1, 
           color = "darkgray", 
           size = 3) +
  annotate("text", x = ymd_hms("2024-10-29 13:20:00"), y = 1, 
           label = "13:20", 
           vjust = -1, hjust = 0.5, 
           color = "black", size = 3) +
  annotate("segment", x = ymd_hms("2024-10-29 13:20:00"), y = 1,
                      xend = ymd_hms("2024-10-29 13:42:00"), yend = 1,
           color = "darkgray", size = 1) +
  
  # Aviso 3 a las 15:04 sobre caudal de las 14.35
  annotate("point", x = ymd_hms("2024-10-29 15:04:00"), y = 1, 
             color = "darkgray", 
             size = 3) + 
  annotate("text", x = ymd_hms("2024-10-29 15:04:00"), y = 1, 
           label = "15:04", 
           vjust = -1, hjust = 0.5, 
           color = "black", size = 3) +
  annotate("point", x = ymd_hms("2024-10-29 14:35:00"), y = 1, 
             color = "darkgray", 
             size = 3) + 
  annotate("text", x = ymd_hms("2024-10-29 14:35:00"), y = 1, 
           label = "14:35", 
           vjust = -1, hjust = 0.5, 
           color = "black", size = 3) +
  annotate("segment", x = ymd_hms("2024-10-29 14:35:00"), y = 1,
                   xend = ymd_hms("2024-10-29 15:04:00"), yend = 1,
               color = "darkgray", size = 1) +
  
  # Aviso 4 a las 16:13 sobre caudal de las 15.50
  annotate("point", x = ymd_hms("2024-10-29 16:13:00"), y = 1, 
           color = "darkgray", 
           size = 3) + 
  annotate("text", x = ymd_hms("2024-10-29 16:13:00"), y = 1, 
           label = "16:13", 
           vjust = -1, hjust = 0.5, 
           color = "black", size = 3) +
  annotate("point", x = ymd_hms("2024-10-29 15:50:00"), y = 1, 
           color = "darkgray", 
           size = 3) + 
  annotate("text", x = ymd_hms("2024-10-29 15:50:00"), y = 1, 
           label = "15:50", 
           vjust = -1, hjust = 0.5, 
           color = "black", size = 3) +
  annotate("segment", x = ymd_hms("2024-10-29 15:50:00"), y = 1,
                   xend = ymd_hms("2024-10-29 16:13:00"), yend = 1,
               color = "darkgray", size = 1) +
  
  # Aviso 5 a las 18.43 sobre caudal a las 18:40
  annotate("point", x = ymd_hms("2024-10-29 18:43:00"), y = 1, 
           color = "darkgray", 
           size = 3) + 
  annotate("text", x = ymd_hms("2024-10-29 18:43:00"), y = 1, 
           label = "18:43", 
           vjust = -1, hjust = 0, 
           color = "black", size = 3) +
  annotate("point", x = ymd_hms("2024-10-29 18:40:00"), y = 1, 
           color = "darkgray", 
           size = 3) + 
  annotate("text", x = ymd_hms("2024-10-29 18:40:00"), y = 1, 
           label = "18:40", 
           vjust = -1, hjust = 1, 
           color = "black", size = 3) +
  annotate("segment", x = ymd_hms("2024-10-29 18:40:00"), y = 1,
                   xend = ymd_hms("2024-10-29 18:43:00"), yend = 1,
               color = "darkgray", size = 1) +
   # Texto x28
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