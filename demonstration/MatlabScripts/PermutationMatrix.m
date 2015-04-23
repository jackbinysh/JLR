function [ PMatrix ] = PermutationMatrix( PVector )

    n = length(PVector);
    PMatrix = zeros(n);
    
    for i=1:n
        PMatrix(i,PVector(i)) = 1;
end

