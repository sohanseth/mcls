load(sprintf('%s/plotImagePatch2.mat', DATAPATH))
close all
myfigure([6, 3]); hold on
% [yy, xx] = ksdensity(G(:)); 
[yy, xx] = myecdf(G(:)); 
plot(xx, yy, 'color', 'r', 'linestyle', ':')
lineStyle = {'-.', '--', '-'};
for c = 1:3
    tmp = Grep(:, :, c);
    % [yy, xx] = ksdensity(tmp(:));
    [yy, xx] = myecdf(tmp(:));
    plot(xx, yy, 'color', 'k', 'linestyle', lineStyle{c})
end
box on
set(gca, 'xlim', [-1 1], 'ylim', [0 1])
legend('Observed', 'Gaussian', 'Laplace', 'Scale mix. Gauss.', 'location', 'southeast')
filename = '../figures/fig/imagePatchGradient';
saveImage(filename, 'figHandle', gcf, 'resolution', 800)