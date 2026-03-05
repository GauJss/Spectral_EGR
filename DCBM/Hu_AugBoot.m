function [SizeAugBoot_Hu,QAugBoot_Hu]=Hu_AugBoot(QAug,omega,type,B,n,k,Boot,alpha)

% Hu et al. (2021) bootstrap-based augmented test
    % Inputs:
    %   QAug   - Original Hu augmented test statistic
    %   omega  - Node degree parameters
    %   type   - Network model type ('sbm' or 'dcbm')
    %   B      - Community connectivity matrix
    %   n      - Number of nodes
    %   k      - Number of communities
    %   Boot   - Number of bootstrap samples
    %   alpha  - Significance level
    %
    % Outputs:
    %   SizeAugBoot_Hu - 1 if the test is rejected, 0 otherwise
    %   QAugBoot_Hu    - Test statistic


nk=round(n/k);
n_new=round(n/k/2); % Sizes of added communities
sizeB=size(B,1);

% Extract intra- and inter-community probabilities
In_p=max(diag(B));
diag_B=diag(diag(B)); diag_B=reshape(diag_B,sizeB^2,1);
vec_B=reshape(B,sizeB^2,1);
Out_p=sort((vec_B-diag_B)/2); 
Out_p=Out_p(find(Out_p>min(Out_p),1));

% Bootstrap loop: generate networks with augmented community and compute test statistic
TAugBoot=zeros(Boot,1);
for loop=1:Boot
A=Generating(n,k,B,omega);  %GenDCBM(n,k,B,omega);
sam=randperm(n,n_new);
omega_new=[omega,omega(sam)];
OA_new=zeros(n,n_new);
for i=1:n
    for j=1:n_new
        OA_new(i,j)=binornd(1,omega_new(i)*Out_p*omega_new(j+n)); 
    end
end
IA_new=zeros(n_new,n_new);
for i=1:n_new
    for j=1:i
        IA_new(i,j)=binornd(1,omega_new(i+n)*In_p*omega_new(j+n)); 
    end
end
for i=2:n_new
    for j=1:i-1
        IA_new(j,i)=IA_new(i,j);
    end
end
A_new=[A,OA_new;OA_new',IA_new];
A_new=A_new+diag(-diag(A_new));

% Estimate parameters for the augmented network
[~,position]=SP_kmeans(A_new,k+1);
[~,~,~,rho_new] = MLE(A_new,k+1,position,omega_new,type);
%% Hu's bootstrap augmented test statistic
Ln=max(max(abs(rho_new)));
TAugBoot(loop,:)=Ln^2-2*log(2*(n+n_new)*(k+1))+log(log(2*(n+n_new)*(k+1)));
end

% Fit the bootstrap distribution (MLE for location-scale)
param0=[-2*log(sqrt(pi)),1];
options = optimset('GradObj','off'); 
fun1= {@(param)(Boot*log(param(2))-sum(-(TAugBoot-param(1))./param(2))+sum(exp(-(TAugBoot-param(1))./param(2))))};
[param_mle,~,~,~]=fminunc(fun1,param0,options);
hat_mu=param_mle(1);hat_beta=param_mle(2);

% Decision based on Hu's bootstrap augmented test statistic
QAugBoot_Hu=-2*log(2*sqrt(pi))+2*(QAug-hat_mu)/hat_beta;
ev=-2*log(-2*sqrt(pi)*log(1-alpha));
if QAugBoot_Hu>ev
    SizeAugBoot_Hu=1;
    else
    SizeAugBoot_Hu=0;
end
end


