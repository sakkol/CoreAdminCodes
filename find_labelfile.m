function [labelfile] = find_labelfile(freesurfer_dir)
% low level function to be used by makeSbj_Metadata.m.

searchExcel = dir(fullfile(freesurfer_dir,'elec_recon'));
for i = 1:length(searchExcel)
    tpm_2(i) = contains(searchExcel(i).name, '.xlsx') & contains(searchExcel(i).name, 'corr','IgnoreCase',true);
end
if ~exist('tpm_2','var') || sum(tpm_2) ~= 1
    warning('Either there is either no correspondence sheet or there are many of them. Check and run again')
else
    labelfile = fullfile(freesurfer_dir,'elec_recon', searchExcel(tpm_2).name);
end

end