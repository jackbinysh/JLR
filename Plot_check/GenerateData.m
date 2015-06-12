function [ data ] = GenerateData(N, k, maxk, mut, muw, minc, maxc, t1, t2)

flagstring = ['-N' ' ' num2str(N) ' ' '-k' ' ' num2str(k) ' ' '-maxk' ' ' num2str(maxk) ' ' '-mu' ' ' num2str(mut) ' ' '-minc' ' ' num2str(minc) ' ' '-maxc' ' ' num2str(maxc) ' ' '-t1' ' ' num2str(t1) ' ' '-t2' ' ' num2str(t2)];
% system call to generate file
[~]= system(['benchm_undirected_unweighted.exe' ' ' flagstring ' ' '> infoLFR.txt']);

data = load('network.dat');
end

