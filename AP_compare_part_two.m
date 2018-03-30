%% Loop through filelist
% ---------filter design
nfilt = 200;  % filter order
fstop = 800;  % stop frequency
fs = 8000;    % sampling rate
d = designfilt('lowpassfir','FilterOrder',nfilt, ...
              'CutoffFrequency',fstop,'SampleRate',fs);
% --------select a file
for fileind = 1:height(result)
    
    clf;
    fig = figure('Visible','off');
%     fig = figure;
    title(num2str(fileind));
    datamat = result.raw(fileind); datamat = datamat{:};
    
    % Spike calculation
    spike = table();
    for j = 1:11
        trace = datamat(:,j);
        x = filter(d,trace);
        delay = mean(grpdelay(d));
        x(1:delay) = [];
        
        dx = gradient(x);
        ddx = gradient(dx);
        dddx = gradient(ddx);
        
        % peak location, peak Height
        [pk,pkloc] = findpeaks(trace(400:6800),'MinPeakProminence',0.015,'MinPeakDistance',0.003*fs,'MinPeakHeight',-0.008);
        pkloc = pkloc+400-1;
        
        if isempty(pk)
            startloc = []; start =[];
            hploc = []; hp = [];
            spike(j,{'numofspike','pkloc','pk','startloc','start','hploc','hp',...
                'halfwidth','halfwidthstd','indrise','inddown','Height','Heightstd',...
                'ISIratio','ISIstd','ISI','HP','HPstd','Hslope','Hslope_c','Hslope_i','Hslope_c_num'}) = {[0] [] [] [] [] [] [] [0] [0] [] [] [0] [0] [0] [0] [0] [0] [0] [1] [1] [1] [0]};
        else
            % Loop through each peak
            start = zeros(size(pkloc));
            startloc = zeros(size(pkloc));
            hploc = zeros(size(pkloc));
            hp = zeros(size(pkloc));
            for i = 1:length(pkloc)
                % Seeking start point
                
                if i == 1
                    tempdx = dx(max(400,pkloc(i)-0.04*fs):pkloc(i));
                    tempdddx = dddx(max(400,pkloc(i)-0.04*fs):pkloc(i));
                else
                    tempdx = dx(max(hploc(i-1),pkloc(i)-0.04*fs):pkloc(i));
                    tempdddx = dddx(max(hploc(i-1),pkloc(i)-0.04*fs):pkloc(i));
                end
                
                [dxmax,dxmaxloc] = findpeaks(tempdx,'MinPeakProminence',0.0001);
                dxmaxloc = dxmaxloc(end);
                tempdddx = tempdddx(1:dxmaxloc);
                
                pks = max(tempdddx);
                locs = find(tempdddx == pks);
                if i == 1
                    startloc(i) = max(400,pkloc(i)-0.04*fs)+locs;
                else
                    startloc(i) = locs+max(hploc(i-1),pkloc(i)-0.04*fs);
                end
                start(i) = trace(startloc(i));
                
                % Seeking hyperpolarization point
                if i < length(pk)
                    temp = trace(pkloc(i)+10:min(pkloc(i+1),pkloc(i)+0.15*fs));
                    tempdx = dx(pkloc(i)+10:min(pkloc(i+1),pkloc(i)+0.15*fs));
                else
                    temp = trace(pkloc(i)+10:pkloc(i)+0.15*fs);
                    tempdx = dx(pkloc(i)+10:pkloc(i)+0.15*fs);
                end
                
                [~,locs] = findpeaks(-temp,'MinPeakProminence',0.001);
                if isempty(locs)
                    tempdx(tempdx>0) = [];
                    pks = max(tempdx);
                    locs = find(tempdx == pks);
                end
                
                hploc(i) = locs(1)+pkloc(i)+10;
                hp(i) = x(hploc(i));
            end
            
            % Check parameters found for each trace as a whole
            if startloc(1)<= 400%600
                pk = pk(2:end);
                pkloc = pkloc(2:end);
                startloc = startloc(2:end);
                start = start(2:end);
                hp = hp(2:end);
                hploc = hploc(2:end);
            end
            if (~isempty(hploc)) && (hploc(end) >6800)
                hploc = hploc(1:end-1);
                hp = hp(1:end-1);
                startloc = startloc(1:end-1);
                start = start(1:end-1);
                pk = pk(1:end-1);
                pkloc = pkloc(1:end-1);
            end
            
            if isempty(pk)
                startloc = []; start =[];
                hploc = []; hp = [];
                spike(j,{'numofspike','pkloc','pk','startloc','start','hploc','hp',...
                    'halfwidth','halfwidthstd','indrise','inddown','Height','Heightstd',...
                    'ISIratio','ISIstd','ISI','HP','HPstd','Hslope','Hslope_c','Hslope_i','Hslope_c_num'}) = {[0] [] [] [] [] [] [] [0] [0] [] [] [0] [0] [0] [0] [0] [0] [0] [1] [1] [1] [0]};
            else
                % Continue to calculate half width
                indrise = [];
                inddown = [];
                Height = pk-start;
                half_Height = 0.5*Height+start;
                for i = 1:length(pkloc)
                    temp = trace-half_Height(i);
                    temp = temp(startloc(i):hploc(i));
                    temp(temp>0) = 1;
                    temp(temp<0) = 0;
                    find(diff(temp)==1,1,'last');
                    indrise(i) = find(diff(temp)==1,1,'last') + startloc(i);
                    inddown(i) = find(diff(temp)==-1,1,'last')+ startloc(i);
                end
                
                % Record everything for this file
                spike(j,'pkloc') = {{floor(pkloc)}};
                spike(j,'pk') = {{trace(round(pkloc))}};
                
                spike(j,'startloc') = {{startloc}};
                spike(j,'start') = {{start}};
                
                spike(j,'hploc')= {{hploc}};
                spike(j,'hp') = {{hp}};
                
                spike(j,'numofspike') = {length(pk)};
                
                spike(j,'HP') = {mean(hp)};
                spike(j,'HPstd') = {[std(hp)]};
                
                spike(j,'Height') = {mean(pk-start)};
                spike(j,'Heightstd') = {std(pk-start)};
                
                
                
                spike(j,'halfwidth') = {mean(inddown-indrise)};
                spike(j,'halfwidthstd') = {std(inddown-indrise)};
                
                spike(j,'indrise') = {{indrise'}};
                spike(j,'inddown') = {{inddown'}};
                
                if length(pk)>2
                    spike(j,'ISIratio') = {(pkloc(end)-pk(end-1))/(pkloc(2)-pkloc(1))};
                else
                    spike(j,'ISIratio') = {-1};
                end
                
                if length(pk) > 1
                    spike(j,'ISI') = { (pkloc(end)-pkloc(1)) /fs/(length(pkloc)-1) };
                    spike(j,'ISIstd') = {std(pkloc(2:end)-pkloc(1:end-1))/fs};
                else
                    spike(j,'ISI') = {-1};
                    spike(j,'ISIstd') = {-1};
                end
               
                hh = pk-start;
                if length(hh)>1
                    cof = polyfit(pkloc,hh,1);
                    cof2 = polyfit(pkloc,pk,1);
                    spike(j,'Hslope') = {cof(1)*8000};
                    
                    eva = evalclusters(pkloc,'kmeans','CalinskiHarabasz','KList',[1:6]);
                    if isnan(eva.OptimalK)
                        spike(j,'Hslope_c') ={cof(1)*8000};
                        spike(j,'Hslope_i') ={cof2(1)*8000};
                        spike(j,'Hslope_c_num') = {0};
                    else
                        idx = kmeans(pkloc,eva.OptimalK);
                        pkloc = pkloc(find(idx==idx(1)));
                        hh = hh(find(idx==idx(1)));
                        pk = pk(find(idx==idx(1)));
                        if length(hh)>1
                            cof = polyfit(pkloc,hh,1);
                            spike(j,'Hslope_c') = {cof(1)*8000};
                            spike(j,'Hslope_c_num') = {length(pk)};
                            cof2 = polyfit(pkloc,pk,1);
                            spike(j,'Hslope_i') = {cof2(1)*8000};
                        else 
                            spike(j,'Hslope_c') ={1};
                            spike(j,'Hslope_i') ={1};
                            spike(j,'Hslope_c_num') = {1};
                        end
                    end
                    
                else
                    spike(j,'Hslope') ={1};
                    spike(j,'Hslope_c') ={1};
                    spike(j,'Hslope_i') ={1};
                end
                
            end % all peaks are deleted
        end   % no peaks found in the beginning
        plot(trace+0.1*j);hold on;
        plot(hploc,hp+0.1*j,'*');hold on;
        plot(startloc,start+0.1*j,'o');hold on;
        
    end
    
    % Save the properties of one file in a large table "result"
    xlabel(num2str(fileind));
    yticks(0.1:0.1:11*0.1);
    yticklabels({spike.numofspike});
    print([num2str(fileind) '.png'],'-dpng');
    
    
    result(fileind,'numofspike') = {spike.numofspike};
    result(fileind,'Hslope') = {{spike.Hslope}};
    result(fileind,'cHslope') = {spike{11,'Hslope'}};
    result(fileind,'Hslope_c') = {{spike.Hslope_c}};
    result(fileind,'Hslope_c_num') = {{spike.Hslope_c_num}};
    result(fileind,'cHslope_c') = {spike{11,'Hslope_c'}};
    result(fileind,'Hslope_i') = {{spike.Hslope_i}};
    result(fileind,'cHslope_i') = {spike{11,'Hslope_i'}};
    
    result(fileind,'Height') = {{spike.Height}};
    result(fileind,'Heightstd') = {{spike.Heightstd}};
    result(fileind,'overall_height') = {sum(spike.Height.*spike.numofspike)/sum(spike.numofspike)};
    result(fileind,'overall_height_std') = {sum(spike.Height.*(spike.numofspike-1))/(sum(spike.numofspike)-1)};
    
    result(fileind,'ISI') = {{spike.ISI}};
    result(fileind,'ISIstd') = {{spike.ISIstd}};
    result(fileind,'ISIratio') = {{spike.ISIratio}};
    
    result(fileind,'HP') = {{spike.HP}};
    result(fileind,'HPstd') = {{spike.HPstd}};
    result(fileind,'overall_hp') = {sum(spike.HP.*spike.numofspike)/sum(spike.numofspike)};
    result(fileind,'overall_hp_std') = {sum(spike.HPstd.*(spike.numofspike-1))/(sum(spike.numofspike)-1)};
    
    result(fileind,'halfwidth') = {{spike.halfwidth}};
    result(fileind,'halfwidthstd') = {{spike.halfwidthstd}};
    result(fileind,'overall_hw') = {sum(spike.halfwidth.*spike.numofspike)/sum(spike.numofspike)};
    result(fileind,'overall_hw_std') = {sum(spike.halfwidthstd.*(spike.numofspike-1))/(sum(spike.numofspike)-1)};
    
end
%%

for i = 1:height(result)
    if sum(cell2mat(result{i,'numofspike'}))==0
        result{i,'select'} = 1;
    else
        result{i,'select'} = 0;
    end
end
result(result.select==1,:) = [];
result.select =[];

%%
save('AP_data.mat','result');
