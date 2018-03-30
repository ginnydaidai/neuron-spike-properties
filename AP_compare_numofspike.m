%% compare spike numbers
result0 = result;
result0(result0.currentstep==10,:) = [];
result0(result0.me==0,:) = [];
% result0(result0.cHslope_c ==1,:) = [];

dayv =  [8 9 10 11 14 15 16 41 42];
col_l = [1 0 0  1  0  1  0  0  0];
col_r = [0 0 1  0  1  0  1  1  1];

accu = zeros(42,11);
accu_n = zeros(42,1);
for i = 1:height(result0)
    x = result0{i,'day'};
    data = cell2mat(result0{i,'numofspike'});
    accu_n(x) = accu_n(x) + 1;
    for j = 1:11
        accu(x,j) = accu(x,j) + data(j);
    end
end

figure;
for i = 1:length(accu_n)  %day
    if col_l(dayv==i) == 1
        col = 'r';
    elseif col_r(dayv==i) == 1
        col = 'b';
    end
    if accu_n(i)~=0
        for j = 1:11
            accu(i,j) = accu(i,j)/accu_n(i);
            scatter(i,accu(i,j),col,'filled','MarkerFaceAlpha',j/11,'MarkerEdgeAlpha',j/11);hold on;
        end
    end
end
xlabel('day');
ylabel('number of spike');
title('number of spike');
