function [correspondenceSheet_file] = create_correspondenceSheet(Sbj_MetadataBIDS)
% to create the correspondence sheet easily, so there is no copy paste.
% This will include all the channel names. All channels might be important
% or can be used later. 
% possible future thoughts: write the specifications of channels, like
% depth, ecg, micro etc.

%% Read entire EDF header once
hdr = ft_read_header(char(Sbj_MetadataBIDS.sourcedata_raw_edf_file));

% find the correspondence sheet
example_corrSheet = readtable(which('example_correspondence_sheet.xlsx'));

% clear what is inside
example_corrSheet(:,:)=[];

% Get number of channels
nChannels = numel(hdr.label);

% Create a new empty table with the same columns but correct number of rows
corrSheet = array2table(repmat({''}, nChannels, width(example_corrSheet)), ...
    'VariableNames', example_corrSheet.Properties.VariableNames);

% Assign labels and numbers
corrSheet.Label = hdr.label;
corrSheet.XLTEK_chan = [1:nChannels]';
corrSheet.TDT_chan = [1:nChannels]';

% corr sheet name
correspondenceSheet_file = fullfile(Sbj_MetadataBIDS.freesurfer,'elec_recon',[Sbj_MetadataBIDS.sub '_correspondence_sheet.xlsx']);

% now write it out
disp([' --> Writing correspondence sheet: ' correspondenceSheet_file]);
writetable(corrSheet,correspondenceSheet_file);

end