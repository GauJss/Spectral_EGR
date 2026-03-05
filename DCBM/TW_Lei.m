function output=TW_Lei(n,p_value1,p_value2,loop)

% Compute empirical Tracy-Widom percentiles of Lei (2016)
%
% Inputs:
%   n         - Matrix dimension
%   p_value1  - First percentile (e.g., 0.05)
%   p_value2  - Second percentile (e.g., 0.95)
%   loop      - Number of Monte Carlo simulations
%
% Output:
%   output    - Two empirical percentiles


Test1=zeros(loop,1); 
for b=1:loop
W=zeros(n,n); 
% Generate symmetric Gaussian Wigner matrix
for i=1:n
    for j=1:i
     W(i,j)=(1/sqrt(n))*randn(1,1);
    end
end
for i=1:n
    for j=1:i-1
        W(j,i)=W(i,j);
    end
end
[~,eigvalue]=eig(W);
lambda=max(diag(eigvalue)); 
Test1(b,:)=n^(2/3)*(lambda-2);
end

% Sort and select empirical percentiles
Test1=sort(Test1,'descend');
per1=Test1(round(length(Test1)*p_value1));
per2=Test1(round(length(Test1)*p_value2));
output=[per1,per2];

