## Estrategias de Investigación Cuantitativa 2026, Universidad de Chile
## Profesor: Pablo Pérez Ahumada
## Apoyo docente: Javiera Romo Sánchez
## Ayudantes: Valentina Montecinos, Martina Buzio, Javiera Álvarez,
##            Millaray Vergara y Tomás González.

# ------------------------------------------------------------------------ #
#   PRÁCTICO 1: ÍNDICE DE POBREZA MULTIDIMENSIONAL (5 DIMENSIONES)          #
#   Encuesta CASEN 2024                                                     #
# ------------------------------------------------------------------------ #

# PASO 1: Base de casen y documentación -----------------------------------

# En la carpeta docs/ están:
#   - Libro_de_codigos_Casen_2024.xlsx  (hoja "PM": pobreza multidimensional)
#   - Cuestionario_Casen_2024.pdf
#   - Metodologia_2024_de_medicion_de_pobreza_multidimensional.pdf
#
# La base que usamos (input/casen_2024_practico.rds) es una versión reducida
# de la CASEN 2024 con las variables del práctico.


# PASO 2: Identificar las variables que necesitamos -----------------------

# Medida de 5 dimensiones (metodología 2015). En la CASEN 2024 estos
# indicadores terminan en "_2015". Cada uno vale 1 = hogar carente, 0 = no carente.
#
# Educación ............ hh_d_asis_2015   (asistencia)
#                        hh_d_rez_2015    (rezago escolar)
#                        hh_d_esc_2015    (escolaridad)

# Salud ................ hh_d_mal_2015    (malnutrición en niños/as)
#                        hh_d_prevs_2015  (adscripción al sistema de salud)
#                        hh_d_acc_2015    (atención)

# Trabajo y seg. social  hh_d_act_2015    (ocupación)
#                        hh_d_cot_2015    (seguridad social)
#                        hh_d_jub_2015    (jubilaciones)

# Vivienda y entorno ... hh_d_habitab_2015  (habitabilidad)
#                        hh_d_servbas_2015  (servicios básicos)
#                        hh_d_entorno_2015  (entorno)

# Redes y cohesión ..... hh_d_appart_2015   (apoyo y participación social)
#                        hh_d_tsocial_2015  (trato igualitario)
#                        hh_d_seg_2015      (seguridad)


# PASO 3: Preparar el entorno de trabajo ----------------------------------

options(scipen = 999)   # desactiva la notación científica
rm(list = ls())         # limpia el entorno de trabajo (borra todos los objetos)

#install.packages("pacman") # Descarga pacman si es que no lo tienen
library("pacman")
pacman::p_load(tidyverse,  # manipulación de casen (dplyr) y gráficos (ggplot2)
               haven,      # trabajar con variables etiquetadas
               sjmisc,     # frq(): tablas de frecuencias
               sjPlot)     # tab_xtab(): tablas cruzadas

casen <- readRDS("input/casen_2024_practico.rds") # Abrir base de casen

# PASO 4: Revisar nuestras variables --------------------------------------

# 4.1 ¿Tienen las categorías de respuesta que esperamos? (0 = no carente, 1 = carente)
frq(casen$hh_d_asis_2015)
frq(casen$hh_d_seg_2015)

# 4.2 ¿Son numéricas?
class(casen$hh_d_asis_2015)   # "haven_labelled": número + etiqueta

# PASO 5: Limpiar y recodificar -------------------------------------------

# 5.1 Nos quedamos sólo con las variables que usaremos y renombramos
casen <- casen %>%
  select(area,
         asistencia       = hh_d_asis_2015,
         rezago           = hh_d_rez_2015,
         escolaridad      = hh_d_esc_2015,
         malnutricion     = hh_d_mal_2015,
         adscripcion      = hh_d_prevs_2015,
         atencion         = hh_d_acc_2015,
         ocupacion        = hh_d_act_2015,
         seguridad_social = hh_d_cot_2015,
         jubilaciones     = hh_d_jub_2015,
         habitabilidad    = hh_d_habitab_2015,
         servicios_basicos = hh_d_servbas_2015,
         entorno          = hh_d_entorno_2015,
         apoyo_participacion = hh_d_appart_2015,
         trato_igualitario = hh_d_tsocial_2015,
         seguridad        = hh_d_seg_2015)

# 5.2 Quitamos las etiquetas y dejamos los indicadores como numéricos
casen <- casen %>%
  mutate(across(asistencia:seguridad, ~ as.numeric(zap_labels(.x))),
         area    = as_factor(area))

# ----- Con lo anterior listo, comenzamos con el cálculo ----- #

# PASO 6: Promediar cada dimensión ----------------------------------------

# na.rm = TRUE: si a un hogar le falta un indicador (por ejemplo, porque no le
# aplica), la dimensión se promedia con los indicadores disponibles.
# Ej.: si en educación sólo hay 2 de 3 indicadores -> (a + b) / 2.
# Así evitamos excluir sistemáticamente a ciertos tipos de hogares.

casen <- casen %>%
  mutate(
    d_educacion = rowMeans(across(c(asistencia, rezago, escolaridad)), na.rm = TRUE),
    d_salud     = rowMeans(across(c(malnutricion, adscripcion, atencion)), na.rm = TRUE),
    d_trabajo   = rowMeans(across(c(ocupacion, seguridad_social, jubilaciones)), na.rm = TRUE),
    d_vivienda  = rowMeans(across(c(habitabilidad, servicios_basicos, entorno)), na.rm = TRUE),
    d_redes     = rowMeans(across(c(apoyo_participacion, trato_igualitario, seguridad)), na.rm = TRUE)
  )

frq(casen$d_educacion)   # valores posibles: 0, 0.33, 0.5, 0.67, 1


# PASO 7: Ponderar y sumar las dimensiones -------------------------------

# La medida oficial de 5 dimensiones no pondera igual todas las dimensiones:
#   Educación, Salud, Trabajo y Vivienda y entorno ... 22,5% cada una
#   Redes y cohesión social .......................... 10%

casen <- casen %>%
  mutate(indice_pm = 
           0.225 * d_educacion + 
           0.225 * d_salud + 
           0.225 * d_trabajo +
           0.225 * d_vivienda  + 
           0.10  * d_redes,
         indice_pm = round(indice_pm, 4))   # redondeamos para evitar errores de decimales

summary(casen$indice_pm)
# Ej.: un hogar con 0.30 tiene un 30% de carencias

# PASO 8: Umbral de pobreza -> variable dummy ------------------------------

# 1 = hogar en situación de pobreza multidimensional; 0 = no.
# Umbral oficial: 22,5% o más de carencias ponderadas (= una dimensión tradicional completa)
casen <- casen %>%
  mutate(pobreza_pm = case_when(indice_pm >= 0.225 ~ 1,
                                indice_pm <  0.225 ~ 0,
                                TRUE ~ NA_real_))

frq(casen$pobreza_pm)


# PASO 9: Resultados -------------------------------------------------------

# 9.1 % de casos en pobreza multidimensional
casen %>%
  summarise(pct_pobreza = mean(pobreza_pm, na.rm = TRUE) * 100)

# 9.2 Según área (urbano / rural)
casen %>%
  group_by(area) %>%
  summarise(indice_promedio = mean(indice_pm, na.rm = TRUE),
            pct_pobreza     = mean(pobreza_pm, na.rm = TRUE) * 100)


# Guardar la base con el índice -------------------------------------------

saveRDS(casen, "output/casen_2024_con_ipm.rds")
