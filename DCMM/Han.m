
function [Size_Han,T] = Han(A,k,m,alpha)

% Han et al.'s (2023) method to test the number of communities
    
    % Inputs:
    %   A      - Adjacency matrix of the network
    %   k      - Tested number of communities
    %   m      - Random sampling parameter
    %   alpha  - Significance level for the hypothesis test
    %
    % Outputs:
    %   Size_Han - 1 if the test statistic is significant, 0 otherwise
    %   T        -  Han et al.'s (2023) Test statistic


n=size(A,1);   % Number of nodes in the network
[eig_vector,eigvalue]=eig(A);   % Compute eigenvalues and eigenvectors of A
eigvalue=diag(eigvalue);

% Sort eigenvalues in descending order
[val_sort,order]=sort(eigvalue,'descend'); 
vec_order = eig_vector(:,order); 
% First k eigenvectors and eigenvalues
vec_Lead=vec_order(:,1:k); 
val_Lead=val_sort(1:k);  

 % Projection matrix for the leading eigenvectors
Q_qiu=zeros(n,n);
for kk=1:k
    Q_qiu=Q_qiu+val_Lead(kk)*vec_Lead(:,kk)*(vec_Lead(:,kk))';
end
W=A-Q_qiu; % Residual matrix

%% Samples
Y=zeros(n,n); 
for i=1:n
   for j=1:i
       Y(i,j)=binornd(1,1/m); 
    end
end
for i=1:n
    for j=1:i-1
        Y(j,i)=Y(i,j);
    end
end
Y=Y-diag(diag(Y));

% Compute the RIRS test statistic
WY=W.*Y;
W2=W.^2;
numerator=sqrt(m)*sum(sum(WY-diag(diag(WY))));
denominator=sqrt(2*sum(sum(W2-diag(diag(W2)))));
T=numerator/denominator;

% Hypothesis test
tn=norminv(1-alpha/2,0,1);
if abs(T)>=tn
    Size_Han=1;
else
    Size_Han=0;
end
end



