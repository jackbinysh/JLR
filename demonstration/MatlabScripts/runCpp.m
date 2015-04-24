function [modularity] = runCpp(filename,communities,fileseperator)

if communities == 0
    
    if ispc
        modularity = system([fileparts(pwd) fileseperator 'ComboCode' fileseperator '"COMBO.exe"' ' ' filename '.net']);
    elseif isunix
        modularity = system([fileparts(pwd) fileseperator 'ComboCode' '"./comboCPP" ' ' ' filename '.net']);
    end
    
else

    if ispc
        modularity = system([fileparts(pwd) fileseperator 'ComboCode' fileseperator '"COMBO.exe"' ' ' filename '.net' ' ' num2str(communities)]);
    elseif isunix
        modularity = system([fileparts(pwd) fileseperator 'ComboCode' '"./comboCPP" ' ' ' filename '.net' ' ' num2str(communities)]);
    end
   
end

end