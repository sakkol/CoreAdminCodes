function [good_chans] = get_info_goodchans(info)
% input is info prepared by create_elecinfo and output is channels
% excluding SOZ, outofbrain, artifact patient and artifact block. Simple.
good_chans = info.channelinfo.Label(...
    info.channelinfo.SOZ~=1&...
    info.channelinfo.epileptic_spikes~=1&...
    info.channelinfo.outofthebrain~=1&...
    info.channelinfo.artifact_patient~=1&...
    info.channelinfo.artifact_block~=1);
end