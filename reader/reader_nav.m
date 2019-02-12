
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
% Date: 24.09.2018


function [reader, open_id] = reader_nav
%READER_MULTI Read txt files from NavigatorSystem
%   Read txt files recorded and exported by NavigatorSystem.
%   Each file contains one time series organized in colmuns. First, second,
%   third columns are the coordinates x, y and z respectively.
%
% OUTPUT:
%
% reader: structure with variables created through reader
% open_id: flag to inform if loading was succesful
%


hwarn = warndlg('Select folder must contain only the navigator files to be processed','Atention!');
uiwait(hwarn);

path_aux = uigetdir;

if isunix %check if platform is linux
    path_aux = [path_aux '/'];
elseif ismac %check if platform is mac
    path_aux = [path_aux '/'];
else %check if platform is windows
    path_aux = [path_aux '\'];
end

file_list = struct2cell(dir(path_aux));  %open the files and its info
file_aux = file_list(1,3:end);     %seleciona a partir da terceira coluna (onde ficam os arquivos)
sort(file_aux);  %sort the files

n_files = size(file_aux, 2);  %check the number of files

if n_files == 12
    % conditions is MRI or MNI
    n_conditions = 2;
    % instant is ADM, FRC or FCP
    n_instants = 3;
    % side is 110 or 120
    n_side = 2;
else n_files == 6
    % conditions is MRI or MNII
    n_conditions = 1;
    % instant is ADM, FRC or FCP
    n_instants = 3;
    % side is 110 or 120
    n_side = 2;
end

if path_aux
    %mostra que o numero de camadas é a possib de intensidade vezes a possib de condicoes
    n_frames = n_side*n_conditions;
    file_names = reshape(file_aux, n_instants, n_frames)';
    
    for id_cond = 1:n_frames
        for ci = 1:n_instants
            data_aux = importdata([path_aux file_names{id_cond,ci}]);
            
            if isstruct(data_aux)
                if size(data_aux.data, 2) == 7  %if theres seven columns
                    data_nav{id_cond,ci} = data_aux.data(:,1:3); %read all rows of first column
                end
            else
                if size(data_aux, 2) == 7
                    data_nav{id_cond,ci} = data_aux(:,1:3); 
                end
            end
        end 
    end
    
    %delete(hbar)
    reader.filename = file_names;
    reader.data_nav = data_nav;
    open_id = 1;
    
else
    reader = 0;
    open_id = 0;
end
