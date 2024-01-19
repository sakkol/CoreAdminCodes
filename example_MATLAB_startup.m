%% INFO
% This is a scaffold startup file that can be used to include all
% necessary folders/files each time Matlab restarts. Can be placed in
% \Documents\MATLAB\ folder in Windows and $userhome$/Documents/MATLAB
% folder in Ubuntu/Linux.

%% FOLDERS
% For Fieldtrip
clear
cd('/home/sakkol/Documents/Codes_git/fieldtrip')
ft_defaults
clc

% For GitHub folders
addpath(genpath('/home/sakkol/Documents/Codes_git/CoreAdminCodes'))
addpath(genpath('/home/sakkol/Documents/Codes_git/JSONio-master'))
addpath(genpath('/home/sakkol/Documents/Codes_git/EPIPROC'))
addpath(genpath('/home/sakkol/Documents/Codes_git/iELVis'))
addpath(genpath('/home/sakkol/Documents/Codes_git/SA_Project_Media'))
addpath(genpath('/home/sakkol/Documents/Codes_git/Speech_Perception'))

%% FREESURFER
fshome = getenv('FREESURFER_HOME');
fsmatlab = sprintf('%s/matlab',fshome);
if (exist(fsmatlab) == 7)
    addpath(genpath(fsmatlab));
end
clear fshome fsmatlab;

fsfasthome = getenv('FSFAST_HOME');
fsfasttoolbox = sprintf('%s/toolbox',fsfasthome);
if (exist(fsfasttoolbox) == 7)
    path(path,fsfasttoolbox);
end
clear fsfasthome fsfasttoolbox;

%% iELVis
global globalFsDir;
globalFsDir = '/media/sakkol/HDD1/HBML/DERIVATIVES/freesurfer';

%% Change directory back to where GitHub folders are
cd('/home/sakkol/Documents/Codes_git')