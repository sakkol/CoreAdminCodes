function [data2bids_output] = ecog2bids(cfg,ecog,info)
% This function creates a BIDS formatted folder structure using the
% information in ecog and info variables. Only requirement for cfg
% is "bidsroot" field, which points out where BIDS root is (=where)
% subject folders are.

%% Input check
if isstring(ecog)
    fprintf('Assuming input ecog is an ecog filename. Loading from %s\n',ecog)
    tmp = load(ecog);
    ecog=tmp;clear tmp
elseif isstruct(ecog)
    fprintf('Assuming input ecog is an ecog data.\n')
end

if isstring(info)
    fprintf('Assuming input ecog is an info filename. Loading from %s\n',info)
    tmp = load(info);
    info=tmp;clear tmp
elseif isstruct(info)
    fprintf('Assuming input info is an info data.\n')
end
% check events if they have onset and duration columns
if ~any(ismember(info.events.Properties.VariableNames, 'onset')) || ~any(ismember(info.events.Properties.VariableNames,'duration'))
    error('Sorry but events table should contain "onset" and "duration" columns, requirement of BIDS :(')
end

if ~isfield(cfg,'bidsroot')
    error('bidsroot field needs to be given in cfg structure')
elseif ~exist(cfg.bidsroot,'dir')
    fprintf('Creating BIDS directory: %s\n',cfg.bidsroot)
    mkdir(cfg.bidsroot)
end

%% General parameters
cfg.method='convert';
% cfg.dataset      = string, filename of the input data
% cfg.outputfile   = %string, optional filename for the output data (default is automatic)
cfg.writejson    = 'yes';
cfg.writetsv     = 'yes';

% parse subject name and session
splsubjID = strsplit(ecog.params.subjectID);
if length(splsubjID) == 1
    sub = splsubjID{1};
    ses = 'implant01';
else
    sub = splsubjID{1};
    if length(splsubjID{2}) > 1     % if the name is like NS128_02
        ses = ['implant' splsubjID{2}];
    else                            % if the name is like NS128_2
        ses = ['implant0' splsubjID{2}];
    end
end

cfg.sub                     = sub;
cfg.ses                     = ses;
cfg.run                     = ecog.params.block;
cfg.task                    = ecog.task;
cfg.datatype                = 'ieeg'; %string, can be any of 'FLAIR', 'FLASH', 'PD', 'PDT2', 'PDmap', 'T1map', 'T1rho', 'T1w', 'T2map', 'T2star', 'T2w', 'angio', 'bold', 'bval', 'bvec', 'channels', 'coordsystem', 'defacemask', 'dwi', 'eeg', 'epi', 'events', 'fieldmap', 'headshape', 'ieeg', 'inplaneT1', 'inplaneT2', 'magnitude', 'magnitude1', 'magnitude2', 'meg', 'phase1', 'phase2', 'phasediff', 'photo', 'physio', 'sbref', 'stim'
% cfg.acq                     = string
% cfg.ce                      = string
% cfg.rec                     = string
% cfg.dir                     = string
% cfg.mod                     = string
% cfg.echo                    = string
% cfg.proc                    = string

%% General description if it's not present
cfg.InstitutionName             = 'Feinstein Institutes for Medical Research';
cfg.InstitutionAddress          = '350 Community Drive, Manhasset, NY, 11003, USA';
cfg.InstitutionalDepartmentName = 'Human Brain Mapping Lab, Institute for Bioelectronic Medicine';
cfg.Manufacturer                = ecog.recAmp;
cfg.ManufacturersModelName      = 'n\a';
cfg.DeviceSerialNumber          = 'n\a';
cfg.SoftwareVersions            = 'n\a';

%% change dataset_description
cfg.dataset_description                     = [];
cfg.dataset_description.writesidecar        = 'yes';
cfg.dataset_description.Name                = 'BIDSroot'; % REQUIRED. Name of the dataset.
cfg.dataset_description.BIDSVersion         = 1.2;        % REQUIRED. The version of the BIDS standard that was used.
cfg.dataset_description.License             = 'n/a';      % RECOMMENDED. What license is this dataset distributed under? The use of license name abbreviations is suggested for specifying a license. A list of common licenses with suggested abbreviations can be found in Appendix II.
cfg.dataset_description.Authors             = 'n/a';      % OPTIONAL. List of individuals who contributed to the creation/curation of the dataset.
cfg.dataset_description.Acknowledgements    = 'n/a';      % OPTIONAL. Text acknowledging contributions of individuals or institutions beyond those listed in Authors or Funding.
cfg.dataset_description.HowToAcknowledge    = 'n/a';      % OPTIONAL. Instructions how researchers using this dataset should acknowledge the original authors. This field can also be used to define a publication that should be cited in publications that use the dataset.
cfg.dataset_description.Funding             = 'n/a';      % OPTIONAL. List of sources of funding (grant numbers)
cfg.dataset_description.ReferencesAndLinks  = 'n/a';      % OPTIONAL. List of references to publication that contain information on the dataset, or links.
cfg.dataset_description.DatasetDOI          = 'n/a';      % OPTIONAL. The Document Object Identifier of the dataset (not the corresponding paper).

%% add channel informations
chantype = ecog.labelimport.Channeltype';
chantype = replace(chantype,{'depth','hd_depth'},'SEEG');
chantype = replace(chantype,{'strip','grid','hd_strip','hd_grid'},'ECOG');

chanunuts = cell(size(ecog.labelimport.labels));
chanunuts(:) = {'uV'};

chanstatus = cell(size(ecog.labelimport.labels));
chanstatus(:) = {'good'};
chanstatus(ecog.labelimport.soz==1) = {'soz'};
chanstatus(ecog.labelimport.spikey==1) = {'spikey'};
chanstatus(ecog.labelimport.out==1) = {'out'};
chanstatus(ecog.labelimport.bad==1) = {'bad'};

cfg.channels.name               = ecog.ftrip.label;  % REQUIRED. Channel name (e.g., MRT012, MEG023)
cfg.channels.type               = chantype; % REQUIRED. Type of channel; MUST use the channel types listed below.
cfg.channels.units              = chanunuts;  % REQUIRED. Physical unit of the data values recorded by this channel in SI (see Appendix V: Units for allowed symbols).
cfg.channels.sampling_frequency = cell(size(ecog.labelimport.labels));  % OPTIONAL. Sampling rate of the channel in Hz.
cfg.channels.description        = cell(size(ecog.labelimport.labels));  % OPTIONAL. Brief free-text description of the channel, or other information of interest. See examples below.
cfg.channels.low_cutoff         = cell(size(ecog.labelimport.labels));  % OPTIONAL. Frequencies used for the high-pass filter applied to the channel in Hz. If no high-pass filter applied, use n/a.
cfg.channels.high_cutoff        = cell(size(ecog.labelimport.labels));  % OPTIONAL. Frequencies used for the low-pass filter applied to the channel in Hz. If no low-pass filter applied, use n/a. Note that hardware anti-aliasing in A/D conversion of all MEG/EEG electronics applies a low-pass filter; specify its frequency here if applicable.
cfg.channels.notch              = cell(size(ecog.labelimport.labels));  % OPTIONAL. Frequencies used for the notch filter applied to the channel, in Hz. If no notch filter applied, use n/a.
cfg.channels.software_filters   = cell(size(ecog.labelimport.labels));  % OPTIONAL. List of temporal and/or spatial software filters applied (e.g. "SSS", "SpatialCompensation"). Note that parameters should be defined in the general MEG sidecar .json file. Indicate n/a in the absence of software filters applied.
cfg.channels.status             = chanstatus;  % OPTIONAL. Data quality observed on the channel (good/bad). A channel is considered bad if its data quality is compromised by excessive noise. Description of noise type SHOULD be provided in [status_description].
cfg.channels.status_description = cell(size(ecog.labelimport.labels));  % OPTIONAL. Freeform text description of noise or artifact affecting data quality on the channel. It is meant to explain why the channel was declared bad in [status].

clear chantype chanunuts chanstatus
%% add participant info
cfg.participants.age             = NaN;
cfg.participants.sex             = 'n/a';
cfg.participants.handedness      = 'n/a';
cfg.participants.language        = 'n/a';
cfg.participants.implantside     = 'n/a';
cfg.participants.implantelecs    = 'n/a';

%% get events from info
cfg.events = info.events;

%% add ieeg specific info
cfg.ieeg.iEEGReference                   = 'scalp';% REQUIRED. General description of the reference scheme used and (when applicable) of location of the reference electrode in the raw recordings (e.g. "left mastoid”, “bipolar”, “T01” for electrode with name T01, “intracranial electrode on top of a grid, not included with data”, “upside down electrode”). If different channels have a different reference, this field should have a general description and the channel specific reference should be defined in the _channels.tsv file.
cfg.ieeg.SamplingFrequency               = ecog.ftrip.fsample; % REQUIRED. Sampling frequency (in Hz) of all the iEEG channels in the recording (e.g., 2400). All other channels should have frequency specified as well in the channels.tsv file.
cfg.ieeg.PowerLineFrequency              = 60; % REQUIRED. Frequency (in Hz) of the power grid where the iEEG recording was done (i.e. 50 or 60)
cfg.ieeg.SoftwareFilters                 = 'n/a'; % REQUIRED. List of temporal software filters applied or ideally  key:value pairs of pre-applied filters and their parameter values. (n/a if none).
cfg.ieeg.HardwareFilters                 = {'HighpassFilter',NaN,'LowpassFilter',NaN}; % REQUIRED. List of hardware (amplifier) filters applied with  key:value pairs of filter parameters and their values.
cfg.ieeg.SEEGChannelCount                = sum(strcmp(cfg.channels.type,'SEEG'));
cfg.ieeg.ECOGChannelCount                = sum(strcmp(cfg.channels.type,'ECOG'));
cfg.ieeg.MiscChannelCount                = 0;

%% now do it
data2bids_output = data2bids(cfg, ecog.ftrip)

% In addition to BrainVision data, save as ecog.mat file
save([erase(data2bids_output.outputfile,'vhdr'), 'mat'],'ecog','-v7.3')

end
