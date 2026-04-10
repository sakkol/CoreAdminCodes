function BlockList = make_BlockListsBIDS(Sbj_MetadataBIDS)

AllBlockInfo = readtable(fullfile(Sbj_MetadataBIDS.project_root,[Sbj_MetadataBIDS.project_name '_BlockInfo.xlsx'])); % "F:\HBML\PROJECTS_DATA\CL_Train\CL_Train_BlockInfo.xlsx"
BlockList = AllBlockInfo.BlockList(strcmpi(AllBlockInfo.sub,Sbj_MetadataBIDS.sub));

if isempty(BlockList)
    warning('Subject %s does not have any block run in this task or BlockInfo sheet has not been updated and saved.',Sbj_MetadataBIDS.sbj_ID)
end
end