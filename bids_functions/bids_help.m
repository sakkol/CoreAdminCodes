function bids_help()
% BIDS_HELP - Display help information for BIDS functions
%
% USAGE:
%   bids_help()
%
% This function displays an overview of all available BIDS functions
% and their purposes.

clc;

fprintf('\n');
fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║           BIDS Functions - Quick Reference Guide            ║\n');
fprintf('║     Brain Imaging Data Structure Conversion Pipeline        ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

fprintf('MAIN PIPELINE FUNCTION\n');
fprintf('──────────────────────────────────────────────────────────────\n\n');

fprintf('bids_pipeline_template(cfg)\n');
fprintf('  Main orchestrator function that converts a single subject/session to BIDS.\n');
fprintf('  Returns: Structure with paths to all created BIDS files\n');
fprintf('  Usage:\n');
fprintf('    cfg.bids_root = ''/path/to/bids'';\n');
fprintf('    cfg.sub = ''NS157'';\n');
fprintf('    cfg.ses = ''implant01'';\n');
fprintf('    cfg.task = ''auditorylocalizer'';\n');
fprintf('    cfg.raw_edf_file = ''/path/to/data.edf'';\n');
fprintf('    cfg.raw_ecog_file = ''/path/to/ecog.mat'';\n');
fprintf('    cfg.anatomical_nifti = ''/path/to/T1w.nii.gz'';\n');
fprintf('    output = bids_pipeline_template(cfg);\n\n');

fprintf('DATA TYPE PROCESSING FUNCTIONS\n');
fprintf('──────────────────────────────────────────────────────────────\n\n');

fprintf('bids_process_ieeg(cfg, bids_dirs)\n');
fprintf('  Process intracranial EEG (electrocorticography) data.\n');
fprintf('  Input: cfg.raw_ecog_file (processed iEEG .mat file)\n');
fprintf('  Output: iEEG data, channels.tsv, and JSON metadata\n');
fprintf('  Location: sub-<label>/ses-<label>/ieeg/\n\n');

fprintf('bids_process_events(cfg, bids_dirs)\n');
fprintf('  Extract behavioral events from TTL channel in EDF file.\n');
fprintf('  Input: cfg.raw_edf_file, cfg.ttl_channel_name, cfg.ttl_threshold\n');
fprintf('  Output: Events TSV (onset, duration, trial_type, value) and JSON\n');
fprintf('  Location: sub-<label>/ses-<label>/beh/\n');
fprintf('  Note: Automatically detects TTL pulses (rising edges)\n\n');

fprintf('bids_process_anatomy(cfg, bids_dirs)\n');
fprintf('  Process anatomical MRI data in NIFTI format.\n');
fprintf('  Input: cfg.anatomical_nifti (T1w.nii.gz or similar)\n');
fprintf('  Output: NIFTI file and JSON metadata\n');
fprintf('  Location: sub-<label>/ses-<label>/anat/\n');
fprintf('  Warning: Issues warnings for placeholder acquisition parameters\n\n');

fprintf('bids_process_physio(cfg, bids_dirs)\n');
fprintf('  Process physiological data (ECG, heart rate, respiration).\n');
fprintf('  Input: cfg.physio_data_file (continuous data .mat file)\n');
fprintf('  Output: Physiology TSV and JSON metadata\n');
fprintf('  Location: sub-<label>/ses-<label>/physio/ (non-standard)\n');
fprintf('  Warning: This is a non-standard BIDS addition\n\n');

fprintf('UTILITY FUNCTIONS\n');
fprintf('──────────────────────────────────────────────────────────────\n\n');

fprintf('bids_create_dataset_description(cfg)\n');
fprintf('  Create dataset_description.json file (BIDS requirement).\n');
fprintf('  Input: cfg.bids_root, optional dataset name and version\n');
fprintf('  Output: dataset_description.json at BIDS root\n');
fprintf('  Note: Required for BIDS compliance\n\n');

fprintf('bids_create_directory_structure(cfg)\n');
fprintf('  Create BIDS folder hierarchy for a subject/session.\n');
fprintf('  Input: cfg.bids_root, cfg.sub, cfg.ses\n');
fprintf('  Output: Structure with all directory paths\n');
fprintf('  Directories created:\n');
fprintf('    - sub-<label>/ses-<label>/ieeg/\n');
fprintf('    - sub-<label>/ses-<label>/beh/\n');
fprintf('    - sub-<label>/ses-<label>/anat/\n');
fprintf('    - sub-<label>/ses-<label>/physio/ (non-standard)\n\n');

fprintf('bids_create_sidecar_json(json_struct, output_file)\n');
fprintf('  Helper function to create BIDS sidecar JSON files.\n');
fprintf('  Input: Structure with data, output file path\n');
fprintf('  Output: JSON file (uses spm_jsonwrite, savejson, or fallback)\n');
fprintf('  Called internally by other functions\n\n');

fprintf('bids_validate_structure(bids_root, sub, ses)\n');
fprintf('  Validate BIDS structure and check for required/recommended files.\n');
fprintf('  Input: bids_root, subject ID, session label\n');
fprintf('  Output: Validation result structure with status, errors, warnings\n');
fprintf('  Checks:\n');
fprintf('    - Required dataset_description.json\n');
fprintf('    - Required channels.tsv for iEEG\n');
fprintf('    - Required onset/duration columns in events.tsv\n');
fprintf('    - Recommended metadata files (JSON sidecars)\n');
fprintf('  Usage:\n');
fprintf('    result = bids_validate_structure(''/path/to/bids'', ''NS157'', ''implant01'');\n\n');

fprintf('EXAMPLE SCRIPT\n');
fprintf('──────────────────────────────────────────────────────────────\n\n');

fprintf('example_pipeline_usage.m\n');
fprintf('  Complete example showing how to configure and run the pipeline.\n');
fprintf('  Demonstrates:\n');
fprintf('    - Configuration setup\n');
fprintf('    - Running the main pipeline\n');
fprintf('    - Validation of output structure\n');
fprintf('    - Next steps for BIDS compliance\n\n');

fprintf('CONFIGURATION OPTIONS\n');
fprintf('──────────────────────────────────────────────────────────────\n\n');

fprintf('Required fields (cfg structure):\n');
fprintf('  cfg.bids_root           - BIDS root directory (created if needed)\n');
fprintf('  cfg.sub                 - Subject ID (e.g., ''NS157'')\n');
fprintf('  cfg.ses                 - Session label (e.g., ''implant01'')\n');
fprintf('  cfg.task                - Task name (e.g., ''auditorylocalizer'')\n\n');

fprintf('Required data files:\n');
fprintf('  cfg.raw_edf_file        - Raw EDF file with TTL channel\n');
fprintf('  cfg.raw_ecog_file       - Processed iEEG data (.mat)\n');
fprintf('  cfg.anatomical_nifti    - Anatomical MRI (NIFTI format)\n\n');

fprintf('Optional data files:\n');
fprintf('  cfg.physio_data_file    - Physiological data (ECG, HR, etc.)\n\n');

fprintf('Optional settings:\n');
fprintf('  cfg.institution         - Institution name (default: Feinstein...)\n');
fprintf('  cfg.dataset_name        - Dataset name (default: BIDSroot)\n');
fprintf('  cfg.bids_version        - BIDS version (default: 1.9)\n');
fprintf('  cfg.ttl_channel_name    - TTL channel name in EDF (default: TTL)\n');
fprintf('  cfg.ttl_threshold       - TTL detection threshold (default: 0.5)\n');
fprintf('  cfg.writejson           - Write JSON files (default: yes)\n');
fprintf('  cfg.writetsv            - Write TSV files (default: yes)\n');
fprintf('  cfg.skip_ieeg           - Skip iEEG processing (default: false)\n');
fprintf('  cfg.skip_anatomy        - Skip anatomy processing (default: false)\n');
fprintf('  cfg.skip_physio         - Skip physiology processing (default: false)\n\n');

fprintf('COMMON WORKFLOWS\n');
fprintf('──────────────────────────────────────────────────────────────\n\n');

fprintf('1. Convert single subject/session with all data types:\n');
fprintf('   - Use bids_pipeline_template() with all data file paths\n\n');

fprintf('2. Convert multiple subjects (batch):\n');
fprintf('   - Run bids_pipeline_template() in a loop\n');
fprintf('   - One iteration per subject\n\n');

fprintf('3. Process only specific data types:\n');
fprintf('   - Set cfg.skip_<datatype> = true for unwanted types\n');
fprintf('   - Or call individual processing functions directly\n\n');

fprintf('4. Validate and fix BIDS structure:\n');
fprintf('   - Use bids_validate_structure() to check for errors\n');
fprintf('   - Manually update JSON files with correct acquisition parameters\n\n');

fprintf('IMPORTANT NOTES\n');
fprintf('──────────────────────────────────────────────────────────────\n\n');

fprintf('⚠  WARNINGS FOR NON-STANDARD ADDITIONS:\n');
fprintf('   - Physiology data is stored in custom ''physio/'' subdirectory\n');
fprintf('   - This will be flagged by BIDS validators\n');
fprintf('   - For official compliance, use standard BIDS data types\n\n');

fprintf('⚠  PLACEHOLDER VALUES IN METADATA:\n');
fprintf('   - JSON files contain example acquisition parameters\n');
fprintf('   - MUST be updated with actual values from your scanner\n');
fprintf('   - Especially: EchoTime, RepetitionTime, FlipAngle, SamplingFrequency\n\n');

fprintf('✓  DEPENDENCIES:\n');
fprintf('   - FieldTrip (for reading EDF files)\n');
fprintf('   - SPM or JSONlab (for JSON writing, or use fallback)\n');
fprintf('   - MATLAB R2016a or later\n\n');

fprintf('TROUBLESHOOTING\n');
fprintf('──────────────────────────────────────────────────────────────\n\n');

fprintf('Problem: ''TTL channel not found''\n');
fprintf('  Solution: Check exact channel name in EDF file\n');
fprintf('           Use ft_read_header(edf_file) to list channels\n\n');

fprintf('Problem: ''FieldTrip not in path''\n');
fprintf('  Solution: addpath(''/path/to/fieldtrip'')\n\n');

fprintf('Problem: ''JSON writing fails''\n');
fprintf('  Solution: Function attempts 3 methods:\n');
fprintf('           1. spm_jsonwrite (SPM toolbox)\n');
fprintf('           2. savejson (JSONlab)\n');
fprintf('           3. Fallback manual JSON writing\n');
fprintf('           At least one should work\n\n');

fprintf('Problem: ''Missing required columns in events.tsv''\n');
fprintf('  Solution: Ensure EDF file has TTL channel\n');
fprintf('           Check TTL threshold value\n');
fprintf('           Manually verify events.tsv has ''onset'', ''duration'' columns\n\n');

fprintf('GETTING STARTED\n');
fprintf('──────────────────────────────────────────────────────────────\n\n');

fprintf('1. Review example_pipeline_usage.m for a complete example\n');
fprintf('2. Read README.md in bids_functions folder for detailed documentation\n');
fprintf('3. Prepare your data files according to expected formats\n');
fprintf('4. Configure cfg structure and run bids_pipeline_template()\n');
fprintf('5. Validate output with bids_validate_structure()\n');
fprintf('6. Update metadata with accurate acquisition parameters\n');
fprintf('7. Test with online BIDS validator (bids-standard.github.io)\n\n');

fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║                     End of Help Guide                       ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

end
