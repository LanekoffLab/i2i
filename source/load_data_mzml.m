function [raw_dat,unique_scanheaders] = load_data_mzml(source_files)
% read mzML files in paralell

%initialize paralell pool and waitbar
D = parallel.pool.DataQueue;
h = waitbar(0,'Please wait loading mzML files...');
afterEach(D,@nUpdateWaitbar);
p = 1;
% preallocate cell array
raw_dat = cell(length(source_files),1);

parfor k= 1:size(source_files,1)
    filename = source_files(k).name;
    file = readstruct(filename,'FileType','xml','StructNodeName','run');
    data_out = cell(size(file.spectrumList.spectrum,2),4);
    for i = 1:size(file.spectrumList.spectrum,2)
        % Extract mass to charge value, intensity, and numeric precision
        mz = char(file.spectrumList.spectrum(i).binaryDataArrayList.binaryDataArray(1).binary);
        intensity = char(file.spectrumList.spectrum(i).binaryDataArrayList.binaryDataArray(2).binary);
        bitsize = [file.spectrumList.spectrum(i).binaryDataArrayList.binaryDataArray(2).cvParam.nameAttribute];
        double_pres = any(strcmp(bitsize,'64-bit float'));
        precision = '';

        switch double_pres
            case 0
                precision = 'single';
            case 1
                precision = 'double';
        end
        % Decode the mass to charge and intenisty
        textBytes = base64decode(mz);
        mz_vec = typecast(textBytes,precision)';
        textBytes = base64decode(intensity);
        int_vec = typecast(textBytes,precision)';
        
        % Store data in the data_out cell array
        cvParam_name_attributes = [file.spectrumList.spectrum(i).cvParam.nameAttribute];
        scanList_scan_name_attributes = [file.spectrumList.spectrum(i).scanList.scan.cvParam.nameAttribute];

        scan_start_time_current_index = find(strcmp(scanList_scan_name_attributes, 'scan start time'));
        total_ion_current_index = find(strcmp(cvParam_name_attributes,'total ion current'));
        filter_string_current_index = find(strcmp(scanList_scan_name_attributes, 'filter string'));
            
        data_out{i,1} = [mz_vec, int_vec];
        data_out{i,2} = file.spectrumList.spectrum(i).scanList.scan.cvParam(scan_start_time_current_index).valueAttribute;
        data_out{i,3} = file.spectrumList.spectrum(i).cvParam(total_ion_current_index).valueAttribute;
        data_out{i,4} = file.spectrumList.spectrum(i).scanList.scan.cvParam(filter_string_current_index).valueAttribute;
    end
    raw_dat{k}=data_out;
    send(D,i);
end


% Update waitbar
    function nUpdateWaitbar(~)
        waitbar(p/length(source_files), h);
        p = p + 1;
    end
close(h)
for i = 1:size(raw_dat,1)
    scanheaders = [raw_dat{1,1}{:,4}]';
end
unique_scanheaders = unique(scanheaders);
end
