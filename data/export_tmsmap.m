
% -------------------------------------------------------------------------
% Signal Hunter - electrophysiological signal analysis
% Copyright (C) 2013, 2013-2016  University of Sao Paulo
%
% Homepage:  http://df.ffclrp.usp.br/biomaglab
% Contact:   biomaglab@gmail.com
% License:   GNU - GPL 3 (LICENSE.txt)
%
% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or any later
% version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
%
% The full GNU General Public License can be accessed at file LICENSE.txt
% or at <http://www.gnu.org/licenses/>.
%
% -------------------------------------------------------------------------
%
% Author: Gabriela Pazin Tardelli
% Date: 25.09.2018


function [filt_id] = export_tmsmap(reader, processed)
%DATA_EXPORT General function to export processed data and navigator coordinates to excel or ascii
%   Each specific export application should be created as a new function
%   and accessed using a new case in initialization function.


% ---- Input data
data_nav = reader.data_nav.data_nav;
ppamp = processed.ppamp;
latency = processed.latency;
file_names_txt = reader.data_nav.filename;   % input file names

n_frames = size(processed.ppamp, 1);    %file size (rows)
n_instants = size(processed.ppamp, 2);  %file size (columns)

pathname = uigetdir('D:folder1\');   % dialog to choose where to export
folder_name = [pathname '\'];     

% ---- Processed data names

for id_cond = 1:n_frames
    for ci = 1:n_instants
        file_names{id_cond, ci} = file_names_txt{id_cond, ci}(1:end-4);
    end
end

add = [{'_processed'}];    
add_to = repmat(add, n_frames, n_instants);

file_names_processed = strcat(file_names,add_to);  % ouput file names

% ---- Organizing tms data

for id_cond = 1:n_frames
    for ci = 1:n_instants
              
        M1_amp{id_cond, ci} = ppamp{id_cond, ci}(:,:,1);
        M2_amp{id_cond, ci} = ppamp{id_cond, ci}(:,:,2);
        M3_amp{id_cond, ci} = ppamp{id_cond, ci}(:,:,3);
        
        M1_lat{id_cond, ci} = latency{id_cond, ci}(2,:,1);
        M2_lat{id_cond, ci} = latency{id_cond, ci}(2,:,2);
        M3_lat{id_cond, ci} = latency{id_cond, ci}(2,:,3);
        
        
        %organized tms data to tmsmap software
        data_tms{id_cond, ci} = permute([M1_amp{id_cond, ci}; M1_lat{id_cond, ci}; M2_amp{id_cond, ci}; ...
            M2_lat{id_cond, ci}; M3_amp{id_cond, ci}; M3_lat{id_cond, ci}], [2 1]); 
    
        % header of amplitude and latency data
        header_tms = [[{'M1'},{'M1'},{'M2'},{'M2'},{'M3'},{'M3'}];...
            [{'Amp'},{'Lat'},{'Amp'},{'Lat'},{'Amp'},{'Lat'}]; ...
                [{'V'},{'ms'},{'V'},{'ms'},{'V'},{'ms'}]];
        % header of navigator data
        header_coord = [[{blanks(1)},{'EF max.'},{blanks(1)},{blanks(1)}]; ... 
            [{'ID'}, {'Loc.'},{blanks(1)}, {blanks(1)}]; ...
                [{blanks(1)}, {'x'}, {'y'}, {'z'}];[{blanks(1)}, {'(mm)'},{'(mm)'},{'(mm)'}]]; 
        
        % ------ Exporting data
        
        xlswrite([folder_name file_names_processed{id_cond, ci}], data_tms{id_cond, ci}, 'Sheet1', 'I7');
        xlswrite([folder_name file_names_processed{id_cond, ci}], data_nav{id_cond, ci}, 'Sheet1', 'D7');
        xlswrite([folder_name file_names_processed{id_cond, ci}], header_tms, 'Sheet1', 'I2');
        xlswrite([folder_name file_names_processed{id_cond, ci}], header_coord, 'Sheet1', 'C2');

     end
 end

filt_id = 1;
