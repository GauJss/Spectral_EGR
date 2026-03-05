function output = Generating(n,k,B,omega) 

 % Generates an adjacency matrix for a network with k communities.
    % Inputs:
    %   n      - Number of nodes in the network
    %   k      - True number of communities
    %   B      - Community connection probability matrix
    %   omega  - Node degree parameters
    %
    % Output:
    %   output - Generated adjacency matrix A

%Initialize the adjacency matrix as zeros
A=zeros(n,n); nk=n/k; 

% Loop over pairs of nodes to assign edge probabilities
for i=1:n
    i1=ceil(i/nk);
    for j=1:i
        j1=ceil(j/nk);
        A(i,j)=binornd(1,omega(i)*B(i1,j1)*omega(j)); 
    end
end

% Ensure the adjacency matrix is symmetric
for i=2:n
    for j=1:i-1
        A(j,i)=A(i,j);
    end
end

% Remove self-loops by setting diagonal entries to zero
A=A+diag(-diag(A));

output=A;

