%note, for this to work
% 1) remove all the stuff before the messages begin, and all the 'val' stuff at the end,
%from the .dbc file you read in. It should just be a list of messages
%2) Make sure theres a whitespace between the last message and the end of
%the file - the last line should be whitespace
clear all;

%some input - put in the list of ECU's you want removed from the data
IgnoredECUs = {'JDS','CANalyzer'};
% put in the file path 
InputFile = fopen('/home/jackbinysh/Desktop/X250_IP7_CANHS_Diesel.Dbc');
% give the name of the output file
OutputFilename = 'X250_IP7_CANHS_Diesel.csv';

%%% BEGIN! %%%

text = textscan(InputFile,'%s','Delimiter','\n\n');
text = text{1};
% isolate each message
StartIndex = 1;
EndIndex = 1;
j=1;
for i=1:length(text)
    if (strcmp (text(i),'') == 1)
        EndIndex=i-1;
        Messages{j} = text(StartIndex:EndIndex);
        j=j+1;
        StartIndex= i+1;
    end
end
% okay we've got the message in a cell array. Now lets do some string
% formatting
EdgeList={};
for i = 1:length(Messages)
    m = Messages{i};
    FirstLine = strsplit(m{1});
    MessageID = FirstLine(2);
    SenderECU = FirstLine(end); %grab the sender ECU of the message
    for j = 2:length(m) % the remainder, these comprise list of recievers  
        Line = strsplit(m{j});
        y =regexp(Line,'"');
        y = cellfun(@isempty,y);
        y = max(find(y==0)); %find the last quotation mark
        RecieverECUs = Line(y+1:end); % grab the entries which are the reciever ECU's
        % filter out the commas
        RecieverECUs = strrep(RecieverECUs,',','');
        % now add these edges to the list
        for k = 1:length(RecieverECUs);
        EdgeList(end+1,1) = MessageID;
        EdgeList(end,2) = SenderECU;
        EdgeList(end,3) = RecieverECUs(k);
      end
    end
end

% okay, we have the cleaned up edge list. there are multi edges in it, and some ECU's we should ignore
%FOR NOW JUSTI IGNORE THE MESSAGE ID'S
EdgeList = EdgeList(:,2:3);
%lets convert multi edges in to weighted edges. Lets taek each signal as a
%unique message
[UniqueEdges,~,b] = uniqueRowsCA(EdgeList);
b = sort(b);
b= hist(b,max(b)); %get the frequencies of occurance
UniqueEdges(:,end+1)=num2cell(b);
clear b;


%okay now we have the weighted edge list. Lets clean it up, removing the
%nodes we are not interested in
for i=1:length(IgnoredECUs)
    IgnoredECU = IgnoredECUs{i};
    filter = strcmp(IgnoredECU,UniqueEdges(:,1:2));
    filter = ~(filter(:,1) | filter(:,2));
    UniqueEdges = UniqueEdges(filter,:);
end


% output the file in a csv format
OutputFileID = fopen(OutputFilename,'w');
formatSpec = '%s %s %i \n';
[nrows,ncols] = size(UniqueEdges);
for row = 1:nrows
    fprintf(OutputFileID,formatSpec,UniqueEdges{row,:});
end
fclose(OutputFileID);