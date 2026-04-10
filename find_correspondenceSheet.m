function [correspondenceSheet_file] = find_correspondenceSheet(Sbj_MetadataBIDS)
% low level function to be used by make_Sbj_MetadataBIDS.m.

freesurfer_dir = Sbj_MetadataBIDS.freesurfer;
searchExcel = dir(fullfile(freesurfer_dir,'elec_recon'));
for i = 1:length(searchExcel)
    tpm_2(i) = contains(searchExcel(i).name, '.xlsx') & contains(searchExcel(i).name, 'corr','IgnoreCase',true);
end
if ~exist('tpm_2','var') || sum(tpm_2) == 0
    warning('Either there is no correspondence sheet. Running create_correspondenceSheet...')
    correspondenceSheet_file = create_correspondenceSheet(Sbj_MetadataBIDS);
elseif ~exist('tpm_2','var') || sum(tpm_2) > 1
    warning('Either there are many of correspondence sheet. Maybe one is open. Check and run again')
else
    correspondenceSheet_file = fullfile(freesurfer_dir,'elec_recon', searchExcel(tpm_2).name);
end

end