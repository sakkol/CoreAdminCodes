function mkdir_Sbj_Metadata(Sbj_Metadata)
% In order to create the folder tree from Sbj_Metadata:
% For now it includes: sbjDir, rawdata, params_dir, iEEG_data, results and behavioral.
% New (July, 2020): block folders within rawdata, iEEG_data and behavioral.

if ~exist(Sbj_Metadata.sbjDir,'dir')
    mkdir(Sbj_Metadata.sbjDir)
end

if ~exist(Sbj_Metadata.rawdata,'dir')
    mkdir(Sbj_Metadata.rawdata)
end

if ~exist(Sbj_Metadata.params_dir,'dir')
    mkdir(Sbj_Metadata.params_dir)
end

if ~exist(Sbj_Metadata.iEEG_data,'dir')
    mkdir(Sbj_Metadata.iEEG_data)
end

if ~exist(Sbj_Metadata.results,'dir')
    mkdir(Sbj_Metadata.results)
end

if isfield(Sbj_Metadata,'behavioral_root') && ~exist(Sbj_Metadata.behavioral_root,'dir')
    mkdir(Sbj_Metadata.behavioral_root)
end

%% Create subfolders for different blocks:
for b = 1:length(Sbj_Metadata.BlockLists)
    
    if ~exist(fullfile(Sbj_Metadata.rawdata,Sbj_Metadata.BlockLists{b}),'dir')
        mkdir(fullfile(Sbj_Metadata.rawdata,Sbj_Metadata.BlockLists{b}))
    end
    
    if ~exist(fullfile(Sbj_Metadata.iEEG_data,Sbj_Metadata.BlockLists{b}),'dir')
        mkdir(fullfile(Sbj_Metadata.iEEG_data,Sbj_Metadata.BlockLists{b}))
    end
    
    if isfield(Sbj_Metadata,'behavioral_root') && ~exist(fullfile(Sbj_Metadata.behavioral_root,Sbj_Metadata.BlockLists{b}),'dir')
        mkdir(fullfile(Sbj_Metadata.behavioral_root,Sbj_Metadata.BlockLists{b}))
    end
end
end