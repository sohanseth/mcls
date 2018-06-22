function h = plotDictionary(images, varargin)
% Plot a set of images in cell array images

argumentList = {'normalize', 'dimension', 'colormap', 'figure'};
argumentDefault = {false, [], 'gray', []};
options = parseVarArg(argumentList, argumentDefault, varargin);

if options.normalize
    maxValue = double(max(cell2mat(cellfun(@(x)(x(:)), images(:), 'uniformoutput', false))));
    minValue = double(min(cell2mat(cellfun(@(x)(x(:)), images(:), 'uniformoutput', false))));
else
    maxValue = 1; minValue = 0;
end

if isempty(options.dimension)
    if any(size(images) == 1)
        ROW = ceil(sqrt(length(images))); COL = ROW;
    else
        [ROW, COL] = size(images);
    end
else
    ROW = options.dimension(2);
    COL = options.dimension(1);
end

if isempty(options.figure)
    h = myfigure([ROW COL]);
else
    h = options.figure;
end

images = images';
for countMaster = 1:numel(images)
    C = colormap(options.colormap);
    mysubplot(ROW, COL, countMaster);
    
    if options.normalize
        % image(double(images{countMaster}) / maxValue * size(C, 1));
        image((double(images{countMaster}) - minValue) / (maxValue - minValue) * size(C, 1));
    else
        imagesc(images{countMaster});
    end
    set(gca, 'xtick', [], 'ytick', [])
end

% function h = plotDictionary(images, varargin)
% % Plot a set of images in cell array images
% 
% argumentList = {'normalize', 'dimension', 'colormap', 'figure'};
% argumentDefault = {false, [], 'gray', []};
% options = parseVarArg(argumentList, argumentDefault, varargin);
% 
% if options.normalize
%     maxValue = double(max(cell2mat(cellfun(@(x)(x(:)), images(:), 'uniformoutput', false))));
% else
%     maxValue = 1;
% end
% 
% if isempty(options.dimension)
%     if any(size(images) == 1)
%         ROW = ceil(sqrt(length(images))); COL = ROW;
%     else
%         [ROW, COL] = size(images);
%     end
% else
%     ROW = options.dimension(2);
%     COL = options.dimension(1);
% end
% 
% if isempty(options.figure)
%     h = myfigure([ROW COL]);
% else
%     h = options.figure;
% end
% countMaster = ROW * COL;
% for countCol = 1:COL
%     for countRow = ROW:-1:1
%                 
%         C = colormap(options.colormap);
%         subplot('position', [(countRow-1)/ROW, (countCol-1)/COL, 1/ROW, 1/COL]);
%         
%         if countMaster > length(images)
%             break;
%         end
%         if options.normalize
%             image(double(images{countMaster}) / maxValue * size(C, 1)); 
%         else
%             imagesc(images{countMaster});
%         end
%         set(gca, 'xtick', [], 'ytick', [])       
%         countMaster = countMaster - 1;        
%     end
% end