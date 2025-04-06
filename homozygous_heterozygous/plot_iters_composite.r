# Load libraries
library(ggplot2)
library(ggridges)
library(dplyr)
library(patchwork)
library(cowplot)
library(grid)

# Load and format the data
data <- read.table("iter_results.txt", header = FALSE)
colnames(data) <- paste0("V", 1:ncol(data))
data <- data %>%
  mutate(V6 = factor(
    V6,
    levels = c("SRR17981950_51_52_Fm_locus_merged.bed",
               "SRR17968711_12_CAU_Silkie_Fm_subseted.bed",
               "SRR27781695_96_97_merged.bed"),
    labels = c("PacBio", "ONT", "ONT (Longer reads)")
  ))

# Define vertical lines
vlines <- data.frame(
  xintercept = c(1.0, 1.5, 2.0),
  colour = c("brown", "blue", "red"),
  label = c("Reference", "Lower Threshold", "Upper Threshold")
)

# Theme
custom_theme <- theme_minimal(base_size = 14) +
  theme(
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold"),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12),
    strip.text.x = element_blank(),
    strip.placement = "outside",
    panel.spacing = unit(1.2, "lines"),
    legend.position = "none",  # Remove legend
    panel.grid = element_blank(),
    panel.background = element_blank(),
    plot.background = element_blank(),
    plot.tag = element_text(face = "bold", size = 16),
    strip.background = element_rect(fill = "#f0f0f0", color = "black", linewidth = 0.6)
  )

# Function to create panels
make_panel <- function(data, xvar, tag_label, xlab) {
  if (xvar == "V2/V3") {
    data <- data %>% mutate(ratio = V2 / V3)
    xvar <- "ratio"
  }

  ggplot(data, aes(x = .data[[xvar]], y = as.factor(V5))) +
    geom_density_ridges(scale = 1.2, fill = "lightgreen", alpha = 0.8) +
    geom_vline(data = vlines,
               aes(xintercept = xintercept, color = label),
               linetype = "dashed", size = 1, inherit.aes = FALSE) +
    scale_x_continuous(
      limits = c(0.5, 3.0),
      breaks = seq(0.5, 2.9, by = 0.5)
    ) +
    facet_grid(rows = vars(), cols = vars(V6)) +
    labs(x = xlab, y = "Number of reads", tag = tag_label) +
    scale_color_manual(values = c("Reference" = "brown",
                                  "Lower Threshold" = "blue",
                                  "Upper Threshold" = "red")) +
    custom_theme
}

# Create individual row plots
row1 <- make_panel(data, "V7", "(a)", "DUP1 / INT Coverage ratio")
row2 <- make_panel(data, "V8", "(b)", "DUP2 / INT Coverage ratio")
row3 <- make_panel(data, "V2/V3", "(c)", "DUP1 / DUP2 Coverage ratio")

# Merge rows
row_plot <- plot_grid(row1, row2, row3, ncol = 1, align = "v", rel_heights = c(1, 1, 1))

# Background colors
bg_colors <- c("#f2f0f7", "#e0ecf4", "#fee8c8")
labels <- c("PacBio (SRR17981950_51_52)", "ONT (SRR17968711_12)", "ONT (SRR27781695_96_97)")

# Column overlay with full-height boxes and embedded titles
column_background_with_titles <- function() {
  rects <- lapply(0:2, function(i) {
    xleft <- i / 3
    xright <- (i + 1) / 3

    gList(
      rectGrob(
        x = unit((xleft + xright) / 2, "npc"),
        y = unit(0.5, "npc"),
        width = unit(1/3, "npc"),
        height = unit(1, "npc"),
        just = "center",
        gp = gpar(fill = bg_colors[i + 1], col = "black", lwd = 1.2)
      ),
      textGrob(
        labels[i + 1],
        x = unit((xleft + xright) / 2, "npc"),
        y = unit(0.98, "npc"),
        gp = gpar(fontsize = 16, fontface = "bold")
      )
    )
  })
  gTree(children = do.call(gList, rects))
}

# Final plot composition (legend removed)
final_full_plot <- ggdraw() +
  draw_grob(column_background_with_titles()) +
  draw_plot(row_plot, y = 0.01, height = 0.9)

# Save final image
ggsave("homozygous_heterozygous.png", final_full_plot,
       width = 16, height = 10, dpi = 400)
