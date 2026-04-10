function bids_create_sidecar_json(json_struct, output_file)
% BIDS_CREATE_SIDECAR_JSON - Create BIDS sidecar JSON files
%
% USAGE:
%   bids_create_sidecar_json(json_struct, output_file)
%
% INPUT:
%   json_struct - Structure containing JSON data
%   output_file - Path to output JSON file
%
% NOTES:
%   This function attempts to use available JSON writing functions
%   (spm_jsonwrite, savejson, or fallback manual writing)

%% Ensure output directory exists
output_dir = fileparts(output_file);
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

%% Try different JSON writing methods
try
    % Try SPM's JSON writer first (most robust)
    spm_jsonwrite(output_file, json_struct, struct('indent', 2));
    
catch
    try
        % Try JSONlab's savejson
        savejson('', json_struct, output_file);
        
    catch
        % Fallback: write JSON manually
        fid = fopen(output_file, 'w');
        
        % Write opening brace
        fprintf(fid, '{\n');
        
        % Get all field names
        fields = fieldnames(json_struct);
        
        % Write each field
        for i = 1:length(fields)
            field_name = fields{i};
            field_value = json_struct.(field_name);
            
            % Format field name
            fprintf(fid, '  "%s": ', field_name);
            
            % Write appropriate value type
            if ischar(field_value) || isstring(field_value)
                % String value
                fprintf(fid, '"%s"', field_value);
            elseif isnumeric(field_value)
                % Numeric value
                if isscalar(field_value)
                    fprintf(fid, '%g', field_value);
                else
                    % Array - convert to JSON array format
                    fprintf(fid, '[%s]', sprintf('%g, ', field_value(1:end-1)));
                    fprintf(fid, '%g]', field_value(end));
                end
            elseif isstruct(field_value)
                % Nested structure (object)
                fprintf(fid, '{');
                nested_fields = fieldnames(field_value);
                for j = 1:length(nested_fields)
                    nested_field = nested_fields{j};
                    nested_value = field_value.(nested_field);
                    fprintf(fid, '\n    "%s": ', nested_field);
                    
                    if ischar(nested_value) || isstring(nested_value)
                        fprintf(fid, '"%s"', nested_value);
                    elseif isnumeric(nested_value)
                        fprintf(fid, '%g', nested_value);
                    elseif isstruct(nested_value)
                        fprintf(fid, '{}');  % Empty nested object
                    elseif iscell(nested_value)
                        fprintf(fid, '[%s]', sprintf('"%s", ', nested_value{1:end-1}));
                        fprintf(fid, '"%s"]', nested_value{end});
                    else
                        fprintf(fid, 'null');
                    end
                    
                    if j < length(nested_fields)
                        fprintf(fid, ',');
                    end
                end
                fprintf(fid, '\n  }');
                
            elseif iscell(field_value)
                % Cell array - convert to JSON array
                fprintf(fid, '[');
                for j = 1:length(field_value)
                    val = field_value{j};
                    if ischar(val) || isstring(val)
                        fprintf(fid, '"%s"', val);
                    elseif isnumeric(val)
                        fprintf(fid, '%g', val);
                    else
                        fprintf(fid, 'null');
                    end
                    if j < length(field_value)
                        fprintf(fid, ', ');
                    end
                end
                fprintf(fid, ']');
            else
                % Default: null
                fprintf(fid, 'null');
            end
            
            % Add comma between fields (not after last field)
            if i < length(fields)
                fprintf(fid, ',\n');
            else
                fprintf(fid, '\n');
            end
        end
        
        % Write closing brace
        fprintf(fid, '}\n');
        fclose(fid);
    end
end

end
