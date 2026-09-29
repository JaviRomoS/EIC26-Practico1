## Estrategias de Investigación Cuantitativa 2026, Universidad de Chile
## Práctico 1 — Script de preparación (SOLO EQUIPO DOCENTE)
##
## La base completa de CASEN 2024 (casen_2024.RData) pesa ~1,5 GB.
## Este script la reduce a las variables que usaremos en el práctico y
## guarda un archivo liviano (input/casen_2024_practico.rds) que es el que
## reciben los y las estudiantes.
##
## Uso: abrir practico_1_R.Rproj y correr este script completo.
## Requiere que input/casen_2024.RData exista (descargar desde
## https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen-2024)

# 1. Cargar la base completa ----------------------------------------------

entorno <- new.env()
load("input/casen_2024.RData", envir = entorno)
casen <- get(ls(entorno)[1], envir = entorno)   # el objeto que venga dentro
rm(entorno); gc()

# 2. Variables que se conservan -------------------------------------------

variables <- c(
  # Identificación y diseño muestral
  "folio", "id_vivienda", "id_persona", "region", "area",
  "expr", "varstrat", "varunit",
  # Características de las personas y hogares
  "sexo", "edad", "pco1", "numper",
  # Indicadores de pobreza multidimensional (metodología 2015, 5 dimensiones)
  "hh_d_asis_2015", "hh_d_rez_2015", "hh_d_esc_2015",          # Educación
  "hh_d_mal_2015", "hh_d_prevs_2015", "hh_d_acc_2015",         # Salud
  "hh_d_act_2015", "hh_d_cot_2015", "hh_d_jub_2015",           # Trabajo y seg. social
  "hh_d_habitab_2015", "hh_d_servbas_2015", "hh_d_entorno_2015", # Vivienda y entorno
  "hh_d_appart_2015", "hh_d_tsocial_2015", "hh_d_seg_2015",    # Redes y cohesión social
  # Indicadores oficiales (para comparar al final)
  "pobreza_multi_2015", "pobreza_multi", "pobreza", "dau"
)

faltan <- setdiff(variables, names(casen))
if (length(faltan) > 0) stop("No se encuentran estas variables: ", paste(faltan, collapse = ", "))

casen_practico <- casen[, variables]

# 3. Guardar ---------------------------------------------------------------

saveRDS(casen_practico, "input/casen_2024_practico.rds", compress = "xz")

cat("Listo:", nrow(casen_practico), "casos y", ncol(casen_practico), "variables.\n")
cat("Tamaño del archivo:",
    round(file.size("input/casen_2024_practico.rds") / 1e6, 1), "MB\n")
