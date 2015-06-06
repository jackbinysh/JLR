function [communities modularity] = RunCommunityDetection( data, mode )

% Transform it to an edje list if we've put in an adjacency matrix
if strcmp(mode,'adj') 
    edje_list = adj2edgeL(data);
elseif strcmp(mode,'edge')
    edje_list = data;
    edje_list(:,3) = 1 ;
end

edgeL2pajek(edje_list, 'comboinput.net');
% system call to the combo executable

[~] = system(['./comboCPP' ' ' 'comboinput.net > modularity.txt']);

% grab the modularity from the the file
modularity = load('modularity.txt');
    
% grab the full list of communities
communities = load('comboinput_comm_comboC++.txt');
end

