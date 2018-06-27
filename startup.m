DATAPATH = sprintf('%s/data/', pwd); % large data files
addpath(DATAPATH)

addpath(sprintf('%s/utilities/', pwd))
addpath(sprintf('%s/functions/', pwd))
addpath(sprintf('%s/plots/', pwd))
addpath(sprintf('%s/data/', pwd))

% path to cbewer
addpath ~/Desktop/localDirectory/matlabToolbox/cbrewer/

% path to matjags
addpath ~/Desktop/localDirectory/matlabToolbox/matjags-master/

% path to GPML
addpath ~/Desktop/localDirectory/matlabToolbox/gpml-matlab-v3.5-2014-12-08/
run('~/Desktop/localDirectory/matlabToolbox/gpml-matlab-v3.5-2014-12-08/startup.m');

% path to GPstuff
addpath ~/Desktop/localDirectory/matlabToolbox/GPstuff-4.7/
run('~/Desktop/localDirectory/matlabToolbox/GPstuff-4.7/startup.m')

% path to RandPatchesFromImagesCell.m
addpath ~/Desktop/localDirectory/matlabToolbox/NIPSGMM/
