function subBIDSfiles = get_subBIDSfiles(main_root, task_name, sub)
% based on makeSbj_Metadata.m (SAkkol - HBML, 2019)
% written by SAkkol - HBML, 2020

subBIDSfiles = [];
subBIDSfiles.sub = sub;
subBIDSfiles.data_root = fullfile(main_root,'PROJECTS_DATA');
subBIDSfiles.task_name = task_name;
subBIDSfiles.task_root = fullfile(subBIDSfiles.data_root,task_name);
subBIDSfiles.sbjDir = fullfile(subBIDSfiles.data_root,task_name, sub);
subBIDSfiles.rawdata = fullfile(subBIDSfiles.data_root,task_name, sub, 'raw');
subBIDSfiles.params_dir = fullfile(subBIDSfiles.data_root,task_name, sub, 'params');
subBIDSfiles.iEEG_data = fullfile(subBIDSfiles.data_root,task_name, sub, 'iEEG_data');
subBIDSfiles.results = fullfile(subBIDSfiles.data_root,task_name, sub, 'results');
subBIDSfiles.BlockLists = makeBlockLists(subBIDSfiles);

if strcmp(task_name,'Speech_Perception') || strcmp(task_name,'ObjectNaming') || strcmp(task_name,'EntrainSounds')
    subBIDSfiles.behavioral_root = fullfile(subBIDSfiles.data_root,task_name, sub, 'behavioral');
end


% Define Freesurfer folder
if strcmp(sub,'NS140_2')
    subBIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS140_02');
    subBIDSfiles.fsname = 'NS140_02';
elseif strcmp(sub,'NS128_2')
    subBIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS128_02');
    subBIDSfiles.fsname = 'NS128_02';
elseif strcmp(sub,'NS144_2')
    subBIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS144_02');
    subBIDSfiles.fsname = 'NS144_02';
elseif strcmp(sub,'NS142_2')
    subBIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS142_02');
    subBIDSfiles.fsname = 'NS142_02';
elseif strcmp(sub,'NS148_2')
    subBIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS148_02');
    subBIDSfiles.fsname = 'NS148_02';
elseif strcmp(sub,'NS151_2')
    subBIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS148_02');
    subBIDSfiles.fsname = 'NS151_02';
elseif strcmp(sub,'NS127_2')
    subBIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS127_02');
    subBIDSfiles.fsname = 'NS127_02';
elseif strcmp(sub,'LH001_2')
    subBIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','LH001_02');
    subBIDSfiles.fsname = 'LH001_02';
elseif strcmp(sub,'NS160_2')
    subBIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS160_02');
    subBIDSfiles.fsname = 'NS160_02';
else
    subBIDSfiles.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer',sub);
    subBIDSfiles.fsname = sub;
end

% Define fsaverage folder
subBIDSfiles.fsaverage_Dir = fullfile(main_root, 'DERIVATIVES','freesurfer','fsaverage');

if ~exist(subBIDSfiles.freesurfer,'dir')
    warning('There is no Freesurfer folder')
    subBIDSfiles.freesurfer = [];
end

searchExcel = dir(fullfile(subBIDSfiles.freesurfer,'elec_recon'));
for i = 1:length(searchExcel)
    tpm_2(i) = contains(searchExcel(i).name, '.xlsx') & contains(searchExcel(i).name, 'corr','IgnoreCase',true);
end
if ~exist('tpm_2','var') || sum(tpm_2) ~= 1
    warning('There is either no Electrode correspondence sheet or there are many excel sheets, check and run again')
else
    subBIDSfiles.labelfile = fullfile(subBIDSfiles.freesurfer,'elec_recon', searchExcel(tpm_2).name);
end

mkdir_Sbj_Metadata(subBIDSfiles)

end