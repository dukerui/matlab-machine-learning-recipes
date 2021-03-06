%% HOMOGENEITYMEASURE The measure is 0 if the data is homogeneous
%
%% Form:
%   [i, d] = HomogeneityMeasure( action, d, data )
%
%% Description
% This computes the homogeneity in a sample. If 'initialize' is passed
% it computes the classes. For update it uses those classes.
% Is  uses the Gini impurity measure.
%
%% Inputs
%  action (1,:) 'initialize' or 'update'
%  d   (.)	Data structure
%           .dist  (1,:) Class distribution in the sample;
%           .class (1,n) List of the classes (1 to n)
%           .i     (1,1) Gini impurity measure
%  data  (:,:) Data in the sample
%
%% Outputs
%  d    (.)   Data structure
%  i    (1,1) Gini impurity measure

function [i, d] = HomogeneityMeasure( action, d, data )

if( nargin == 0 )
  if( nargout == 1 )
    i = DefaultDataStructure;
  else
    Demo;
  end
  return
end

switch lower(action)
  case 'initialize'
    d = Initialize( d, data );
    i = d.i;
  case 'update'
    d = Update( d, data );
    i = d.i;
  otherwise
    error('%s is not an available action',action);
end

function d = Update( d, data )
%% Update

newDist = zeros(1,length(d.class));

m = reshape(data,[],1);
n = length(m);

if( n > 0 )
  for k = 1:length(d.class)
    j          = find(m==d.class(k));
    newDist(k) = length(j)/n;
  end
end

d.i = 1 - sum(newDist.^2);

d.dist = newDist;

function d = Initialize( d, data )
%% HomogeneityMeasure>Initialize

m       = reshape(data,[],1);
c       = 1:max(m);
n       = length(m);
d.dist  = zeros(1,c(end));
d.class = c;
if( n > 0 )
  for k = 1:length(c)
    j         = find(m==c(k));
    d.dist(k) = length(j)/n;
  end
end
d.i = 1 - sum(d.dist.^2);
   
%% HomogeneityMeasure>DefaultDataStructure
function d = DefaultDataStructure
% Default data structure
d.dist  = [];
d.class = [];
d.i     = 1;

%% HomogeneityMeasure>Demo
function d = Demo
% Demonstrate the homogeniety measure for a data set.

data    = [1 2 3 4 3 1 2 4 4 1 1 1 2 2 3 4]; fprintf(1,'%2.0f',data);
d       = HomogeneityMeasure;
[i, d]  = HomogeneityMeasure( 'initialize', d, data );
fprintf(1,'\nHomogeneity Measure %6.3f\n',i);
fprintf(1,'Classes             [%1d %1d %1d %1d]\n',d.class);
fprintf(1,'Distribution        [%5.3f %5.3f %5.3f %5.3f]\n',d.dist);

data = [1 1 1 2 2]; fprintf(1,'%2.0f',data);
[i, d] = HomogeneityMeasure( 'update', d, data );
fprintf(1,'\nHomogeneity Measure %6.3f\n',i);
fprintf(1,'Classes             [%1d %1d %1d %1d]\n',d.class);
fprintf(1,'Distribution        [%5.3f %5.3f %5.3f %5.3f]\n',d.dist);

data = [1 1 1 1]; fprintf(1,'%2.0f',data);
[i, d] = HomogeneityMeasure( 'update', d, data );
fprintf(1,'\nHomogeneity Measure %6.3f\n',i);
fprintf(1,'Classes             [%1d %1d %1d %1d]\n',d.class);
fprintf(1,'Distribution        [%5.3f %5.3f %5.3f %5.3f]\n',d.dist);

data = []; fprintf(1,'%2.0f',data);
[i, d] = HomogeneityMeasure( 'update', d, data );
fprintf(1,'\nHomogeneity Measure %6.3f\n',i);
fprintf(1,'Classes             [%1d %1d %1d %1d]\n',d.class);
fprintf(1,'Distribution        [%5.3f %5.3f %5.3f %5.3f]\n',d.dist);



