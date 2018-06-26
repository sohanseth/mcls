DATAPATH = sprintf('%s/data/', pwd); % large data files
addpath(DATAPATH)

addpath(sprintf('%s/utilities/', pwd))
addpath(sprintf('%s/functions/', pwd))
addpath(sprintf('%s/plots/', pwd))
addpath(sprintf('%s/data/', pwd))

addpath ~/Desktop/localDirectory/matlabToolbox/cbrewer/

addpath ~/Desktop/localDirectory/matlabToolbox/matjags-master/

addpath ~/Desktop/localDirectory/matlabToolbox/gpml-matlab-v3.5-2014-12-08/
run('~/Desktop/localDirectory/matlabToolbox/gpml-matlab-v3.5-2014-12-08/startup.m');

addpath ~/Desktop/localDirectory/matlabToolbox/GPstuff-4.7/
run('~/Desktop/localDirectory/matlabToolbox/GPstuff-4.7/startup.m')

addpath ~/Desktop/localDirectory/matlabToolbox/NIPSGMM/