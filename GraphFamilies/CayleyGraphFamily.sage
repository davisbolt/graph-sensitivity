class CayleyGraphFamily(VTGraphFamily):

    def __init__(self):
        self._gensets = []

    def graph(self, graphDetails):
        group = graphDetails.group
        genset = graphDetails.genset
        elements = graphDetails.element_list

        graph = group.cayley_graph(generators = [elements[i - 1] for i in genset]).to_undirected()
        graphDetails.graph = graph
        return graph

    @abstractmethod
    def group(self, n): pass
    @abstractmethod
    def element_list(self, n, group): pass

    def table(self, n = None, min_s = 0, print_table = False, gensets = None, include_n = False, show_columns = True):
        group = self.group(n)
        elements = self.element_list(n, group)

        if show_columns and include_n:
            t = [["n"] + self.table_columns]
        elif show_columns:
            t = [self.table_columns]
        else:
            t = []
        for genset in gensets:
            gd = self.GraphDetails(n = n, genset = genset, group = group, element_list = elements)
            graph = self.graph(gd)
            alpha = self.alpha(gd)
            sigma = self.sensitivity(gd)
            if sigma >= min_s:
                row = [graph.order(), graph.size(), self.max_degree(graph), genset, alpha, sigma]
                if include_n: row.insert(0, n)
                t.append(row)

        if print_table:
            print(self.name + ", n = " + str(n))
            print(table(t))
            print("\n\n")

        return t

    def output_results(self, max_n = None, min_s = 0, genset_method = None):
        invalid = "Invalid genset_method"
        result = self.genset_switch.get(genset_method.__name__, invalid)
        if result == invalid:
            print(invalid)
            return
        genset_str = result[0]
        genset_table_type = result[1]

        min_s_str = ("_s>=" + str(min_s)) if min_s > 0 else ""
        f = open(self.out_dir + self.name + genset_str + min_s_str + ".txt", 'w')

        for n in range(self.min_n, max_n + 1):
            gensets = genset_method(n)
            if not gensets: continue

            if genset_table_type == "1table" and n == self.min_n:
                t = self.table(n = n, min_s = min_s, gensets = gensets, include_n = True)
            elif genset_table_type == "1table":
                t += self.table(n = n, min_s = min_s, gensets = gensets, include_n = True, show_columns = False)
            else:
                t = self.table(n = n, min_s = min_s, gensets = gensets)
                if len(t) <= 1: continue
                f.write("n = " + str(n) + "\n")
                f.write(str(table(t)) + "\n\n")

        if genset_table_type == "1table":
            f.write(str(table(t)))
        f.close()
        print(self.name + genset_str + " Results Done")

    class GraphDetails(VTGraphFamily.GraphDetails):
        def __init__(self, graph = None, n = None, alpha = None, genset = None, group = None, element_list = None):
            super().__init__(graph, n, alpha)
            self.genset = genset
            self.group = group
            self.element_list = element_list

    def iterateSubsets(self, n, l, data, start, end, i, size, update_method):
        if i == size:
            return update_method(n, data)

        j = start
        while (j <= end) and (end - j + 1 >= size - i):
            data[i] = l[j]
            if not self.iterateSubsets(n, l, data, j + 1, end, i + 1, size, update_method): return False
            j += 1

        return True