function [sourcedata_raw_edf_file] = find_edf_bids(Sbj_MetadataBIDS)
% to find the right edf file for this sub,ses,task,run
% called within make_Sbj_MetadataBIDS.m
% April 2026, UAB
% Serdar Akkol, MD PhD

searchExcel = dir(Sbj_MetadataBIDS.sourcedata_raw_edf_dir);
for i = 1:length(searchExcel)
    tpm_2(i) = contains(searchExcel(i).name, '.edf') & contains(searchExcel(i).name, Sbj_MetadataBIDS.file_prefix,'IgnoreCase',true);
end
if ~exist('tpm_2','var') || sum(tpm_2) ~= 1
    warning('Either there is either no edf file or there are many of them. Check and run again')
    warning(['Name should be something like this: ' Sbj_MetadataBIDS.file_prefix '.edf'])
    sourcedata_raw_edf_file=[];
else
    sourcedata_raw_edf_file = fullfile(Sbj_MetadataBIDS.sourcedata_raw_edf_dir, searchExcel(tpm_2).name);
end

end