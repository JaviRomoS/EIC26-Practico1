# Taller práctico N°1 · Pobreza multidimensional con CASEN 2024

Estrategias de Investigación Cuantitativa 2026 · Facultad de Ciencias Sociales, Universidad de Chile

Construcción del índice de pobreza multidimensional de **5 dimensiones** (metodología 2015) en R, usando la Encuesta CASEN 2024.

## Contenido

| Ruta | Qué es |
|---|---|
| `index.qmd` | Presentación del taller (Quarto revealjs) |
| `estilos.scss`, `img/` | Tema y figuras de la presentación |
| `docs/` | Presentación ya renderizada (la que publica GitHub Pages) |
| `practico_1_R/` | Proyecto de RStudio para los estudiantes |
| `practico_1_R.zip` | El mismo proyecto comprimido (se descarga desde la presentación) |

### Proyecto de los estudiantes (`practico_1_R/`)

```
practico_1_R/
├── practico_1_R.Rproj
├── input/casen_2024_practico.rds   base reducida (31 variables, 218.367 personas)
├── docs/                           libro de códigos, cuestionario y metodología
├── script/practico_1.R             código del práctico, paso a paso
└── output/                         aquí se guardan los resultados
```

## Publicar en GitHub Pages

1. Crear el repositorio en GitHub y subir esta carpeta.
2. En el repositorio: **Settings → Pages → Build and deployment**: *Deploy from a branch*, rama `main`, carpeta **`/docs`**.
3. La presentación queda en `https://<usuario>.github.io/<repositorio>/`.

## Modificar la presentación

Editar `index.qmd` y renderizar desde la terminal de RStudio (en la carpeta del repositorio):

```bash
quarto render
```

Esto actualiza `docs/`. Luego hacer commit y push.

## Actualizar la base o el zip (equipo docente)

La base completa (`casen_2024.RData`, ~1,5 GB) **no se sube al repositorio**. Para regenerar la base reducida:

1. Descargar `casen_2024.RData` desde el [Observatorio Social](https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen-2024) y guardarla en `practico_1_R/input/`.
2. Abrir `practico_1_R/practico_1_R.Rproj` y correr `script/00_preparar_base.R`.
3. Volver a crear `practico_1_R.zip` (sin `casen_2024.RData` ni `00_preparar_base.R`) y renderizar la presentación.

## Fuente de datos

Ministerio de Desarrollo Social y Familia. Encuesta de Caracterización Socioeconómica Nacional (CASEN) 2024. Observatorio Social.
