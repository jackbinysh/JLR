function [modularity] = runCpp(filename,communities)

if communities == 0
    
    
    cd ..
    cd ([pwd '\ComboCode'])
    if ispc
        modularity = system([fileparts(pwd) filesep 'ComboCode' filesep '"COMBO.exe"' ' ' filename '.net > modularity.txt']);
    elseif isunix
        modularity = system([fileparts(pwd) filesep 'ComboCode' ' ' './comboCPP' ' ' filename '.net > modularity.txt']);
    end
    cd ..
    cd ([pwd '\MatlabScripts'])
    
    
else
    cd ..
    cd ([pwd '\ComboCode'])
    if ispc
        modularity = system([fileparts(pwd) filesep 'ComboCode' filesep '"COMBO.exe"' ' ' filename '.net' ' ' num2str(communities) ' > modularity.txt']);
    elseif isunix
        modularity = system([fileparts(pwd) filesep 'ComboCode' ' '  './comboCPP' ' ' filename '.net' ' ' num2str(communities) ' > modularity.txt' ]);
    end
    cd ..
    cd ([pwd '\MatlabScripts'])
    
end

end