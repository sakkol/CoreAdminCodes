%% CHECK THE LENGTHS OF EVENTS
% Come to iEEG_data folder of the subject and then run this
allecog = dir(fullfile(pwd,'*','*_ecog.mat'));
for i=1:length(allecog)
    ecogss = load(fullfile(allecog(i).folder,allecog(i).name));
    fprintf('There are %d events in %s.\n',size(ecogss.ecog.events.eventsSample,2),allecog(i).name)
end