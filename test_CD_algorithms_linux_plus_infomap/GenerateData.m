function [ data ] = GenerateData(choice, N, k, maxk, mut, muw, minc, maxc, t1, t2)

% switch choice
%     case 1 % undirected and unweighted
%         flagstring = ['-N' ' ' num2str(N) ' ' '-k' ' ' num2str(k) ' ' '-maxk' ' ' num2str(maxk) ' ' '-mu' ' ' num2str(mut) ' ' '-minc' ' ' num2str(minc) ' ' '-maxc' ' ' num2str(maxc) ' ' '-t1' ' ' num2str(t1) ' ' '-t2' ' ' num2str(t2)];
%         % system call to generate file
%         [~]= system(['benchm_undirected_unweighted.exe' ' ' flagstring ' ' '> infoLFR.txt']);
%         
%     case 2 % undirected and weighted
%         flagstring = ['-N' ' ' num2str(N) ' ' '-k' ' ' num2str(k) ' ' '-maxk' ' ' num2str(maxk) ' ' '-mut' ' ' num2str(mut) ' ' '-muw' ' ' num2str(muw) ' ' '-minc' ' ' num2str(minc) ' ' '-maxc' ' ' num2str(maxc) ' ' '-t1' ' ' num2str(t1) ' ' '-t2' ' ' num2str(t2)];
%         % system call to generate file
%         [~]= system(['benchm_undirected_weighted.exe' ' ' flagstring ' ' '> infoLFR.txt']);
%         
%     case 3
%         % directed and weighted
%         flagstring = ['-N' ' ' num2str(N) ' ' '-k' ' ' num2str(k) ' ' '-maxk' ' ' num2str(maxk) ' ' '-mut' ' ' num2str(mut) ' ' '-muw' ' ' num2str(muw) ' ' '-minc' ' ' num2str(minc) ' ' '-maxc' ' ' num2str(maxc) ' ' '-t1' ' ' num2str(t1) ' ' '-t2' ' ' num2str(t2)];
%         % system call to generate file
%         [~]= system(['benchm_directed_weighted.exe' ' ' flagstring ' ' '> infoLFR.txt']);
%     otherwise
%         error('check your case')
% end

switch choice
    case 1 % undirected and unweighted
        flagstring = ['-N' ' ' num2str(N) ' ' '-k' ' ' num2str(k) ' ' '-maxk' ' ' num2str(maxk) ' ' '-mu' ' ' num2str(mut) ' ' '-minc' ' ' num2str(minc) ' ' '-maxc' ' ' num2str(maxc) ' ' '-t1' ' ' num2str(t1) ' ' '-t2' ' ' num2str(t2)];
        % system call to generate file
        [~]= system(['./benchm_undirected_unweighted_linux' ' ' flagstring ' ' '> infoLFR.txt']);
        
    case 2 % undirected and weighted
        flagstring = ['-N' ' ' num2str(N) ' ' '-k' ' ' num2str(k) ' ' '-maxk' ' ' num2str(maxk) ' ' '-mut' ' ' num2str(mut) ' ' '-muw' ' ' num2str(muw) ' ' '-minc' ' ' num2str(minc) ' ' '-maxc' ' ' num2str(maxc) ' ' '-t1' ' ' num2str(t1) ' ' '-t2' ' ' num2str(t2)];
        % system call to generate file
        [~]= system(['./benchm_undirected_weighted_linux' ' ' flagstring ' ' '> infoLFR.txt']);
        
    case 3
        % directed and weighted
        flagstring = ['-N' ' ' num2str(N) ' ' '-k' ' ' num2str(k) ' ' '-maxk' ' ' num2str(maxk) ' ' '-mut' ' ' num2str(mut) ' ' '-muw' ' ' num2str(muw) ' ' '-minc' ' ' num2str(minc) ' ' '-maxc' ' ' num2str(maxc) ' ' '-t1' ' ' num2str(t1) ' ' '-t2' ' ' num2str(t2)];
        % system call to generate file
        [~]= system(['./benchm_directed_weighted_linux' ' ' flagstring ' ' '> infoLFR.txt']);
    otherwise
        error('check your case')
end

%load the edge list
data = load('network.dat');
end

