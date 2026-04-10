function BlockInfo = make_BlockInfoBIDS(Sbj_MetadataBIDS)

AllBlockInfo = readtable(fullfile(Sbj_MetadataBIDS.project_root,[Sbj_MetadataBIDS.project_name '_BlockInfo.xlsx'])); % "F:\HBML\PROJECTS_DATA\CL_Train\CL_Train_BlockInfo.xlsx"
BlockInfo = AllBlockInfo(strcmpi(AllBlockInfo.sub,Sbj_MetadataBIDS.sub),:);

if isempty(AllBlockInfo) || isempty(BlockInfo)
    warning('Couldn''t load Block List or current block for patient: %s',Sbj_Metadata.sbj_ID)
end
end