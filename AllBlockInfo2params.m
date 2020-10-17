function [params] = AllBlockInfo2params(Sbj_Metadata,curr_block)
% With Sbj_Metadata and curr_block inputs, this function creates and saves
% the params.mat file. BlockInfo sheet is needed to be ready.

%% General part
params = [];
params.task = Sbj_Metadata.project_name;
params.block = curr_block;
params.subjectID = Sbj_Metadata.sbj_ID;
params.device = 'XLtek';
params.directory = fullfile(Sbj_Metadata.rawdata, params.block);
params.filename = curr_block;
params.labelfile = Sbj_Metadata.labelfile;
BlockInfo = makeBlockInfo(Sbj_Metadata,curr_block);
params.CurrBlockInfo = BlockInfo;

%% set the EEGDAT, ANALOGDAT and DIGITALDATA
if any(strcmpi(BlockInfo.Properties.VariableNames,'EEGDAT'))
    params.EEGDAT = BlockInfo.EEGDAT;
else
    warning('EEGDAT column in BlockInfo sheet was not found, defaults are EEG1 and EEG2')
    params.EEGDAT = {'data.streams.EEG1','data.streams.EEG2'};
end
if any(strcmpi(BlockInfo.Properties.VariableNames,'ANALOGDATA'))
    params.ANALOGDATA = BlockInfo.ANALOGDATA;
end
if any(strcmpi(BlockInfo.Properties.VariableNames,'DIGITALDATA'))
    params.DIGITALDATA = BlockInfo.DIGITALDATA;
end
if any(strcmpi(BlockInfo.Properties.VariableNames,'task_type'))
    params.task_type = BlockInfo.task_type;
end

if contains(params.EEGDAT, ',') % if it's something like "data.streams.EEG1,data.streams.EEG2", split it into different bank names
    params.EEGDAT = strsplit(params.EEGDAT{1},',');
end

%% Info about the stimulation paradigms (needed for TDT2ecog)
if any(strcmpi(BlockInfo.Properties.VariableNames,'RecCh_lab'))
    params.stimulationexp = 1;
    params.stimulation = [];
    params.stimulation.RecCh_lab = BlockInfo.RecCh_lab;
    params.stimulation.StimCh1_lab = BlockInfo.StimCh1_lab;
    params.stimulation.StimCh2_lab = BlockInfo.StimCh2_lab;
end

%% general params directories, for output of ecog from TDT/edf2ecog functions
params.directory = char(fullfile(Sbj_Metadata.rawdata,curr_block));
params.directoryOUT = char(fullfile(Sbj_Metadata.iEEG_data,curr_block));
params.directoryPICS = char(fullfile(Sbj_Metadata.iEEG_data,curr_block,'PICS'));

if ~exist(params.directoryOUT,'dir')
    mkdir(params.directoryOUT)
end
if ~exist(params.directoryPICS,'dir')
    mkdir(params.directoryPICS)
end

%% Save the file
paramsfile = fullfile(Sbj_Metadata.params_dir,[Sbj_Metadata.sbj_ID '_' curr_block '_params.mat']);
params.paramsfile = paramsfile;
save(paramsfile, 'params');

end