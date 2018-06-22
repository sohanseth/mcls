% This script generates replicate samples from the fitted distribution, and
% compare their statistics with the observed data in terms of image gradient

clear all
K = 16;
totImage = 50000; % number of replicate images to compute image statistics

Xrep = zeros(64, totImage, 3); Z = zeros(16, totImage, 3);

for c = 1:3 % Gaussian, Laplace and scale mixture of Gaussian
    
    load(sprintf('%s/50000_%d_%d', DATAPATH, K, c))
    samples = samples{c};
    
    for countSample = 100 % 1:100 % MCMC samples
        
        Theta = squeeze(samples.V(1, countSample, :, :))';
        b = squeeze(samples.bV(1, countSample, :));
        tau = samples.tau(1, countSample);
        
        utau = samples.Utau(1, countSample, :);
        if c == 3
            pU = squeeze(samples.pU(1, countSample, :)); pU = pU / sum(pU);
        end
        
        % Generate samples from latent distribution and corresponding image
        for countImage = 1:totImage
            if c == 1        
                Z(:, countImage, c) = randn(16, 1) / sqrt(utau);
            end
            if c == 2
                Z(:, countImage, c) = randl(16, 1) / utau;
            end
            if c == 3
                Z(:, countImage, c) = randn(16, 1) / sqrt(utau(mnrnd(1, pU) == 1));
            end
            
            Xrep(:, countImage, c) = Theta * Z(:, countImage, c) + b + randn(64, 1) / sqrt(tau);
            
            % Compute image gradients
            [gx, gy] = imgradientxy(reshape(Xrep(:, countImage, c), 8, 8));
            Grep(:, countImage, c) = [gx(:); gy(:)];
        end
    end
end

%% Statistics from real data
load ../data/BSDS300/iids_train.txt
images = cell(length(iids_train), 1);
for count = 1:length(iids_train)
    images{count} = im2double(rgb2gray(imread(sprintf('../data/BSDS300/images/train/%d.jpg', iids_train(count)))));
end
%
patchSize = 8;
miniBatchSize = totImage;
X = removeDC(RandPatchesFromImagesCell(miniBatchSize, patchSize, images));

for countImage = 1:size(X, 2)
    t = imgradientxy(reshape(X(:, countImage), 8, 8));
    G(:, countImage) = t(:);
end