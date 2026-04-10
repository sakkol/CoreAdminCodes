function [corrSheet_import] = import_correspondenceSheet(corrSheet_file)
% Read label file (excel) and if 2nd input is ecog variable, write it out
% (to ecog.labelfile and ecog.bad_chans etc.). If overwrite ==1, it will
% not ask if it should overwrite these fields.
%
% corrSheet = excel sheet with initial info about the electrodes.
% row#1     = header 			
% columns   = label (str) / XLTEK# (num) / TDT# (num) / cable# (num) / TDT
% bank (str) / Good (0/1 - currently not used) / Spec (depth, strip, cranial, epidural, +/- hd_ if high density) / 
% SOZ (0/1) / Spikey (0/1) / Out (0/1) / BAD (0/1) ...maybe later add FS surface
% 
% 
% This is based on read_labelfile by sb (08/2018)
%
% Updated by Serdar Akkol, MD PhD for consistency with BIDS.
% April 2026, UAB

num=[]; txt=[]; raw=[]; corrSheet_import=[];
[num,txt,raw] = xlsread(corrSheet_file);

%% Import labels, tdt and natus numbers and channeltype
corrSheet_import.xls_file = corrSheet_file;
corrSheet_import.labels = txt(2:end,1);
corrSheet_import.TDT_nr  = num(:,2);
corrSheet_import.Natus_nr  = num(:,1);
corrSheet_import.Channeltype  = lower( txt(2:end,7) );

num_elec = size(corrSheet_import.labels,1);

header = []; c=1;
for i=1:size(raw,2)
    if ischar(raw{1,i})
        header{c} = raw{1,i};
        c=c+1;
    end
end

%% Import SOZ channels

ind = find(contains(lower(header),'soz'));
if isempty(ind)
    error('Did not find SOZ column (even with case insensitive search)');
end
corrSheet_import.soz=[];
c=1;
for i=2:num_elec+1
    corrSheet_import.soz(c,1) = raw{i,ind};
    c=c+1;
end

%% import spikey chns
ind = find(contains(lower(header),'spikey'));
if isempty(ind)
    error('Did not find Spikey column (even with case insensitive search)');
end
corrSheet_import.spikey=[];
c=1;
for i=2:num_elec+1
    corrSheet_import.spikey(c,1) = raw{i,ind}; c=c+1;
end


%% Import freesurfer labels if present

ind = find(contains(lower(header),'fs_label'));
if isempty(ind)
    disp('Did not find FS_label column (even with case insensitive search)');
else
    corrSheet_import.FS_labels=[];
    c=1;
    for i=2:num_elec+1
        corrSheet_import.FS_labels{c,1} = raw{i,ind};
        c=c+1;
    end
end

%% Import PTD  if present

ind = find(contains(lower(header),'ptd'));
if isempty(ind)
    disp('Did not find PTD column (even with case insensitive search)');
else
    corrSheet_import.PTD=[];
    c=1;
    for i=2:num_elec+1
        corrSheet_import.PTD(c,1) = raw{i,ind};
        c=c+1;
    end
end


%% Not really using the good column later, but it's there so import it...
ind = find(contains(lower(header),'good'));
if isempty(ind)
    error('Did not find Good column (even with case insensitive search)');
end
corrSheet_import.good=[];
c=1;
for i=2:num_elec+1
    corrSheet_import.good(c,1) = raw{i,ind}; c=c+1;
end


%% Import bad channels
ind = find(contains(lower(header),'bad'));
if isempty(ind)
    error('Did not find BAD column (even with case insensitive search)');
end
corrSheet_import.bad=[];
c=1;
for i=2:num_elec+1
    corrSheet_import.bad(c,1) = raw{i,ind}; c=c+1;
end

%% import out 
ind = find(contains(lower(header),'out'));
if isempty(ind)
    error('Did not find OUT column (even with case insensitive search)');
end
corrSheet_import.out=[];
c=1;
if ~isempty(ind)
    for i=2:num_elec+1
        corrSheet_import.out(c,1) = raw{i,ind}; c=c+1;
    end
end

end

