read.table(file="iter_results.txt",header=F)->M
#boxplot(M$V7~M$V5)

library(ggridges)
library(ggplot2)
library(dplyr)

# Example: set specific facet titles
M <- M %>%
  mutate(V6 = factor(V6, levels = c("SRR17981950_51_52_Fm_locus_merged.bed", "SRR17968711_12_CAU_Silkie_Fm_subseted.bed", "SRR27781695_96_97_merged.bed"),
                              labels = c("SRR17981950_51_52 (PacBio)", "SRR17968711_12 (ONT)", "SRR27781695_96_97 (ONT-Longer reads)")))

P <- ggplot(M, aes(x = V7, y = as.factor(V5))) +
  geom_density_ridges(scale = 1.2, fill = "lightgreen", alpha = 0.8) +
  geom_vline(xintercept = 2, color = "red", linetype = "dashed", size = 1) +
  geom_vline(xintercept = 1.5, color = "blue", linetype = "dashed", size = 1) +
  labs(
    x = "DUP1/INT Coverage ratio",
    y = "Number of reads"
  ) +
  facet_wrap(~ V6, nrow = 1) +  # Titles now show as custom labels
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold"),
    strip.text = element_text(size = 13, face = "bold"),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA)
  )

ggsave("DUP1_highres.png", plot = P, width = 12, height = 4, dpi = 300)


P <- ggplot(M, aes(x = V8, y = as.factor(V5))) +
  geom_density_ridges(scale = 1.2, fill = "lightgreen", alpha = 0.8) +
  geom_vline(xintercept = 2, color = "red", linetype = "dashed", size = 1) +
  geom_vline(xintercept = 1.5, color = "blue", linetype = "dashed", size = 1) +
  labs(
    x = "DUP2/INT Coverage ratio",
    y = "Number of reads"
  ) +
  facet_wrap(~ V6, nrow = 1) +  # Titles now show as custom labels
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold"),
    strip.text = element_text(size = 13, face = "bold"),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA)
  )

ggsave("DUP2_highres.png", plot = P, width = 12, height = 4, dpi = 300)


P <- ggplot(M, aes(x = V2/V3, y = as.factor(V5))) +
  geom_density_ridges(scale = 1.2, fill = "lightgreen", alpha = 0.8) +
  geom_vline(xintercept = 2, color = "red", linetype = "dashed", size = 1) +
  geom_vline(xintercept = 1.5, color = "blue", linetype = "dashed", size = 1) +
  labs(
    x = "DUP1/DUP2 Coverage ratio",
    y = "Number of reads"
  ) +
  facet_wrap(~ V6, nrow = 1) +  # Titles now show as custom labels
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold"),
    strip.text = element_text(size = 13, face = "bold"),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA)
  )

ggsave("DUP1_DUP2_highres.png", plot = P, width = 12, height = 4, dpi = 300)
