%% If needed, elaborate on this function to be able to merge block with same parameters:



BlockInfo = readtable(fullfile(Sbj_Metadata.project_root,[Sbj_Metadata.project_name '_BlockInfo.xlsx']));

%% Grouping the blocks:
info4grouping = BlockInfo(strcmp(BlockInfo.sbj_ID,sbj_ID),[2,6,7,10,11,12,15,16]); % based on stim electrode, trainFreq, peakvsvalley and openvsclosed loop and eyes openvsclosed
groups=findgroups(info4grouping.StimCh1_lab,info4grouping.peak_valley,info4grouping.trainFreq,info4grouping.open_closed,info4grouping.trainNum,info4grouping.eyes);

conditions = {};
for grs = 1:max(groups)
    conditions{grs} = info4grouping(groups==grs,:);
end

plotgroups = findgroups(info4grouping.StimCh1_lab,info4grouping.peak_valley,info4grouping.open_closed,info4grouping.trainNum,info4grouping.eyes);
plotconds = {};
for grs = 1:max(plotgroups)
    plotconds{grs} = info4grouping(plotgroups==grs,:);
end

tobemergedblocks = cell(size(conditions));x=1;
for i=1:length(conditions)
    if size(conditions{i},1)>1
        for n=1:length(plotconds)
            if contains(conditions{i}.BlockList,plotconds{n}.BlockList)
                tobemergedblocks{x} = plotconds{n}.BlockList(contains(plotconds{n}.BlockList,conditions{i}.BlockList),:);
                x=x+1;
            end
        end
    end
end
list_tobemerged=[tobemergedblocks{:}];

%%

if ismember(list_tobemerged,plotconds{conds}.BlockList)
    howmanygroups = sum(ismember(list_tobemerged(1,:),plotconds{conds}.BlockList),2);
    for grs = 1:howmanygroups
        howmany_tomerge = sum(size(list_tobemerged(:,grs),1));
        for i=1:howmany_tomerge
            wltfiles = dir(fullfile(Sbj_Metadata.iEEG_data,list_tobemerged{i,grs}, ['*_ecog_' ref '_wlt.mat']));
            load(fullfile(wltfiles.folder,wltfiles.name));
            
            % powspctrm conversion from 3dimension to 4 dimension
            % (averaging trials, which was not averaged during
            % CLtrain_TFanalysis_SA.m)
            wlt_post.powspctrm_meantrls = squeeze(nanmean(wlt_post.powspctrm,1));
            wlt_bl.powspctrm_meantrls = squeeze(nanmean(wlt_bl.powspctrm,1));
            
            ntime = length(wlt_post.time);
            
            % Z-transform post wlt (whole epoch)
            m = nanmean(wlt_post.powspctrm_meantrls,3);
            stdbl = nanstd(wlt_post.powspctrm_meantrls,0,3);
            wlt_post.powspctrm_z = (wlt_post.powspctrm_meantrls-repmat(m,1,1,ntime))./repmat(stdbl,1,1,ntime);
            
            % Z-transform post using pre-stim-baseline
            m = nanmean(wlt_bl.powspctrm_meantrls,3);
            stdbl = nanstd(wlt_bl.powspctrm_meantrls,0,3);
            wlt_post.powspctrm_z_bl = (wlt_post.powspctrm_meantrls-repmat(m,1,1,ntime))./repmat(stdbl,1,1,ntime);
            
            eval(['wlt_bl_' num2str(i) ' =  wlt_bl; ']);
            eval(['wlt_post_' num2str(i) ' =  wlt_post; ']);
            clear wlt_bl wlt_post m stdbl
        end
        
        % combining/merging same type of parameter blocks
        
        
        
        eval(['wlt_bl_' num2str(grs) ' =  wlt_bl; ']);
        eval(['wlt_post_' num2str(grs) ' =  wlt_post; ']);
        
    end
    
else
    wltfiles = dir(fullfile(Sbj_Metadata.iEEG_data,conditions{conds}.BlockList{1}, ['*_ecog_' ref '_wlt.mat']));
    load(fullfile(wltfiles.folder,wltfiles.name));
    
    avg2plot = squeeze(mean(wlt_post.tdom_trial,1));
    eval(['wlt_temp = wlt_post_' num2str(stim_i) ';']);
    eval(['wlt_bl_temp = wlt_bl_' num2str(stim_i) ';']);
    eval(['avg2plot = squeeze(mean(wlt_post_' num2str(stim_i) '.tdom_trial,1));']);
    avg2plot = zscore(avg2plot(chn_i,:));
end