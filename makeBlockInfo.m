function BlockInfo = makeBlockInfo(Sbj_Metadata,curr_block)

AllBlockInfo = readtable(fullfile(Sbj_Metadata.project_root,[Sbj_Metadata.project_name '_BlockInfo.xlsx']));
BlockInfo = AllBlockInfo((strcmp(AllBlockInfo.sbj_ID,Sbj_Metadata.sbj_ID) & strcmp(AllBlockInfo.BlockList,curr_block)),:);

if isempty(AllBlockInfo) || isempty(BlockInfo)
    warning('Couldn''t load Block List or current block for patient: %s',Sbj_Metadata.sbj_ID)
end
end