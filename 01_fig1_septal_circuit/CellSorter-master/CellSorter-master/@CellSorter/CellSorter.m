classdef CellSorter

properties

sset          % contains a statset structure
nClusters = 3 % how many clusters do you want?
% nDims = 3     % only for plotting 
nDims = 2     % for real calculation

verbosity = true;
algorithm = 'umap';
% algorithm = 't-SNE';


end % properties

properties (SetAccess = Protected)

end % properties setaccess protected

methods

  function self = CellSorter()
    self.sset = statset;
    self.sset.Display = 'iter';
    self.sset.MaxIter = 100;
    self.sset.UseParallel = true;
  end % constructor

  function set.nClusters(self, value)
    assert(isinteger(value), 'nClusters must be an integer')
    assert(isscalar(value), 'nClusters must be a scalar')
    assert(value > 0, 'nClusters must be positive')
    self.nClusters = value;
  end

  function set.nDims(self, value)
    assert(isinteger(value), 'nDims must be an integer')
    assert(isscalar(value), 'nDims must be a scalar')
    assert(value > 0, 'nDims must be positive')
    self.nDims = value;
  end

end % methods

methods (Static)

  batchFunction(index, batchname, location, outfile, test)

end % static methods

end % classdef
