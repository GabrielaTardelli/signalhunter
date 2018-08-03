
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
% Author: Victor Hugo Souza
% Date: 13.11.2016


function handles = callback_detect_multi(handles, id_pb)
%CALLBACK_DETECT_MULTI Summary of this function goes here
%   Detailed explanation goes here

handles = pb_detect_callback(handles, id_pb);

function handles = pb_detect_callback(handles, id_pb)

axesdetect = handles.axesdetect;
% id = handles.id_cond;
id_cond = handles.id_axes(1);
ci = handles.id_axes(2);
ri = handles.id_axes(3);

info_text = handles.info_text;

fs = handles.reader.fs{id_cond, ci};
xs_norm = handles.processed.xs_norm{id_cond,ci}(:,1);
%average_pots = handles.processed.average_pots{id_cond,ci}(:,:,ri);


yl = get(axesdetect, 'YLim');

switch id_pb
    case 1
        split_pots = handles.processed.split_pots{id_cond,ci}(:,handles.id_pot,ri);
        hstr = handles.hstr(id_pb, :);
        
        % ---- Delete previous plots
        if isfield(handles,'hpeaks')
            if ishandle(handles.hpeaks)
                delete(handles.hpeaks)
            end
        end
        % ----
        
        hold on
        
        % ---- Potential minimum peak
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the minimum peak and click ENTER');
        [x(1), ~] = getpts(axesdetect);
        
        pmin = [round((x(1)-xs_norm(1))*(fs/1000));...
            split_pots(round((x(1)-xs_norm(1))*(fs/1000)))];
        
        set(hstr(1,1), 'String', num2str(pmin(2),'%.2f'));
        handles.hpeaks(1) = plot(axesdetect, xs_norm(pmin(1)), pmin(2), '+m',...
            'MarkerSize', 10);
        
        % ---- Potential maximum peak
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the maximum peak and click ENTER');
        [x(2), ~] = getpts(axesdetect);
        
        pmax = [round((x(2)-xs_norm(1))*(fs/1000));...
            split_pots(round((x(2)-xs_norm(1))*(fs/1000)))];
        
        set(hstr(1,2), 'String', num2str(pmax(2),'%.2f'));
        handles.hpeaks(2) = plot(axesdetect, xs_norm(pmax(1)), pmax(2), '+m',...
            'MarkerSize', 10);
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update potential amplitudes, minimum and maximum peaks
        %handles.processed.ppamp_av{id_cond,ci}(:,:,ri) = abs(pmax(2) - pmin(2));
        %handles.processed.pmin_av{id_cond,ci}(:,:,ri) = pmin;
        %handles.processed.pmax_av{id_cond,ci}(:,:,ri) = pmax;
        handles.processed.ppamp{id_cond,ci}(:,handles.id_pot,ri) = abs(pmax(2) - pmin(2));
        handles.processed.pmin{id_cond,ci}(:,handles.id_pot,ri) = pmin;
        handles.processed.pmax{id_cond,ci}(:,handles.id_pot,ri) = pmax;
        
    case 2
        
        hstr = handles.hstr(id_pb, :);
        
        % ---- Delete previous plots
        if isfield(handles,'hlat')
            if ishandle(handles.hlat)
                delete(handles.hlat)
            end
        end
        % ----
        
        % ---- Potential start
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the potential start and click ENTER');
        [x(1), ~] = getpts(axesdetect);
        
        lat = [ceil((x(1)-xs_norm(1))*(fs/1000));...
            xs_norm(ceil((x(1)-xs_norm(1))*(fs/1000)))];
        
        set(hstr(1,1), 'String', num2str(lat(2),'%.2f'));
        handles.hlat = plot(axesdetect, [lat(2) lat(2)], [yl(1) yl(2)], 'c',...
            'LineWidth', 2);
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update MEPs duration, start and end instants
        %handles.processed.latency_av{id_cond,ci}(:,:,ri) = lat;
        handles.processed.latency{id_cond,ci}(:,handles.id_pot,ri) = lat;
        
    case 3
        
        % ---- Delete previous plots
        if isfield(handles,'hpeaks')
            if ishandle(handles.hpeaks)
                delete(handles.hpeaks)
            end
        end
        
        if isfield(handles,'hlat')
            if ishandle(handles.hlat)
                delete(handles.hlat)
            end
        end
        
        % Update potential amplitude, minimum and maximum peaks form backup
        %handles.processed.ppamp_av{id_cond,ci}(:,:,ri) = 0;
        %handles.processed.pmin_av{id_cond,ci}(:,:,ri) = [1; 0];
        %handles.processed.pmax_av{id_cond,ci}(:,:,ri) = [1; 0];
        handles.processed.ppamp{id_cond,ci}(:,handles.id_pot,ri) = 0;
        handles.processed.pmin{id_cond,ci}(:,handles.id_pot,ri) = [1; 0];
        handles.processed.pmax{id_cond,ci}(:,handles.id_pot,ri) = [1; 0];
        
        % Update potential latency from backup
        %handles.processed.latency_av{id_cond,ci}(:,:,ri) = [1; 0];
        handles.processed.latency{id_cond,ci}(:,handles.id_pot,ri) = [1; 0];
        
        % Update strings
        hstr = handles.hstr(1, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.2f'));
        set(hstr(1,2), 'String', num2str(0.00,'%.2f'));
        
        hstr = handles.hstr(2, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.2f'));
        set(hstr(1,2), 'String', num2str(0.00,'%.2f'));
        
    case 4
        
        % ---- Delete previous plots
        if isfield(handles,'hpeaks')
            if ishandle(handles.hpeaks)
                delete(handles.hpeaks)
            end
        end
        
        if isfield(handles,'hlat')
            if ishandle(handles.hlat)
                delete(handles.hlat)
            end
        end
        
        % Update potential amplitude, minimum and maximum peaks form backup
        %handles.processed.ppamp_av{id_cond,ci}(:,:,ri) = handles.processed.ppamp_av_bkp{id_cond,ci}(:,:,ri);
        %handles.processed.pmin_av{id_cond,ci}(:,:,ri) = handles.processed.pmin_av_bkp{id_cond,ci}(:,:,ri);
        %handles.processed.pmax_av{id_cond,ci}(:,:,ri) = handles.processed.pmax_av_bkp{id_cond,ci}(:,:,ri);
        handles.processed.ppamp{id_cond,ci}(:,handles.id_pot,ri) = handles.processed.ppamp_bkp{id_cond,ci}(:,handles.id_pot,ri);
        handles.processed.pmin{id_cond,ci}(:,handles.id_pot,ri) = handles.processed.pmin_bkp{id_cond,ci}(:,handles.id_pot,ri);
        handles.processed.pmax{id_cond,ci}(:,handles.id_pot,ri) = handles.processed.pmax_bkp{id_cond,ci}(:,handles.id_pot,ri);
        
        % Update potential latency from backup
        %handles.processed.latency_av{id_cond,ci}(:,:,ri) = handles.processed.latency_av_bkp{id_cond,ci}(:,:,ri);
        handles.processed.latency{id_cond,ci}(:,handles.id_pot,ri) = handles.processed.latency_bkp{id_cond,ci}(:,handles.id_pot,ri);
        
        % Update amplitude  and latency plots
        %hold on
        %handles.hpeaks(1) = plot(axesdetect, xs_norm(handles.processed.pmin_av{id_cond,ci}(1,:,ri)),...
        %    handles.processed.pmin_av{id_cond,ci}(2,:,ri), '+r', 'MarkerSize', 10);
        %handles.hpeaks(2) = plot(axesdetect, xs_norm(handles.processed.pmax_av{id_cond,ci}(1,:,ri)),...
        %    handles.processed.pmax_av{id_cond,ci}(2,:,ri), '+r', 'MarkerSize', 10);
        %handles.hlat = plot(axesdetect, [handles.processed.latency_av{id_cond,ci}(2,:,ri),...
        %    handles.processed.latency_av{id_cond,ci}(2,:,ri)], [yl(1) yl(2)], 'g', 'LineWidth', 2);
        %hold off
           hold on
        handles.hpeaks(1) = plot(axesdetect, xs_norm(handles.processed.pmin{id_cond,ci}(1,handles.id_pot,ri)),...
            handles.processed.pmin{id_cond,ci}(2,handles.id_pot,ri), '+r', 'MarkerSize', 10);
        handles.hpeaks(2) = plot(axesdetect, xs_norm(handles.processed.pmax{id_cond,ci}(1,handles.id_pot,ri)),...
            handles.processed.pmax{id_cond,ci}(2,handles.id_pot,ri), '+r', 'MarkerSize', 10);
        handles.hlat = plot(axesdetect, [handles.processed.latency{id_cond,ci}(2,handles.id_pot,ri),...
            handles.processed.latency{id_cond,ci}(2,handles.id_pot,ri)], [yl(1) yl(2)], 'g', 'LineWidth', 2);
        hold off
        
        % Update strings
        hstr = handles.hstr(1, :);
        %set(hstr(1,1), 'String', num2str(handles.processed.pmin_av{id_cond,ci}(2,:,ri),'%.2f'));
        %set(hstr(1,2), 'String', num2str(handles.processed.pmax_av{id_cond,ci}(2,:,ri),'%.2f'));
        set(hstr(1,1), 'String', num2str(handles.processed.pmin{id_cond,ci}(2,handles.id_pot,ri),'%.2f'));
        set(hstr(1,2), 'String', num2str(handles.processed.pmax{id_cond,ci}(2,handles.id_pot,ri),'%.2f'));
        
        hstr = handles.hstr(2, :);
        %set(hstr(1,1), 'String', num2str(handles.processed.latency_av{id_cond,ci}(2,:,ri),'%.2f'));
        %set(hstr(1,2), 'String', num2str(handles.processed.latency_av{id_cond,ci}(2,:,ri),'%.2f'));
        set(hstr(1,1), 'String', num2str(handles.processed.latency{id_cond,ci}(2,handles.id_pot,ri),'%.2f'));
        set(hstr(1,2), 'String', num2str(handles.processed.latency{id_cond,ci}(2,handles.id_pot,ri),'%.2f'));
    
    case 5
        % ---- Delete previous plots
        if isfield(handles,'hsig')
            if ishandle(handles.hsig)
                delete(handles.hsig)
            end
        end
        
        if isfield(handles,'hpeaks')
            if ishandle(handles.hpeaks)
                delete(handles.hpeaks)
            end
        end
        
        if isfield(handles,'hlat')
            if ishandle(handles.hlat)
                delete(handles.hlat)
            end
        end
        
        hold on
        
        % ---- Previous potencial
        id_cond = handles.id_axes(1);
        ci = handles.id_axes(2);
        ri = handles.id_axes(3);

        split_pots = handles.processed.split_pots{id_cond,ci}(:,:,ri);
        pmin = handles.processed.pmin{id_cond,ci}(:,:,ri);
        pmax = handles.processed.pmax{id_cond,ci}(:,:,ri);
        latency = handles.processed.latency{id_cond,ci}(:,:,ri);
        n_pots = size(split_pots, 2);

        if handles.id_pot == 1
            handles.id_pot = n_pots;
%             set(handles.edit_idcond, 'String',...
%                 num2str(handles.conditions(handles.id_cond)))
        else
            handles.id_pot = handles.id_pot - 1;
%             set(handles.edit_idcond, 'String',...
%                 num2str(handles.conditions(handles.id_cond)))
        end
        
        hstr = handles.hstr(:, :);
        set(hstr(1,1), 'String', num2str(pmin(2,handles.id_pot),'%.2f'));
        set(hstr(1,2), 'String', num2str(pmax(2,handles.id_pot),'%.2f'));
        set(hstr(2,1), 'String', num2str(latency(2,handles.id_pot),'%.2f'));

        [handles.hsig, handles.hpeaks, handles.hlat] = plot_multi_single(axesdetect,...
        handles.processed, handles.id_axes, handles.id_pot);
        % ---- Update edit condition
        set(handles.edit_idpot, 'String', num2str(handles.id_pot));
        
    case 6
        % ---- Delete previous plots
        if isfield(handles,'hsig')
            if ishandle(handles.hsig)
                delete(handles.hsig)
            end
        end
        
        if isfield(handles,'hpeaks')
            if ishandle(handles.hpeaks)
                delete(handles.hpeaks)
            end
        end
        
        if isfield(handles,'hlat')
            if ishandle(handles.hlat)
                delete(handles.hlat)
            end
        end
        
        hold on        
        
        % ---- Next potencial
        id_cond = handles.id_axes(1);
        ci = handles.id_axes(2);
        ri = handles.id_axes(3);

        split_pots = handles.processed.split_pots{id_cond,ci}(:,:,ri);
        pmin = handles.processed.pmin{id_cond,ci}(:,:,ri);
        pmax = handles.processed.pmax{id_cond,ci}(:,:,ri);
        latency = handles.processed.latency{id_cond,ci}(:,:,ri);
        n_pots = size(split_pots, 2);

        if handles.id_pot >= n_pots
            handles.id_pot = 1;
            %set(handles.edit_idcond, 'String',...
            %   num2str(handles.conditions(handles.id_pot)))
        else
            handles.id_pot = handles.id_pot + 1;
            %set(handles.edit_idcond, 'String',...
              %  num2str(handles.conditions(handles.id_pot)))
        end
        
        hstr = handles.hstr(:, :);
        set(hstr(1,1), 'String', num2str(pmin(2,handles.id_pot),'%.2f'));
        set(hstr(1,2), 'String', num2str(pmax(2,handles.id_pot),'%.2f'));
        set(hstr(2,1), 'String', num2str(latency(2,handles.id_pot),'%.2f'));
        
        [handles.hsig, handles.hpeaks, handles.hlat] = plot_multi_single(axesdetect,...
        handles.processed, handles.id_axes, handles.id_pot);

         
        % ---- Update edit condition
        set(handles.edit_idpot, 'String', num2str(handles.id_pot));
end
        