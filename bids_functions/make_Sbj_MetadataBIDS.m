function Sbj_MetadataBIDS = make_Sbj_MetadataBIDS(main_root, project_name, sub, ses, task, run)
% make_Sbj_MetadataBIDS - Create BIDS metadata structure carrying file and
% folder information. This is based on makeSbj_Metadata.m but adapted for
% BIDS folder structure. Gathers and organizes all important paths for a
% BIDS dataset.
%
% USAGE:
%   Sbj_MetadataBIDS = make_Sbj_MetadataBIDS(main_root, sub, ses, task, run)
%
% INPUT:
%   main_root - Root directory of BIDS dataset
%   project_name - name of the project (e.g., 'auditorylocalizer')
%   sub - Subject ID (e.g., 'NS157')
%   ses - Session label (e.g., 'implant01')
%   task - Task name (e.g. 'auditoryLocalizer')
%   run - Order of the run for the specific task (e.g. 3)
%
% OUTPUT:
%   Sbj_MetadataBIDS - Structure containing all BIDS paths and file locations
%       Fields include:
%       - Root directories
%       - Subject/session paths
%       - Datatype directories (ieeg, beh, anat, physio)
%       - File paths for each data type
%       - Electrode and channel information paths
%
% EXAMPLE:
%   Sbj_MetadataBIDS = make_Sbj_MetadataBIDS('/path/to/bids', 'auditorylocalizer', 'NS157', 'implant01','auditoryLocalizer'.2);

%% Input validation
if ~exist(main_root, 'dir')
    error('BIDS root directory not found: %s', main_root);
end

if nargin < 5
    error('All input arguments (main_root, project_name, sbj_ID, ses, task) are required');
end

vars=who;
if ~any(ismember(vars,'run'))
    run = '01'; 
end

% convert the numberic inputs to strings
if isnumeric(ses),ses = num2str(ses);end
if isnumeric(run),run = num2str(run);end
clear vars

%% Initialize metadata structure
Sbj_MetadataBIDS = [];

%% Root level information
Sbj_MetadataBIDS.main_root = main_root;
project_root = fullfile(main_root,'PROJECTS_DATA',project_name);
Sbj_MetadataBIDS.project_root = project_root;
Sbj_MetadataBIDS.dataset_description = fullfile(project_root, 'dataset_description.json');

%% Sourcedata root directory (raw unprocessed data)
Sbj_MetadataBIDS.sourcedata_root = fullfile(project_root, 'sourcedata');
Sbj_MetadataBIDS.sourcedata_sub_dir = fullfile(Sbj_MetadataBIDS.sourcedata_root, sprintf('sub-%s', sub));
Sbj_MetadataBIDS.sourcedata_ses_dir = fullfile(Sbj_MetadataBIDS.sourcedata_sub_dir, sprintf('ses-%s', ses));

% Create sourcedata directories if they don't exist
if ~exist(Sbj_MetadataBIDS.sourcedata_ses_dir, 'dir')
    mkdir(Sbj_MetadataBIDS.sourcedata_ses_dir);
end

% Sourcedata subdirectories for different raw data types
Sbj_MetadataBIDS.sourcedata_raw_edf_dir = fullfile(Sbj_MetadataBIDS.sourcedata_ses_dir, 'raw_edf');
Sbj_MetadataBIDS.sourcedata_raw_mri_dir = fullfile(Sbj_MetadataBIDS.sourcedata_ses_dir, 'raw_mri');
Sbj_MetadataBIDS.sourcedata_raw_beh_dir = fullfile(Sbj_MetadataBIDS.sourcedata_ses_dir, 'raw_beh');
Sbj_MetadataBIDS.sourcedata_raw_physio_dir = fullfile(Sbj_MetadataBIDS.sourcedata_ses_dir, 'raw_physio');

if ~exist(Sbj_MetadataBIDS.sourcedata_raw_edf_dir, 'dir')
    mkdir(Sbj_MetadataBIDS.sourcedata_raw_edf_dir);
end
if ~exist(Sbj_MetadataBIDS.sourcedata_raw_mri_dir, 'dir')
    mkdir(Sbj_MetadataBIDS.sourcedata_raw_mri_dir);
end
if ~exist(Sbj_MetadataBIDS.sourcedata_raw_beh_dir, 'dir')
    mkdir(Sbj_MetadataBIDS.sourcedata_raw_beh_dir);
end
if ~exist(Sbj_MetadataBIDS.sourcedata_raw_physio_dir, 'dir')
    mkdir(Sbj_MetadataBIDS.sourcedata_raw_physio_dir);
end

%% Subject and session identifiers
Sbj_MetadataBIDS.sub = sub;
Sbj_MetadataBIDS.ses = ses;
Sbj_MetadataBIDS.task = task;
Sbj_MetadataBIDS.run = run;
Sbj_MetadataBIDS.project = project_name;

Sbj_MetadataBIDS.sub_label = sprintf('sub-%s', sub);
Sbj_MetadataBIDS.ses_label = sprintf('ses-%s', ses);

%% Subject/Session level directories
Sbj_MetadataBIDS.sub_dir = fullfile(project_root, Sbj_MetadataBIDS.sub_label);
Sbj_MetadataBIDS.ses_dir = fullfile(Sbj_MetadataBIDS.sub_dir, Sbj_MetadataBIDS.ses_label);

%% Datatype directories
Sbj_MetadataBIDS.ieeg_dir = fullfile(Sbj_MetadataBIDS.ses_dir, 'ieeg');
Sbj_MetadataBIDS.beh_dir = fullfile(Sbj_MetadataBIDS.ses_dir, 'beh');
Sbj_MetadataBIDS.anat_dir = fullfile(Sbj_MetadataBIDS.ses_dir, 'anat');
Sbj_MetadataBIDS.physio_dir = fullfile(Sbj_MetadataBIDS.ses_dir, 'physio');

%% Construct file prefix for BIDS naming convention
file_prefix = sprintf('%s_%s_task-%s_run-%s', Sbj_MetadataBIDS.sub_label, Sbj_MetadataBIDS.ses_label, task, run);
Sbj_MetadataBIDS.file_prefix = file_prefix;

%% iEEG files
Sbj_MetadataBIDS.ieeg = [];
Sbj_MetadataBIDS.ieeg.data = fullfile(Sbj_MetadataBIDS.ieeg_dir, [file_prefix '_ieeg.mat']);
Sbj_MetadataBIDS.ieeg.channels_tsv = fullfile(Sbj_MetadataBIDS.ieeg_dir, [file_prefix '_channels.tsv']);
Sbj_MetadataBIDS.ieeg.channels_csv = fullfile(Sbj_MetadataBIDS.ieeg_dir, [file_prefix '_channels.csv']);
Sbj_MetadataBIDS.ieeg.electrodes_tsv = fullfile(Sbj_MetadataBIDS.ieeg_dir, [file_prefix '_electrodes.tsv']);
Sbj_MetadataBIDS.ieeg.electrodes_csv = fullfile(Sbj_MetadataBIDS.ieeg_dir, [file_prefix '_electrodes.csv']);
Sbj_MetadataBIDS.ieeg.json = fullfile(Sbj_MetadataBIDS.ieeg_dir, [file_prefix '_ieeg.json']);

%% Behavioral/Events files
Sbj_MetadataBIDS.beh = [];
Sbj_MetadataBIDS.beh.events_tsv = fullfile(Sbj_MetadataBIDS.beh_dir, [file_prefix '_events.tsv']);
Sbj_MetadataBIDS.beh.events_csv = fullfile(Sbj_MetadataBIDS.beh_dir, [file_prefix '_events.csv']);
Sbj_MetadataBIDS.beh.events_json = fullfile(Sbj_MetadataBIDS.beh_dir, [file_prefix '_events.json']);

%% Anatomical files
Sbj_MetadataBIDS.anat = [];
Sbj_MetadataBIDS.anat.T1w = fullfile(Sbj_MetadataBIDS.anat_dir, [sprintf('%s_%s_T1w', Sbj_MetadataBIDS.sub_label, Sbj_MetadataBIDS.ses_label) '.nii.gz']);
Sbj_MetadataBIDS.anat.T1w_json = fullfile(Sbj_MetadataBIDS.anat_dir, [sprintf('%s_%s_T1w', Sbj_MetadataBIDS.sub_label, Sbj_MetadataBIDS.ses_label) '.json']);

%% Physiology files (non-standard BIDS)
Sbj_MetadataBIDS.physio = [];
Sbj_MetadataBIDS.physio.data_tsv = fullfile(Sbj_MetadataBIDS.physio_dir, [file_prefix '_physio.tsv']);
Sbj_MetadataBIDS.physio.data_csv = fullfile(Sbj_MetadataBIDS.physio_dir, [file_prefix '_physio.csv']);
Sbj_MetadataBIDS.physio.json = fullfile(Sbj_MetadataBIDS.physio_dir, [file_prefix '_physio.json']);

%% Additional metadata files
Sbj_MetadataBIDS.participants_tsv = fullfile(project_root, 'participants.tsv');
Sbj_MetadataBIDS.participants_json = fullfile(project_root, 'participants.json');
Sbj_MetadataBIDS.README = fullfile(project_root, 'README');
Sbj_MetadataBIDS.CHANGES = fullfile(project_root, 'CHANGES');
Sbj_MetadataBIDS.scans_tsv = fullfile(Sbj_MetadataBIDS.sub_dir, [Sbj_MetadataBIDS.sub_label '_scans.tsv']);

%% Find the edf file for this run
Sbj_MetadataBIDS.sourcedata_raw_edf_file = find_edf_bids(Sbj_MetadataBIDS);

%% set the Freesurfer and iELVis folders
% Define Freesurfer folder
[Sbj_MetadataBIDS.freesurfer, Sbj_MetadataBIDS.fsname] = find_freesurfer_dir_name(main_root, sub);

% Define fsaverage folder
Sbj_MetadataBIDS.fsaverage_Dir = fullfile(main_root, 'DERIVATIVES','freesurfer','fsaverage');

% Find the electrode correspondence sheet
Sbj_MetadataBIDS.correspondenceSheet = find_correspondenceSheet(Sbj_MetadataBIDS);

%% Create a results folder
Sbj_MetadataBIDS.results_dir = fullfile(project_root,'results');

%% Helper function: create all main required directories 
mkdir_Sbj_MetadataBIDS(Sbj_MetadataBIDS)
% Sbj_MetadataBIDS.directories_exist = check_bids_directories(Sbj_MetadataBIDS);

%% Helper function: List all files in session directory
Sbj_MetadataBIDS.files = get_session_files(Sbj_MetadataBIDS);

fprintf('BIDS Metadata structure created for %s/%s (task: %s)\n', ...
    Sbj_MetadataBIDS.sub_label, Sbj_MetadataBIDS.ses_label, task);

end

% %% Helper function: Check if directories exist
% function exist_status = check_bids_directories(BIDS_Metadata)
% exist_status = [];
% exist_status.ses_dir = exist(BIDS_Metadata.ses_dir, 'dir') == 7;
% exist_status.ieeg_dir = exist(BIDS_Metadata.ieeg_dir, 'dir') == 7;
% exist_status.beh_dir = exist(BIDS_Metadata.beh_dir, 'dir') == 7;
% exist_status.anat_dir = exist(BIDS_Metadata.anat_dir, 'dir') == 7;
% exist_status.physio_dir = exist(BIDS_Metadata.physio_dir, 'dir') == 7;
% exist_status.all_exist = all(struct2array(exist_status));
% end

%% Helper function: List all files in session directory
function files = get_session_files(BIDS_Metadata)
if exist(BIDS_Metadata.ses_dir, 'dir')
    d = dir(BIDS_Metadata.ses_dir);
    file_list = {d(~[d.isdir]).name}';
    files = file_list;
else
    files = {};
end
end
