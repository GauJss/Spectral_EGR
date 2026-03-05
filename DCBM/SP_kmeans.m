function [hat_A,hat_sigma] = SP_kmeans(A,k)

% Spectral clustering via k-means
%
% Inputs:
%   A - Adjacency matrix (n x n)
%   k - Number of communities
%
% Outputs:
%   hat_A    - Reordered adjacency matrix according to clustering
%   hat_sigma - Community labels for nodes (1 x n)


[eig_vector,eigvalue]=eig(A);
[~,order]=sort(diag(eigvalue),'descend'); 
eig_Lead = eig_vector(:,order);
eig_Lead=eig_Lead(:,1:k);

% Apply k-means to the top-k eigenvectors to get community assignments
hat_sigma = kmeans(eig_Lead,k);

% Reorder adjacency matrix according to clustering labels
num=0;
for kk=1:k
    num1=find(hat_sigma==kk);
    num=[num;num1];
end
num(1)=[];
hat_A=A(num,num);
end