
library(RSpectra)   
library(nFactors)  

# Generate SBM adjacency matrix
set.seed(123)

n <- 3000
K <- 20
pin  <- 0.5
pout <- 0.1

# Community labels
g <- rep(1:K, each = n / K)

# Probability matrix for SBM
P <- matrix(pout, K, K)
diag(P) <- pin

# Generate SBM adjacency matrix
A <- matrix(0, n, n)

for (k1 in 1:K) {
  for (k2 in k1:K) {
    idx1 <- which(g == k1)
    idx2 <- which(g == k2)
    
    if (k1 == k2) {
      block <- matrix(rbinom(length(idx1)^2, 1, pin), length(idx1), length(idx1))
      diag(block) <- 0                # zero diagonal
      A[idx1, idx1] <- block
    } else {
      block <- matrix(rbinom(length(idx1)*length(idx2,1), 1, pout), length(idx1), length(idx2))
      A[idx1, idx2] <- block
      A[idx2, idx1] <- t(block)
    }
  }
}

diag(A) <- 0    # double check zero diagonal

# Center adjacency
H <- diag(n) - matrix(1/n, n, n)
X <- H %*% A %*% H

# Compute top 'neig' eigenvalues
neig <- 100
eig_data <- eigs_sym(cov(X), k = neig, which = "LM")$values
eig_data <- sort(eig_data, decreasing = TRUE)

# Custom permutation (parallel analysis)
B <- 500  
eig_perm <- matrix(NA, B, neig)

for (b in 1:B) {
  X_perm <- apply(X[,1:neig], 2, sample)  
  eig_perm[b,] <- sort(eigen(cov(X_perm))$values, decreasing = TRUE)
}

aparallel <- apply(eig_perm, 2, quantile, 0.95)   

# -----------------------------
# nScree + Plotting
# -----------------------------
nf <- nScree(x = eig_data, aparallel = aparallel)

plotnScree(nf)

# Output estimated rank (from parallel analysis)
rank_pa <- sum(eig_data > aparallel)
cat("Estimated rank (parallel analysis):", rank_pa, "\n")


