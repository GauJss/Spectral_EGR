function [SizeBoot_Hu,QBoot_Hu] = Hu_Boot(Qn,B,omega,type,n,k,Boot,alpha)

 % Hu et al. (2021) bootstrap test.
    %
    % Inputs:
    %   Qn    - Original Hu's test statistic
    %   B     - Community connectivity matrix
    %   omega - Node degree parameters
    %   type  - Network model type ('sbm' or 'dcbm')
    %   n     - Number of nodes
    %   k     - Number of communities
    %   Boot  - Number of bootstrap samples
    %   alpha - Significance level
    %
    % Outputs:
    %   SizeBoot_Hu - 1 if the test rejects the null, 0 otherwise
    %   QBoot_Hu    - Bootstrap test statistic

TBoot=zeros(Boot,1);

% Bootstrap loop: generate networks and compute test statistic
for loop=1:Boot
A=Generating(n,k,B,omega); %GenDCBM(n,k,B,omega);
[~,position]=SP_kmeans(A,k);
[~,~,~,rho] = MLE(A,k,position,omega,type);
Ln=max(max(abs(rho)));
TBoot(loop,:)=Ln^2-2*log(2*n*k)+log(log(2*n*k));
end

% Fit bootstrap distribution using MLE (location-scale)
param0=[-2*log(2*sqrt(pi)),2];
options = optimset('GradObj','off'); 
fun= {@(param)(Boot*log(param(2))-sum(-(TBoot-param(1))./param(2))+sum(exp(-(TBoot-param(1))./param(2))))};
[param_mle,~,~,~]=fminunc(fun,param0,options);
hat_mu=param_mle(1);hat_beta=param_mle(2);

% Test decision
QBoot_Hu=-2*log(2*sqrt(pi))+2*(Qn-hat_mu)/hat_beta;
ev=-2*log(-2*sqrt(pi)*log(1-alpha));
if QBoot_Hu>ev
    SizeBoot_Hu=1;
    else
    SizeBoot_Hu=0;
end
end

