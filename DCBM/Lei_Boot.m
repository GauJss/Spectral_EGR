function [SizeBoot_Lei,TnBoot_Lei] = Lei_Boot(A,k,B,Q,omega,type,Boot,tw)

 % Bootstrap version of Lei (2016) test.
    %
    % Inputs:
    %   A     - Adjacency matrix
    %   k     - Number of communities
    %   B     - Community connectivity matrix
    %   Q     - Edge probability matrix
    %   omega - Node degree parameters
    %   type  - Network type ('sbm' or 'dcbm')
    %   Boot  - Number of bootstrap samples
    %   tw    - Critical value from Tracy-Widom law
    %
    % Outputs:
    %   SizeBoot_Lei - 1 if the test rejects null, 0 otherwise
    %   TnBoot_Lei   - Bootstrapped test statistic

n=size(A,1);A_qiu=zeros(n,n);

 % Standardize adjacency matrix
for i=2:n
    for j=1:i-1
        A_qiu(i,j)=(A(i,j)-Q(i,j))/sqrt((n-1)*Q(i,j)*(1-Q(i,j)));       
    end
end
A_qiu=A_qiu+A_qiu';
A_qiu=A_qiu+diag(-diag(A_qiu));

 % Compute leading and smallest eigenvalues
[~,eigvalue]=eig(A_qiu);
lambda1=max(diag(eigvalue));
lambda2=min(diag(eigvalue));

% Bootstrap loop
lambdaB1=zeros(Boot,1);lambdaB2=zeros(Boot,1);
for m=1:Boot
AM=Generating(n,k,B,omega);  %GenDCBM(n,k,B,omega);
[~,positionM]=SP_kmeans(AM,k);
[~,QM,~,~] = MLE(AM,k,positionM,omega,type); 
AM_qiu=zeros(n,n);
for i=2:n
    for j=1:i-1
        AM_qiu(i,j)=(AM(i,j)-QM(i,j))/sqrt((n-1)*QM(i,j)*(1-QM(i,j)));       
    end
end
AM_qiu=AM_qiu+AM_qiu';
AM_qiu=AM_qiu+diag(-diag(AM_qiu));
[~,eigvaluem]=eig(AM_qiu);
lambdaB1(m,:)=max(diag(eigvaluem));
lambdaB2(m,:)=min(diag(eigvaluem));
end

% Bootstrap mean and std
mu1=mean(lambdaB1);st1=std(lambdaB1);
mu2=mean(lambdaB2);st2=std(lambdaB2);
% Standardize Tracy-Widom location parameters
mu_tw=-1.20653;st_tw=sqrt(1.60778);

% Decision of the test
TnBoot_Lei=mu_tw+st_tw*max((lambda1-mu1)/st1,-(lambda2-mu2)/st2);
if TnBoot_Lei>=tw
    SizeBoot_Lei=1;
else
    SizeBoot_Lei=0;
end
end

