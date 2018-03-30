function plotpatchdata(str)
[~,data] = readpatchdata(str);
figure;
for i = 1:2:size(data,2)
    plot(0.08*i+data(:,i));hold on;
end
yticks(0.05:0.08*2:0.08*21-0.03);
yticklabels(1:11);
% ylabel('I command');
end
