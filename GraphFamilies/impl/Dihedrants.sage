class Dihedrants(CayleyGraphFamily):
    def __init__(self):
        super().__init__()
        self.name = "Dihedrants"
        self.out_dir = "out/Dihedrants/"
        self.table_columns = ["|V|", "|E|", "deg", "Gen Set", "alpha", "sigma"]
        self.genset_switch = {
            "gensets1_1": ["1_1", "1table"],
            "gensets1_2": ["1_2", "1table"],
            "gensets1_3": ["1_3", "ntables"],
            "gensets1_4": ["1_4", "ntables"],
            "gensets1_5": ["1_5", "ntables"],
            "gensets1_7": ["1_7", "ntables"],
            "gensets1_8": ["1_8", "ntables"],
            "gensets1_9": ["1_9", "ntables"]
        }
        self.min_n = 4

    def group(self, n):
        return DihedralGroup(n)

    def element_list(self, n, group):
        elements = [group.gens()[0]]
        for i in range(n - 2):
            prevRotation = elements[-1]
            elements.append(make_permgroup_element(group, Permutation(prevRotation).left_action_product(Permutation(group.gens()[0]))))
        elements += [group.gens()[1]] + [make_permgroup_element(group, Permutation(elements[i]).left_action_product(Permutation(group.gens()[1]))) for i in range(n - 1)]
        return elements

    def results_suite(self):
        self.output_results(max_n = 15, genset_method = self.gensets1_1)
        self.output_results(max_n = 15, genset_method = self.gensets1_2)
        self.output_results(max_n = 12, genset_method = self.gensets1_3)
        self.output_results(max_n = 15, genset_method = self.gensets1_4)
        self.output_results(max_n = 12, genset_method = self.gensets1_5)
        self.output_results(max_n = 15, genset_method = self.gensets1_7)
        self.output_results(max_n = 5, genset_method = self.gensets1_8)
        self.output_results(max_n = 10, genset_method = self.gensets1_9)


    ## Genset Methods ##

    # Generating sets from prop 1.1
    def gensets1_1(self, n):
        return [[1, n]]

    # Generating sets from prop 1.2
    def gensets1_2(self, n):
        return [[n, n + 1]]

    # Generating sets from prop 1.3
    def gensets1_3(self, n):
        gensets = Circulants().gensets(n)
        for genset in gensets:
            genset.append(n)
        return gensets

    # Generating sets from prop 1.4
    def gensets1_4(self, n):
        gensets = Circulants().gensetsMinReduced(n)
        for genset in gensets:
            genset = list(genset)
            genset.append(n)
        return gensets

    # Generating sets from prop 1.5
    def gensets1_5(self, n):
        max_num_diffs = 3
        while max_num_diffs*(max_num_diffs + 1)//2 < n:
            max_num_diffs += 1

        self._gensets.clear()
        for size in range(2, max_num_diffs):
            d = range(1, n - size*(size - 1)//2)
            data = [None] * size
            self.iterateSubsets(n, d, data, 0, len(d) - 1, 0, size, self.updateGensets1_5)

        return self._gensets.copy()

    # Generating sets from prop 1.7
    def gensets1_7(self, n):
        max_num_diffs = 3
        while max_num_diffs*(max_num_diffs + 1)//2 < n:
            max_num_diffs += 1

        self._gensets.clear()
        for size in range(2, max_num_diffs):
            d = range(1, n - size*(size - 1)//2)
            data = [None] * size
            self.iterateSubsets(n, d, data, 0, len(d) - 1, 0, size, self.updateGensets1_7)

        return self._gensets.copy()

    # Generating sets from prop 1.8
    # Elements >= n represent reflections (n represents b, n + 1 represents ab, n + 2 represents a^2b, ...)
    #### TODO only find unique differences for reflections ####
    def gensets1_8(self, n):
        self._gensets.clear()
        elements = list(range(1, 2*n))
        for size in range(3, len(elements) + 1):
            data = [None] * size
            self.iterateSubsets(n, elements, data, 0, len(elements) - 1, 0, size, self.updateGensets1_8)

        return self._gensets.copy()

    # Generating sets from prop 1.9
    # Elements >= n represent reflections (n represents b, n + 1 represents ab, n + 2 represents a^2b, ...)
    #### TODO only find unique differences for reflections ####
    def gensets1_9(self, n):
        self._gensets.clear()
        elements = list(range(1, 2*n))
        for size in range(3, len(elements) + 1):
            data = [None] * size
            self.iterateSubsets(n, elements, data, 0, len(elements) - 1, 0, size, self.updateGensets1_9)

        return self._gensets.copy()

    def updateGensets1_5(self, n, data):
        # Check if differences are valid
        if sum(data) >= n:
            return True

        # Check if generating
        if gcd(data + [n]) == 1:
            # Build reflections
            reflections = [n]
            for i in range(len(data)):
                reflections.append(reflections[i] + data[i])
            self._gensets.append(reflections.copy())

        return True

    def updateGensets1_7(self, n, data):
        # Check if differences are valid
        if sum(data) >= n:
            return True

        # Check if generating
        if gcd(data + [n]) == 1:
            data2 = data.copy()
            data2.append(sum(data2))

            # Check if minimal
            for i in range(len(data2)):
                temp = data2.copy()
                temp.pop(i)
                temp.pop(i % len(temp))
                if gcd(temp + [n]) == 1:
                    return True

            # Build reflections
            reflections = [n]
            for i in range(len(data)):
                reflections.append(reflections[i] + data[i])
            self._gensets.append(reflections.copy())

        return True

    def updateGensets1_8(self, n, data):
        # Check at least one rotation and two reflections exist
        if (data[0] >= n or data[-1] < n or data[-2] < n):
            return True

        # Get rotations
        data2 = data.copy()
        rotations = []
        while (data2[0] < n):
            rotations.append(data2.pop(0))

        # Calculate differences
        d = []
        for i in range(len(data2)):
            d.append(data2[(i + 1) % len(data2)] - data2[i % len(data2)])

        # Check if generating
        if (gcd(rotations + d[0:len(d)-1] + [n]) == 1):
            self._gensets.append(data.copy())

        return True

    def updateGensets1_9(self, n, data):
        # Check at least one rotation and two reflections exist
        if (data[0] >= n or data[-1] < n or data[-2] < n):
            return True

        # Get rotations
        data2 = data.copy()
        rotations = []
        while (data2[0] < n):
            rotations.append(data2.pop(0))

        # Calculate differences
        d = []
        for i in range(len(data2)):
            d.append(data2[(i + 1) % len(data2)] - data2[i % len(data2)])

        # Check if generating
        if (gcd(rotations + d[0:len(d)-1] + [n]) == 1):
            # Check if minimal
            # Cannot remove rotation
            for i in range(len(rotations)):
                tempRotations = rotations.copy()
                tempRotations.pop(i)
                for j in range(len(d)):
                    tempD = d.copy()
                    tempD.pop(j)
                    if gcd(tempRotations + tempD + [n]) == 1:
                        return True

            # Cannot remove reflection
            for i in range(len(d)):
                tempD = d.copy()
                tempD.pop(i)
                tempD.pop(i % len(tempD))
                if gcd(rotations + tempD + [n]) == 1:
                    return True

            self._gensets.append(data.copy())

        return True