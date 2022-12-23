dirpath='BinMaskedImages/';
dirpath1='BinMaskedTrainingSet/';
type='mat';
type1='jpg';
oldvar = '';
for j=1:length(dirpath)
    infile = fullfile(dirpath, sprintf('bwy.mat', j));
    fullOutputFileName = fullfile(dirpath1, sprintf('img21.jpg', j));
    datastruct = load(infile);
    fn = fieldnames(datastruct);
    firstvar = fn{1};
    data = datastruct.(firstvar);
    %reSize = imresize(data, [256, 256]);
    imwrite(data, fullOutputFileName); % Note: lossless mode.
    if ~strcmp(oldvar, firstvar)
      fprintf('loading from variable %s as of file %d\n', firstvar);
    end
end