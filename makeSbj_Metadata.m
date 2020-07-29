function Sbj_Metadata = makeSbj_Metadata(main_root, project_name, sbj_ID)
% based on InitializeSbj_Metadata.m (Pedro Pinheiro-Chagas, LBCN - 2019)
% written by SAkkol - HBML, 2019

Sbj_Metadata = [];
Sbj_Metadata.sbj_ID = sbj_ID;
Sbj_Metadata.data_root = fullfile(main_root,'PROJECTS_DATA');
Sbj_Metadata.project_name = project_name;
Sbj_Metadata.project_root = fullfile(Sbj_Metadata.data_root,project_name);
Sbj_Metadata.sbjDir = fullfile(Sbj_Metadata.data_root,project_name, sbj_ID);
Sbj_Metadata.rawdata = fullfile(Sbj_Metadata.data_root,project_name, sbj_ID, 'raw');
Sbj_Metadata.params_dir = fullfile(Sbj_Metadata.data_root,project_name, sbj_ID, 'params');
Sbj_Metadata.iEEG_data = fullfile(Sbj_Metadata.data_root,project_name, sbj_ID, 'iEEG_data');
Sbj_Metadata.results = fullfile(Sbj_Metadata.data_root,project_name, sbj_ID, 'results');
Sbj_Metadata.BlockLists = makeBlockLists(Sbj_Metadata);

if strcmp(project_name,'Speech_Perception') || strcmp(project_name,'ObjectNaming')
    Sbj_Metadata.behavioral_root = fullfile(Sbj_Metadata.data_root,project_name, sbj_ID, 'behavioral');
end


% Define Freesurfer folder
if strcmp(sbj_ID,'NS140_2')
    Sbj_Metadata.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS140_02');
    Sbj_Metadata.fsname = 'NS140_02';
elseif strcmp(sbj_ID,'NS128_2')
    Sbj_Metadata.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS128_02');
    Sbj_Metadata.fsname = 'NS128_02';
elseif strcmp(sbj_ID,'NS144_2')
    Sbj_Metadata.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS144_02');
    Sbj_Metadata.fsname = 'NS144_02';
elseif strcmp(sbj_ID,'NS148_2')
    Sbj_Metadata.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS148_02');
    Sbj_Metadata.fsname = 'NS148_02';
elseif strcmp(sbj_ID,'NS151_2')
    Sbj_Metadata.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS148_02');
    Sbj_Metadata.fsname = 'NS151_02';
elseif strcmp(sbj_ID,'NS127_2')
    Sbj_Metadata.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer','NS127_02');
    Sbj_Metadata.fsname = 'NS127_02';
else
    Sbj_Metadata.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer',sbj_ID);
    Sbj_Metadata.fsname = sbj_ID;
end

% Define fsaverage folder
Sbj_Metadata.fsaverage_Dir = fullfile(main_root, 'DERIVATIVES','freesurfer','fsaverage');

if ~exist(Sbj_Metadata.freesurfer,'dir')
    warning('There is no Freesurfer folder')
    Sbj_Metadata.freesurfer = [];
end

searchExcel = dir(Sbj_Metadata.sbjDir);
for i = 1:length(searchExcel)
    tpm_2(i) = contains(searchExcel(i).name, '.xlsx') & contains(searchExcel(i).name, 'corr','IgnoreCase',true);
end
if sum(tpm_2) ~= 1
    warning('There is either no Electrode correspondence sheet or there are many excel sheets, check and run again')
    return
else
    Sbj_Metadata.labelfile = fullfile(Sbj_Metadata.sbjDir, searchExcel(tpm_2).name);
end

mkdir_Sbj_Metadata(Sbj_Metadata)

end