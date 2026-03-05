function [Size_Lei,Tn_Lei] = Lei_Or(A,Q,tw)

    % Lei (2016) test.
    %
    % Inputs:
    %   A  - Adjacency matrix
    %   Q  - Edge probability matrix
    %   tw - Critical value from Tracy-Widom law
    %
    % Outputs:
    %   Size_Lei - 1 if the test rejects null, 0 otherwise
    %   Tn_Lei   - Test statistic

n=size(A,1);A_qiu=zeros(n,n);

% Standardize adjacency matrix
for i=2:n
    for j=1:i-1
        A_qiu(i,j)=(A(i,j)-Q(i,j))/sqrt((n-1)*Q(i,j)*(1-Q(i,j)));       
    end
end
A_qiu=A_qiu+A_qiu';
A_qiu=A_qiu+diag(-diag(A_qiu));

% Compute largest eigenvalue in absolute value
[~,eigvalue]=eig(A_qiu);
lambda1=max(diag(eigvalue));
lambda2=-min(diag(eigvalue));
lambda=max(lambda1,lambda2);

% Decision
Tn_Lei=n^(2/3)*(lambda-2);
if Tn_Lei>=tw
    Size_Lei=1;
else
    Size_Lei=0;
end
end

