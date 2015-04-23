clear
clc
close all

filename = 'smallnetwork_adj'; % Insert the txt file's name

% IN ADJACENCY MATRIX FORMAT
data = load(sprintf([filename '.txt']));

% Transform it to andat edje list
edje_list = adj2edgeL(data);

%% ***********************************************
% IF IN EDJE LIST FORMAT
% data = load(sprintf([filename '.txt']));
%
% % The file is of the format:
% % V1 | V2 | (weight)connection
% adjlist = data(:,1:2);
% weight = data(:,3);
% 
% % Initialise an adjacency matrix
% adj=zeros(max(max(adjlist)));
% 
% % Create the adjacency matrix from the data
% for i=1:length(adjlist)
%     adj(adjlist(i,1),adjlist(i,2)) = 1;
% end
% %***********************************************
%%
% Extract the edge list into pajek format in order
% to be handled by the COMBO algorithm
edgeL2pajek(edje_list, sprintf([filename '.net']));

%% Running the C++ executable
disp('The modularity is');
if ispc
    modularity = system(['"COMBO.exe"' ' ' filename '.net']);
elseif isunix
    modularity = system(['"./comboCPP" ' ' ' filename '.net']); 
end
%% Insert the output of the Combo algorithm

comm = load(sprintf([filename '_comm_comboC++.txt']));

%% Pair the communities found to the nodes

new_node_list = zeros(length(comm),3);

for i = 1:length(comm)
    new_node_list(i,1:3) = [i i comm(i)];
end

%% Output to xls file with headers  

if exist([filename '.csv']) ~= 0
    %     temp_n = exist([filename '.csv']);
    %     filename_temp = [filename num2str(temp_n)];
    % else
    %     filename_temp = [filename];
    
    delete([filename '.csv']);
end
    
col_header = {'ID','Label','Node_type'};
xlswrite([filename '.csv'],new_node_list,'Sheet1','A2');     %Write data
xlswrite([filename '.csv'],col_header,'Sheet1','A1');     %Write column header


%% Unscramble the adjacency matrix (Jacks way)
% get the permutation vector
[~,PVector] = sort(comm);
% get the permutation matrix from this vector
PMatrix = PermutationMatrix(PVector);
% apply it to our initial adjacency matrix to unscramble it
outputdata = PMatrix*data*PMatrix';

%TODO write piece of code which orders the nodes ascendingly within a community 




