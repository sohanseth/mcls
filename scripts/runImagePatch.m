load ../data/BSDS300/iids_train.txt
images = cell(length(iids_train), 1);
for count = 1:length(iids_train)
    images{count} = im2double(rgb2gray(imread(sprintf('../data/BSDS300/images/train/%d.jpg', iids_train(count)))));
end
%
patchSize = 8;
miniBatchSize = 50000
X = removeDC(RandPatchesFromImagesCell(miniBatchSize, patchSize, images))';

%%
K = 16;
for c = 1:3
    switch c
        case 1
            model = 'mf_Gauss_prior.txt';
        case 2
            model = 'mf_Gauss_prior_Lap.txt';
        case 3
            model = 'mf_Gauss_prior_mix.txt';
    end
    samples{c} = runImage(X, K, model);
    save(['../data/', num2str(miniBatchSize), '_', num2str(K), '_', num2str(c)], 'samples')
end