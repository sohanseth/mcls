BEEPATH = '../data/bee'; % '~/Desktop/matlabToolbox';
load(sprintf('%s/sequence%d/btf/ximage.btf', BEEPATH, countData))
load(sprintf('%s/sequence%d/btf/yimage.btf', BEEPATH, countData))
load(sprintf('%s/sequence%d/btf/timage.btf', BEEPATH, countData))
load(sprintf('%s/sequence%d/btf/label.btf', BEEPATH, countData))

Y = [ximage, yimage, sin(timage), cos(timage)]'; Y = zscore(Y')'; K = 4;