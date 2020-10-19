# CoreAdminCodes
Matlab-based administrative functions to generate and manage the folders and files for different projects using common structure.

## Folder Structure
data_root is where 'PROJECTS_DATA' and 'DERIVATIVES' folders are located.
In 'DERIVATIVES' folder, there is freesurfer folder, where Freesurfer subject folders are located.
In 'PROJECTS_DATA' folder, there are projects' main folders. Each project folder has "*PROJECTNAME_BlockInfo.xlsx*" sheet and folders for each subject.

Each subject folder has raw, params, iEEG_data and results folder. 
- raw: where edf or TDT folders are located. In raw, there is one folder for each block (=run).
- params: where params.mat files which are used for converting raw files to ecog format.
- iEEG_data: where there is one folder for each block (=run). Within each block folder, there are "*BLOCKNAME_ecog.mat*", "*BLOCKNAME_ecog_avg.mat*", "*BLOCKNAME_ecog_bp.mat*" and "*BLOCKNAME_info.mat*" or any other iEEG data are located.
- results: arbitrary results folder.

For each block (=run), there is one folder within raw and iEEG_data.

Each "*PROJECTNAME_BlockInfo.xlsx*" sheet has some information regarding the blocks. There is an example sheet; change and adapt it to task's needs.

Following example folder structure is for **ObjectNaming** project with subject ID **NS157** that has 1 block called **ObjNaming**:

```bash
└── MAIN_DIR
    ├── DERIVATIVES
    │   └── freesurfer
    │       └── NS157
    │           ├── elec_recon
    │           ├── label
    │           ├── mri
    │           ├── scripts
    │           ├── stats
    │           ├── surf
    │           └── touch
    └── PROJECTS_DATA
        └── ObjectNaming
            ├── NS157
            │   ├── behavioral
            │   │   ├── ObjNaming
            │   │   │   └── ObjNaming_events.csv
            │   │   ├── Reading1
            │   │   │   └── Reading1_events.csv
            │   │   └── Reading2
            │   │       └── Reading2_events.csv
            │   ├── iEEG_data
            │   │   ├── ObjNaming
            │   │   │   ├── ObjNaming_ecog_avg.mat
            │   │   │   ├── ObjNaming_ecog_bp.mat
            │   │   │   ├── ObjNaming_ecog.mat
            │   │   │   ├── ObjNaming_info.mat
            │   │   │   ├── ObjNaming_wlt.mat
            │   │   │   └── PICS
            │   │   │       └── events.jpg
            │   ├── params
            │   │   ├── NS157_ObjNaming_params.mat
            │   ├── raw
            │   │   ├── ObjNaming
            │   │   │   └── ObjNaming.edf
            │   └── results
            │       └── Quick_results
            └── ObjectNaming_BlockInfo.xlsx
```

## Common Helper Functions & Metadata

personal_dirs_SAkkol.m script has examples for common functions used for each project:
- If switching to a new hard-drive or computer, new folders can be created like this:
``` Matlab
%% constructing directories
data_root = '/media/sakkol/HDD1/HBML/';
project_names = {'Rest','project_name1','project_name2','project_name3'};
construct_roots(data_root,project_names)
```
- In any "*pipeline_PROJECTNAME.m*" script, following code must be used to create Sbj_Metadata structure.
``` Matlab
%% Creating Sbj_Metadata:
data_root = '/media/sakkol/HDD1/HBML/';
project_name = 'Rest';
sbj_ID = 'sbj_ID1';
Sbj_Metadata = makeSbj_Metadata(data_root, project_name, sbj_ID); % 'SAkkol_Stanford'
```
- Another important highlight of the CoreAdminCores is Sbj_Metadata structure. Sbj_Metadata contains necessary directories where the files are located and paths to several important files. An example Sbj_Metadata is the following:
``` Matlab
Sbj_Metadata = 
  struct with fields:

             sbj_ID: 'NS157'
          data_root: '/media/sakkol/HDD1/HBML/PROJECTS_DATA'
       project_name: 'ObjectNaming'
       project_root: '/media/sakkol/HDD1/HBML/PROJECTS_DATA/ObjectNaming'
             sbjDir: '/media/sakkol/HDD1/HBML/PROJECTS_DATA/ObjectNaming/NS157'
            rawdata: '/media/sakkol/HDD1/HBML/PROJECTS_DATA/ObjectNaming/NS157/raw'
         params_dir: '/media/sakkol/HDD1/HBML/PROJECTS_DATA/ObjectNaming/NS157/params'
          iEEG_data: '/media/sakkol/HDD1/HBML/PROJECTS_DATA/ObjectNaming/NS157/iEEG_data'
            results: '/media/sakkol/HDD1/HBML/PROJECTS_DATA/ObjectNaming/NS157/results'
    behavioral_root: '/media/sakkol/HDD1/HBML/PROJECTS_DATA/ObjectNaming/NS157/behavioral'
         BlockLists: {3×1 cell}
         freesurfer: '/media/sakkol/HDD1/HBML/DERIVATIVES/freesurfer/NS157'
             fsname: 'NS157'
      fsaverage_Dir: '/media/sakkol/HDD1/HBML/DERIVATIVES/freesurfer/fsaverage'
          labelfile: '/media/sakkol/HDD1/HBML/DERIVATIVES/freesurfer/NS157/elec_recon/NS157_Electrodes_Natus_TDT_correspondence.xlsx'
```
- Several examples how Sbj_Metadata structure can be helpful:
``` Matlab
% Loading data:
load(fullfile(Sbj_Metadata.iEEG_data, curr_block, [curr_block '_ecog.mat']))
load(fullfile(Sbj_Metadata.iEEG_data,curr_block,[curr_block '_info.mat']))

% Saving data
save(fullfile(Sbj_Metadata.iEEG_data, curr_block, [curr_block '_ecog.mat']),'ecog','-v7.3');
print(fullfile(Sbj_Metadata.iEEG_data,curr_block,'PICS','events.jpg'),'-djpeg','-r300')

% Running analysis with fewer inputs
pre  = 1;
post = 4.5;
run_waveletTF(Sbj_Metadata,blockname);
```
- Another important aspect is to have the "*PROJECTNAME_BlockInfo.xlsx*" sheet, which has information for each blocks (=runs).
``` Matlab
% Selecting subjects directly from BlockInfo sheet
data_root = '/media/sakkol/HDD1/HBML/';
project_name = 'Rest';
AllBlockInfo = readtable(fullfile(data_root,'PROJECTS_DATA',project_name,[project_name '_BlockInfo.xlsx']));
subjects = unique(AllBlockInfo.sbj_ID);
[indx,~] = listdlg('ListString',subjects);

% Combined with Sbj_Metadata, it's easy to run anything in loop
for s = 1:length(indx)
    sbj_ID = subjects{indx(s)};
    Sbj_Metadata = makeSbj_Metadata(data_root, project_name, sbj_ID); % 'SAkkol_Stanford'
    whichblocks = AllBlockInfo.BlockList(ismember(AllBlockInfo.sbj_ID,sbj_ID) & AllBlockInfo.ready==1 & isnan(AllBlockInfo.wlt_ready));
    for b = 1:length(whichblocks)
        curr_block = whichblocks{b};
        fprintf('Running wavelet for %s: block %s\n',sbj_ID,curr_block)
        run_wltTF(Sbj_Metadata,curr_block)
    end
end
```
