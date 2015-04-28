clear 
close all
clc

% load in adjacency matrix FOR NOW JUST MAKE A RANDOM ONE

%data = load(file);
data = rand(50)>0.9;

%run the combo code on it
[communities modularity] = RunCombo(data);
communities(:,2) = communities;
communities (:,1) = 1:length(communities);

% run the reverse cuthill mckee on it
Permutation = symrcm(data);





