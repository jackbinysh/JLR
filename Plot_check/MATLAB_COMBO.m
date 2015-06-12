clear
format LONGE
%initialising parameters to put in the LFR benchmark generator
NumNodes = 1000;
AvgK = 20;
MaxK = 50;
MuW = 0.5;
t1 = 2;
t2 = 1;
minc = 10;
maxc = 50;
%varying the topological mixing parameter    
MuT = 0:0.05:1;

runs = 1;
vcombo = zeros(length(MuT),1); %initialising vectors that will contain nmi
vlouvain = zeros(length(MuT),1);
for i = 1:length(MuT)
    %if previous .dat files present delete
    if exist('network.dat', 'file')==2
        delete('network.dat');
        delete('statistics.dat');
        delete('community.dat');
    end
    i %see the point the iteration is at
    EdgeList = GenerateData(NumNodes, AvgK, MaxK , MuT(i), MuW, minc, maxc, t1, t2); %, MuW, t1, t2
    EdgeList(:,3) = 1;
    AdjMatrix = edgeL2adj(EdgeList); %convert edge list to an adjacency matrix
    tmpLFR = load('community.dat'); %load LFR community labellings
    communitiesLFR = tmpLFR(:,2);
    [communitiesCombo, modularity] = RunCommunityDetection(EdgeList, 'edge');
    vcombo(i,1)  = nmi(communitiesCombo+1, communitiesLFR); %stores nmi for combo communities and current MuT current MuT
    [communitylouvain, Q] = louvain(AdjMatrix); %feed Adjacency matrix into louvain
    vlouvain(i,1)  = nmi(communitylouvain, communitiesLFR); %stores nmi for louvain communities and current MuT
end
figure
plot(MuT,mean(vcombo,2),'-r*')
hold on
plot(MuT,mean(vlouvain,2),'-*g')
hold off