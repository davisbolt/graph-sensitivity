class Hypercubes(OneVarGraphFamily, VTGraphFamily):

    def __init__(self):
        super().__init__()
        self.name = "Hypercubes"
        self.out_dir = "out/Cubes/"

    def graph(self, graphDetails):
        graph = graphs.CubeGraph(graphDetails.n)
        graphDetails.graph = graph
        return graph

    def results_suite(self):
        self.output_results(max_n = 5)

    def alpha(self, graphDetails):
        alpha = graphDetails.graph.order()//2
        graphDetails.alpha = alpha
        return alpha