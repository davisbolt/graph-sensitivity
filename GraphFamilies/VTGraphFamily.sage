class VTGraphFamily(GraphFamily):

    def sensitivity(self, graphDetails):
        # print("VT sensitivity called")
        graph = graphDetails.graph
        n = graph.order()
        a = graphDetails.alpha if graphDetails.alpha != None else self.alpha(graphDetails)
        bssf = self.sensitivity_estimate(graphDetails)
        if bssf <= 1: return bssf

        q = BinaryHeap([0], 0)    # set of active subproblems
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