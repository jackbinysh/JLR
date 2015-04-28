function [communities modularity] = RunCombo( data )

% Transform it to an edje list
edje_list = adj2edgeL(data);
%
edgeL2pajek(edje_list, 'comboinput.net');
% system call to the combo executable
[~] = system(['./comboCPP'  ' ' 'comboinput.net > modularity.txt']);

% grab the modularity from the the file
modularity = load('modularity.txt');
    
% grab the full list of communities
communities = load('comboinput_comm_comboC++.txt');
end

