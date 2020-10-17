# CoreAdminCodes
Administrative functions to generate and manage the folder and file for different projects with common structure.

data_root is where 'PROJECTS_DATA' and 'DERIVATIVES' folders are located.
In 'DERIVATIVES' folder, there is freesurfer folder, where Freesurfer subject folders are located.
In 'PROJECTS_DATA' folder, there are projects' main folders. Each project folder has <PROJECT NAME>_BlockInfo.xlsx sheet and folders for each subject.

Each subject folder has raw, params, iEEG_data and results folder. 
- raw: where edf or TDT folders are located.
- params: params.mat files which are used for 2ecog functions.
- iEEG_data: where _eco.mat, _ecog_avg.mat and _ecog_bp.mat _info.mat or any other iEEG data are located.
- results: arbitrary results folder.
For each block (=run), there is one folder within raw and iEEG_data.

Each _BlockInfo.xlsx sheet has some information regarding the blocks. There is an example sheet; change and adapt it to task's needs.