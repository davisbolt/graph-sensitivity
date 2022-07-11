class CrownGraphs(OneVarGraphFamily, VTGraphFamily):
    def __init__(self):
        super().__init__()
        self.name = "CrownGraphs"
        self.min_n = 3

    def graph(self, graphDetails):
        n = graphDetails.n
        graphDetails.graph = graphs.CompleteGraph(n).cartesian_product(graphs.CompleteGraph(2)).complement()
        return graphDetails.graph

    def results_suite(self):
        self.output_results(max_n = 15)

    #TODO
    # def alpha(self, graphDetails):
    #     pass