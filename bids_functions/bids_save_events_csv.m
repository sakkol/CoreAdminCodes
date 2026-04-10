function events_output = bids_save_events_csv(events_table, output_file, varargin)
% BIDS_SAVE_EVENTS_CSV - Save behavioral events to CSV file
%
% Saves events information to CSV format, complementing the TSV format
% used by BIDS. Useful for analysis and compatibility with other tools.
%
% USAGE:
%   events_output = bids_save_events_csv(events_table, output_file)
%   events_output = bids_save_events_csv(events_table, output_file, 'param', value, ...)
%
% INPUT:
%   events_table - Table with event information
%       Required columns: 'onset', 'duration'
%       Optional columns: 'trial_type', 'value', 'response', 'accuracy'
%
%   output_file - Path to save the CSV file
%
% OPTIONAL PARAMETERS:
%   'delimiter' - CSV delimiter character (default: ',')
%   'header' - Include header row (default: true)
%   'description' - Add description column to output (default: false)
%
% OUTPUT:
%   events_output - Structure containing:
%       .filename - Path to saved CSV file
%       .n_events - Number of events
%       .table - The saved events table
%       .columns - Column names
%
% EXAMPLE:
%   % Create events table
%   events = table();
%   events.onset = [0; 1.5; 3.2; 4.8];
%   events.duration = [0.1; 0.1; 0.1; 0.1];
%   events.trial_type = {'stimulus'; 'stimulus'; 'response'; 'response'};
%   
%   % Save to CSV
%   output = bids_save_events_csv(events, '/path/to/events.csv');

%% Parse optional arguments
p = inputParser;
addParameter(p, 'delimiter', ',', @ischar);
addParameter(p, 'header', true, @islogical);
addParameter(p, 'description', false, @islogical);
parse(p, varargin{:});

delimiter = p.Results.delimiter;

%% Input validation
if ~istable(events_table)
    error('events_table must be a table');
end

if ~ismember('onset', events_table.Properties.VariableNames)
    error('events_table must contain an ''onset'' column (BIDS requirement)');
end

if ~ismember('duration', events_table.Properties.VariableNames)
    error('events_table must contain a ''duration'' column (BIDS requirement)');
end

if nargin < 2 || isempty(output_file)
    error('output_file path is required');
end

%% Initialize output
events_output = [];
events_output.filename = output_file;
events_output.n_events = height(events_table);

fprintf('Saving %d events to CSV...\n', events_output.n_events);

%% Prepare output table
output_table = events_table;

% Add description column if requested
if p.Results.description
    if ~ismember('description', output_table.Properties.VariableNames)
        output_table.description = cell(height(output_table), 1);
        for i = 1:height(output_table)
            % Create description from available fields
            desc_parts = {};
            
            if ismember('trial_type', output_table.Properties.VariableNames)
                desc_parts{end+1} = sprintf('Type: %s', output_table.trial_type{i});
            end
            
            if ismember('value', output_table.Properties.VariableNames)
                val = output_table.value(i);
                if iscell(val)
                    val = val{1};
                end
                desc_parts{end+1} = sprintf('Value: %s', num2str(val));
            end
            
            if ismember('response', output_table.Properties.VariableNames)
                desc_parts{end+1} = sprintf('Response: %s', output_table.response{i});
            end
            
            output_table.description{i} = sprintf('[%s]', sprintf('%s | ', desc_parts{:}));
            output_table.description{i}(end-2:end) = ']';  % Remove last ' | '
        end
    end
end

%% Create output directory if needed
output_dir = fileparts(output_file);
if ~isempty(output_dir) && ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

%% Save to CSV (using writetable for CSV format)
if strcmp(delimiter, ',')
    % Native CSV format
    writetable(output_table, output_file);
else
    % Use tab or other delimiter
    writetable(output_table, output_file, 'Delimiter', delimiter);
end

fprintf('Saved to: %s\n', output_file);

end
