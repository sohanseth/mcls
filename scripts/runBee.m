clear all;
for countData = 1:6
    
    runBeeLoad    
    
    for countFilter = 1:2
        switch countFilter
            case 1
                model = 'kalman.txt';
            case 2
                model = 'kalmanswitch.txt';
        end
        
        samples{countData, countFilter} = runKalman(Y, K, model);
    end
end
save ../data/KalmanResultFull10000.mat