function [ data ] = GenerateData( N, k, maxk, mu  )

flagstring = ['-N' ' ' num2str(N) ' ' '-k' ' ' num2str(k) ' ' '-maxk' ' ' num2str(maxk) ' ' '-mu' ' ' num2str(mu)];
% system call to generate file
status = system(['./benchmark' ' ' flagstring]);
%load the edge list
data = load('network.dat');
end

