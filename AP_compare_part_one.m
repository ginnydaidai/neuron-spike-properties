%---------Swtich off warning
% w = warning('query','last')
% id = w.identifier;
id = 'MATLAB:table:RowsAddedExistingVars';
warning('off',id);
id = 'MATLAB:table:RowsAddedNewVars';
warning('off',id);
id = 'signal:findpeaks:largeMinPeakHeight';
warning('off',id);
id = 'stats:clustering:evaluation:ClusterCriterion:RemoveTooBigK';
warning('off',id);
id = 'MATLAB:polyfit:RepeatedPointsOrRescale';
warning('off',id);

%% File name & raw data
clear all
filelist = dir('**/*.txt');
result = table;
for i = 1:length(filelist)
    if contains(filelist(i).name,'txt1')
        select(i) = 1;
    else
        select(i) = 0;
    end
end

filelist(find(select>0)) = [];
    

for i = 1:length(filelist)
    str = [filelist(i).folder '/' filelist(i).name];
    result(i,'file') = table({str});
    
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
    data = data(:,1:2:21);
    result.raw(i) = {data};
    
end

%% classification
for i = 1:height(result)

    str = result{i,'file'};
    if contains(str,'20180308 HipR 20180226 wt')
        result{i,'YFP'} = 0;
        result{i,'minus70'} = 1-double(contains(str,'step'));
        result{i,'left'} = 0;
        result{i,'day'} = 10;
        result{i,'currentstep'} = 20;
        result{i,'me'} =1;
    elseif contains(str,'20180309 HipL 20180226 wt')
        result{i,'YFP'} = 0;
        result{i,'minus70'} = 1-double(contains(str,'step'));
        result{i,'left'} = 1;
        result{i,'day'} = 11;
        result{i,'currentstep'} = 20;
        result{i,'me'} =1;
    elseif contains(str,'20180312 HipR 20180226')
        result{i,'YFP'} = 0;
        result{i,'minus70'} = 1-double(contains(str,'step'));
        result{i,'left'} = 0;
        result{i,'day'} = 14;
        result{i,'me'} = 1;
   elseif contains(str,'20180313 HipL 20180226')
        result{i,'YFP'} = 0;
        result{i,'minus70'} = 1-double(contains(str,'step'));
        result{i,'left'} = 1;
        result{i,'day'} = 15;
        result{i,'currentstep'} = 20;
        result{i,'me'} =1;
   elseif contains(str,'20180314 HipR 20180226')
        result{i,'YFP'} = 0;
        result{i,'minus70'} = 1-double(contains(str,'step'));
        result{i,'left'} = 0;
        result{i,'day'} = 16;
        result{i,'currentstep'} = 20;
        result{i,'me'} =1;
   elseif contains(str,'20180306 HipL 20180226 wt')
        result{i,'YFP'} = 0;
        result{i,'minus70'} = 1-double(contains(str,'step'));
        result{i,'left'} = 1;
        result{i,'day'} = 8;
        result{i,'currentstep'} = 20;
        result{i,'me'} =1;
    elseif contains(str,'20180301 HipR 20180118 c57')
        result{i,'YFP'}  = 0;
        result{i,'minus70'} = 1-double(contains(str,'step'));
        result{i,'left'} = 0; 
        result{i,'day'} = 41;
        result{i,'currentstep'} = 20;
        result{i,'me'} =1;
    elseif contains(str,'20180302 HipR 20180118 c57')
        result{i,'YFP'}  = 0;
        result{i,'minus70'} = 1-double(contains(str,'step'));
        result{i,'left'} = 0;
        result{i,'day'} = 42;
        result{i,'currentstep'} = 20;
        result{i,'me'} =1;
    elseif contains(str,'nr10 8-8-2017 9 days old hip L')
        result.YFP(i) = double(contains(str,'YFPpos'));
        result.minus70(i) = double(contains(str,'-70'));
        result.left(i) = 1;
        result.day(i) = 9;
        result.currentstep(i) = 10;
        result{i,'me'} =0;
    elseif contains(str,'nr10 8-8-2017 9 days old hip R')
        result.YFP(i) = double(contains(str,'YFPpos'));
        result.minus70(i) = double(contains(str,'-70'));
        result.left(i) = 0;
        result.day(i) = 9;
        result.currentstep(i) = 10;
        result{i,'me'} =0;
    elseif contains(str,'nr10 8-8-2017 14 days old hip L')
        result.YFP(i) = double(contains(str,'YFPpos'));
        result.minus70(i) = double(contains(str,'-70'));
        result.left(i) = 1;
        result.day(i) = 14;
        result.currentstep(i) = 10;
        result{i,'me'} =0;
    elseif contains(str,'nr10 8-8-2017 15 days old hip L')
        result.YFP(i) = double(contains(str,'YFPpos'));
        result.minus70(i) = double(contains(str,'-70'));
        result.left(i) = 1;
        result.day(i) = 15;
        result.currentstep(i) = 10; 
        result{i,'me'} =0;
     elseif contains(str,'nr10 8-8-2017 17 days old hip L')
        result.YFP(i) = double(contains(str,'YFPpos'));
        result.minus70(i) = double(contains(str,'-70'));
        result.left(i) = 1;
        result.day(i) = 9;
        result.currentstep(i) = 10; 
        result{i,'me'} =0;
    elseif contains(str,'culture16') && contains(str,'YFPneg_HipL_Vm')
        result.YFP(i) = 0;
        result.minus70(i) = double(contains(str,'-70'));
        result.left(i) = 1;
        result.day(i) = 10;
        result.currentstep(i) = 20; 
        result{i,'me'} =0;
    elseif contains(str,'culture16') && contains(str,'YFPneg_HipR_Vm')
        result.YFP(i) = 0;
        result.minus70(i) = double(contains(str,'-70'));
        result.left(i) = 0;
        result.day(i) = 10;
        result.currentstep(i) = 20; 
                result{i,'me'} =0;
    elseif contains(str,'culture16') && contains(str,'YFPpos_HipR_Vm')
        result.YFP(i) = 1;
        result.minus70(i) = double(contains(str,'-70'));
        result.left(i) = 0;
        result.day(i) = 10;
        result.currentstep(i) = 20; 
                result{i,'me'} =0;
    elseif contains(str,'culture16') && contains(str,'YFPpos_HipL_Vm')
        result.YFP(i) = 1;
        result.minus70(i) = double(contains(str,'-70'));
        result.left(i) = 1;
        result.day(i) = 10;
        result.currentstep(i) = 20; 
           result{i,'me'} =0;
    elseif  contains(str,'culture19') 
                result{i,'me'} =0;
        result.YFP(i) = double(contains(str,'YFPpos'));
        result.minus70(i) = double(contains(str,'-70'));
        result.left(i) = double(contains(str,'HipL'));
        result.day(i) = 8;
        result.currentstep(i) = 20;
          result{i,'me'} =0;
    else
        result.select(i) = 1;
        
    end
    if contains(str,'cell3_hipL_YFPneg_15days_step_20_Vm')
       result.currentstep(i) = 20;
    end
end

% result(result.select == 1,:) = [];
% result.select = [];iles
for i  = 1:height(result)
%% Calculate baseline + delete unstable f
        data = result.raw(i);
        data = data{:};
        zerocurrent = data(2000:6000,1);
        if std(zerocurrent(:))> 0.003
            result{i,'select'}= 1;
        else 
            result{i,'select'} = 0;
        end
        result.baseline_std(i) = std(zerocurrent(:));
        result.baseline(i) = mean(zerocurrent(:));
end
result(result.select == 1,:) = [];
result.select = [];
% save('AP_data.mat','result');
