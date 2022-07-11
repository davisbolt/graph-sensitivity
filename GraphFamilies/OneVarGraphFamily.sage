class OneVarGraphFamily(GraphFamily):
    def __init__(self):
        super().__init__()
        self.table_columns = ["n", "|V|", "|E|", "deg", "alpha", "sigma"]
        self.min_n = 1

    def table(self, max_n, min_s = 0, print_table = false):
        t = [self.table_columns]
        for n in range(self.min_n, max_n + 1):
            gd = self.GraphDetails(n = n)
            graph = self.graph(gd)
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

    def output_results(self, max_n, min_s = 0):
        min_s_str = ("_s>=" + str(min_s)) if min_s > 0 else ""
        f = open(self.out_dir + self.name + min_s_str + ".txt", 'w')

        t = self.table(max_n = max_n, min_s = min_s)
        if len(t) <= 1:
            f.close()
            return

        f.write(str(table(t)))
        f.close()
        print(self.name + " Results done")