result0 = result;
result0(result0.currentstep==10,:) = [];
result0(result0.me==0,:) = [];
% result0(result0.cHslope_c ==1,:) = [];

dayv =  [8 9 10 11 14 15 16 41 42];
col_l = [1 0 0  1  0  1  0  0  0];
col_r = [0 0 1  0  1  0  1  1  1];

figure;
for i = 1:height(result0)
    x = result0{i,'day'};
    n = cell2mat(result0{i,'Hslope_c_num'});
    data = cell2mat(result0{i,'Hslope_c'});
    data = data(7:11);
    for j = 1:length(data)
        if data(j)~=1
            if col_l(dayv==x) == 1
                col = 'r';
            elseif col_r(dayv==x) == 1
                col = 'b';
            end
            scatter(x,data(j),col,'filled','MarkerFaceAlpha',min(1,n(j)/5),'MarkerEdgeAlpha',min(1,n(j)/5));hold on;
        end
    end
    
end
xlabel('day');
ylabel('slope');
title('Hslope-c clustered  alpha: Hslope-c-num');
    