function per = Tracy_Percentile(n,k,kmax,pvalue,loop) 

% Compute empirical percentile for eigengap ratio
%
% Inputs:
%   n       - Matrix dimension
%   k       - Number of communities
%   kmax    - Maximum number of communities for testing
%   pvalue  - Desired percentile (e.g., 0.05 for 5%)
%   loop    - Number of Monte Carlo simulations
%
% Output:
%   per     - Empirical percentile of the eigengap ratio


Test=zeros(loop,1);
kk=kmax-k+2;
for b=1:loop
W=zeros(n,n); 

% Generate GOE matrix
for i=1:n-1
    for j=1:i
     W(i,j)=(1/sqrt(n))*randn(1,1);
    end
end

for i=1:n
     W(i,i)=(sqrt(2/n))*randn(1,1);
end


for i=1:n-1
    for j=1:i-1
        W(j,i)=W(i,j);
    end
end

% Compute eigengap ratio
[~,eigvalue]=eig(W);
lambda=sort(diag(abs(eigvalue)),'descend'); 
Test(b,:)=(lambda(1)-lambda(kk-1))/(lambda(kk-1)-lambda(kk));
end

% Return empirical percentile
Test=sort(Test,'descend');
per=Test(round(length(Test)*pvalue));
end

