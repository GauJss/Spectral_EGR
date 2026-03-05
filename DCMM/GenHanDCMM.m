function [A,H] = GenHanDCMM(n,npi,k,B0,rho,sparsity,x,Gentype) %pw0,pw1

% Generate a DCMM adjacency matrix following Han et al. (2023)

% Inputs:
%   n         - Number of nodes 
%   npi       - Community size parameter
%   k         - Number of communities
%   B0        - Initialized community probability matrix
%   rho       - Community correlation parameter 
%   sparsity  - Network sparsity parameter
%   x         - Mixing parameter to determine the probability distribution between communities
%   Gentype   - Generate DCBM or DCMM 
%
% Outputs:
%   A         - Generated adjacency matrix
%   H         - Probability matrix used in generating A


% Community connection probabilities B
if strcmpi(Gentype , 'NotHan')
    B=B0;
    elseif strcmpi(Gentype , 'Han')
        B=zeros(k,k);  %rho=0.9 or 0.1 and sparsity=1 or 5*n^(-5/9)
        for i=1:k
            B(i,i)=(k+1-i)/k;
        end
        for i=2:k
            for j=1:i-1
                B(i,j)=sparsity*rho^abs(i-j);
            end
        end
        for i=2:k
            for j=1:i-1
                B(j,i)=B(i,j);
            end
        end
else
    error('The case does not exit!'); 
end

% Degree correction
omega=unifrnd(0.5,1,n,1);

% Community assignment probabilities
Pi=zeros(n,k);
MM=[x,1-x,zeros(1,k-2);1-x,x,zeros(1,k-2);diag(eye(k))'/k];
rPN=randperm(n,round(k*npi)); rPN=reshape(rPN,k,length(rPN)/k);
for i=1:k
    Pi(rPN(i,:),i)=1;
end
rMM=setdiff(1:n,rPN);rMM=reshape(rMM,size(MM,1),length(rMM)/size(MM,1));
for i=1:size(rMM,1)
    Pi(rMM(i,:),:)=MM(i,:).*ones(size(Pi(rMM(i,:),:)));
end

H=diag(omega)*Pi*B*Pi'*diag(omega);

% Generate symmetric adjacency matrix A
A=zeros(n,n);
for i=1:n
    for j=1:i
        A(i,j)=binornd(1,H(i,j)); 
    end
end

for i=2:n
    for j=1:i-1
        A(j,i)=A(i,j);
    end
end
A=A+diag(-diag(A));

