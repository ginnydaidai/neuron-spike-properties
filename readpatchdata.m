function [text,data] = readpatchdata(str)

    fileID = fopen(str,'r');
    
    N = 22;
    formatSpec = '';
    for j = 1:N
        formatSpec = [formatSpec '%s'];
    end
    
    text = textscan(fileID,[formatSpec '\n']);
    
    formatSpec = '';
    for j = 1:N
        formatSpec = [formatSpec '%f'];
    end
    data = textscan(fileID,formatSpec);
    
    data = cell2mat(data);
end
