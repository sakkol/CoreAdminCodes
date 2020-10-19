# CoreAdminCodes
Matlab-based administrative functions to generate and manage the folders and files for different projects with common structure.

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

## Helper Functions

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
- Another important highlight of the CoreAdminCores is Sbj_Metadata structure. 
