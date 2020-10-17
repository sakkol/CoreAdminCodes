function BlockList = makeBlockLists(Sbj_Metadata)

AllBlockInfo = readtable(fullfile(Sbj_Metadata.project_root,[Sbj_Metadata.project_name '_BlockInfo.xlsx'])); % "F:\HBML\PROJECTS_DATA\CL_Train\CL_Train_BlockInfo.xlsx"
BlockList = AllBlockInfo.BlockList(strcmpi(AllBlockInfo.sbj_ID,Sbj_Metadata.sbj_ID));

if isempty(BlockList)
    error('Subject %s does not have any block run in this task or BlockInfo sheet has not been updated and saved.',Sbj_Metadata.sbj_ID)
end
end