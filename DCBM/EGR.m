function [Size,Tn] = EGR(A, kmax, k, threva)
% Our method: Use the eigengap ratio to estimate the number of communities in a network.
    % Inputs:
    %   A      - Adjacency matrix of the network
    %   kmax   - Possible maximum number of communities
    %   k      - Tested Current number of communities
    %   threva - Threshold for our test statistic
    %
    % Outputs:
    %   Size   - 1 if our test exceeds the threshold, 0 otherwise
    %   Tn     - Calculated eigengap ratio test statistic

%Compute the eigenvalues of A
[~,eigvalueA]=eigs(A,kmax+2,'la');
lambdaA=sort(diag(abs(eigvalueA)),'descend'); 

% Outputs
Tn=(lambdaA(k+1)-lambdaA(kmax+1))/(lambdaA(kmax+1)-lambdaA(kmax+2));
if Tn>=threva
    Size = 1;
else
    Size = 0;
end
    
end

