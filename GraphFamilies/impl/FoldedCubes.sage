class FoldedCubes(OneVarGraphFamily, VTGraphFamily):

    def __init__(self):
        super().__init__()
        self.name = "FoldedCubes"
        self.out_dir = "out/Cubes/"

    def graph(self, graphDetails):
        graph = graphs.FoldedCubeGraph(graphDetails.n + 1)
        graphDetails.graph = graph
        return graph

    def results_suite(self):
        self.output_results(max_n = 6)

    # TODO
    #def alpha(self, graphDetails):
    #    alpha = 
    #    graphDetails.alpha = alpha
    #    return alpha