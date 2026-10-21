# ==== BBBC018 Cytoskeleton Lab — 05899 ====
phenotype <- "Large Spread"
image_id  <- "05899"

# Read the Fiji Results CSV (no R packages needed)
d <- read.csv("fiji_results.csv", check.names = FALSE)
needed <- c("Area", "Mean", "Circ.", "AR")
if (!all(needed %in% names(d))) { stop("Missing Fiji columns. Recheck Set Measurements.") }
d <- d[complete.cases(d[, needed]), ]
if (nrow(d) < 5) stop("Measure five clear cells.")
d$Cell <- paste0("Cell ", seq_len(nrow(d)))
dir.create("results", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)

# Save numerical summary
s <- data.frame(
  phenotype = phenotype, image_id  = image_id,
  cells_measured = nrow(d), mean_area_px2  = 
  mean(d$Area), mean_circularity = mean(d[["Circ."]]),
  mean_aspect_ratio = mean(d$AR), mean_actin_signal = mean(d$Mean))
write.csv(s, "results/cell_summary.csv", row.names = FALSE)
print(s)

# Figure 1: Cell area vs circularity
png("figures/area_vs_circularity.png", width = 900, height = 650)
plot(d$Area, d[["Circ."]], pch  = 19, col = "steelblue",
     xlab = "Cell area (pixels squared)", ylab = "Circularity (0 to 1)",
     main = paste(phenotype, "-", image_id))
text(d$Area, d[["Circ."]], labels = d$Cell, pos = 3, cex = 0.75)
dev.off()

# Figure 2: Relative actin signal of measured cells
png("figures/actin_intensity.png", width = 900, height = 650)
barplot(d$Mean, names.arg = d$Cell, col  = "steelblue",
        ylab = "Mean actin fluorescence (arbitrary units)",
        main = paste("Actin signal —", image_id))
dev.off()
