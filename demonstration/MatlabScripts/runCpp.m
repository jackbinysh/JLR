function [modularity] = runCpp(filename,communities)

if communities == 0
    
    cd ..
    cd ([pwd '\ComboCode'])
    if ispc
        modularity = system(['"COMBO.exe"' ' ' filename '.net']);
    elseif isunix
        modularity = system(['"./comboCPP" ' ' ' filename '.net']);
    end
    cd ..
    cd ([pwd '\MatlabScripts'])
    
else
    
    cd ..
    cd ([pwd '\ComboCode'])
    if ispc
        modularity = system(['"COMBO.exe"' ' ' filename '.net' ' ' num2str(communities)]);
    elseif isunix
        modularity = system(['"./comboCPP" ' ' ' filename '.net' ' ' num2str(communities)]);
    end
    cd ..
    cd ([pwd '\MatlabScripts'])
    
end

end