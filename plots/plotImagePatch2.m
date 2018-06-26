load(sprintf('%s/plotImagePatch2.mat', DATAPATH))
close all
myfigure([6, 3]); hold on 
[yy, xx] = myecdf(X(:)); 
plot(xx, yy, 'color', 'r', 'linestyle', ':')
lineStyle = {'-.', '--', '-'};
for c = 1:3
    tmp = Xrep(:, :, c);
    [yy, xx] = myecdf(tmp(:));
    plot(xx, yy, 'color', 'k', 'linestyle', lineStyle{c})
end
box on
set(gca, 'xlim', [-0.5 0.5], 'ylim', [0 1])
legend('Observed', 'Gaussian', 'Laplace', 'Scale mix. Gauss.', 'location', 'southeast')
filename = '../figures/fig/imagePatchRaw';
saveImage(filename, 'figHandle', gcf, 'resolution', 800)