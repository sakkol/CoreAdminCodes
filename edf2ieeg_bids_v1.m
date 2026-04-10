function ieeg = edf2ieeg_bids_v1(Sbj_MetadataBIDS)
% This function is used to convert edf files to mat files in the format that
% is used by the Human Brain Mapping Lab (aka ecog), here renamed as
% "ieeg". To run the script, the struct containing subject and session
% metadata must be passed as input. This function is based on edf2ecog
% function written by awesome Noah Markowitz at HBMLab, New York in 2019.
% 
% Serdar Akkol, MD PhD
% University of Alabama at Birmingham
% April 2026

%% Collect some info
edf = Sbj_MetadataBIDS.sourcedata_raw_edf_file;
correspondenceSheet = Sbj_MetadataBIDS.correspondenceSheet;

% Overwrite?
if exist(Sbj_MetadataBIDS.ieeg.data,'file')
    sense = 0;
    while sense == 0
        question = 'The ""ieeg.mat"" file exists already. Redo pre-processing and overwrite?';
        questTitle = 'Redo pre-processing?';
        button1 = 'YES. I don''t care';
        button2 = 'NO!! Get me out of here';
        answer = questdlg(question, questTitle, button1, button2, button2);

        if strcmp(answer,'YES. I don''t care')
            sense = 1;
            disp([' --> Ok. Re-processing then overwriting ' Sbj_MetadataBIDS.ieeg.data]);
        elseif strcmp(answer,'NO!! Get me out of here')
            error(' >> Exit; You chose not to overwrite the existing mat file.');
        end
    end
end

%% Read in correspondence sheet
disp([' --> Reading correspondence sheet ' correspondenceSheet]);
corrSheet_import = import_correspondenceSheet(correspondenceSheet);
fields = fieldnames(corrSheet_import);
has_xltek = ~isnan(corrSheet_import.Natus_nr);
for labN = 2:length(fields)
    col = fields{labN};
    corrSheet_import.(col) = corrSheet_import.(col)(has_xltek);
end

%% Set parameters for import
% Construct cfg struct for importing
cfg = [];
cfg.dataset = char(edf);
cfg.continuous = 'yes';
channel_select = corrSheet_import.labels;
cfg.channel = channel_select;

%% Import the edf file
disp([' --> Reading EDF data ' edf]);
edfdata=ft_preprocessing(cfg);
edfdata.info.task=task;

%% Import all depth and strips/grids, based on xls sheet.
[eeg_ind, ~] = match_str(corrSheet_import.Channeltype,{'grid' 'hd_grid' 'depth' 'hd_depth' 'strip' 'hd_strip'});
eeg_chan_length = length(eeg_ind);
eeg = edfdata.trial{1,1};
eeg=eeg(eeg_ind,:);
label=corrSheet_import.labels(eeg_ind);
fs = edfdata.fsample;

%% iEEG data
% Set the ieeg variable 
ieeg=[];

% Add the fieldtrip
ieeg.ftrip.fsample    = fs;
ieeg.ftrip.nChans     = eeg_chan_length;
ieeg.ftrip.label      = label;
ieeg.ftrip.trial      = {eeg};
ieeg.ftrip.time{1}    = edfdata.time{1,1};

%% Import Micro-electrodes if present (in xls sheet)
[micro_ind, ~] = match_str(corrSheet_import.Channeltype,{'micro'});
if ~isempty(micro_ind)

    micro = edfdata.trial{1,1}(micro_ind,:);
    ieeg.micro.fs  = edfdata.fsample;

    ieeg.micro.trial{1}=micro;
    ieeg.micro.label=corrSheet_import.labels(micro_ind);
end
clear micro micro_ind

%% Import EMG if present (in xls sheet)
[emg_ind, ~] = match_str(corrSheet_import.Channeltype,{'emg'});
if ~isempty(emg_ind)

    emg = edfdata.trial{1,1}(emg_ind,:);
    ieeg.emg.fs  = edfdata.fsample;

    ieeg.emg.trial{1}=emg;
    ieeg.emg.label=corrSheet_import.labels(emg_ind);
end
clear emg emg_ind

%% Import Epidural if present (in xls sheet)
[dural_ind, ~] = match_str(corrSheet_import.Channeltype,{'epidural'});
if ~isempty(dural_ind)

    dural = edfdata.trial{1,1}(dural_ind,:);
    ieeg.epidural.fs  = edfdata.fsample;

    ieeg.epidural.trial{1}=dural;
    ieeg.epidural.label=corrSheet_import.labels(dural_ind);
end
clear dural dural_ind

%% Import Epicranial if present (in xls sheet)
[cranial_ind, ~] = match_str(corrSheet_import.Channeltype,{'cranial'});
if ~isempty(cranial_ind)

    cranial = edfdata.trial{1,1}(cranial_ind,:);
    ieeg.cranial.fs  = edfdata.fsample;

    ieeg.cranial.trial{1}=cranial;
    ieeg.cranial.label=corrSheet_import.labels(cranial_ind);
end
clear cranial cranial_ind

%% Import Scalp if present (in xls sheet)
[scalp_ind, ~] = match_str(corrSheet_import.Channeltype,{'scalp'});
if ~isempty(scalp_ind)

    scalp = edfdata.trial{1,1}(scalp_ind,:);
    ieeg.scalp.fs  = edfdata.fsample;

    ieeg.scalp.trial{1}=scalp;
    ieeg.scalp.label=corrSheet_import.labels(scalp_ind);
end
clear scalp scalp_ind

%% Import ECG if present (in xls sheet)
[ecg_ind, ~] = match_str(corrSheet_import.Channeltype,{'ecg'});
if ~isempty(ecg_ind)

    ecg = edfdata.trial{1,1}(ecg_ind,:);
    ieeg.ecg.fs  = edfdata.fsample;

    ieeg.ecg.trial{1}=ecg;
    ieeg.ecg.label=corrSheet_import.labels(ecg_ind);
end
clear ecg ecg_ind

%% Import Analog Channels
[analog_ind, ~] = match_str(corrSheet_import.Channeltype,{'analog'});
if ~isempty(analog_ind)

    analog = edfdata.trial{1,1}(analog_ind,:);
    ieeg.analog.fs  = edfdata.fsample;

    ieeg.analog.trial{1}=analog;
    ieeg.analog.label=corrSheet_import.labels(analog_ind);
end
clear analog analog_ind

%% Import Digital Channels
[digital_ind, ~] = match_str(corrSheet_import.Channeltype,{'digital'});
if ~isempty(digital_ind)

    digital = edfdata.trial{1,1}(digital_ind,:);
    ieeg.digital.fs  = edfdata.fsample;

    ieeg.digital.trial{1}=digital;
    ieeg.digital.label=corrSheet_import.labels(digital_ind);
end
clear digital digital_ind

%% Collect some output
ieeg.fsurf_subname    = Sbj_MetadataBIDS.sub;
ieeg.filename         = Sbj_MetadataBIDS.ieeg.data;
ieeg.edf_filepath     = edf;
ieeg.task             = Sbj_MetadataBIDS.task;
ieeg.corrSheet_import = corrSheet_import;

% ieeg.szr_onset_chans    = labelimport.labels(labelimport.soz==1);
% ieeg.bad_chans          = [labelimport.labels(labelimport.bad ==1 & labelimport.out==1)];
% ieeg.spike_chans        = labelimport.labels(labelimport.spikey==1);

%% Write the sidecar json file
fprintf('Creating sidecar JSON file...\n');
json_sidecar = [];
json_sidecar.TaskName = Sbj_MetadataBIDS.task;
json_sidecar.TaskDescription = Sbj_MetadataBIDS.task;
json_sidecar.Modality = 'ieeg';
json_sidecar.RepetitionTime = 1;  % Sampling rate - update based on actual data
json_sidecar.EchoTime = 0;
json_sidecar.SamplingFrequency = ieeg.ftrip.fsample;  % Update based on actual sampling rate
json_sidecar.PowerLineFrequency = 60;
json_sidecar.Manufacturer = 'Unknown';
json_sidecar.ManufacturersModelName = 'Unknown';
json_sidecar.InstitutionName = '';
json_sidecar.InstitutionAddress = '';

json_sidecar_file = Sbj_MetadataBIDS.ieeg.json;
bids_create_sidecar_json(json_sidecar, json_sidecar_file);
ieeg.json_sidecar = json_sidecar;

%% Finally save
disp([' --> Saving ieeg variable to: ' Sbj_MetadataBIDS.ieeg.data]);
save(Sbj_MetadataBIDS.ieeg.data,'ieeg','-v7.3');

end