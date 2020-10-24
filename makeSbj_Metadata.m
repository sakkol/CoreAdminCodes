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
splsbj_ID = strsplit(sbj_ID,'_');
if length(splsbj_ID) == 1
    Sbj_Metadata.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer',sbj_ID);
    Sbj_Metadata.fsname = sbj_ID;
else
    if length(splsbj_ID{2}) > 1     % if the name is like NS128_02, this is also fine
        Sbj_Metadata.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer',sbj_ID);
        Sbj_Metadata.fsname = sbj_ID;
    else                            % if the name is like NS128_2, then put a "0" between "_" and "2"
        Sbj_Metadata.freesurfer = fullfile(main_root, 'DERIVATIVES','freesurfer',[splsbj_ID{1} '_0' splsbj_ID{2}]);
        Sbj_Metadata.fsname = sbj_ID;
    end
end
if ~exist(Sbj_Metadata.freesurfer,'dir')
    warning('There is no Freesurfer folder')
    Sbj_Metadata.freesurfer = [];
end

% Define fsaverage folder
Sbj_Metadata.fsaverage_Dir = fullfile(main_root, 'DERIVATIVES','freesurfer','fsaverage');

%% Find the electrode correspondence sheet
searchExcel = dir(fullfile(Sbj_Metadata.freesurfer,'elec_recon'));
for i = 1:length(searchExcel)
    tpm_2(i) = contains(searchExcel(i).name, '.xlsx') & contains(searchExcel(i).name, 'corr','IgnoreCase',true);
end
if ~exist('tpm_2','var') || sum(tpm_2) ~= 1
    warning('There is either no Electrode correspondence sheet or there are many excel sheets, check and run again')
else
    Sbj_Metadata.labelfile = fullfile(Sbj_Metadata.freesurfer,'elec_recon', searchExcel(tpm_2).name);
end

%% Create the directories
mkdir_Sbj_Metadata(Sbj_Metadata)

end