library(ggplot2)

# Set parameters
n <- 3000
epsilon=0.005

# Define range of rho_n 
rho_n <- seq(0.001, 0.999, length.out = 100)

# Calculate the feasible maximum K
K_max <- 3*sqrt(n^(1/3-epsilon) * rho_n)

# Plot the trade-off graph
df <- data.frame(rho_n = rho_n, K_max = K_max)
ggplot(df, aes(x = rho_n, y = K_max)) +
  geom_line(color = "blue", size = 1.2) +
  geom_ribbon(aes(ymin = 0, ymax = K_max), fill = "lightblue", alpha = 0.3) +
  labs(
    title = expression(paste("Trade-off for diverging ", n^{1/3} * max[i != j]*P[ij]/K^2)),
    x = expression(max[i != j]*P[ij]),
    y = "K"
  ) +
  theme_minimal() +
  theme(
    text = element_text(size = 14),
    plot.title = element_text(hjust = 0.5)  
  )



