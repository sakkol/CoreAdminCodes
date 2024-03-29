function Sbj_Metadata = makeSbj_Metadata(main_root, project_name, sbj_ID)
% based on InitializeSbj_Metadata.m (Pedro Pinheiro-Chagas, LBCN - 2019)
% written by SAkkol - HBML, 2019

%% Main part
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
Sbj_Metadata.behavioral_root = fullfile(Sbj_Metadata.data_root,project_name, sbj_ID, 'behavioral');

Sbj_Metadata.BlockLists = makeBlockLists(Sbj_Metadata); % block names from the same subjects

%% Define Freesurfer folder
[Sbj_Metadata.freesurfer, Sbj_Metadata.fsname] = find_freesurfer_dir_name(main_root, sbj_ID);

%% Define fsaverage folder
Sbj_Metadata.fsaverage_Dir = fullfile(main_root, 'DERIVATIVES','freesurfer','fsaverage');

%% Find the electrode correspondence sheet
Sbj_Metadata.labelfile = find_labelfile(Sbj_Metadata.freesurfer);

%% Create the directories
mkdir_Sbj_Metadata(Sbj_Metadata)

end