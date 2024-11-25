%   Function to extract ion intensites given a mass list MHmass
%   and a tolerence cutoffppm. The input data is generated from the function
%   load_data_mzml.m.


function [analyte_matrix, signal_inten] = mass_intensity_dev2(MHmass,cutoffppm,peak_data,NumberOfScans)
%   allocate matrices for intensity, closest mass and mass difference.
all_intensities = cell(length(peak_data),1);
all_closest_mass =  cell(length(peak_data),1);
all_mass_diff =  cell(length(peak_data),1);

% Initialize waitbar
    function nUpdateWaitbar(~)
        waitbar(p/length(peak_data), h);
        p = p + 1;
    end

% Calculate mass differences and find the minimum mass difference between
% the input MHmass and the data. If the number of ions in MHmass is bigger
% than 1 (one) use pralell computing, otherwise do it on a single core.

switch length(MHmass)>1.5
    case 1
        D = parallel.pool.DataQueue;
        h = waitbar(0,'Please wait extracting features...');
        afterEach(D,@nUpdateWaitbar);
        p = 1;

        % For each line scan initialize matrices for calculating mass
        % difference, closest mass and intensity value

        parfor i = 1:length(peak_data)

            linescan_data = peak_data{i};

            % Ensure all entries in linescan_data are non-empty and have valid dimensions
            for j = 1:length(linescan_data)
                if isempty(linescan_data{j}) || size(linescan_data{j}, 2) < 2
                    % Replace empty entries with a placeholder [0, 0]
                    linescan_data{j} = [0, 0];
                end
            end
            % disp(linescan_data)
            massdiff = zeros(size(MHmass,1),size(linescan_data,1));
            closestmass = zeros(size(MHmass,1),size(linescan_data,1));
            intensities = zeros(size(MHmass,1),size(linescan_data,1));
            % For each scan event in a line scan determine the closest mass
            % to charge value and store the difference, the actual mass and
            % intensity
            for j = 1:length(linescan_data)
                scan = linescan_data{j};

                %disp(scan)
                %disp(size(MHmass));
                disp(j);

                [~, idx1] = min(abs(MHmass - scan(:,1)'),[],2);
                massdiff(:,j) = (abs((scan(idx1,1)-MHmass)./MHmass)*1E6)';
                closestmass(:,j) = scan(idx1,1);
                intensities(:,j) = scan(idx1,2);
            end
            all_mass_diff{i} = massdiff;
            all_closest_mass{i} = closestmass;
            all_intensities{i} = intensities;
            send(D,i);
        end


        close(h)
    case 0
        for i = 1:length(peak_data)
            linescan_data = peak_data{i};
            massdiff = zeros(size(MHmass,1),size(linescan_data,1));
            closestmass = zeros(size(MHmass,1),size(linescan_data,1));
            intensities = zeros(size(MHmass,1),size(linescan_data,1));
            for j = 1:length(linescan_data)
                scan = linescan_data{j};

                [~, idx1] = min(abs(MHmass - scan(:,1)'),[],2);
                massdiff(:,j) = (abs((scan(idx1,1)-MHmass)./MHmass)*1E6)';
                closestmass(:,j) = scan(idx1,1);
                intensities(:,j) = scan(idx1,2);
            end
            all_mass_diff{i} = massdiff;
            all_closest_mass{i} = closestmass;
            all_intensities{i} = intensities;

        end
end
fs_mass_diff = cell(length(peak_data),1);
fs_closest_mass = cell(length(peak_data),1);
signal_inten = cell(length(peak_data),1);

% Save data if the ppm tolerance is below the treshold.
for u = 1:length(all_mass_diff)

    tmp_diff = all_mass_diff{u};
    tmp_closest_mass = all_closest_mass{u};
    tmp_intensities = all_intensities{u};
    for i = 1:numel(tmp_diff)
        j = tmp_diff(i);
        if j <= cutoffppm
            tmp_diff(i) = tmp_diff(i);
            tmp_closest_mass(i) = tmp_closest_mass(i);
            tmp_intensities(i) = tmp_intensities(i);
        else
            tmp_diff(i) = 0;
            tmp_closest_mass(i) = 0;
            tmp_intensities(i) = 0;
        end
    end
    fs_mass_diff{u} = tmp_diff;
    fs_closest_mass{u} = tmp_closest_mass;
    signal_inten{u} = tmp_intensities;
end

%Extract all intensites from all scans for each target ion into a cell
%array.
analyte_matrix = cell(length(MHmass),1);
for i = 1:length(MHmass)
    tmp_linescan = zeros(length(NumberOfScans),max(NumberOfScans));
    for j = 1:length(signal_inten)
        linescan_data = signal_inten{j};
        b = linescan_data(i,:);
        tmp_linescan(j,1:length(b)) = b;
    end
    analyte_matrix{i} = tmp_linescan;
end
end

