
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


function [hsig, hpeaks, hlat] = plot_multi_single(ax, processed, id_axes, id_pot)
%PLOT_MULTI: Summary of this function goes here
%   Detailed explanation goes here

id_cond = id_axes(1);
ci = id_axes(2);
ri = id_axes(3);

split_pots = processed.split_pots{id_cond,ci}(:,:,ri);
average_pots = processed.average_pots{id_cond,ci}(:,:,ri);

% xs starting from trigger
n_pots = size(split_pots, 2);
xs_norm = processed.xs_norm{id_cond,ci};

latency = processed.latency{id_cond,ci}(1,id_pot,ri);
pmin = processed.pmin{id_cond,ci}(:,id_pot,ri);
pmax = processed.pmax{id_cond,ci}(:,id_pot,ri);

globalmin = processed.globalmin(id_cond,ci);
globalmax = processed.globalmax(id_cond,ci);

axes(ax);
hold on

% signal
hsig_av = plot(xs_norm(:,1), average_pots);
hsig = plot(xs_norm(:,id_pot), split_pots(:,id_pot));
% for n = 1:n_pots
set(hsig_av, 'Color', [209 209 209]/255, 'LineWidth', 2);
set(hsig, 'Color', 'k', 'LineWidth', 2);
legend([hsig_av, hsig], 'Average Potential', 'Single Potential');
% end
% set(hsig(end), 'Color', 'k');

axis([xs_norm(1,1) xs_norm(end,1) 1.2*globalmin 1.2*globalmax]);

lim = axis;

% potential peaks
hpeaks = plot(xs_norm(pmin(1),1), pmin(2), xs_norm(pmax(1),1), pmax(2)) ;
set(hpeaks(1), 'Marker', '+', 'Color', 'r', 'MarkerSize', 9, 'LineWidth', 2);
set(hpeaks(2), 'Marker', '+', 'Color', 'r', 'MarkerSize', 9, 'LineWidth', 2);

% potential latency
hlat = plot([xs_norm(latency,1) xs_norm(latency,1)], [lim(3)  lim(4)], 'g', 'LineWidth', 2);

hold off

