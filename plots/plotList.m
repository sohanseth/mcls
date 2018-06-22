%% Figure 2
c = 1; plotImagePatch; close all; clear all
c = 2; plotImagePatch; close all; clear all
c = 3; plotImagePatch; close all; clear all

%% Figure 3
plotImagePatch2; clear all

%% Figure 4
plotBee; clear all;

%% Figure 5
plotBee2; clear all;

%% Figure 6
for c = 1:3
    run('../startup.m')
    load(sprintf('%s/testGaussianProcess_CO2_%d.mat', DATAPATH, c)); 
    plotCO2(X, Y, YPred, Lambda, c, z, length(YTrain)); 
    saveImage(filename, 'resolution', 800, 'figHandle', gcf); 
    close gcf; clear all;
end

%% Figure 7
run('../startup.m')

h = myfigure([6, 2]);
load(sprintf('%s/testGaussianProcess_CO2_%d.mat', DATAPATH, 1)); 
mysubplot(1, 2, 1, 'left', 0.04, 'right', 0.00, 'bottom', 0.2, 'column', 0.04)
plot( XTrain, U(:, end-4:end) * c(end-4:end), XTrain, U(:, end-92:end-91) * c(end-92:end-91))
axis tight
myxylabel('year', '', '')
HL = mylegend({'$\sum_{i \in \{1,\ldots,5\}} c_{i}{\bf u}_{i}$', '$\sum_{i \in \{91,92\}} c_{i}{\bf u}_{i}$'}, 'location', 'northwest', 'interpreter', 'latex', 'fontsize', 10);
set(HL, 'edgecolor', 'none', 'color', 'none');

load(sprintf('%s/testGaussianProcess_CO2_%d.mat', DATAPATH, 2));
mysubplot(1, 2, 2, 'left', 0.04, 'right', 0.00, 'bottom', 0.2, 'column', 0.04)
plot(XTrain, U(:, end-[1,3,5]) * c(end-[1,3,5]), XTrain, U(:, end-[2,4,6]) * c(end-[2,4,6]))
axis tight
myxylabel('year', '', '')
HL = mylegend({'$\sum_{i \in \{2,4,6\}} c_{i}{\bf u}_{i}$', '$\sum_{i \in \{3,5,7\}} c_{i}{\bf u}_{i}$'}, 'location', 'northwest', 'interpreter', 'latex', 'fontsize', 10);
set(HL, 'edgecolor', 'none', 'color', 'none');

filename = '../figures/fig/testGaussianProcess_CO2_e';
saveImage(filename, 'fontsize', 8, 'figHandle', h, 'resolution', 1000); close(gcf)