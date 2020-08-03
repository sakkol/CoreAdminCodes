function params = create_Params(Sbj_Metadata,curr_block)

params = [];
params.task = Sbj_Metadata.project_name;
params.block = curr_block;
params.subjectID = Sbj_Metadata.sbj_ID;
params.device = 'XLtek';
params.directory = fullfile(Sbj_Metadata.rawdata, params.block);
params.filename = curr_block;
params.labelfile = Sbj_Metadata.labelfile;

% AllBlockInfo = readtable(fullfile(Sbj_Metadata.project_root,[Sbj_Metadata.project_name '_BlockInfo.xlsx']));
CurrBlockInfo = makeCurrBlockInfo(Sbj_Metadata,curr_block);
params.CurrBlockInfo = CurrBlockInfo;

if strcmp(params.task,'Rest')
    params.EEGDAT = CurrBlockInfo.EEGDAT;
elseif strcmp(params.task,'CL_train')
    params.EEGDAT = {'data.streams.Raw1' 'data.streams.Raw2'};
elseif strcmp(params.task,'Auditory_Localizer') || strcmp(params.task,'Speech_Perception') || ...
        strcmp(params.task,'ObjectNaming') || strcmp(params.task,'Efields_Alone')  || ...
        strcmp(params.task,'PassiveListening') || strcmp(params.task,'CCEP') || strcmp(params.task,'EntrainSounds')
    params.EEGDAT = CurrBlockInfo.EEGDAT;
    params.ANALOGDATA = CurrBlockInfo.ANALOGDATA;
end

if contains(params.EEGDAT, ',')
    params.EEGDAT = strsplit(params.EEGDAT{1},',');
end

if strcmp(params.task,'ObjectNaming')
    params.DIGITALDATA = CurrBlockInfo.DIGITALDATA;
    params.task_type = CurrBlockInfo.task_type;
end

% Info about this particular params.stimulation
if strcmp(Sbj_Metadata.project_name,'CL_train')
    params.stimulationexp = 1;
    params.stimulation = [];
    params.stimulation.RecCh_lab = CurrBlockInfo.RecCh_lab;
    params.stimulation.StimCh1_lab = CurrBlockInfo.StimCh1_lab;
    params.stimulation.StimCh2_lab = CurrBlockInfo.StimCh2_lab;
    params.stimulation.Amp = CurrBlockInfo.Amp_mA;
    params.stimulation.trainFreq = CurrBlockInfo.trainFreq; %Hz
    
    filthigh = CurrBlockInfo.trainFreq -2; if filthigh<0,filthigh=1;end
    filtlow = CurrBlockInfo.trainFreq +2;
    params.stimulation.RecCh_filterband = [filthigh, filtlow]; %Hz
    params.stimulation.trainNum = CurrBlockInfo.trainNum;
    params.stimulation.comments = CurrBlockInfo.comments;
    params.stimulation.peak_valley = CurrBlockInfo.peak_valley;
    params.stimulation.loop = CurrBlockInfo.open_closed;
    params.stimulation.eyes = CurrBlockInfo.eyes;
elseif strcmp(Sbj_Metadata.project_name,'CCEP') || strcmp(params.task,'Efields_Alone')
    params.stimulation = [];
    params.stimulation.RecCh_lab = CurrBlockInfo.RecCh_lab{1};
    params.stimulation.StimCh1_lab = CurrBlockInfo.StimCh_anode{1};
    params.stimulation.StimCh2_lab = CurrBlockInfo.StimCh_cathode{1};
    params.stimulation.Amp = CurrBlockInfo.Amp_mA;
    params.stimulation.pulseType = CurrBlockInfo.pulseType;
    params.stimulation.pulseCount = CurrBlockInfo.pulseCount;
    params.stimulation.Location = CurrBlockInfo.Location;
    params.stimulation.comments = CurrBlockInfo.comments;
end

params.directory = char(fullfile(Sbj_Metadata.rawdata,curr_block));
params.directoryOUT = char(fullfile(Sbj_Metadata.iEEG_data,curr_block));
params.directoryPICS = char(fullfile(Sbj_Metadata.iEEG_data,curr_block,'PICS'));

if ~exist(params.directoryOUT,'dir')
    mkdir(params.directoryOUT)
end
if ~exist(params.directoryPICS,'dir')
    mkdir(params.directoryPICS)
end

paramsfile = fullfile(Sbj_Metadata.params_dir,[Sbj_Metadata.sbj_ID '_' curr_block '_params.mat']);
params.paramsfile = paramsfile;

save(paramsfile, 'params');

end