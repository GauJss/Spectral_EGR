function [SizeAug_Hu,QAug_Hu] = Hu_Aug(A,B,k,omega,type,alpha)

% Hu et al. (2021) augmented test for detecting communities.
    %
    % Inputs:
    %   A      - Adjacency matrix
    %   B      - Community connectivity matrix
    %   k      - Number of communities
    %   omega  - Node degree parameters
    %   type   - Model type ('sbm' or 'dcbm')
    %   alpha  - Significance level
    %
    % Outputs:
    %   SizeAug_Hu - 1 if the test is rejected, 0 otherwise
    %   QAug_Hu    - Calculated augmented test statistic

n=size(A,1); 
n_new=round(n/k/2); % Number of nodes in the added community
sizeB=size(B,1);
In_p=max(diag(B));  % Within-community probability
diag_B=diag(diag(B)); diag_B=reshape(diag_B,sizeB^2,1);
vec_B=reshape(B,sizeB^2,1);
Out_p=sort((vec_B-diag_B)/2); 
Out_p=Out_p(find(Out_p>min(Out_p),1));   % Inter-community probability

 %% Generate edges for the newly added community
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

% Combine original and new community adjacency matrices
A_new=[A,OA_new;OA_new',IA_new];
A_new=A_new+diag(-diag(A_new));

%% Hu AUG Test Statistics 
[~,position]=SP_kmeans(A_new,k+1);
[~,~,~,rho_new] = MLE(A_new,k+1,position,omega_new,type);
Ln_new=max(max(abs(rho_new)));
QAug_Hu=Ln_new^2-2*log(2*(n+n_new)*(k+1))+log(log(2*(n+n_new)*(k+1)));

% Decide if the test is rejected
ev=-2*log(-2*sqrt(pi)*log(1-alpha));
if QAug_Hu>ev
    SizeAug_Hu=1;
else
    SizeAug_Hu=0;
end
end

