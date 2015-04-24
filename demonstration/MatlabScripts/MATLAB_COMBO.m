clear
clc
close all

% Insert the name of the file e.g. smallnetwork_adj   
%filename = input('Insert the name of the file without the file type (e.g. example) : ','s'); % Insert the txt file's name

uiwait(msgbox('Browse to your file'));

[FileName,PathName] = uigetfile('*.txt','Select the input file of .txt format');
[filename tmp] = strread(FileName, '%s %s', 'delimiter','.');
filename = char(filename); 

% IN ADJACENCY MATRIX FORMAT

tmppwd = pwd;
file = fullfile([PathName sprintf(FileName)]);
data = load(file);

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
movefile(sprintf([filename '.net']),[fileparts(pwd) '\ComboCode'])

%% Running the C++ executable
flag = 'run';
communities = 0;

while flag == 'run'
    
    disp('The modularity is');
    
    modularity = runCpp(filename,communities);
    
    % Insert the output of the Combo algorithm
    
    file = fullfile([fileparts(pwd) '\ComboCode\' sprintf(filename) '_comm_comboC++.txt']);
    comm = load(file);
    
    
    disp(' ')
    disp(['The Combo algorithm has detected ' num2str(length(unique(comm))) ' communities'] )
    disp(' ')
    disp('Do you want to run Combo for less communities? If yes type the number, else type zero.')
    disp(' ')
    flag = input('Type your choice ');
    
    
    %%%%%%% TO DO in btter way
    if communities == 0
    maxcomm = length(unique(comm));
    end
    
    if length(unique(comm)) > maxcomm
        maxcomm = length(unique(comm)) 
    end
    %%%%%%%%%%
    
    if flag > 0 & flag <= maxcomm
        communities = flag;
        flag = 'run';
    elseif flag == 0
        flag = 0;
    else
        error('You can not have a negative number of communities or more than initially found')
    end
    
end


%% Pair the communities found to the nodes

new_node_list = zeros(length(comm),3);

for i = 1:length(comm)
    new_node_list(i,1:3) = [i i comm(i)];
end

%% Output to xls file with headers


mkdir( [fileparts(pwd)], '\Output_for_Gephi')

if exist([ fileparts(pwd) '\Output_for_Gephi' filename '.csv']) ~= 0
    %     temp_n = exist([filename '.csv']);
    %     filename_temp = [filename num2str(temp_n)];
    % else
    %     filename_temp = [filename];
    
    delete([fileparts(pwd) '\Output_for_Gephi' filename '.csv']);
end

col_header = {'ID','Label','Node_type'};
xlswrite([[fileparts(pwd) '\Output_for_Gephi\'] filename '.csv'],new_node_list,'Sheet1','A2');     %Write data
xlswrite([[fileparts(pwd) '\Output_for_Gephi\'] filename '.csv'],col_header,'Sheet1','A1');     %Write column header




%% Unscramble the adjacency matrix containing the original data

% A test to verify that the following method works even with 
% weighted directed matrices can be performed as follows:
% 
% A = [0 2 1 0 0 0; 0 0 1 0 0 0; 0 3 0 1 0 0; 0 0 0 0 1 1; 0 0 0 2 0 2; 0 0 0 0 0 0 ];
% % Seed for the shuffling 
% v = [4 6 5 2 1 3];
% % Creating a permutation matrix acording to v
% P = PermutationMatrix(v);
% % Shuffling the data in with the permutation matrix
% K = P*A*P';
% % Obtaing the correct order (Unshuffling) using the Sparse reverse Cuthill-McKee ordering 
% k = symrcm(K);
% sorted_data = K(k,:);
% sorted_data = sorted_data(:,k)

% Obtaing the correct order (unshuffling) using the Sparse reverse Cuthill-McKee ordering 


order = symrcm(data);
sorted_data = data(order,:);
sorted_data = sorted_data(:,order);

mkdir( [fileparts(pwd)], '\Sorted_Adj_Output')
if exist([ fileparts(pwd) '\Sorted_Adj_Output' filename '_sorted_matrix.txt']) ~= 0   
    delete([fileparts(pwd) '\Sorted_Adj_Output' filename '_sorted_matrix.txt']);
end

dlmwrite([fileparts(pwd) '\Sorted_Adj_Output' filename '_sorted_matrix.txt'],sorted_data)









