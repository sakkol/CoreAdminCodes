function BlockList = makeBlockLists(Sbj_Metadata)

blocklistsheet = [char(Sbj_Metadata.project_root) filesep char(Sbj_Metadata.project_name) '_BlockInfo.xlsx']; % "F:\HBML\PROJECTS_DATA\CL_Train\CL_Train_BlockLists.xlsx";    

blocklistall = readtable(blocklistsheet);
BlockList = blocklistall.BlockList(strcmpi(blocklistall.sbj_ID,Sbj_Metadata.sbj_ID));

if isempty(BlockList)
    error('There is No Block for patient: %s',Sbj_Metadata.sbj_ID)
end
end