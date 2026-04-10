function ieeg = edf2ieeg_bids_v2(Sbj_MetadataBIDS)
% This function is used to convert edf files to mat files in the format that
% is used by the Human Brain Mapping Lab (aka ecog), here renamed as
% "ieeg". To run the script, the struct containing subject and session
% metadata must be passed as input. This function is based on edf2ecog
% function written by awesome Noah Markowitz at HBMLab, New York in 2019.
% 
% Serdar Akkol, MD PhD
% University of Alabama at Birmingham
% April 2026
% v2: obtains the auxillary channels' data once directly from the raw edf
% and assigns them in a loop afterwards, instead of calling
% ft_preprocessing for each auxillary channel type in the original.

%% Overwrite?
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

%% Collect some info
edf = Sbj_MetadataBIDS.sourcedata_raw_edf_file;
correspondenceSheet = Sbj_MetadataBIDS.correspondenceSheet;

%% Read in correspondence sheet
disp([' --> Reading correspondence sheet ' correspondenceSheet]);
corrSheet_import = import_correspondenceSheet(correspondenceSheet);

%% Import the edf file for ieeg data first
% Set parameters for import
[eeg_ind, ~] = match_str(corrSheet_import.Channeltype,{'grid' 'hd_grid' 'depth' 'hd_depth' 'strip' 'hd_strip'});

% Construct cfg struct for importing
cfg = [];
cfg.dataset = char(edf);
cfg.continuous = 'yes';
channel_select = corrSheet_import.labels(eeg_ind);
cfg.channel = channel_select;

% Import the edf 
disp([' --> Reading EDF data ' edf]);
edfdata=ft_preprocessing(cfg);
edfdata.info.task=task;

%% iEEG data
% Set the ieeg variable 
ieeg=[];

% Add the fieldtrip
ieeg.ftrip = edfdata; clear edfdata

%% Load each auxiliary channel type independently
% Each of these will get its own ft_preprocessing call
other_types  = {'micro','emg','epidural','cranial','scalp','ecg','digital','analog','oxy','pleth','trig'};

% Read entire EDF header once
hdr = ft_read_header(char(edf));

% Read all raw data in one shot (no ft_preprocessing overhead)
raw = ft_read_data(char(edf), 'header', hdr);   % channels × samples

% Then index into raw by channel name for each type
for ot = 1:length(other_types)
    [ind, ~] = match_str(corrSheet_import.Channeltype, {other_types{ot}});
    if isempty(ind), continue; end
    chan_names = corrSheet_import.labels(ind);
    [~, raw_ind] = match_str(hdr.label, chan_names);
    ieeg.(other_types{ot}).trial{1} = raw(raw_ind, :);
    ieeg.(other_types{ot}).label    = chan_names;
    % fs must come from hdr.orig.fs per channel if the EDF stores it
    ieeg.(other_types{ot}).fs       = hdr.Fs;   % or hdr.orig.SampleRate(raw_ind(1))
end

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