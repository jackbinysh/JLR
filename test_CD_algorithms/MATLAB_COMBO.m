clear

tic;

format LONGE

iter = 0;
h = waitbar(0,'Please wait...');

for choice = 1:3
    
    close all
    clc
    
    %% construct a synthetic matrix using the LFR benchmark
    %input parameters
    
    NumNodes = 1000;
    AvgK = 20;
    MaxK = 50;
    MuW = 0.5;
    t1 = 2;
    t2 = 1;
    minc = 10;
    maxc = 50;
    
    MuT = 0:0.1:1;
    
    runs = 5;
    
    maxiter = 3 * length(MuT);
    
    vcombo = zeros(length(MuT),runs);
    vlouvain = zeros(length(MuT),runs);
    
    for i = 1:length(MuT)
        
        for j = 1:runs
            
            if exist('network.dat', 'file')==2
                delete('network.dat');
                delete('statistics.dat');
                delete('community.dat');
            end
            
            EdgeList = GenerateData(choice,NumNodes, AvgK, MaxK , MuT(i), MuW, minc, maxc, t1, t2); %, MuW, t1, t2
            
            
            switch choice
                case 1 % undirected & unweighted
                    EdgeList(:,3) = 1;
                    AdjMatrix = edgeL2adj(EdgeList);
                case 2 % undirected & weighted
                    edge_indexes = EdgeList(:, 1:2);
                    n_edges = max(edge_indexes(:));
                    AdjMatrix = zeros(n_edges);
                    for local_edge = EdgeList' %transpose in order to iterate by edge
                        AdjMatrix(local_edge(1), local_edge(2)) = local_edge(3);
                    end
                case 3 % directed & weighted
                    edge_indexes = EdgeList(:, 1:2);
                    n_edges = max(edge_indexes(:));
                    AdjMatrix = zeros(n_edges);
                    for local_edge = EdgeList' %transpose in order to iterate by edge
                        AdjMatrix(local_edge(1), local_edge(2)) = local_edge(3);
                    end
                otherwise
                    error('check your case')
            end
            
            tmpLFR = load('community.dat');
            communitiesLFR = tmpLFR(:,2);
            
            %run the combo code on it
            [communitiesCombo, modularity] = RunCommunityDetection(EdgeList, 'edge');
            vcombo(i,j)  = nmi(communitiesCombo+1, communitiesLFR);
            
            [communitylouvain, Q] = louvain(AdjMatrix);
            vlouvain(i,j)  = nmi(communitylouvain, communitiesLFR);
            
            
        end
        
        iter = iter + (choice * i)/length(MuT);
        waitbar(iter / maxiter);
        
    end
    
    
        plot(MuT,mean(vcombo,2),'-*r')
    
        hold on
    
        grid on
    
        plot(MuT,mean(vlouvain,2),'-*g')
    
        legend('Combo' , 'Louvain');
    
        ylabel('NMI');
        xlabel('MuT (topological)');
    
        hold off
    
        switch choice
            case 1
                title('unweighted & undirected')
                hold off
                export_fig('Fig_unweighted_undirected','-nocrop','-pdf')
                save unweighted_undirected.mat
            case 2
                title('weighted & undirected')
                hold off
                export_fig('Fig_weighted_undirected','-nocrop','-pdf')
                save weighted_undirected.mat
            case 3
                title('weighted & directed')
                hold off
                export_fig('Fig_weighted_directed','-nocrop','-pdf')
                save weighted_directed.mat
            otherwise
                hold off
                error('check your case')
        end
    
end % end choice

close(h)

time_elapsed = toc;