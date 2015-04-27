function [modularity] = runCpp(filename,communities)

if communities == 0
    
    
%     cd ..
%     cd ([pwd '\ComboCode'])
    if ispc
        modularity = system([fileparts(pwd) filesep 'ComboCode' filesep 'COMBO.exe' ' ' '..' filesep 'ComboCode' filesep filename '.net > modularity.txt']);
    elseif isunix
        modularity = system(['cd' ' ' fileparts(pwd) filesep 'ComboCode' '; ' './comboCPP' ' ' '..' filesep 'ComboCode' filesep filename '.net > ../MatlabScripts/modularity.txt']);
    end
%     cd ..
%     cd ([pwd '\MatlabScripts'])
    
    
else
    if ispc
        modularity = system([fileparts(pwd) filesep 'ComboCode' filesep '"COMBO.exe"' ' ' '..' filesep 'ComboCode' filesep filename '.net' ' ' num2str(communities) ' > modularity.txt']);
    elseif isunix
        modularity = system(['cd' ' ' fileparts(pwd) filesep 'ComboCode' '; '  './comboCPP' ' ' '..' filesep 'ComboCode' filesep filename '.net' ' ' num2str(communities) ' > ../MatlabScripts/modularity.txt']);
    end
    
end

end