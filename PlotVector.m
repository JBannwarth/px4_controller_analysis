function [] = PlotVector( in, scale, label, color, labelPos, varargin )
%PLOTVECTOR Plot a vector in three dimensions
%   Inputs:
%       - in:       vector to plot.
%       - scale:    scale of the vector (scale=2 means twice the default
%                   scale).
%       - color:    color of the vector.
%       - labelPos: where to put the label. Possible values: 'end', 'side'.
%       - vStart:   start location of the vector (optional).
%
%   Written by:    J.X.J. Bannwarth, 28/09/2017
%   Last modified: J.x.J. Bannwarth, 02/10/2017

    sz = size( in );
    if ( ( sz(1) == 3 ) && ( sz(2) == 1 ) )
        v = in;
    elseif ( ( sz(1) == 1 ) && ( sz(2) == 3 ) )
        v = in';
    else
        error( 'Input needs to be a 3x1 or 1x3 vector' )
    end
    
    showArrowHead = 'on';
    vStart = [0; 0; 0];
    invert = false;
    
    if ( nargin >= 6 )
        vStart = varargin{1};
        sz = size( vStart );
        if max( sz ) == 0
            vStart = [0;0;0];
        elseif ( ( sz(1) == 3 ) && ( sz(2) == 1 ) )
            vStart = vStart;
        elseif ( ( sz(1) == 1 ) && ( sz(2) == 3 ) )
            vStart = vStart';
        else
            error( 'Starting point needs to be a 3x1 or 1x3 vector' )
        end
        
        if ( nargin >= 7 )
            showArrowHead = varargin{2};
            
            if ( nargin >= 8 )
                invert = varargin{3};
                
                if ( nargin > 8 )
                    error('Invalid number of input')
                end
            end
        end
    end
    
    vRot = scale .* v .* [1;  -1;  -1]; % in NED
    vStart = scale .* vStart .* [1;  -1;  -1];
    
    if invert
        tmp = vRot;
        vRot = -vRot + vStart;
        vStart = tmp;
    end
    
    hold on;    
    % Plot arrow
    quiver3(vStart(1), vStart(2), vStart(3), vRot(1), vRot(2), vRot(3), 'linewidth', 1.5, 'color', color, ...
        'AutoScale', 'off', 'ShowArrowHead', showArrowHead )
        
    % Add arrow labels
    if ( isempty(labelPos) || strcmp(labelPos, 'end') || strcmp(labelPos, '') )
        vRot = 1.05*vRot;
        vRot = vRot+vStart;
        text(vRot(1), vRot(2), vRot(3), label, 'interpreter', 'latex');
    elseif strcmp( labelPos, 'side' )
        vRot = 0.5*vRot;
        vRot = vRot+vStart;
        text(vRot(1), vRot(2), vRot(3), label, 'interpreter', 'latex');
    else
        error( 'Invalid text position argument' )
    end
end