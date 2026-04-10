function validation_result = bids_validate_structure(bids_root, sub, ses)
% BIDS_VALIDATE_STRUCTURE - Validate BIDS folder structure and required files
%
% USAGE:
%   validation_result = bids_validate_structure(bids_root, sub, ses)
%
% INPUT:
%   bids_root - Root directory of BIDS dataset
%   sub - Subject ID (e.g., 'NS157')
%   ses - Session label (e.g., 'implant01')
%
% OUTPUT:
%   validation_result - Structure with validation results and errors/warnings
%
% EXAMPLE:
%   result = bids_validate_structure('/path/to/bidsroot', 'NS157', 'implant01');
%   disp(result);

%% Input validation
if ~exist(bids_root, 'dir')
    error('BIDS root directory not found: %s', bids_root);
end

%% Initialize results
validation_result = [];
validation_result.bids_root = bids_root;
validation_result.sub = sub;
validation_result.ses = ses;
validation_result.is_valid = true;
validation_result.errors = {};
validation_result.warnings = {};
validation_result.missing_files = {};
validation_result.found_files = {};

%% Check dataset description
fprintf('Validating BIDS structure...\n\n');
fprintf('Dataset level:\n');

dataset_desc_file = fullfile(bids_root, 'dataset_description.json');
if exist(dataset_desc_file, 'file')
    fprintf('  ✓ dataset_description.json found\n');
    validation_result.found_files{end+1} = dataset_desc_file;
else
    fprintf('  ✗ dataset_description.json NOT found\n');
    validation_result.errors{end+1} = 'Missing: dataset_description.json';
    validation_result.is_valid = false;
end

%% Check BIDSIGNORE
bidsignore_file = fullfile(bids_root, '.bidsignore');
if exist(bidsignore_file, 'file')
    fprintf('  ✓ .bidsignore found\n');
else
    fprintf('  ⚠ .bidsignore NOT found (recommended)\n');
    validation_result.warnings{end+1} = 'Missing: .bidsignore (recommended)';
end

%% Check subject/session structure
fprintf('\nSubject/Session level:\n');

sub_label = sprintf('sub-%s', sub);
ses_label = sprintf('ses-%s', ses);

ses_dir = fullfile(bids_root, sub_label, ses_label);
if exist(ses_dir, 'dir')
    fprintf('  ✓ %s/%s directory found\n', sub_label, ses_label);
else
    fprintf('  ✗ %s/%s directory NOT found\n', sub_label, ses_label);
    validation_result.errors{end+1} = sprintf('Missing: %s/%s', sub_label, ses_label);
    validation_result.is_valid = false;
    
    % If session dir doesn't exist, can't check further
    fprintf('\nValidation FAILED: Session directory does not exist.\n');
    return;
end

%% Check datatype directories
fprintf('\nDatatype directories:\n');

datatypes = {'ieeg', 'beh', 'anat', 'physio'};
for dt = 1:length(datatypes)
    datatype = datatypes{dt};
    datatype_dir = fullfile(ses_dir, datatype);
    if exist(datatype_dir, 'dir')
        fprintf('  ✓ %s/ found\n', datatype);
        
        % Check for files in each directory
        d = dir(fullfile(datatype_dir, '*'));
        files_found = {d(~[d.isdir]).name};
        
        if ~isempty(files_found)
            fprintf('      Files: %s\n', sprintf('%s, ', files_found{:}));
            for f = 1:length(files_found)
                validation_result.found_files{end+1} = fullfile(datatype_dir, files_found{f});
            end
        else
            fprintf('      ⚠ Datatype directory is empty\n');
            validation_result.warnings{end+1} = sprintf('%s/ directory is empty', datatype);
        end
    else
        fprintf('  ⚠ %s/ NOT found\n', datatype);
        validation_result.warnings{end+1} = sprintf('Missing: %s/', datatype);
    end
end

%% Check required files for each datatype
fprintf('\nRequired/Recommended files:\n');

% iEEG requirements
ieeg_dir = fullfile(ses_dir, 'ieeg');
if exist(ieeg_dir, 'dir')
    fprintf('  iEEG files:\n');
    
    % Look for ieeg data file (EDF, TSV, or similar)
    ieeg_data = dir(fullfile(ieeg_dir, sprintf('*_%s_run-*_ieeg.edf', ses_label)));
    if ~isempty(ieeg_data)
        fprintf('    ✓ iEEG data file found\n');
    else
        fprintf('    ⚠ iEEG data file not found (*.edf)\n');
        validation_result.warnings{end+1} = 'iEEG data file not found';
    end
    
    % Check channels TSV
    channels_tsv = dir(fullfile(ieeg_dir, '*_channels.tsv'));
    if ~isempty(channels_tsv)
        fprintf('    ✓ Channels TSV found\n');
    else
        fprintf('    ✗ Channels TSV NOT found (required)\n');
        validation_result.errors{end+1} = 'Missing: channels.tsv for iEEG';
        validation_result.is_valid = false;
    end
    
    % Check iEEG JSON sidecar
    ieeg_json = dir(fullfile(ieeg_dir, '*_ieeg.json'));
    if ~isempty(ieeg_json)
        fprintf('    ✓ iEEG JSON sidecar found\n');
    else
        fprintf('    ⚠ iEEG JSON sidecar not found (recommended)\n');
        validation_result.warnings{end+1} = 'iEEG JSON sidecar not found';
    end
end

% Behavioral/Events requirements
beh_dir = fullfile(ses_dir, 'beh');
if exist(beh_dir, 'dir')
    fprintf('  Behavioral/Events files:\n');
    
    % Check events TSV
    events_tsv = dir(fullfile(beh_dir, '*_events.tsv'));
    if ~isempty(events_tsv)
        fprintf('    ✓ Events TSV found\n');
        
        % Verify required columns
        [status, msg] = check_events_tsv(fullfile(beh_dir, events_tsv(1).name));
        if status
            fprintf('    ✓ Events TSV has required columns (onset, duration)\n');
        else
            fprintf('    ✗ Events TSV missing required columns: %s\n', msg);
            validation_result.errors{end+1} = msg;
            validation_result.is_valid = false;
        end
    else
        fprintf('    ⚠ Events TSV not found\n');
        validation_result.warnings{end+1} = 'Events TSV not found';
    end
    
    % Check events JSON
    events_json = dir(fullfile(beh_dir, '*_events.json'));
    if ~isempty(events_json)
        fprintf('    ✓ Events JSON sidecar found\n');
    else
        fprintf('    ⚠ Events JSON sidecar not found (recommended)\n');
    end
end

% Anatomical requirements
anat_dir = fullfile(ses_dir, 'anat');
if exist(anat_dir, 'dir')
    fprintf('  Anatomical files:\n');
    
    % Check T1w NIFTI
    t1w_files = dir(fullfile(anat_dir, '*_T1w.nii*'));
    if ~isempty(t1w_files)
        fprintf('    ✓ T1w NIFTI found\n');
    else
        fprintf('    ⚠ T1w NIFTI not found\n');
        validation_result.warnings{end+1} = 'T1w NIFTI not found';
    end
    
    % Check T1w JSON
    t1w_json = dir(fullfile(anat_dir, '*_T1w.json'));
    if ~isempty(t1w_json)
        fprintf('    ✓ T1w JSON sidecar found\n');
    else
        fprintf('    ⚠ T1w JSON sidecar not found (recommended)\n');
    end
end

%% Summary
fprintf('\n========================================\n');
fprintf('VALIDATION SUMMARY\n');
fprintf('========================================\n');

if validation_result.is_valid
    fprintf('✓ VALIDATION PASSED\n');
else
    fprintf('✗ VALIDATION FAILED\n');
end

fprintf('\nFiles found: %d\n', length(validation_result.found_files));
fprintf('Warnings: %d\n', length(validation_result.warnings));
fprintf('Errors: %d\n', length(validation_result.errors));

if ~isempty(validation_result.errors)
    fprintf('\nErrors:\n');
    for e = 1:length(validation_result.errors)
        fprintf('  - %s\n', validation_result.errors{e});
    end
end

if ~isempty(validation_result.warnings)
    fprintf('\nWarnings:\n');
    for w = 1:length(validation_result.warnings)
        fprintf('  - %s\n', validation_result.warnings{w});
    end
end

fprintf('========================================\n\n');

end

%% Helper function to check events TSV
function [is_valid, msg] = check_events_tsv(tsv_file)
try
    % Read TSV file
    opts = delimitedTextImportOptions('Delimiter', '\t');
    events_table = readtable(tsv_file, opts);
    
    % Check for required columns
    col_names = events_table.Properties.VariableNames;
    has_onset = any(strcmpi(col_names, 'onset'));
    has_duration = any(strcmpi(col_names, 'duration'));
    
    if has_onset && has_duration
        is_valid = true;
        msg = '';
    else
        is_valid = false;
        missing = {};
        if ~has_onset
            missing{end+1} = 'onset';
        end
        if ~has_duration
            missing{end+1} = 'duration';
        end
        msg = sprintf('Missing required columns: %s', sprintf('%s, ', missing{:}));
    end
catch
    is_valid = false;
    msg = 'Could not read events TSV file';
end
end
