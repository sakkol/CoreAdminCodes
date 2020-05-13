function params = adaptParams(Sbj_Metadata,block)

paramsfile = fullfile(Sbj_Metadata.params_dir,'raw_params',[Sbj_Metadata.sbj_ID '_' block '_params.m']);
if ~exist(paramsfile,'file')
    block_erased = erase(block,{'_CLtrain','_Cltrain','_cltrain','_CL','_OL','_ol'});
    paramsfile = fullfile(Sbj_Metadata.params_dir,'raw_params',[Sbj_Metadata.sbj_ID '_' block_erased '_params.m']);
end
run(paramsfile)

params.directory = char(fullfile(Sbj_Metadata.rawdata,block));
params.directoryOUT = char(fullfile(Sbj_Metadata.iEEG_data,block));
params.directoryPICS = char(fullfile(Sbj_Metadata.iEEG_data,block,'PICS'));

if ~exist(params.directoryOUT,'dir')
    mkdir(params.directoryOUT)
end

if ~exist(params.directoryPICS,'dir')
    mkdir(params.directoryPICS)
end

params.labelfile = Sbj_Metadata.labelfile;

paramsfile = fullfile(Sbj_Metadata.params_dir,[Sbj_Metadata.sbj_ID '_' block '_params.mat']);
params.paramsfile = paramsfile;

save(paramsfile, 'params')

end