function construct_roots(data_root,project_names)
% This helps with setting up the new computer directories easily.
vars=who;
if ~ismember(vars,'project_names')
    project_names = {'Rest'};
elseif isempty(project_names)
    project_names = {'Rest'};
end

% Create main directories
fprintf('Created:%s\n',fullfile(data_root,'PROJECTS_DATA'))
mkdir(fullfile(data_root,'PROJECTS_DATA'))
fprintf('Created:%s\n',fullfile(data_root,'DERIVATIVES','freesurfer'))
mkdir(fullfile(data_root,'DERIVATIVES','freesurfer'))

% Create project directories
for p = 1:length(project_names)
    fprintf('Created:%s\n',fullfile(data_root,'PROJECTS_DATA',project_names{p}))
    mkdir(fullfile(data_root,'PROJECTS_DATA',project_names{p}))
end
end