%load from CSV
arg_data = importdata('arg.csv');
arg_matrix = arg_data.data;

mag_data = importdata('mag.csv');
mag_matrix = mag_data.data;
    

fulldata= [arg_matrix mag_matrix];


% Set option = 0 for classification targets, 1 for regression targets
option = 1;

%Set t  to the number of modulation schemes in the dataset
t=15;

% Get the size of fulldata
 n = length(fulldata);

% Initialize targets
targets = zeros(1, n);

if option == 0
    % Classification
    
    step = floor(n / t);
    
    % Fill targets with values 0 to t-1
    for i = 0:t-1
        start_idx = i * step + 1;
        if i < t-1
            end_idx = (i+1) * step;
        else
            % For the last segment, include all remaining entries
            end_idx = n;
        end
        targets(start_idx:end_idx) = i;
    end
    writematrix(fulldata,'1_inputs_v.csv')
    writematrix(targets,'1_targets_v.csv')
    
elseif option == 1
    % Regression
    regression_values = [-10 -5 0 3 5 8 10 15 20 25 30 35 40];
    step = floor(n / 13);
    
    % Fill targets with regression values
    for i = 1:13
        start_idx = (i-1) * step + 1;
        if i < 13
            end_idx = i * step;
        else
            % For the last segment, include all remaining entries
            end_idx = n;
        end
        targets(start_idx:end_idx) = regression_values(i);
    end
    writematrix(fulldata,'1_inputs_snr_v.csv')
    writematrix(targets,'1_targets_snr_v.csv')
end




gscatter(arg_matrix,mag_matrix,targets)


