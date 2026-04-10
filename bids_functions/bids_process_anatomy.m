function anatomy_output = bids_process_anatomy(cfg, bids_dirs)
% BIDS_PROCESS_ANATOMY - Process anatomical MRI data in BIDS format
%
% USAGE:
%   anatomy_output = bids_process_anatomy(cfg, bids_dirs)
%
% INPUT:
%   cfg - Configuration structure with fields:
%       cfg.anatomical_nifti - Path to anatomical NIFTI file (e.g., T1w.nii.gz)
%       cfg.writejson - Write sidecar JSON ('yes'/'no')
%       cfg.institution - Institution name
%   bids_dirs - Directory structure from bids_create_directory_structure
%
% OUTPUT:
%   anatomy_output - Structure containing anatomical file information and metadata

%% Initialize output
anatomy_output = [];

%% Input validation
if ~isfield(cfg, 'anatomical_nifti') || isempty(cfg.anatomical_nifti)
    error('cfg.anatomical_nifti is required for anatomical processing');
end

if ~exist(cfg.anatomical_nifti, 'file')
    error('Anatomical NIFTI file not found: %s', cfg.anatomical_nifti);
end

if ~isfield(cfg, 'institution')
    cfg.institution = 'Unknown Institution';
end

%% Create BIDS filename for T1w image
% Format: sub-<label>_ses-<label>_T1w
bids_anat_filename = sprintf('%s_%s_T1w', ...
    bids_dirs.sub_label, bids_dirs.ses_label);

%% Copy NIFTI file to BIDS anatomy directory
[~, fname, ext] = fileparts(cfg.anatomical_nifti);

% Handle compressed NIFTI files (.nii.gz)
if strcmp(ext, '.gz')
    [~, base_name, base_ext] = fileparts(fname);
    full_ext = [base_ext ext];
else
    full_ext = ext;
end

output_nifti_file = fullfile(bids_dirs.anat_dir, [bids_anat_filename full_ext]);

fprintf('Copying anatomical NIFTI file to BIDS structure...\n');
fprintf('Source: %s\n', cfg.anatomical_nifti);
fprintf('Target: %s\n', output_nifti_file);

copyfile(cfg.anatomical_nifti, output_nifti_file);
fprintf('Created: %s\n', output_nifti_file);

anatomy_output.nifti_file = output_nifti_file;
anatomy_output.data_source = cfg.anatomical_nifti;

%% Create sidecar JSON file for anatomical data
if strcmpi(cfg.writejson, 'yes')
    fprintf('Creating anatomical sidecar JSON file...\n');
    
    % Create anatomical JSON structure with minimum BIDS requirements
    json_anat = [];
    json_anat.EchoTime = 0.00456;           % TE in seconds (example value)
    json_anat.RepetitionTime = 2.3;         % TR in seconds (example value)
    json_anat.FlipAngle = 9;                % Flip angle in degrees (example value)
    json_anat.TaskName = 'n/a';
    json_anat.Modality = 'MRI';
    json_anat.MagneticFieldStrength = 3.0;  % Magnetic field in Tesla (example)
    json_anat.Manufacturer = 'Unknown';     % Update as needed
    json_anat.ManufacturersModelName = 'Unknown';  % Update as needed
    json_anat.InstitutionName = cfg.institution;
    json_anat.ConversionSoftware = 'BIDS Pipeline';
    json_anat.ConversionSoftwareVersion = '1.0';
    
    % Optional fields that should be updated by user
    json_anat.EchoTrainLength = [];
    json_anat.InversionTime = [];
    json_anat.ImageType = 'ORIGINAL\\PRIMARY\\M\\NORM\\DIS2D';
    
    anat_json_filename = [bids_anat_filename '.json'];
    anat_json_file = fullfile(bids_dirs.anat_dir, anat_json_filename);
    
    bids_create_sidecar_json(json_anat, anat_json_file);
    fprintf('Created: %s\n', anat_json_file);
    anatomy_output.json_file = anat_json_file;
    
    % Issue warning about non-standard acquisition parameters
    fprintf('\n*** WARNING: Non-standard addition ***\n');
    fprintf('The sidecar JSON file contains example/placeholder values.\n');
    fprintf('Please update the following fields based on your actual acquisition:\n');
    fprintf('  - EchoTime, RepetitionTime, FlipAngle\n');
    fprintf('  - MagneticFieldStrength\n');
    fprintf('  - Manufacturer, ManufacturersModelName\n');
    fprintf('  - InversionTime, EchoTrainLength (if applicable)\n');
    fprintf('File location: %s\n', anat_json_file);
    fprintf('***\n\n');
    
end

fprintf('Anatomical processing complete.\n');

end
