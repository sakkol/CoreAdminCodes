cfg=[];
cfg.method='convert';
% cfg.dataset      = string, filename of the input data
% cfg.outputfile   = %string, optional filename for the output data (default is automatic)
cfg.writejson    = 'yes';
cfg.writetsv     = 'yes';

cfg.bidsroot                = '/media/sakkol/HDD1/HBML/BIDSroot';
cfg.sub                     = 'NS162';
cfg.ses                     = 'implant01';
cfg.run                     = 1;
cfg.task                    = 'auditorylocalizer';
cfg.datatype                = 'ieeg';%string, can be any of 'FLAIR', 'FLASH', 'PD', 'PDT2', 'PDmap', 'T1map', 'T1rho', 'T1w', 'T2map', 'T2star', 'T2w', 'angio', 'bold', 'bval', 'bvec', 'channels', 'coordsystem', 'defacemask', 'dwi', 'eeg', 'epi', 'events', 'fieldmap', 'headshape', 'ieeg', 'inplaneT1', 'inplaneT2', 'magnitude', 'magnitude1', 'magnitude2', 'meg', 'phase1', 'phase2', 'phasediff', 'photo', 'physio', 'sbref', 'stim'
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
cfg.dataset_description                     = [];% ft_getopt(cfg, 'dataset_description'                       );
cfg.dataset_description.writesidecar        = 'yes';
cfg.dataset_description.Name                = 'BIDSroot'; % REQUIRED. Name of the dataset.
cfg.dataset_description.BIDSVersion         = 1.2; % REQUIRED. The version of the BIDS standard that was used.
cfg.dataset_description.License             = 'n/a';%ft_getopt(cfg.dataset_description, 'License'               ); % RECOMMENDED. What license is this dataset distributed under? The use of license name abbreviations is suggested for specifying a license. A list of common licenses with suggested abbreviations can be found in Appendix II.
cfg.dataset_description.Authors             = 'n/a';%ft_getopt(cfg.dataset_description, 'Authors'               ); % OPTIONAL. List of individuals who contributed to the creation/curation of the dataset.
cfg.dataset_description.Acknowledgements    = 'n/a';%ft_getopt(cfg.dataset_description, 'Acknowledgements'      ); % OPTIONAL. Text acknowledging contributions of individuals or institutions beyond those listed in Authors or Funding.
cfg.dataset_description.HowToAcknowledge    = 'n/a';%ft_getopt(cfg.dataset_description, 'HowToAcknowledge'      ); % OPTIONAL. Instructions how researchers using this dataset should acknowledge the original authors. This field can also be used to define a publication that should be cited in publications that use the dataset.
cfg.dataset_description.Funding             = 'n/a';%ft_getopt(cfg.dataset_description, 'Funding'               ); % OPTIONAL. List of sources of funding (grant numbers)
cfg.dataset_description.ReferencesAndLinks  = 'n/a';%ft_getopt(cfg.dataset_description, 'ReferencesAndLinks'    ); % OPTIONAL. List of references to publication that contain information on the dataset, or links.
cfg.dataset_description.DatasetDOI          = 'n/a';%ft_getopt(cfg.dataset_description, 'DatasetDOI'            ); % OPTIONAL. The Document Object Identifier of the dataset (not the corresponding paper).



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

cfg.participants.age        = 26;
cfg.participants.sex        = 'm';
cfg.participants.handedness = 'right';
cfg.participants.language = 'engspa';
cfg.participants.implantside = 'bilateral';
cfg.participants.implantelecs = 'seeg';

%% get events from info

info.events.Properties.VariableNames{1}='onset';
info.events.Properties.VariableNames{3}='duration';
cfg.events = info.events(:,[1:3,5]);

%% ieeg specific areas
cfg.ieeg.iEEGReference                   = 'scalp';% REQUIRED. General description of the reference scheme used and (when applicable) of location of the reference electrode in the raw recordings (e.g. "left mastoid”, “bipolar”, “T01” for electrode with name T01, “intracranial electrode on top of a grid, not included with data”, “upside down electrode”). If different channels have a different reference, this field should have a general description and the channel specific reference should be defined in the _channels.tsv file.
cfg.ieeg.SamplingFrequency               = ecog.ftrip.fsample; % REQUIRED. Sampling frequency (in Hz) of all the iEEG channels in the recording (e.g., 2400). All other channels should have frequency specified as well in the channels.tsv file.
cfg.ieeg.PowerLineFrequency              = 60; % REQUIRED. Frequency (in Hz) of the power grid where the iEEG recording was done (i.e. 50 or 60)
cfg.ieeg.SoftwareFilters                 = 'n/a'; % REQUIRED. List of temporal software filters applied or ideally  key:value pairs of pre-applied filters and their parameter values. (n/a if none).
cfg.ieeg.HardwareFilters                 = {'HighpassFilter',500,'LowpassFilter',0.1}; % REQUIRED. List of hardware (amplifier) filters applied with  key:value pairs of filter parameters and their values.
cfg.ieeg.SEEGChannelCount                = sum(strcmp(cfg.channels.type,'SEEG'));
cfg.ieeg.ECOGChannelCount                = sum(strcmp(cfg.channels.type,'ECOG'));
cfg.ieeg.MiscChannelCount                = 0;

%% now do it
cfg = data2bids(cfg, ecog.ftrip)

