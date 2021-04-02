function move_copy_select_files(data_root,project_name,move_to,what_to_move)
% This function can be called to move or copy specific files across
% subjects to a delineated location. 

%% Set the stage
if ~exist('data_root','var') || isempty(data_root)
    data_root = '/media/sakkol/HDD1/HBML/';
end
if ~exist('project_name','var') || isempty(project_name)
    projs = dir(fullfile(data_root,'PROJECTS_DATA'));
    projs = {projs.name};projs = projs(~ismember(projs,{'.','..'}));
    [indx,~] = listdlg('ListString',projs);
    project_name  =projs{indx};
end
if ~exist('move_to','var') || isempty(move_to)
    move_to = uigetdir(data_root);
end
if ~exist('what_to_move','var') || isempty(what_to_move)
    prompt = 'Enter which files to move:';
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'_ecog_bp'};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    what_to_move = answer{1};
end
copy_move = questdlg('Important choice to make', ...
        'Do you want to copy or move the files?', ...
        'Copy','Move','Copy');

%% Create paths of all files to be moved
AllBlockInfo = readtable(fullfile(data_root,'PROJECTS_DATA',project_name,[project_name '_BlockInfo.xlsx']));
subjects = unique(AllBlockInfo.sbj_ID);
all_present={};all_absent={};
for s = 1:length(subjects)
    sbj_ID = subjects{s};
    Sbj_Metadata = makeSbj_Metadata(data_root, project_name, sbj_ID); % 'SAkkol_Stanford'
    whichblocks = AllBlockInfo.BlockList(ismember(AllBlockInfo.sbj_ID,sbj_ID));
    for b = 1:length(whichblocks)
        curr_block = whichblocks{b};
        xx = dir(fullfile(Sbj_Metadata.iEEG_data,curr_block,[curr_block what_to_move '.mat']));
        if isempty(xx)
            all_absent{end+1,1} = fullfile(Sbj_Metadata.iEEG_data,curr_block,[curr_block what_to_move '.mat']);
        elseif length(xx) == 1
            all_present{end+1,1} = xx.folder;
            all_present{end,2} = xx.name;
            all_present{end,3} = sbj_ID;
        else
            error(['More than one files are recognized with the same parameters here: ' xx(1).folder])
        end        
    end
end

%% Create a text file to take note of the process
t=datetime;
ts=replace(char(datetime),{':',' ','-'},'_');
fileID = fopen(fullfile(move_to,['mv_select_files_' ts '.txt']),'w');
if ~strcmp(copy_move,'Copy')
fprintf(fileID,'Moving files using "mv_select_files.m" (date:%s).\n\n',char(t));
fprintf(fileID,'Project from files that are moved: "%s".\n',project_name);
fprintf(fileID,'Files with extension "%s" are moved.\n\n',what_to_move);
else
fprintf(fileID,'Copying files using "mv_select_files.m" (date:%s).\n\n',char(t));
fprintf(fileID,'Project from files that are copied: "%s".\n',project_name);
fprintf(fileID,'Files with extension "%s.mat" are copied.\n\n',what_to_move);
end

% first move and write out the ones that were moved
fprintf(fileID,'The files that were found and their new locations are in "%s":\n',move_to);
for f = 1:size(all_present,1)
    if strcmp(copy_move,'Copy')
        copyfile(fullfile(all_present{f,1},all_present{f,2}),fullfile(move_to,[all_present{f,3} '_' all_present{f,2}]))
    else
        movefile(fullfile(all_present{f,1},all_present{f,2}),fullfile(move_to,[all_present{f,3} '_' all_present{f,2}]))
    end
    fprintf(fileID,[fullfile(all_present{f,1},all_present{f,2}) '\n']);
end
% second write out the ones that were not be able to be moved
fprintf(fileID,'\n\nThese files are not found.\n');
for f = 1:size(all_absent,1)
    fprintf(fileID,[all_absent{f,1} '\n']);
end
fclose(fileID);
end
