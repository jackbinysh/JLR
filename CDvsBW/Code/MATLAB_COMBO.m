clear 
close all
clc

%% construct a synthetic matrix using the LFR benchmark
%input parameters

NumNodes = 30;
AvgK = 5;
MaxK = 7; 
Mu = 0.15;

EdgeList = GenerateData(NumNodes, AvgK, MaxK , Mu);
EdgeList(:,3) = 1;
AdjMatrix = edgeL2adj(EdgeList);

%run the combo code on it
[communities modularity] = RunCommunityDetection(EdgeList, 'edge');

% some bookkeeping - make a vector of nodes labelled by communities,
% and sort it
communities(:,2) = communities;
communities (:,1) = 1:length(communities);
[SortedCommunities(:,2) SortedCommunities(:,1)]  = sort(communities(:,2));

% the permutation suggested by this sorting of the communities
CDPermutation = SortedCommunities(:,1);

% permute into the blocks of communites found
TempAdjMatrix = AdjMatrix(CDPermutation,CDPermutation);


% within the groups found in the detection, apply cuthill mckee to permute
for i=2:length(SortedCommunities(:,2))
    divisions(i) = (SortedCommunities(i,2) ~= SortedCommunities(i-1,2));
end
divisions = find(divisions);
divisions = [1 divisions];

Permutation = 1:length(TempAdjMatrix);
for i = 1:length(divisions)-1;
    lowerbound = divisions(i);
    upperbound = divisions(i+1)-1;
    partialpermutation = symrcm(TempAdjMatrix(lowerbound:upperbound,lowerbound:upperbound));
    partialpermutation = partialpermutation + lowerbound -1;
    Permutation(lowerbound:upperbound) = partialpermutation;
end
CDPermutation = CDPermutation(Permutation');

% run the reverse cuthill mckee on the matrix, and get its suggested
% permutation(Permutation,Permutation)
BWPermutation = symrcm(AdjMatrix);

% generate heatmaps for each of these matrices to compare
%imagesc(AdjMatrix(permutation,permutation));

%% export the data to gephi, with the node labellings.

% export CD
col_header = {'Id','Label','node-type'};
[~, InverseCDPermutation] = sort(CDPermutation);
data = [1:NumNodes]' ; data(:,end+1) = [1:NumNodes]';data(:,end+1) = InverseCDPermutation';

filename = [ 'Output_for_Gephi_CD' '.csv'];  
fileID = fopen (filename,'w');

fprintf(fileID,'%s,%s,%s\n',col_header{1,:});
for row = 1:length(data)
    fprintf(fileID,'%d,%d,%d\n',data(row,:));
end
fclose(fileID);


% export BW
col_header = {'Id','Label','node-type'};
[~, InverseBWPermutation] = sort(BWPermutation);
data = [1:NumNodes]' ; data(:,end+1) = [1:NumNodes]';data(:,end+1) = InverseBWPermutation';

filename = [ 'Output_for_Gephi_BW' '.csv'];  
fileID = fopen (filename,'w');

fprintf(fileID,'%s,%s,%s\n',col_header{1,:});
for row = 1:length(data)
    fprintf(fileID,'%d,%d,%d\n',data(row,:));
end
fclose(fileID);

% export edge list
col_header = {'Source','Target','Type'};
data = num2cell(EdgeList(:,[1 2]));
data(:,end+1) =repmat({'undirected'},length(data),1);

filename = [ 'Output_for_Gephi_Edge_List' '.csv'];  
fileID = fopen (filename,'w');

fprintf(fileID,'%s,%s,%s\n',col_header{1,:});
for row = 1:length(data)
    fprintf(fileID,'%d,%d,%s\n',data{row,:});
end
fclose(fileID);

subplot(1,3,1);
imagesc(AdjMatrix);
subplot(1,3,2);
imagesc(AdjMatrix(CDPermutation,CDPermutation));
subplot(1,3,3);
imagesc(AdjMatrix(BWPermutation,BWPermutation));

