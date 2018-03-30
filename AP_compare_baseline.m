%% compare baseline
result0 = result;
result0(result0.currentstep==10,:) = [];
result0(result0.me==0,:) = [];
result0(result0.minus70 ==1,:) =[];

dayv =  [8 9 10 11 14 15 16 41 42];
col_l = [1 0 0  1  0  1  0  0  0];
col_r = [0 0 1  0  1  0  1  1  1];
figure;
accu = zeros(42,11);
accu_n = zeros(42,1);
for i = 1:height(result0)
    x = result0{i,'day'};
    y = result0{i,'baseline'};
    if col_l(dayv==x) == 1
        col = 'r';
    elseif col_r(dayv==x) == 1
        col = 'b';
    end
    scatter(x,y,col,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5);hold on;
end
xlabel('day');ylabel('baseline');

