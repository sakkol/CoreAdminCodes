function [freesurfer_dir, freesurfer_name] = find_freesurfer_dir_name(main_root, sbj_ID)
% low level function to find freesurfer directory of subject and the
% subject name as used in freesurfer folder.

splsbj_ID = strsplit(sbj_ID,'_');
if length(splsbj_ID) == 1
    freesurfer_dir = fullfile(main_root, 'DERIVATIVES','freesurfer',sbj_ID);
    freesurfer_name = sbj_ID;
else
    if length(splsbj_ID{2}) > 1     % if the name is like NS128_02, this is also fine
        freesurfer_dir = fullfile(main_root, 'DERIVATIVES','freesurfer',sbj_ID);
        freesurfer_name = sbj_ID;
    else                            % if the name is like NS128_2, then put a "0" between "_" and "2"
        freesurfer_dir = fullfile(main_root, 'DERIVATIVES','freesurfer',[splsbj_ID{1} '_0' splsbj_ID{2}]);
        freesurfer_name = [splsbj_ID{1} '_0' splsbj_ID{2}];
    end
end
if ~exist(freesurfer_dir,'dir')
    warning('There is no Freesurfer folder')
    freesurfer_dir = [];
end

end