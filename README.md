# NMAfreq

A single-file **R Shiny** application for **frequentist network meta-analysis (NMA)**.

The app wraps the `netmeta` package: it accepts study data, fits a frequentist
network meta-analysis (common-effect and/or random-effects), and presents the
network, pooled relative effects, forest plots, league tables, and related
diagnostics through a `bs4Dash` dashboard UI.

## Files

- `app.R` — the Shiny application (UI + server + `shinyApp(ui, server)`). This
  is the standard single-file Shiny layout, so it can be launched with
  `shiny::runApp()` from the repository directory.
- `test_nma.R` — a standalone smoke test for the statistical core (`netmeta`),
  runnable without the Shiny UI. See **Testing** below.

## Required R packages

`app.R` loads the following packages at startup:

```r
install.packages(c(
  "shiny", "bs4Dash", "shinycssloaders", "promises", "future",
  "netmeta", "visNetwork", "DT", "readr", "igraph", "meta"
))
```

All of these must be installed before the app will run. The frequentist NMA
engine itself is provided by `netmeta`.

## Running the app

From the repository directory:

```r
shiny::runApp(".")
```

or from a shell:

```sh
R -e "shiny::runApp('.')"
```

Because this is a server-side Shiny app (not a static page), it requires an R
session with all packages above installed and an interactive Shiny server; it
does not run as a plain script or as a static web page.

## Testing

`test_nma.R` validates the statistical core that the app wraps. It runs a small
known 3-treatment network through `netmeta::netmeta()` and checks basic
well-defined properties (correct treatment/study counts, finite pooled
contrasts, anti-symmetric contrast matrix, finite Q). It uses only the
`netmeta` package, so it can run headless without the Shiny UI:

```sh
Rscript test_nma.R
```
