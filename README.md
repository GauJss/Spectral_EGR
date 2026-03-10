# Spectral_EGR

This folder contains the code for the spectral inference method proposed in "A Spectral Inference Method for Determining the Number of Communities in Networks".

DCBM: Includes the code for hypothesis testing under both Stochastic Block Model and Degree-Corrected Stochastic Block Model, where "Simu_Table*.m" is the main script responsible for coordinating the simulation process for the corresponding table in the main paper, calling various supporting functions.

DCMM: Includes the code for hypothesis testing under the Degree-Corrected Mixed Membership Model, where "Simu_Table*.m" is the main script that manages the simulation process for the respective table in the main paper, invoking supporting functions as needed.

Real data: Real data: Contains three public network datasets analyzed in the paper, along with the main scripts for each analysis. These scripts call the same utility functions in the DCBM folder.

"Figure_S*.R": The main script for generating the figures in the supplementary material.

"Kmax_selection.R": The script implements Algorithm S.1 from the supplement for selecting the practical value of $K_{\max}$.

