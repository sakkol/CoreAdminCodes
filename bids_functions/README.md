# BIDS Functions Documentation

This folder contains MATLAB functions to convert brain imaging data to BIDS (Brain Imaging Data Structure) format. These functions are designed to handle a single subject's single session conversion.

## Overview

The BIDS functions support the following data types:
- **iEEG data**: Intracranial EEG (electrocorticography) recordings
- **Behavioral/Events**: Extracted from TTL pulses in raw EDF files
- **Anatomical MRI**: NIFTI formatted structural images
- **Physiology**: Continuous physiological data (ECG, heart rate, respiration)

## Main Functions

### 1. `bids_pipeline_template.m` (Main Entry Point)
The orchestrator function that coordinates conversion of all data types for a single subject/session.

**Usage:**
```matlab
cfg = [];
cfg.bids_root = '/path/to/bidsroot';
cfg.sub = 'NS157';
cfg.ses = 'implant01';
cfg.task = 'auditorylocalizer';
cfg.raw_edf_file = '/path/to/raw_data.edf';
cfg.raw_ecog_file = '/path/to/ecog_processed.mat';
cfg.anatomical_nifti = '/path/to/T1w.nii.gz';
cfg.physio_data_file = '/path/to/physio_data.mat';

bids_output = bids_pipeline_template(cfg);
```

**Required Input:**
- `cfg.bids_root` - Root directory where BIDS dataset will be created
- `cfg.sub` - Subject ID (e.g., 'NS157')
- `cfg.ses` - Session label (e.g., 'implant01')
- `cfg.task` - Task name (e.g., 'auditorylocalizer')
- `cfg.raw_edf_file` - Path to raw EDF file (for event extraction)
- `cfg.raw_ecog_file` - Path to processed iEEG data (.mat)
- `cfg.anatomical_nifti` - Path to anatomical MRI (NIFTI format)
- `cfg.physio_data_file` - Path to physiology data (optional)

**Optional Input:**
- `cfg.institution` - Institution name (default: 'Feinstein Institutes for Medical Research')
- `cfg.dataset_name` - Dataset name (default: 'BIDSroot')
- `cfg.bids_version` - BIDS version (default: 1.9)
- `cfg.ttl_channel_name` - TTL channel name in EDF (default: 'TTL')
- `cfg.ttl_threshold` - TTL detection threshold (default: 0.5)
- `cfg.skip_ieeg` - Skip iEEG processing (default: false)
- `cfg.skip_anatomy` - Skip anatomical processing (default: false)
- `cfg.skip_physio` - Skip physiology processing (default: false)

## Supporting Functions

### 2. `bids_create_dataset_description.m`
Creates the required `dataset_description.json` file with BIDS minimum requirements.

### 3. `bids_create_directory_structure.m`
Creates the BIDS folder hierarchy including sourcedata directory for raw unprocessed data:
```
bids_root/
├── sourcedata/           (Raw unprocessed data)
│   └── sub-<label>/
│       └── ses-<label>/
│           ├── raw_edf/
│           ├── raw_mri/
│           └── raw_physio/
└── sub-<label>/
    └── ses-<label>/
        ├── ieeg/        (Processed iEEG data)
        ├── beh/         (Behavioral/Events)
        ├── anat/        (Anatomical MRI)
        └── physio/      (Non-standard: Physiology)
```

### 4. `bids_make_metadata.m`
Creates a BIDS metadata structure similar to `makeSbj_Metadata.m` but for BIDS datasets. This function:
- Organizes all important file and folder paths
- Includes sourcedata directories
- Provides filename prefixes for easy file naming
- Creates standard BIDS subdirectories

**Usage:**
```matlab
bids_metadata = bids_make_metadata('/path/to/bids', 'NS157', 'implant01', 'auditorylocalizer');
disp(bids_metadata.ses_dir);           % /path/to/bids/sub-NS157/ses-implant01
disp(bids_metadata.sourcedata_ses_dir); % /path/to/bids/sourcedata/sub-NS157/ses-implant01
```

**Key fields:**
- `bids_metadata.bids_root` - BIDS root directory
- `bids_metadata.sourcedata_ses_dir` - Sourcedata directory for this subject/session
- `bids_metadata.ieeg_dir`, `.beh_dir`, `.anat_dir`, `.physio_dir` - Datatype directories
- `bids_metadata.file_prefix` - Prefix for all files (e.g., `sub-NS157_ses-implant01_task-auditorylocalizer_run-01`)

### 5. `bids_save_channelinfo_csv.m`
Saves electrode/channel information to CSV format (extending create_info.m concept).

**Usage:**
```matlab
cfg = [];
cfg.ecog = my_ecog_data;
cfg.elecInfo = '/path/to/correspondence_sheet.xlsx';  % or a table
channelinfo_output = bids_save_channelinfo_csv(cfg, '/path/to/channels.csv');
```

**Output columns:**
- `label` - Channel/electrode label
- `channel_type` - Type of electrode (grid, depth, strip, etc.)
- `xyz_x`, `xyz_y`, `xyz_z` - 3D coordinates
- `soz` - Seizure onset zone (yes/no)
- `epileptic_spikes` - Spike channels (yes/no)
- `out_of_brain` - Out of brain electrodes (yes/no)
- `artifact_patient` - Bad channels from patient history (yes/no)
- `artifact_block` - Bad channels detected in current block (yes/no)

**Returns:**
- `channelinfo_output.filename` - Path to saved CSV
- `channelinfo_output.table` - The channel information table
- `channelinfo_output.summary` - Summary statistics

### 6. `bids_save_events_csv.m`
Saves behavioral events to CSV format (complementing the TSV format used by BIDS).

**Usage:**
```matlab
% Create events table (must have 'onset' and 'duration')
events = table();
events.onset = [0; 1.5; 3.2; 4.8];
events.duration = [0.1; 0.1; 0.1; 0.1];
events.trial_type = {'stimulus'; 'stimulus'; 'response'; 'response'};

% Save to CSV
output = bids_save_events_csv(events, '/path/to/events.csv');
```

**Optional parameters:**
- `'delimiter'` - CSV delimiter (default: ',')
- `'header'` - Include header row (default: true)
- `'description'` - Add description column (default: false)

**Returns:**
- `events_output.filename` - Path to saved CSV
- `events_output.table` - The events table
- `events_output.n_events` - Number of events
- `events_output.trial_counts` - Counts per trial type

### 7. `bids_process_ieeg.m`
Processes intracranial EEG data:
- Loads pre-processed iEEG data (.mat format)
- Creates channels information TSV file
- Generates sidecar JSON metadata

**Output files:**
- `*_ieeg.edf` (reference location)
- `*_channels.tsv` (channel information)
- `*_ieeg.json` (metadata)

### 8. `bids_process_events.m`
Extracts behavioral events from TTL channel in EDF file:
- Reads raw EDF file using FieldTrip
- Detects TTL pulses (rising edges)
- Creates events TSV file with onset and duration

**Output files:**
- `*_events.tsv` (BIDS requirement: onset, duration, trial_type, value)
- `*_events.json` (metadata for event columns)

**BIDS Requirements Met:**
- Must-have columns: `onset`, `duration`
- Additional columns: `trial_type`, `value`

### 6. `bids_process_anatomy.m`
Processes anatomical MRI data in NIFTI format:
- Copies NIFTI file to BIDS structure
- Creates sidecar JSON with acquisition parameters
- Issues warnings for non-standard values

**Output files:**
- `*_T1w.nii.gz` (or .nii)
- `*_T1w.json` (metadata)

### 7. `bids_process_physio.m`
Processes physiological data (ECG, heart rate, respiration):
- **WARNING**: This is a non-standard BIDS addition
- Extracts available physiological signals
- Creates physio subdirectory and files for reference

**Output files:**
- `physio/*_physio.tsv` (physiological signals)
- `physio/*_physio.json` (metadata)

### 8. `bids_create_sidecar_json.m`
Helper function to create BIDS sidecar JSON files. Attempts multiple methods:
1. SPM's `spm_jsonwrite` (if available)
2. JSONlab's `savejson` (if available)
3. Manual JSON writing (fallback)

## BIDS Output Structure Example

For subject NS157, session implant01, task auditorylocalizer:

```
bidsroot/
├── dataset_description.json
├── .bidsignore
├── sourcedata/                          ← Raw unprocessed data
│   └── sub-NS157/
│       └── ses-implant01/
│           ├── raw_edf/                 (Raw EDF files)
│           ├── raw_mri/                 (Raw MRI files)
│           └── raw_physio/              (Raw physiology files)
└── sub-NS157/
    └── ses-implant01/
        ├── ieeg/
        │   ├── sub-NS157_ses-implant01_task-auditorylocalizer_run-01_ieeg.edf
        │   ├── sub-NS157_ses-implant01_task-auditorylocalizer_run-01_channels.tsv
        │   ├── sub-NS157_ses-implant01_task-auditorylocalizer_run-01_channels.csv
        │   └── sub-NS157_ses-implant01_task-auditorylocalizer_run-01_ieeg.json
        ├── beh/
        │   ├── sub-NS157_ses-implant01_task-auditorylocalizer_run-01_events.tsv
        │   ├── sub-NS157_ses-implant01_task-auditorylocalizer_run-01_events.csv
        │   └── sub-NS157_ses-implant01_task-auditorylocalizer_run-01_events.json
        ├── anat/
        │   ├── sub-NS157_ses-implant01_T1w.nii.gz
        │   └── sub-NS157_ses-implant01_T1w.json
        └── physio/ (non-standard)
            ├── sub-NS157_ses-implant01_task-auditorylocalizer_run-01_physio.tsv
            ├── sub-NS157_ses-implant01_task-auditorylocalizer_run-01_physio.csv
            └── sub-NS157_ses-implant01_task-auditorylocalizer_run-01_physio.json
```

## Important Notes

### Sourcedata Folder Structure
The `sourcedata/` folder (BIDS standard) stores raw, unprocessed files:
```
sourcedata/
└── sub-<label>/
    └── ses-<label>/
        ├── raw_edf/     (Raw EDF files from acquisition)
        ├── raw_mri/     (Raw MRI files before conversion/processing)
        └── raw_physio/  (Raw physiological data files)
```

This folder is:
- **Created automatically** by `bids_create_directory_structure.m`
- **Accessible via** `bids_make_metadata.m`:
  - `bids_metadata.sourcedata_root` - Main sourcedata directory
  - `bids_metadata.sourcedata_ses_dir` - Subject/session sourcedata
  - `bids_metadata.sourcedata_raw_edf_dir` - Raw EDF storage
  - `bids_metadata.sourcedata_raw_mri_dir` - Raw MRI storage
  - `bids_metadata.sourcedata_raw_physio_dir` - Raw physio storage

### Using Sourcedata
Store your raw, unprocessed files in sourcedata before conversion:
```matlab
% Get metadata structure
bids_metadata = bids_make_metadata('/path/to/bids', 'NS157', 'implant01', 'task');

% Copy raw EDF file to sourcedata
raw_edf = '/original/location/raw_data.edf';
copyfile(raw_edf, fullfile(bids_metadata.sourcedata_raw_edf_dir, 'raw_data.edf'));

% Then process and place converted files in main directories
```

### Events from TTL
- TTL channel is automatically detected from the raw EDF file
- Events are created with columns: `onset` (seconds), `duration` (seconds), `trial_type`, `value`
- TTL pulses are detected as rising edges above the specified threshold

### Non-Standard Additions
The pipeline issues **WARNINGS** for non-standard BIDS additions:
- **Physiology data**: Stored in custom `physio/` subdirectory
- **Custom fields in JSON**: May not be recognized by BIDS validators

### Placeholder Values
Several files contain example/placeholder values that should be updated:
- Anatomical JSON: `EchoTime`, `RepetitionTime`, `FlipAngle`, `MagneticFieldStrength`
- iEEG JSON: `SamplingFrequency`, `Manufacturer`
- Physiology JSON: `SamplingFrequency`, `Units`

### Minimum Requirements
This pipeline implements BIDS **minimum requirements** only:
- `dataset_description.json` with required fields
- Data files with proper naming convention
- Essential metadata in sidecar JSON files
- Events file with required columns (onset, duration)

## Dependencies

- **FieldTrip**: For reading EDF files (`ft_read_data`, `ft_read_header`)
- **SPM or JSONlab**: For JSON writing (or uses fallback method)

## Configuration Tips

1. **Subject ID**: Can include numbers or underscores (e.g., 'NS157', 'sub_001')
2. **Session Label**: Typically indicates implantation number (e.g., 'implant01', 'implant02')
3. **Task Name**: Should be lowercase without spaces (e.g., 'auditorylocalizer', 'rest', 'objectnaming')
4. **TTL Channel**: Verify the exact name in your EDF file before processing

## Workflow Example

```matlab
% Step 1: Prepare configuration
cfg = [];
cfg.bids_root = '/media/data/MyStudy_BIDS';
cfg.sub = 'NS157';
cfg.ses = 'implant01';
cfg.task = 'auditorylocalizer';
cfg.raw_edf_file = '/media/rawdata/NS157_session1.edf';
cfg.raw_ecog_file = '/media/processed/NS157_ecog.mat';
cfg.anatomical_nifti = '/media/mri/NS157_T1w.nii.gz';
cfg.physio_data_file = '/media/physio/NS157_ecg_data.mat';

% Step 2: Run pipeline
output = bids_pipeline_template(cfg);

% Step 3: Review output structure
disp(output);
```

## Troubleshooting

**Error: "TTL channel not found"**
- Check the exact channel name in your EDF file
- Use FieldTrip's `ft_read_header()` to list available channels

**Error: "FieldTrip not in path"**
- Add FieldTrip to your MATLAB path
- Alternative: Use `addpath('/path/to/fieldtrip')`

**JSON writing fails**
- Ensure SPM or JSONlab is in your path
- Fallback method should work if both are unavailable

## New Utility Functions

### `bids_make_metadata.m` - BIDS Metadata Structure
Creates a BIDS metadata structure similar to `makeSbj_Metadata.m` (from CoreAdminCodes), carrying comprehensive file and folder information.

**Purpose**: Organize and track all important paths and file locations for a BIDS dataset

**Usage:**
```matlab
bids_metadata = bids_make_metadata(bids_root, sub, ses, task);

% Example:
bids_metadata = bids_make_metadata('/path/to/bids', 'NS157', 'implant01', 'auditorylocalizer');

% Access paths:
disp(bids_metadata.ses_dir);              % /path/to/bids/sub-NS157/ses-implant01
disp(bids_metadata.sourcedata_ses_dir);   % /path/to/bids/sourcedata/sub-NS157/ses-implant01
disp(bids_metadata.ieeg_dir);             % /path/to/bids/sub-NS157/ses-implant01/ieeg
disp(bids_metadata.file_prefix);          % sub-NS157_ses-implant01_task-auditorylocalizer_run-01
```

**Key output fields:**
- `.bids_root` - BIDS root directory
- `.sourcedata_*` - All sourcedata directory paths
- `.ieeg_dir`, `.beh_dir`, `.anat_dir`, `.physio_dir` - Datatype directories
- `.file_prefix` - Standardized filename prefix
- `.ieeg.channels_csv`, `.ieeg.electrodes_csv` - CSV file paths for both TSV and CSV versions
- `.beh.events_csv` - Events CSV path
- Directories are created automatically if they don't exist

### `bids_save_channelinfo_csv.m` - Save Electrode Information
Saves electrode/channel information to CSV format, extending the functionality of `create_info.m`.

**Purpose**: Extract and save detailed channel/electrode metadata for analysis and record-keeping

**Usage:**
```matlab
cfg = [];
cfg.ecog = my_ecog_data;  % FieldTrip-like structure with channel info
cfg.elecInfo = '/path/to/correspondence_sheet.xlsx';  % or a table

channelinfo_output = bids_save_channelinfo_csv(cfg, '/path/to/channels.csv');
```

**Input requirements (cfg structure):**
- `cfg.ecog.label` or `cfg.ecog.ftrip.label` - Channel labels
- `cfg.elecInfo` - Correspondence sheet (file path or table)
  - Should contain: Contact, channel_type, xyz coordinates, SOZ, spikey, out, bad
- `cfg.ecog.bad_chans` - Bad channels from current block (optional)
- `cfg.ecog.spike_chans` - Spike channels (optional)

**Output CSV columns:**
- `label` - Channel/electrode label
- `channel_type` - Type (grid, depth, strip, etc.)
- `xyz_x`, `xyz_y`, `xyz_z` - Electrode 3D coordinates
- `soz` - Seizure onset zone (yes/no)
- `epileptic_spikes` - Spike channels (yes/no)
- `out_of_brain` - Out of brain electrodes (yes/no)
- `artifact_patient` - Bad channels from patient history (yes/no)
- `artifact_block` - Bad channels detected in current block (yes/no)

**Returns:**
- `.filename` - Path to saved CSV file
- `.table` - The channel information table
- `.summary` - Summary statistics (counts of different channel types)

### `bids_save_events_csv.m` - Save Events to CSV
Saves behavioral events to CSV format, complementing the BIDS-standard TSV format. Useful for analysis and compatibility with other tools.

**Purpose**: Create CSV version of events for additional analysis flexibility

**Usage:**
```matlab
% Create or load events table (must have 'onset' and 'duration')
events = table();
events.onset = [0; 1.5; 3.2; 4.8];
events.duration = [0.1; 0.1; 0.1; 0.1];
events.trial_type = {'stimulus'; 'stimulus'; 'response'; 'response'};
events.value = [1; 1; 2; 2];

% Save to CSV
output = bids_save_events_csv(events, '/path/to/events.csv');

% With options
output = bids_save_events_csv(events, '/path/to/events.csv', ...
    'delimiter', ',', ...
    'description', true);
```

**Required columns in events table:**
- `onset` - Event onset time in seconds (BIDS requirement)
- `duration` - Event duration in seconds (BIDS requirement)

**Optional columns:**
- `trial_type` - Type of trial/event
- `value` - Numeric value
- `response` - Response information
- `accuracy` - Accuracy metric

**Optional parameters:**
- `'delimiter'` - CSV delimiter character (default: ',')
- `'header'` - Include header row (default: true)
- `'description'` - Add auto-generated description column (default: false)

**Returns:**
- `.filename` - Path to saved CSV file
- `.table` - The saved events table
- `.n_events` - Total number of events
- `.trial_counts` - Counts per trial type

## Example Workflow Using New Functions

```matlab
%% Step 1: Create metadata structure
bids_metadata = bids_make_metadata('/path/to/bids', 'NS157', 'implant01', 'auditorylocalizer');

%% Step 2: Copy raw files to sourcedata
copyfile(raw_edf_file, fullfile(bids_metadata.sourcedata_raw_edf_dir, 'raw.edf'));
copyfile(raw_mri_file, fullfile(bids_metadata.sourcedata_raw_mri_dir, 'raw.nii.gz'));

%% Step 3: Save channel information to CSV
cfg = [];
cfg.ecog = my_ecog_data;
cfg.elecInfo = '/path/to/correspondence_sheet.xlsx';
channelinfo = bids_save_channelinfo_csv(cfg, ...
    fullfile(bids_metadata.ieeg_dir, [bids_metadata.file_prefix '_channels.csv']));

%% Step 4: Save events to both TSV and CSV
events_csv = bids_save_events_csv(my_events, ...
    fullfile(bids_metadata.beh_dir, [bids_metadata.file_prefix '_events.csv']));

%% Access paths easily
fprintf('Channel info saved to: %s\n', channelinfo.filename);
fprintf('Events saved to: %s\n', events_csv.filename);
```

## Future Enhancements

- Batch processing for multiple subjects
- Validation against BIDS standard
- Automatic metadata extraction from file headers
- Support for additional data types (DWI, fMRI, MEG)
- Links to Freesurfer derivatives
