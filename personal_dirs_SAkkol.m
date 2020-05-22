%% constructing directories
data_root = '/media/sakkol/HDD1/HBML/';
project_names = {'Rest','Speech_Perception','Auditory_Localizer','CL_Train','new_project_name'};
construct_roots(data_root,project_names)

%% Creating Sbj_Metadata:
data_root = '/media/sakkol/HDD1/HBML/';
project_name = 'Rest';
project_name = 'CL_Train';
project_name = 'Speech_Perception';
project_name = 'Auditory_Localizer';
sbj_ID = 'NS148_2';
Sbj_Metadata = makeSbj_Metadata(data_root, project_name, sbj_ID); % 'SAkkol_Stanford'

%% Choose block
curr_block = Sbj_Metadata.BlockLists{2};

%% create_elecinfo example, this can stay here for rapidity
data_root = '/media/sakkol/HDD1/HBML/';
sbj_name = 'NS148_02';

cfg=[];
cfg.subj_folder = fullfile(data_root,'DERIVATIVES','freesurfer',sbj_name);
cfg.fsaverage_dir = '/media/sakkol/HDD1/HBML/DERIVATIVES/freesurfer/fsaverage';
cfg.FS_atlas_info = '/media/sakkol/HDD1/HBML/DERIVATIVES/freesurfer/Freesurfer_Atlas_Labels.xlsx';
% '/media/sakkol/HDD1/HBML/PROJECTS_DATA/Speech_Perception/NS144_2/NS144_2_Electrodes_Natus_TDT_correspondence.xlsx'
create_elecInfo(sbj_name, cfg)

%% running iELVis functions if necessary
dykstraElecPjctmgridCoords_server(sbj_name,0,cfg.subj_folder)

makeIniLocTxtFile(sbj_name,'mgrid',[])
yangWangElecPjct(sbj_name)

%% Ploting easy to do
cfg=[];
cfg.view='romni';           % change this if it is unilateral/bilateral: romni/lomni/omni
cfg.showLabels='y';
cfg.elecShape = 'sphere';
cfg.elecSize = 1.5;
cfg.ignoreDepthElec = 'n';
cfg.pullOut = 0;
cfg.title='';
% cfg.fsurfSubDir = erase(Sbj_Metadata.freesurfer,Sbj_Metadata.fsname);
cfg.opaqueness = 0.7;
% cfg.elecColors = 'r';
plotPialSurf(Sbj_Metadata.fsname,cfg);

print(fullfile('/media/sakkol/HDD1/[PERSONAL]/Thesis_Figures','144_2_subdural_red'),'-djpeg','-r300')