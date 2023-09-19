%% constructing directories
data_root = '/media/sakkol/HDD1/HBML/';
project_names = {'Rest','Speech_Perception','Auditory_Localizer','CL_Train','new_project_name'};
construct_roots(data_root,project_names)

%% Creating Sbj_Metadata:
data_root = '/media/sakkol/HDD1/HBML/';
% project_name = 'Rest';
% project_name = 'CL_Train';
% project_name = 'Speech_Perception';
% project_name = 'Auditory_Localizer';
project_name = 'EntrainSounds';
sbj_ID = 'NS1LH001_248_2';
Sbj_Metadata = makeSbj_Metadata(data_root, project_name, sbj_ID); % 'SAkkol_Stanford'

%% Choose block
curr_block = Sbj_Metadata.BlockLists{2};

%% Create bulk directories for multiple subjects

blockinfotable = readtable(fullfile(data_root,'PROJECTS_DATA',project_name,[project_name '_BlockInfo.xlsx']));

subs = blockinfotable.sbj_ID;
for s = 1:length(subs)
    Sbj_Metadata = makeSbj_Metadata(data_root, project_name, subs{s}); % 'SAkkol_Stanford'
    mkdir_Sbj_Metadata(Sbj_Metadata)
end

clear blockinfotable subs Sbj_Metadata
%% create_elecinfo example, this can stay here for rapidity
data_root = '/media/sakkol/HDD1/HBML/';
sbj_ID = 'NS170';

cfg=[];
cfg.subj_folder = fullfile(data_root,'DERIVATIVES','freesurfer',sbj_ID);
cfg.fsaverage_dir = fullfile(data_root,'DERIVATIVES','freesurfer','fsaverage');
cfg.FS_atlas_info = fullfile(data_root,'DERIVATIVES','freesurfer','Freesurfer_Atlas_Labels.xlsx');
create_elecInfo(sbj_ID, cfg)

%% running iELVis functions if necessary
sbj_ID = 'NS120';

% for dykstra
cfg=[];
cfg.subj_folder = fullfile(data_root,'DERIVATIVES','freesurfer',sbj_ID);
dykstraElecPjctmgridCoords_server(sbj_ID,0,cfg.subj_folder)

% for yang-wang
makeIniLocTxtFile(sbj_ID,'mgrid',[])
yangWangElecPjct(sbj_ID)

% for plotting depth electrode slices
cfg=[];
cfg.printFigs=1;
plotAllDepthsOnSlices(sbj_ID,'mgrid',cfg)

% for fsaverage electrode coordinates
cfg=[];
cfg.outputTextfile = 1;
sub2AvgBrain(sbj_ID,cfg);
close all

%% Ploting easy to do
cfg=[];
cfg.view='r';           % change this if it is unilateral/bilateral: romni/lomni/omni
cfg.showLabels='y';
cfg.elecShape = 'sphere';
cfg.elecSize = 1.5;
cfg.ignoreDepthElec = 'n';
cfg.pullOut = 0;
cfg.title='';
cfg.fsurfSubDir = erase(Sbj_Metadata.freesurfer,Sbj_Metadata.fsname);
cfg.opaqueness = .8;
% cfg.elecColors = 'r';
plotPialSurf(Sbj_Metadata.fsname,cfg);

% print(fullfile('/media/sakkol/HDD1/[PERSONAL]/Thesis_Figures','144_2_subdural_red'),'-djpeg','-r300')