function Sbj_BIDSfiles = getSbj_BIDSfiles(main_root, project_name, sbj_ID)
% based on makeSbj_Metadata.m (SAkkol - HBML, 2019)
% written by SAkkol - HBML, 2020

Sbj_BIDSfiles = [];
Sbj_BIDSfiles.sbj_ID = sbj_ID;
Sbj_BIDSfiles.data_root = fullfile(main_root,'PROJECTS_DATA');
Sbj_BIDSfiles.project_name = project_name;
Sbj_BIDSfiles.project_root = fullfile(Sbj_BIDSfiles.data_root,project_name);
Sbj_BIDSfiles.sbjDir = fullfile(Sbj_BIDSfiles.data_root,project_name, sbj_ID);
Sbj_BIDSfiles.rawdata = fullfile(Sbj_BIDSfiles.data_root,project_name, sbj_ID, 'raw');
Sbj_BIDSfiles.params_dir = fullfile(Sbj_BIDSfiles.data_root,project_name, sbj_ID, 'params');
Sbj_BIDSfiles.iEEG_data = fullfile(Sbj_BIDSfiles.data_root,project_name, sbj_ID, 'iEEG_data');
Sbj_BIDSfiles.results = fullfile(Sbj_BIDSfiles.data_root,project_name, sbj_ID, 'results');
Sbj_BIDSfiles.BlockLists = makeBlockLists(Sbj_BIDSfiles);

if strcmp(project_name,'Speech_Perception') || strcmp(project_name,'ObjectNaming') || strcmp(project_name,'EntrainSounds')
    Sbj_BIDSfiles.behavioral_root = fullfile(Sbj_BIDSfiles.data_root,project_name, sbj_ID, 'behavioral');
end


% Define Freesurfer folder
if strcmp(sbj_ID,'NS140_2')
    Sbj_BIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS140_02');
    Sbj_BIDSfiles.fsname = 'NS140_02';
elseif strcmp(sbj_ID,'NS128_2')
    Sbj_BIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS128_02');
    Sbj_BIDSfiles.fsname = 'NS128_02';
elseif strcmp(sbj_ID,'NS144_2')
    Sbj_BIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS144_02');
    Sbj_BIDSfiles.fsname = 'NS144_02';
elseif strcmp(sbj_ID,'NS142_2')
    Sbj_BIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS142_02');
    Sbj_BIDSfiles.fsname = 'NS142_02';
elseif strcmp(sbj_ID,'NS148_2')
    Sbj_BIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS148_02');
    Sbj_BIDSfiles.fsname = 'NS148_02';
elseif strcmp(sbj_ID,'NS151_2')
    Sbj_BIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS148_02');
    Sbj_BIDSfiles.fsname = 'NS151_02';
elseif strcmp(sbj_ID,'NS127_2')
    Sbj_BIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS127_02');
    Sbj_BIDSfiles.fsname = 'NS127_02';
elseif strcmp(sbj_ID,'LH001_2')
    Sbj_BIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','LH001_02');
    Sbj_BIDSfiles.fsname = 'LH001_02';
elseif strcmp(sbj_ID,'NS160_2')
    Sbj_BIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS160_02');
    Sbj_BIDSfiles.fsname = 'NS160_02';
else
    Sbj_BIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer',sbj_ID);
    Sbj_BIDSfiles.fsname = sbj_ID;
end

% Define fsaverage folder
Sbj_BIDSfiles.fsaverage_Dir = fullfile(main_root, 'DERIVATIVES','freesurfer','fsaverage');

if ~exist(Sbj_BIDSfiles.freesurfer,'dir')
    warning('There is no Freesurfer folder')
    Sbj_BIDSfiles.freesurfer = [];
end

searchExcel = dir(fullfile(Sbj_BIDSfiles.freesurfer,'elec_recon'));
for i = 1:length(searchExcel)
    tpm_2(i) = contains(searchExcel(i).name, '.xlsx') & contains(searchExcel(i).name, 'corr','IgnoreCase',true);
end
if ~exist('tpm_2','var') || sum(tpm_2) ~= 1
    warning('There is either no Electrode correspondence sheet or there are many excel sheets, check and run again')
else
    Sbj_BIDSfiles.labelfile = fullfile(Sbj_BIDSfiles.freesurfer,'elec_recon', searchExcel(tpm_2).name);
end

mkdir_Sbj_Metadata(Sbj_BIDSfiles)

end