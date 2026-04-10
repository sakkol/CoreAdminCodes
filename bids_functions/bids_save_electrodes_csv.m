function bids_save_electrodes_csv(info, Sbj_MetadataBIDS)
% BIDS_SAVE_ELECTRODES_CSV - Save electrode/channel information to CSV file
% obtained from the info.channelinfo.

%% Save the channelinfo as electrodes.csv
channelinfo_clean = prepare_table_for_csv(info.channelinfo);
fprintf('Writing electrode information to CSV...\n');
writetable(channelinfo_clean, Sbj_MetadataBIDS.ieeg.electrodes_csv);
fprintf('✓ Saved: %s\n', Sbj_MetadataBIDS.ieeg.electrodes_csv);

end


%% Helper function: Prepare table for CSV export
function table_clean = prepare_table_for_csv(input_table)
table_clean = input_table;
% Convert categorical columns to strings
for col = 1:width(table_clean)
    var_name = table_clean.Properties.VariableNames{col};
    if iscategorical(table_clean.(var_name))
        table_clean.(var_name) = string(table_clean.(var_name));
    end
end

% Convert logical to strings
for col = 1:width(table_clean)
    var_name = table_clean.Properties.VariableNames{col};
    if islogical(table_clean.(var_name))
        table_clean.(var_name) = string(table_clean.(var_name));
    end
end

% Replace NaN with 'NaN' string for visibility
for col = 1:width(table_clean)
    var_name = table_clean.Properties.VariableNames{col};
    col_data = table_clean.(var_name);
    
    if isnumeric(col_data)
        nan_idx = isnan(col_data);
        if any(nan_idx)
            col_data_str = string(col_data);
            col_data_str(nan_idx) = "NaN";
            table_clean.(var_name) = col_data_str;
        end
    end
end

end
