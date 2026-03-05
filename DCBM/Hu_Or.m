function [Size_Hu,Q_Hu] = Hu_Or(rho,n,k,alpha)

 % Hu et al. (2021) test.
    %
    % Inputs:
    %   rho   - Estimated entry-wise deviations
    %   n     - Number of nodes
    %   k     - Number of communities
    %   alpha - Significance level
    %
    % Outputs:
    %   Size_Hu - 1 if the test rejects the null, 0 otherwise
    %   Q_Hu    - Hu's test statistic
    % 

% Compute test statistic and decision of the test
Ln=max(max(abs(rho)));
Q_Hu=Ln^2-2*log(2*n*k)+log(log(2*n*k));
ev=-2*log(-2*sqrt(pi)*log(1-alpha));
if Q_Hu>ev
    Size_Hu=1;
else
    Size_Hu=0;
end
end

