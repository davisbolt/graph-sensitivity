class CompleteSplitGraphs(GraphFamily):
    def __init__(self):
        super().__init__()
        self.name = "CompleteSplitGraphs"
        self.table_columns = ["m", "|V|", "|E|", "deg", "alpha", "sigma"]

    class GraphDetails(GraphFamily.GraphDetails):
        def __init__(self, n = None, m = None, graph = None, alpha = None):
            super().__init__(n = n, graph = graph, alpha = alpha)
            self.m = m

    def graph(self, graphDetails):
        n = graphDetails.n
        m = graphDetails.m
        g = graphs.CompleteGraph(m)
        vertices = g.vertices()
        for i in range(n):
            vertexName = i + m
            g.add_vertex(vertexName)
            g.add_edges([(vertices[j], vertexName) for j in range(m)])
        graphDetails.graph = g
        return g

    def table(self, n, max_m, min_s = 0, print_table = False):
        t = [self.table_columns]
        for m in range(1, max_m + 1):
            gd = self.GraphDetails(n = n, m = m)
            graph = self.graph(gd)
            alpha = self.alpha(gd)
            sigma = self.sensitivity(gd)
            deg = self.max_degree(graph) if graph.order() > 0 else 0
            row = [m, graph.order(), graph.size(), deg, alpha, sigma]
            if sigma >= min_s:
                t.append(row)

        if print_table:
            print(self.name + ", n = " + str(n))
            print(table(t))
            print("\n\n")
        else:
            return t

    def output_results(self, max_n, max_m, min_s = 0):
        min_s_str = ("_s>=" + str(min_s)) if min_s > 0 else ""
        f = open(self.out_dir + self.name + min_s_str + ".txt", 'w')

        for n in range(1, max_n + 1):
            t = self.table(n, max_m, min_s)
            if len(t) <= 1: continue

            f.write("n = " + str(n) + "\n")
            f.write(str(table(t)) + "\n\n")

        f.close()
        print(self.name + "Results done")

    def results_suite(self):
        self.output_results(10, 10)

    def alpha(self, graphDetails):
        return graphDetails.n