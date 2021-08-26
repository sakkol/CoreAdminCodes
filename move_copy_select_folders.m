function move_copy_select_folders(data_root,project_name,move_to,what_to_move)
% This function can be called to move or copy specific folders across
% subjects to a delineated location. 

%% Set the stage
if ~exist('data_root','var') || isempty(data_root)
    data_root = '/media/sakkol/HDD1/HBML/';
end
if ~exist('project_name','var') || isempty(project_name)
    projs = dir(fullfile(data_root,'PROJECTS_DATA'));
    projs = {projs.name};projs = projs(~ismember(projs,{'.','..'}));
    [indx,~] = listdlg('ListString',projs);
    try
        project_name = projs{indx};
    catch
        error('No project selected!')
    end
end
if ~exist('move_to','var') || isempty(move_to)
    move_to = uigetdir(data_root);
end
if move_to==0,error('No folders selected!'),end
if ~exist('what_to_move','var') || isempty(what_to_move)
    prompt = 'Enter which folders to move/copy:';
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'rawdata'};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    what_to_move = answer{1};
end
copy_move = questdlg('Important choice to make', ...
        'Do you want to copy or move the files?', ...
        'Copy','Move','Copy');
if strcmp(copy_move,''),error('Ok, quiting!'),end

%% Create paths of all files to be moved
AllBlockInfo = readtable(fullfile(data_root,'PROJECTS_DATA',project_name,[project_name '_BlockInfo.xlsx']));
subjects = unique(AllBlockInfo.sbj_ID);
all_present={};all_absent={};
for s = 1:length(subjects)
    sbj_ID = subjects{s};if isempty(sbj_ID),continue,end
    Sbj_Metadata = makeSbj_Metadata(data_root, project_name, sbj_ID); % 'SAkkol_Stanford'
    whichblocks = AllBlockInfo.BlockList(ismember(AllBlockInfo.sbj_ID,sbj_ID));
    for b = 1:length(whichblocks)
        curr_block = whichblocks{b};
        xx = fullfile(Sbj_Metadata.(what_to_move),curr_block);
        if ~exist(xx)
            all_absent{end+1,1} = Sbj_Metadata.project_root;
            all_absent{end,2} = erase(xx,Sbj_Metadata.project_root);
        else
            all_present{end+1,1} = Sbj_Metadata.project_root;
            all_present{end,2} = erase(xx,Sbj_Metadata.project_root);
        end
    end
end

%% Create a text file to take note of the process
t=datetime;
ts=replace(char(datetime),{':',' ','-'},'_');
fileID = fopen(fullfile(move_to,['mv_select_files_' ts '.txt']),'w');
if ~strcmp(copy_move,'Copy')
fprintf(fileID,'Moving files using "move_copy_select_folders.m" (date:%s).\n\n',char(t));
fprintf(fileID,'Project from where the folders are moved: "%s".\n',project_name);
fprintf(fileID,'Folders in "%s" folder moved.\n\n',what_to_move);
else
fprintf(fileID,'Copying files using "move_copy_select_folders.m" (date:%s).\n\n',char(t));
fprintf(fileID,'Project from where the folders are copied: "%s".\n',project_name);
fprintf(fileID,'Folders in "%s" folder copied.\n\n',what_to_move);
end

% first move and write out the ones that were moved
fprintf(fileID,'The files that were found and their new locations are in "%s":\n',move_to);
for f = 1:size(all_present,1)
    if strcmp(copy_move,'Copy')
        copyfile(fullfile(all_present{f,1},all_present{f,2}),fullfile(move_to,all_present{f,2}))
    else
        try
            movefile(fullfile(all_present{f,1},all_present{f,2}),fullfile(move_to,all_present{f,2}))
            fprintf(fileID,[fullfile(all_present{f,1},all_present{f,2}) '\n']);
        catch
            fprintf(fileID,[fullfile(all_present{f,1},all_present{f,2}) ' : already empty\n']);
        end
    end
    
    fprintf([fullfile(all_present{f,1},all_present{f,2}) '\n']);
end
% second write out the ones that were not be able to be moved
fprintf(fileID,'\n\nThese folders are not found.\n');
for f = 1:size(all_absent,1)
    fprintf(fileID,[all_absent{f,1} '\n']);
end
fclose(fileID);
end
