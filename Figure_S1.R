library(tidyverse)

# Create a data frame with different network settings, methods, and corresponding computation times
cpu <- tribble(
  ~n, ~Kmax, ~setting, ~method, ~time,
  
  # =====================
  # n = 3000
  # =====================
  3000, 9,  "Dense",  "T", 0.514,
  3000, 9,  "Dense",  "Lei", 2.038,
  3000, 9,  "Dense",  "Lei_boot", 2049.774,
  3000, 9,  "Dense",  "Han", 18.570,
  3000, 9,  "Dense",  "Hu", 2.488,
  3000, 9,  "Dense",  "Hu_aug_boot", 4111.784,
  
  3000, 12, "Dense",  "T", 0.567,
  3000, 12, "Dense",  "Lei", 2.140,
  3000, 12, "Dense",  "Lei_boot", 2043.115,
  3000, 12, "Dense",  "Han", 18.206,
  3000, 12, "Dense",  "Hu", 2.259,
  3000, 12, "Dense",  "Hu_aug_boot", 4163.432,
  
  3000, 17, "Dense",  "T", 0.468,
  3000, 17, "Dense",  "Lei", 1.780,
  3000, 17, "Dense",  "Lei_boot", 2004.319,
  3000, 17, "Dense",  "Han", 17.600,
  3000, 17, "Dense",  "Hu", 2.035,
  3000, 17, "Dense",  "Hu_aug_boot", 4070.824,
  
  3000, 9,  "Sparse", "T", 0.525,
  3000, 9,  "Sparse", "Lei", 1.833,
  3000, 9,  "Sparse", "Lei_boot", 2025.399,
  3000, 9,  "Sparse", "Han", 17.827,
  3000, 9,  "Sparse", "Hu", 2.291,
  3000, 9,  "Sparse", "Hu_aug_boot", 4076.111,
  
  3000, 12, "Sparse", "T", 0.507,
  3000, 12, "Sparse", "Lei", 1.848,
  3000, 12, "Sparse", "Lei_boot", 2022.521,
  3000, 12, "Sparse", "Han", 17.770,
  3000, 12, "Sparse", "Hu", 2.094,
  3000, 12, "Sparse", "Hu_aug_boot", 4082.963,
  
  3000, 17, "Sparse", "T", 0.517,
  3000, 17, "Sparse", "Lei", 1.831,
  3000, 17, "Sparse", "Lei_boot", 2030.575,
  3000, 17, "Sparse", "Han", 17.614,
  3000, 17, "Sparse", "Hu", 2.126,
  3000, 17, "Sparse", "Hu_aug_boot", 4080.464,

  # =====================
  # n = 6000
  # =====================
  6000, 9,  "Dense",  "T", 2.312,
  6000, 9,  "Dense",  "Lei", 12.653,
  6000, 9,  "Dense",  "Lei_boot", 9015.261,
  6000, 9,  "Dense",  "Han", 75.199,
  6000, 9,  "Dense",  "Hu", 13.360,
  6000, 9,  "Dense",  "Hu_aug_boot", 17555.033,

  6000, 12, "Dense",  "T", 2.736,
  6000, 12, "Dense",  "Lei", 12.079,
  6000, 12, "Dense",  "Lei_boot", 8879.568,
  6000, 12, "Dense",  "Han", 74.397,
  6000, 12, "Dense",  "Hu", 12.770,
  6000, 12, "Dense",  "Hu_aug_boot", 16989.730,
  
  6000, 17, "Dense",  "T", 3.615,
  6000, 17, "Dense",  "Lei", 12.787,
  6000, 17, "Dense",  "Lei_boot", 9048.512,
  6000, 17, "Dense",  "Han", 76.522,
  6000, 17, "Dense",  "Hu", 14.156,
  6000, 17, "Dense",  "Hu_aug_boot", 17390.493,
  
  6000, 9,  "Sparse", "T", 1.951,
  6000, 9,  "Sparse", "Lei", 13.461,
  6000, 9,  "Sparse", "Lei_boot", 9114.929,
  6000, 9,  "Sparse", "Han", 77.157,
  6000, 9,  "Sparse", "Hu", 13.010,
  6000, 9,  "Sparse", "Hu_aug_boot", 17327.906,
  
  6000, 12, "Sparse", "T", 3.091,
  6000, 12, "Sparse", "Lei", 11.989,
  6000, 12, "Sparse", "Lei_boot", 8874.047,
  6000, 12, "Sparse", "Han", 74.313,
  6000, 12, "Sparse", "Hu", 12.970,
  6000, 12, "Sparse", "Hu_aug_boot", 17023.230,
  
  6000, 17, "Sparse", "T", 3.648,
  6000, 17, "Sparse", "Lei", 11.404,
  6000, 17, "Sparse", "Lei_boot", 8771.785,
  6000, 17, "Sparse", "Han", 76.461,
  6000, 17, "Sparse", "Hu", 14.186,
  6000, 17, "Sparse", "Hu_aug_boot", 17155.424,
  
  # =====================
  # n = 9000
  # =====================
  9000, 9,  "Dense",  "T", 6.781,
  9000, 9,  "Dense",  "Lei", 53.971,
  9000, 9,  "Dense",  "Lei_boot", 25544.957,
  9000, 9,  "Dense",  "Han", 213.932,
  9000, 9,  "Dense",  "Hu", 59.716,
  9000, 9,  "Dense",  "Hu_aug_boot", 44917.910,
  
  9000, 12, "Dense",  "T", 7.357,
  9000, 12, "Dense",  "Lei", 55.626,
  9000, 12, "Dense",  "Lei_boot", 25715.316,
  9000, 12, "Dense",  "Han", 198.310,
  9000, 12, "Dense",  "Hu", 55.455,
  9000, 12, "Dense",  "Hu_aug_boot", 45247.198,
  
  9000, 17, "Dense",  "T", 8.159,
  9000, 17, "Dense",  "Lei", 53.255,
  9000, 17, "Dense",  "Lei_boot", 25158.241,
  9000, 17, "Dense",  "Han", 201.053,
  9000, 17, "Dense",  "Hu", 58.397,
  9000, 17, "Dense",  "Hu_aug_boot", 44616.335,
  
  9000, 9,  "Sparse", "T", 5.155,
  9000, 9,  "Sparse", "Lei", 54.819,
  9000, 9,  "Sparse", "Lei_boot", 26942.922,
  9000, 9,  "Sparse", "Han", 192.157,
  9000, 9,  "Sparse", "Hu", 55.331,
  9000, 9,  "Sparse", "Hu_aug_boot", 44132.278,
  
  9000, 12, "Sparse", "T", 6.751,
  9000, 12, "Sparse", "Lei", 55.613,
  9000, 12, "Sparse", "Lei_boot", 25306.798,
  9000, 12, "Sparse", "Han", 193.441,
  9000, 12, "Sparse", "Hu", 54.945,
  9000, 12, "Sparse", "Hu_aug_boot", 46557.029,
  
  9000, 17, "Sparse", "T", 7.355,
  9000, 17, "Sparse", "Lei", 55.091,
  9000, 17, "Sparse", "Lei_boot", 25707.009,
  9000, 17, "Sparse", "Han", 196.141,
  9000, 17, "Sparse", "Hu", 54.572,
  9000, 17, "Sparse", "Hu_aug_boot", 45024.219
)



# Check the structure of the data
glimpse(cpu)

# Plot computation time (log scale), grouped by Kmax, method, and faceted by n and setting
ggplot(cpu, aes(Kmax, time, color = method, group = method)) +
  geom_line() +
  geom_point() +
  scale_y_log10() +
  facet_grid(n ~ setting) +
  theme_bw() +
  labs(
    x = expression(K[max]),
    y = expression("Computation time (seconds, log"[10]*" scale)"),
    color = "Method"
  )


# Create simplified labels for methods
cpu <- cpu %>%
  mutate(
    method_label = case_when(
      method == "T"           ~ "T",
      method == "Lei"         ~ "T[Lei]",
      method == "Lei_boot"    ~ "T[Lei*','*boot]",
      method == "Han"         ~ "T[Han]",
      method == "Hu"          ~ "T[Hu]",
      method == "Hu_aug_boot" ~ "T[Hu*','*boot]^aug"
    ),
    # Order the method labels based on computation time
    method_label = factor(method_label,
                          levels = c(
                            "T",
                            "T[Lei]",
                            "T[Lei*','*boot]",
                            "T[Han]",
                            "T[Hu]",
                            "T[Hu*','*boot]^aug"
                          ))
  )

# Plot the updated computation time (log scale), with simplified method labels
ggplot(cpu, aes(Kmax, time, color = method_label, group = method_label)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2) +
  scale_y_log10() +
  facet_grid(n ~ setting) +
  theme_bw() +
  labs(
    x = expression(K[max]),
    y = expression("Computation time (seconds, log"[10]*" scale)"),
    color = "Method"
  ) +
  scale_color_discrete(labels = parse(text = levels(cpu$method_label)))
