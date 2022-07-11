class KneserGraphs(VTGraphFamily):
    def __init__(self):
        super().__init__()
        self.name = "KneserGraphs"
        self.table_columns = ["n", "|V|", "|E|", "deg", "alpha", "sigma"]

    class GraphDetails(VTGraphFamily.GraphDetails):
        def __init__(self, n = None, k = None, graph = None, alpha = None):
            super().__init__(n = n, graph = graph, alpha = alpha)
            self.k = k

    def graph(self, graphDetails):
        n = graphDetails.n
        k = graphDetails.k
        graphDetails.graph = graphs.KneserGraph(n, k)
        return graphDetails.graph

    def table(self, max_n, k, min_s = 0, print_table = False):
        t = [self.table_columns]
        for n in range(4, max_n + 1):
            gd = self.GraphDetails(n = n, k = k)
            graph = self.graph(gd)
            if not graph.is_connected(): continue
            alpha = self.alpha(gd)
            sigma = self.sensitivity(gd)
            deg = self.max_degree(graph) if graph.order() > 0 else 0
            row = [n, graph.order(), graph.size(), deg, alpha, sigma]
            if sigma >= min_s:
                t.append(row)

        if print_table:
            print(self.name)
            print(table(t))
            print("\n\n")
        else:
            return t

    def output_results(self, max_n, k, min_s = 0):
        min_s_str = ("_s>=" + str(min_s)) if min_s > 0 else ""
        k_str = "_k=" + str(k)
        f = open(self.out_dir + self.name + k_str + min_s_str + ".txt", 'w')

        t = self.table(max_n = max_n, k = k, min_s = min_s)
        if len(t) <= 1:
            f.close()
            return

        f.write(str(table(t)))
        f.close()
        print(self.name + k_str + " Results done")

    def results_suite(self):
        self.output_results(9, 2)
        self.output_results(7, 3)