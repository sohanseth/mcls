%%
XLIM = [-2 2];
flagSave = true;
for countData = 6 % 1:6
    myfigure([2 4]), hold on
    filename = sprintf('../figures/fig/Bee%d', countData);
    for countSubplot = 1:2 % for X and Y
        for countFilter = 1:2
            switch countFilter
                case 1
                    model = 'kalman.txt'; D = 1; LINESTYLE = '-.';
                case 2
                    model = 'kalmanswitch.txt'; D = 3; LINESTYLE = '-';
            end
            runBeeLoad; [M, N] = size(Y);
            
            load KalmanResultFull10000.mat samples
            samples = samples{countData, countFilter};
            [EX, EY] = runBeeComputeInnovation(Y, samples, D);
            
            subplot(2, 1, countSubplot), hold on
            switch countSubplot
                case 1
                    myecdf(EX(:));
                    [~, p] = kstest(EX(:));
                    textLegend{countFilter, countSubplot} = ...
                        ['S = ', num2str(D),', p = ', num2str(p, '%0.2f')];
                    % textLegend{countFilter, countSubplot} = ...
                    %    ['agg. post., ',10, 'S = 1, p=', num2str(p, '%0.2f')];
                case 2
                    myecdf(EY(:));
                    [~, p] = kstest(EY(:));
                    textLegend{countFilter, countSubplot} = ...
                        ['S = ', num2str(D),', p = ', num2str(p, '%0.2f')];
                    % textLegend{countFilter, countSubplot} = ...
                    %    ['agg. post., ',10, 'S = 3, p=', num2str(p, '%0.2f')];
            end
            h  = get(gca, 'children');
            set(h(1), 'linestyle', LINESTYLE, 'color', 'k')
            hLegend(countFilter, countSubplot) = h(1);
        end
        text(-1.5, 0.8, [textLegend{1, countSubplot}, 10, textLegend{2, countSubplot}], 'fontsize', 8, 'fontname', 'palatino');
        h2 = plotNormalCDF;
        %h = legend([hLegend(1, countSubplot), hLegend(2, countSubplot), h2], ...
        %    {textLegend{1, countSubplot}, textLegend{2, countSubplot}, 'N(0, 1)'});        
        set(gca, 'xlim', XLIM, 'ylim', [0 1])
        box on
        if countSubplot == 1
            myxylabel('z', '', 'latent space')
        else
            myxylabel('x', '', 'observation space')
        end
        if countSubplot == 2
            h = mylegend([h2, hLegend(1, countSubplot), hLegend(2, countSubplot)], ...
                {'prior', 'agg. post. S = 1', 'agg. post. S = 3'});
            set(h, 'edgecolor', 'none', 'location', 'southeast', 'edgecolor', 'none')
            POS = get(h, 'position');
            set(h, 'position', [POS(1)+0.1, POS(2)-0.04, POS(3:end)])
        end
    end
    if flagSave
        saveImage(filename, 'figHandle', gcf, 'fontsize', 8, 'resolution', 800)
    end
end

%% Plot time series
flagSave = true;
for countData = 6
    for countFilter = 2
        myfigure([4, 4])
        filename = sprintf('../figures/fig/Bee%dts', countData);
        
        switch countFilter
            case 1
                model = 'kalman.txt'; D = 1;
            case 2
                model = 'kalmanswitch.txt'; D = 3;
        end
        runBeeLoad, [M, N] = size(Y);
        
        load KalmanResultFull10000.mat samples
        samples = samples{countData, countFilter};
        
        [EX, EY, Z] = runBeeComputeInnovation(Y, samples, D);
        
        colorList = cbrewer('qual', 'Set1', 3);
        for c = 1:3
            subplot(3, 1, c),
            
            ind = [1; 1 + find(diff(Z) ~= 0); length(label)];
            hold on
            for count = 1:length(ind)-1
                plot(ind(count): ind(count + 1), ....
                    Y(c, ind(count): ind(count + 1))', ...
                    'marker', 'none', 'color', colorList(Z(ind(count)), :), ...
                    'markerfacecolor', 'none', 'markersize', 4,  'linestyle', '-');
            end
            
            changePoints = 1 + find(diff(label) ~= 0);
            for count = 1:length(changePoints)
                switch label(changePoints(count))
                    case 1
                        changePointMarker = '<';
                    case 2
                        changePointMarker = '>';
                    case 3
                        changePointMarker = 'o';
                end
                plot(changePoints(count), 0, changePointMarker, ...
                    'markerfacecolor', 'none', 'color', 'k', 'markersize', 3);
            end
            
            switch c
                case 1
                    myxylabel('', 'x', ''), set(gca, 'xtick', [])
                case 2
                    myxylabel('', 'y', ''), set(gca, 'xtick', [])
                case 3
                    myxylabel('t', 'cos(\nu)', ''), set(gca, 'xtick', 100:100:length(label))                 
            end
            axis tight, box on
            
            XLIM = get(gca, 'xlim');
            set(gca, 'xlim', [XLIM(1), XLIM(2) + 270])
            box off
        end
        
        c = 1; subplot(3, 1, c),            
        YLIM = get(gca, 'ylim');
        h(1) = line([-5 0], [-5 0], 'color', colorList(1, :));
        h(2) = line([-5 0], [-5 0], 'color', colorList(2, :));
        h(3) = line([-5 0], [-5 0], 'color', colorList(3, :));
        h = mylegend(h(1:3), 'state 1', 'state 2', 'state 3');
        set(h, 'location', 'east', 'edgecolor', 'none', 'orientation', 'vertical')
        set(gca, 'ylim', YLIM);
        c = 2; subplot(3, 1, c),            
        YLIM = get(gca, 'ylim');
        h(4) = plot([-5 -5], 'marker', '<', 'color', 'k', 'linestyle', 'none', 'markersize', 3);
        h(5) = plot([-5 -5], 'marker', '>', 'color', 'k', 'linestyle', 'none', 'markersize', 3);
        h(6) = plot([-5 -5], 'marker', 'o', 'color', 'k', 'linestyle', 'none', 'markersize', 3);
        h = mylegend(h(4:6), 'left', 'right', 'waggle');
        set(h, 'location', 'east', 'edgecolor', 'none', 'orientation', 'vertical')
        set(gca, 'ylim', YLIM);
        
        if flagSave
            saveImage(filename, 'figHandle', gcf, 'fontsize', 8, 'resolution', 800)
        end
    end
end