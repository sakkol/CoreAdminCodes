function dataset_desc = bids_create_dataset_description(cfg)
% BIDS_CREATE_DATASET_DESCRIPTION - Create dataset_description.json file
%
% USAGE:
%   dataset_desc = bids_create_dataset_description(cfg)
%
% INPUT:
%   cfg - Configuration structure with fields:
%       cfg.bids_root - Root directory of BIDS dataset
%       cfg.dataset_name - Name of the dataset (default: 'BIDSroot')
%       cfg.bids_version - BIDS version (default: 1.9)
%       cfg.institution - Institution name (default: 'Feinstein Institutes for Medical Research')
%       cfg.writejson - Write to file ('yes'/'no', default: 'yes')
%
% OUTPUT:
%   dataset_desc - Structure containing dataset description metadata

%% Set defaults
if ~isfield(cfg, 'dataset_name')
    cfg.dataset_name = 'BIDSroot';
end
if ~isfield(cfg, 'bids_version')
    cfg.bids_version = 1.9;
end
if ~isfield(cfg, 'institution')
    cfg.institution = 'University of Alabama at Birmingham';
end
if ~isfield(cfg, 'writejson')
    cfg.writejson = 'yes';
end

%% Create dataset description structure (BIDS minimum requirements)
dataset_desc = [];
dataset_desc.Name = cfg.dataset_name;
dataset_desc.BIDSVersion = cfg.bids_version;
dataset_desc.DatasetType = 'raw';
dataset_desc.License = 'CC0';  % Placeholder, should be updated by user
dataset_desc.Authors = [];     % To be filled in
dataset_desc.Acknowledgements = '';
dataset_desc.HowToAcknowledge = '';
dataset_desc.Funding = [];
dataset_desc.EthicsApprovals = [];
dataset_desc.ReferencesAndLinks = [];
dataset_desc.DatasetDOI = '';
dataset_desc.SourceDatasets = [];  % If this is a derivative

%% Save to JSON file if requested
if strcmpi(cfg.writejson, 'yes')
    desc_file = fullfile(cfg.bids_root, 'dataset_description.json');
    
    % Create BIDS root directory if it doesn't exist
    if ~exist(cfg.bids_root, 'dir')
        mkdir(cfg.bids_root);
    end
    
    % Write JSON file using spm_jsonwrite or savejson (check which is available)
    try
        spm_jsonwrite(desc_file, dataset_desc, struct('indent', 2));
        fprintf('Created: %s\n', desc_file);
    catch
        try
            savejson('', dataset_desc, desc_file);
            fprintf('Created: %s\n', desc_file);
        catch
            % Fallback: write simple JSON manually
            fid = fopen(desc_file, 'w');
            fprintf(fid, '{\n');
            fprintf(fid, '  "Name": "%s",\n', dataset_desc.Name);
            fprintf(fid, '  "BIDSVersion": "%.1f",\n', dataset_desc.BIDSVersion);
            fprintf(fid, '  "DatasetType": "raw",\n');
            fprintf(fid, '  "License": "CC0",\n');
            fprintf(fid, '  "Authors": [],\n');
            fprintf(fid, '  "Acknowledgements": "",\n');
            fprintf(fid, '  "HowToAcknowledge": "",\n');
            fprintf(fid, '  "Funding": [],\n');
            fprintf(fid, '  "EthicsApprovals": [],\n');
            fprintf(fid, '  "ReferencesAndLinks": [],\n');
            fprintf(fid, '  "DatasetDOI": ""\n');
            fprintf(fid, '}\n');
            fclose(fid);
            fprintf('Created: %s (using fallback method)\n', desc_file);
        end
    end
end

end
