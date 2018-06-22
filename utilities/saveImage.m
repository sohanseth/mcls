function saveImage(filename, varargin)
% SAVEIMAGE reads a Matlab figure and saves it in a different format.
%   SAVEIMAGE(FILENAME) reads a Matlab figure FILENAME(.fig) and saves it
%   as FILENAME(.FOTMAT) where format is either 'png' (default) or 'eps'.
%
%   SAVEIMAGE(FILENAME, 'FORMAT', 'PNG') reads a Matlab figure FILENAME(.fig)
%   and saves it as FILENAME.PNG. List of optional arguments are as follows:
%       FOTMAT: format of the image (eps or png) (default is png)
%       FONTSIZE: fontsize of texts within the image (default is 8)
%       FONTNAME: fontname of texts within the image (default in palatino)
%       DIMENSION: dimension of the image (default is the original size)
%       RESOLUTION: resolution of the saved image in dpi (default it 600)
%       PRESENTATION: if true then fontsize is increased to 12 (default false)
%       VISIBLE: if 'on' ('off') then the figure is displayed on the screen (default is 'on')
%       FIGHANDLE: if provided then figure is saved from the handle
%
%   If FILENAME follows syntax */fig/*, then the output figure is saved in the 
%   folder */FORMAT/*, e.g., dir/fig/test.fig will be saved as dir/png/test.png.
%   If the optional argument PRESENTATION is provided, then the image is saved
%   as dir/pre/test.png.
%
% Authour: Sohan Seth, sseth@inf.ed.ac.uk

if (length(filename) > 4) & any(strcmp(filename(end-3:end), {'.fig', '.png', '.pdf', '.eps', '.jpg'}))
    filename = filename(1:end-4);
end

isHandle = find(strcmpi('figHandle', varargin));
if ~isempty(isHandle)
    h = varargin{isHandle + 1};
else
    h = open(sprintf('%s.fig', filename));
end
POS = get(h, 'paperposition');

varList = {'figHandle', 'fontname', 'fontsize', 'dimension', 'format', 'resolution', 'presentation', 'visible'};
varDefault = {0, 'palatino', 8, POS(3:4), 'png', 600, false, 'on'};
options = parseVarArg(varList, varDefault, varargin);
if options.presentation
    options.fontsize = 12;
end

flagPDF = false;
if strcmp(options.format, 'pdf')
    options.format = 'eps';
    flagPDF = true;
end

set(h, 'papertype', 'a4', 'units', 'inch', 'color', [1 1 1], 'paperunits', 'inch', ...
    'paperposition', [(get(gcf, 'PaperSize') - options.dimension) / 2, options.dimension], ...
    'position', [0 0 options.dimension], 'visible', options.visible);

hc = get(h, 'children');
% hc(strcmp(cellfun(@(x)(x(1:2)), get(h.Children, 'Type'), 'UniformOutput', false), 'ui')) = []; % Removing ui related handles
set(hc, 'FontSize', options.fontsize);
set(hc, 'FontName', options.fontname)

if ~isempty(strfind(filename, '/fig/')) %contains(filename, '/fig/')
    if options.presentation
        filename = strrep(filename, '/fig/', '/pre/'); options.format = 'png';
    else
        filename = strrep(filename, '/fig/', sprintf('/%s/', options.format));
    end
end

switch options.format
    case 'png'
        driver = sprintf('-d%s', options.format);
    case 'eps'
        driver = sprintf('-d%s', 'epsc2');
end
print(driver, sprintf('-r%d', options.resolution), sprintf('%s.%s', filename, options.format));

if flagPDF
    [~, ~] = system(sprintf('/usr/local/bin/gs -dEPSCrop -sDEVICE=pdfwrite -o %s.pdf %s.eps', strrep(filename, '/eps/', '/pdf/'), filename));
end

if isempty(options.figHandle)
    close(h);
end

% TODO
% Tex font change in eps/pdf