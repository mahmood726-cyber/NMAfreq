# test_nma.R
#
# Smoke test for the statistical core that app.R wraps: netmeta::netmeta().
# The Shiny UI cannot run headless (shiny/bs4Dash etc. are not installed and a
# Shiny app needs an interactive server), so this test exercises ONLY the
# frequentist NMA engine the app calls at app.R: netmeta(TE, seTE, treat1,
# treat2, studlab, data = ...). Uses ONLY installed packages (netmeta).
#
# Run:  Rscript test_nma.R

suppressPackageStartupMessages(library(netmeta))

# A tiny 3-treatment network (A, B, C) in contrast format: TE = log-ratio style
# effect, seTE = its standard error. Two direct comparisons per contrast so the
# network is connected (A-B, A-C, B-C) and an indirect path exists.
d <- data.frame(
  studlab = c("S1", "S2", "S3", "S4", "S5", "S6"),
  treat1  = c("A", "A", "A", "A", "B", "B"),
  treat2  = c("B", "B", "C", "C", "C", "C"),
  TE      = c(0.20, 0.25, 0.50, 0.45, 0.28, 0.32),
  seTE    = c(0.10, 0.12, 0.11, 0.13, 0.10, 0.12),
  stringsAsFactors = FALSE
)

net <- netmeta(TE, seTE, treat1, treat2, studlab,
               data = d, common = TRUE, random = TRUE)

# --- Assertions on basic, well-defined properties of the fitted object ---

# 1. The network has exactly the 3 treatments we supplied.
stopifnot(net$n == 3)
stopifnot(setequal(net$trts, c("A", "B", "C")))

# 2. All 6 studies were used.
stopifnot(net$m == 6)

# 3. Pooled fixed/common-effect contrasts are finite (the n x n TE matrix).
stopifnot(all(is.finite(net$TE.common)))
stopifnot(all(is.finite(net$TE.random)))

# 4. The contrast matrix is anti-symmetric on the off-diagonal:
#    effect(A vs B) == -effect(B vs A). This is a defining property of a
#    coherent set of pooled relative effects.
stopifnot(isTRUE(all.equal(net$TE.common, -t(net$TE.common))))

# 5. The connected network yields a single design with a defined Q statistic.
stopifnot(is.finite(net$Q))

cat("NMA SMOKE TEST PASSED\n")
cat(sprintf("  treatments: %s\n", paste(net$trts, collapse = ", ")))
cat(sprintf("  studies:    %d\n", net$m))
cat(sprintf("  A vs B (common): %.4f\n", net$TE.common["A", "B"]))
cat(sprintf("  A vs C (common): %.4f\n", net$TE.common["A", "C"]))
cat(sprintf("  Q (heterogeneity/inconsistency): %.4f\n", net$Q))
