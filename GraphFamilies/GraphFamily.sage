from abc import ABC, abstractmethod
import sys
from sage.groups.perm_gps.permgroup_element import make_permgroup_element
attach("PriorityQueue.sage")

class GraphFamily(ABC):

    def __init__(self):
        self.out_dir = "out/"

    @abstractmethod
    def graph(self): pass
    @abstractmethod
    def table(self): pass
    @abstractmethod
    def output_results(self): pass
    @abstractmethod
    def results_suite(self): pass

    class GraphDetails:
        def __init__(self, graph = None, n = None, alpha = None):
            self.graph = graph
            self.n = n
            self.alpha = alpha

    ## Sensitivity methods ##

    def alpha(self, graphDetails):
        alpha = len(graphDetails.graph.independent_set())
        graphDetails.alpha = alpha
        return alpha

    def max_degree(self, graph):
        return max(graph.degree())

    def _lowerbound(self, graph, indices):
        return self.max_degree(graph.subgraph(vertices = [graph.vertices()[i] for i in indices]))
    def _lowerbound2(self, graph, verts):
        return self.max_degree(graph.subgraph(vertices = verts))

    def _depth(self, soln):
        return len(soln["vertices"])

    def sensitivity(self, graphDetails):
        graph = graphDetails.graph
        n = graph.order()
        a = graphDetails.alpha if graphDetails.alpha != None else self.alpha(graphDetails)
        bssf = self.sensitivity_estimate(graphDetails)
        if bssf <= 1: return bssf

        q = BinaryHeap([0], 0)    # set of active subproblems
        for v in range(1, n - a):
            q.insert([v], 0)
        while not q.isEmpty():
            soln = q.deleteMin()    # select solution
            if soln["lb"] >= bssf: continue # prune solution
            elif self._depth(soln) == a + 1:    # candidate solution, update bssf
                bssf = soln["lb"]
                if bssf <= 1: return bssf
            else:                        # partial solution, expand
                for v in range(soln["vertices"][-1] + 1, n - a + self._depth(soln)):
                    newVertices = soln["vertices"].copy()
                    newVertices.append(v)
                    newlb = self._lowerbound(graph, newVertices)
                    if newlb < bssf: q.insert(newVertices, newlb) # add new solution to active set
                    # else new solution is pruned

        return bssf

    def sensitivity_estimate(self, graphDetails):
        graph = graphDetails.graph
        n = graph.order()
        a = graphDetails.alpha if graphDetails.alpha != None else self.alpha(graphDetails)
        if n <= a: return 0

        # greedy
        remaining = graph.vertices().copy()
        vertices = [remaining.pop(0)]
        for i in range(a):
            best = sys.maxsize
            index = 0
            for j in range(len(remaining)):
                lb = self._lowerbound2(graph, vertices + [remaining[j]])
                if lb < best:
                    best = lb
                    index = j
            vertices.append(remaining.pop(index))

        # local search
        improved = True
        best = self._lowerbound2(graph, vertices)
        while improved:
            improved = False
            for i in range(len(vertices)):
                for j in range(len(remaining)):
                    vertices[i], remaining[j] = remaining[j], vertices[i]
                    lb = self._lowerbound2(graph, vertices)
                    if lb < best:
                        best = lb
                        improved = true
                    else:
                        vertices[i], remaining[j] = remaining[j], vertices[i]

        return self._lowerbound2(graph, vertices)