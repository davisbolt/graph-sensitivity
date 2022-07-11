# Not sure if Vertex Transitive
class HalfCubes(OneVarGraphFamily):
    def __init__(self):
        super().__init__()
        self.name = "HalfCubes"
        self.out_dir = "out/Cubes/"
        self.min_n = 2

    def graph(self, graphDetails):
        n = graphDetails.n
        graphDetails.graph = graphs.HalfCube(n)
        return graphDetails.graph

    def results_suite(self):
        self.output_results(max_n = 6)