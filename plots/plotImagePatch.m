%% Combine all K
COLOR = 'k'; COLOR2 = 'r'; LINEWIDTH2 = 1;
flagSave = true; 
XLIM = [-0.5 0.5];
if c == 2
    XLIM = [-1 1];
end
K = 16;
load(sprintf('%s/50000_%d_%d', DATAPATH, K, c))

myfigure([3 1.5]/1.4);
filename = sprintf('../figures/fig/ImageU%d', c);

hold on
for count = 1%:10:100
    Unorm = (squeeze(samples{c}.U(1, end - count + 1, :, :)));
    tau = squeeze(samples{c}.Utau(1, end - count + 1, :));
    if c == 1
        prop = 1;
    end
    if c == 3
        tmp = sortrows(myunique(squeeze(samples{c}.ZU(1, end - count + 1, :))));
        prop = tmp(:, 2) / sum(tmp(:, 2));
    end
    % ksdensity(Unorm(:), -10:0.1:10);
    ecdf(Unorm(:))
    h = get(gca, 'children'); set(h(1), ...
        'color', 'k', 'linestyle', '-'); % [0.8 0.8 0.8]
end

switch c
    case 1
        [~, xCDF, yCDF] = plotNormalCDF(tau, prop); axis tight; box on; 
        set(gca, 'xlim', XLIM); [~, p] = kstest(Unorm(:), 'CDF', [xCDF(:), yCDF(:)]);
    case 2
        [~, xCDF, yCDF] = plotDoubleExpCDF(tau); axis tight; box on; 
        set(gca, 'xlim', XLIM); [~, p] = kstest(Unorm(:), 'CDF', [xCDF(:), yCDF(:)]);
    case 3
        [~, xCDF, yCDF] = plotNormalCDF(tau, prop); axis tight; box on; 
        set(gca, 'xlim', XLIM); [~, p] = kstest(Unorm(:), 'CDF', [xCDF(:), yCDF(:)]);
end
hold off
myxylabel('z', 'F(z)', '')
% h = mylegend(['agg. post., p=',num2str(p, '%20.2f')], 'true');
% set(h, 'edgecolor', 'none', 'location', 'north', 'color', 'none')
if flagSave
    saveImage(filename, 'figHandle', gcf, 'resolution', 800);
end
%%
%myfigure([2.5, 2.5]);
flagSave = false;
COLOR = 'k'; COLOR2 = 'r'; LINEWIDTH2 = 1;
filename = sprintf('../figures/fig/ImageV%d', c);
[Vsvd, Ssvd, ~] = svd(squeeze(samples{c}.V(1, end, :, :))');
for count = 1:K
    imagesV{count} = reshape(Vsvd(:, count), 8, 8);    
end
plotDictionary(imagesV)
if flagSave
    saveImage(filename, 'figHandle', gcf, 'resolution', 800);
end

%% Bivariate distribution
COLOR = 'k'; COLOR2 = 'r'; LINEWIDTH2 = 1;
flagSave = true;
K = 16; k1 = 1; k2 = 2;
filename = sprintf('../figures/fig/ImageUU%d', c);
load(sprintf('%s/50000_%d_%d', DATAPATH, K, c))
U = squeeze(samples{c}.U(1, end, :, :));
% scatter(U(1:10:end, k1), U(1:10:end, k2), 36, [0.5 0.5 0.5], '.')
% t1 = U(:, 1:K-1); t2 = U(:, 2:K); clear U; U(:, 1) = t1(:); U(:, 2) = t2(:);
t1 = []; t2 = [];
for count1 = 1:15
    for count2 = count1+1:16
        t1 = [t1; U(:, count1)]; t2 = [t2; U(:, count2)];
        fprintf('[%d %d]\n', count1, count2);
    end
end
U = [t1, t2];
% scatter(U(1:100:end, 1), U(1:100:end, 2), 36, [0.5 0.5 0.5], '.')
% U = randn(50000, 2); % test
switch c
    case 1
        XLIM = [-0.5 0.5]; xRes = 0.01; xGrid = XLIM(1):xRes:XLIM(2);
    case 2
        XLIM = [-1 1]; xRes = 0.01; xGrid = XLIM(1):xRes:XLIM(2);
    case 3
        XLIM = [-0.5 0.5]; xRes = 0.01; xGrid = XLIM(1):xRes:XLIM(2);
end
for count = 1:length(xGrid)
    yLength(count) = sum((U(:, 1) > xGrid(count) - xRes) & (U(:, 1) < xGrid(count) + xRes));
    if yLength(count) > 100
        yMean(count) = mean(U((U(:, 1) > xGrid(count) - xRes) & (U(:, 1) < xGrid(count) + xRes), 2));
        yStd(count) = std(U((U(:, 1) > xGrid(count) - xRes) & (U(:, 1) < xGrid(count) + xRes), 2));
    else
        yMean(count) = nan; yStd(count) = nan;
    end
end

myfigure([3 3]/1.4);
hold on

LINEWIDTH = 1;
h1 = plot(xGrid, yMean, '-', 'color', COLOR, 'linewidth', LINEWIDTH);
plot(xGrid, yMean + yStd, '-', 'color', COLOR, 'linewidth', LINEWIDTH)
plot(xGrid, yMean - yStd, '-', 'color', COLOR, 'linewidth', LINEWIDTH)

tau = squeeze(samples{c}.Utau(1, end, :));
if c == 1
    h2 = plot(xGrid, zeros(size(yMean)), '--', 'color', COLOR2, 'linewidth', LINEWIDTH2);
    plot(xGrid, tau^(-0.5) * ones(size(yMean)), '--', 'color', COLOR2, 'linewidth', LINEWIDTH2)
    plot(xGrid, - tau^(-0.5) * ones(size(yMean)), '--', 'color', COLOR2, 'linewidth', LINEWIDTH2)
end
if c == 2
    h2 = plot(xGrid, zeros(size(yMean)), '--', 'color', COLOR2, 'linewidth', LINEWIDTH2);
    plot(xGrid, sqrt(2) * tau^(-1) * ones(size(yMean)), '--', 'color', COLOR2, 'linewidth', LINEWIDTH2)
    plot(xGrid, - sqrt(2) * tau^(-1) * ones(size(yMean)), '--', 'color', COLOR2, 'linewidth', LINEWIDTH2)
end
if c == 3    
    pU = squeeze(samples{c}.pU(1, end, :));
    for count = 1:length(xGrid)
        pUU = normpdf(xGrid(count), 0, tau.^(-0.5)) .* pU; pUU = pUU / sum(pUU);
        stdList(count) = sqrt(sum(pUU .* (tau).^(-1)));
    end
    h2 = plot(xGrid, zeros(size(yMean)), '--', 'color', COLOR2, 'linewidth', LINEWIDTH2);
    plot(xGrid, stdList, '--', 'color', COLOR2, 'linewidth', LINEWIDTH2)
    plot(xGrid, - stdList, '--', 'color', COLOR2, 'linewidth', LINEWIDTH2)
end

% fill([xGrid, xGrid(end-1:-1:2)], [yMean + yStd, yMean(end-1:-1:2) - yStd(end-1:-1:2)], COLOR)
hold off
switch c
    case 1
        box on; set(gca, 'xlim', XLIM, 'ylim', XLIM);    
    case 2
        box on; set(gca, 'xlim', XLIM, 'ylim', XLIM);
    case 3
        box on; set(gca, 'xlim', XLIM, 'ylim', XLIM);    
end
myxylabel('$z_1$', '$z_2$', '', 'interpreter', 'latex');
set(gca, 'xtick', [], 'ytick', [])
if c == 3
    h = mylegend([h2, h1], 'true', 'agg. post.');
    set(h, 'edgecolor', 'none', 'location', 'north', 'color', 'none')
end
if flagSave
    saveImage(filename, 'figHandle', gcf, 'resolution', 800);
end