function mkdir_Sbj_MetadataBIDS(Sbj_MetadataBIDS)
% In order to create the main folders from Sbj_MetadataBIDS.
% 
% Adapted from mkdir_Sbj_Metadata.m in April 2026
% Serdar Akkol, MD PhD

if ~exist(Sbj_MetadataBIDS.sub_dir,'dir')
    mkdir(Sbj_MetadataBIDS.sub_dir)
end

if ~exist(Sbj_MetadataBIDS.ses_dir,'dir')
    mkdir(Sbj_MetadataBIDS.ses_dir)
end

if ~exist(Sbj_MetadataBIDS.ieeg_dir,'dir')
    mkdir(Sbj_MetadataBIDS.ieeg_dir)
end

if ~exist(Sbj_MetadataBIDS.anat_dir,'dir')
    mkdir(Sbj_MetadataBIDS.anat_dir)
end

if ~exist(Sbj_MetadataBIDS.beh_dir,'dir')
    mkdir(Sbj_MetadataBIDS.beh_dir)
end

if ~exist(Sbj_MetadataBIDS.physio_dir,'dir')
    mkdir(Sbj_MetadataBIDS.physio_dir)
end

if ~exist(Sbj_MetadataBIDS.results_dir,'dir')
    mkdir(Sbj_MetadataBIDS.results_dir)
end


end