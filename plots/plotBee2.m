XLIM = [-2 2];
flagSave = true;
for countData = 6 %1:6
    % myfigure([2 4]), hold on
    % filename = sprintf('../figures/fig/Bee%d', countData);
    fprintf('countData = %d\n', countData)
    for countFilter = 1:2
        switch countFilter
            case 1
                model = 'kalman.txt'; D = 1; LINESTYLE = '-.';
            case 2
                model = 'kalmanswitch.txt'; D = 3; LINESTYLE = '-';
        end
        runBeeLoad, [M, N] = size(Y);
        
        load ~/Desktop/sseth/modelCriticism/data/KalmanResultFull10000.mat samples
        samples = samples{countData, countFilter};
        [EX, EY] = runBeeComputeInnovation(Y, samples, D);
        
        TXt = []; TYt = []; % Temporal dependence in X = latent and Y = observation space
        TX = []; TY = []; % Spatial dependence in X = latent and Y = observation space
        for c1 = 1:4;
            % [~, pxt] = corr(EX(c1, 2:end-1)', EX(c1, 3:end)');
            TXt = [TXt; [EX(c1, 2:end-1)', EX(c1, 3:end)']];
            % [~, pyt] = corr(EY(c1, 2:end-1)', EY(c1, 3:end)');
            TYt = [TYt; [EY(c1, 2:end-1)', EY(c1, 3:end)']];
            % fprintf('channels %d %f %f (temporal) \n', c1, pxt, pyt)
            for c2 = c1+1:4;
                % plot(EX(c1, :), EX(c2, :)); pause(1);
                % [~, px] = corr(EX(c1, 2:end)', EX(c2, 2:end)');
                TX = [TX; [EX(c1, 2:end)', EX(c2, 2:end)']];
                % [~, py] = corr(EY(c1, 2:end)', EY(c2, 2:end)');
                TY = [TY; [EY(c1, 2:end)', EY(c2, 2:end)']];
                % fprintf('channels %d %d %f %f\n', c1, c2, px, py)
            end
        end
        
        [vx, px] = corr(TX(:, 1), TX(:, 2));
        [vy, py] = corr(TY(:, 1), TY(:, 2));
        [vxt, pxt] = corr(TXt(:, 1), TXt(:, 2));
        [vyt, pyt] = corr(TYt(:, 1), TYt(:, 2));
        fprintf('countFilter = %d, pvalues (%f %f) (%f %f)\n', countFilter, px, py, pxt, pyt)
        
        latInn{countData, countFilter} = TXt;
        obsInn{countData, countFilter} = TYt;
        latInnV(countData, countFilter) = vxt;
        obsInnV(countData, countFilter) = vyt;
        latInnP(countData, countFilter) = pxt;
        obsInnP(countData, countFilter) = pyt;
    end
end

%%
myfigure([8 2]);
xGrid = -2.5:0.25:2.5; clear m s;
subplotOptions = {'left', 0.05, 'bottom', 0.1, 'right', 0.01, 'top', 0.1, 'column', 0.05};
for countSub = 1:4
    switch countSub
        case 1
            data = latInn{6, 1}; V = latInnV(6, 1); P = latInnP(6, 1);
            XLABEL = '$\tilde{z}_{t}$'; YLABEL = '$\tilde{z}_{t+1}$'; TITLE = 'latent space';
        case 2
            data = obsInn{6, 1}; V = obsInnV(6, 1); P = obsInnP(6, 1);
            XLABEL = '$\tilde{x}_{t}$'; YLABEL = '$\tilde{x}_{t+1}$'; TITLE = 'latent space';
        case 3
            data = latInn{6, 2}; V = latInnV(6, 2); P = latInnP(6, 2);
            XLABEL = '$\tilde{z}_{t}$'; YLABEL = '$\tilde{z}_{t+1}$'; TITLE = 'observation space';
        case 4
            data = obsInn{6, 2}; V = obsInnV(6, 2); P = obsInnP(6, 2);
            XLABEL = '$\tilde{x}_{t}$'; YLABEL = '$\tilde{x}_{t+1}$'; TITLE = 'observation space';
    end
    
    for count = 1:length(xGrid) - 1
        ids = data(:, 1) > xGrid(count) & data(:, 1) < xGrid(count + 1);
        m(count) = mean(data(ids, 2));
        s(count) = std(data(ids, 2));
    end
    
    mysubplot(1, 4, countSub, subplotOptions{:}); hold on
    
    % Mean
    plot(xGrid, zeros(1, length(xGrid)), 'r--', 'linewidth', 2)
    plot((xGrid(1:end-1) + xGrid(2:end))/2, m, 'k', 'linewidth', 2)
    
    % Mean + - Std
    plot(xGrid, ones(1, length(xGrid)), 'r--', 'linewidth', 2)
    plot(xGrid, -ones(1, length(xGrid)), 'r--', 'linewidth', 2)
    
    plot((xGrid(1:end-1) + xGrid(2:end))/2, m + s, 'k', 'linewidth', 2)
    plot((xGrid(1:end-1) + xGrid(2:end))/2, m - s, 'k', 'linewidth', 2)
    hold off
    
    axis([-2.5 2.5 -2.5 2.5])
    set(gca, 'xtick', {}, 'ytick', {})
    box on
    myxylabel(XLABEL, YLABEL, TITLE, 'interpreter', 'latex')
    
    if countSub == 4
        legend('prior', 'agg. post.', 'location', 'south')
    end
    text(0, 2, sprintf('%0.2e (%0.2e)', V, P), 'horizontalalignment', 'center') 
end

filename = '../figures/fig/plotBee2';
saveImage(filename, 'figHandle', gcf)