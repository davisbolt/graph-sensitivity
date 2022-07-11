class Circulants(CayleyGraphFamily):
    def __init__(self):
        super().__init__()
        self.name = "Circulants"
        self.out_dir = "out/Circulants/"
        self.table_columns = ["|V|", "|E|", "deg", "Gen Set", "alpha", "sigma"]
        self.genset_switch = {
            "gensets": ["","ntables"],
            "gensetsOdds": ["Odd","ntables"],
            "gensetsCoprimes": ["Coprime","ntables"],
            "gensetsMaxCoprimes": ["Unitary","1table"],
            "gensetsMinReduced": ["Min","ntables"]
        }
        self.min_n = 4

    def group(self, n):
        return CyclicPermutationGroup(n)

    def element_list(self, n, group):
        elements = [group.gens()[0]]
        for i in range(n - 2):
            prevElement = elements[-1]
            elements.append(make_permgroup_element(group, Permutation(prevElement).left_action_product(Permutation(group.gens()[0]))))
        return elements

    def results_suite(self):
        self.output_results(max_n = 22, genset_method = self.gensets)
        self.output_results(max_n = 30, genset_method = self.gensetsMinReduced)
        self.output_results(max_n = 25, genset_method = self.gensetsOdds)
        self.output_results(max_n = 25, genset_method = self.gensetsCoprimes)
        self.output_results(max_n = 30, genset_method = self.gensetsMaxCoprimes)

    ## Gen Set Methods ##

    # Adds data to self._gensets if generating
    def updateGensets(self, n, data):
        if gcd(data + [n]) == 1:
            self._gensets.append(data.copy())
        return True

    # Adds data to self._gensets if generating and minimal
    def updateGensetsMin(self, n, data):
        if gcd(data + [n]) == 1:

            # Check if minimal
            for i in range(len(data)):
                temp = data.copy()
                temp.pop(i)
                if (gcd(temp + [n]) == 1):
                    return True

            self._gensets.append(data.copy())

        return True

    # Generating sets
    def gensets(self, n):
        rotations = list(range(1,  n//2 + 1))
        self._gensets.clear()
        for size in range(2, len(rotations) + 1):
            data = [None] * size
            self.iterateSubsets(n, rotations, data, 0, len(rotations) - 1, 0, size, self.updateGensets)

        return self._gensets.copy()

    # Generating sets with only odd powers of rotations
    def gensetsOdds(self, n):
        rotations = []
        for i in range(1,  n//2 + 1):
            if i % 2 == 1: rotations.append(i)

        self._gensets.clear()
        for size in range(2, len(rotations) + 1):
            data = [None] * size
            self.iterateSubsets(n, rotations, data, 0, len(rotations) - 1, 0, size, self.updateGensets)

        return self._gensets.copy()

    # Generating sets with only powers of rotations coprime to n
    def gensetsCoprimes(self, n):
        rotations = []
        for i in range(1,  n//2 + 1):
            if gcd(n, i) == 1: rotations.append(i)

        self._gensets.clear()
        for size in range(2, len(rotations) + 1):
            data = [None] * size
            self.iterateSubsets(n, rotations, data, 0, len(rotations) - 1, 0, size, self.updateGensets)

        return self._gensets.copy()

    # Generating sets with all powers of rotations coprime to n
    def gensetsMaxCoprimes(self, n):
        rotations = []
        for i in range(1,  n//2 + 1):
            if gcd(n, i) == 1: rotations.append(i)

        return [rotations]

    # Minimal generating sets
    def gensetsMin(self, n):
        rotations = []
        for rotation in range(1, n//2 + 1):
            if gcd(rotation, n) > 1:
                rotations.append(rotation)

        self._gensets.clear()
        for size in range(2, len(rotations) + 1):
            data = [None] * size
            self.iterateSubsets(n, rotations, data, 0, len(rotations) - 1, 0, size, self.updateGensetsMin)

        return self._gensets.copy()

    # Minimal generating sets (only divisors)
    def gensetsMinDivisors(self, n):
        rotations = divisors(n)
        rotations.pop(0)    # remove 1
        rotations.pop()     # remove n

        self._gensets.clear()
        for size in range(2, len(rotations) + 1):
            data = [None] * size
            self.iterateSubsets(n, rotations, data, 0, len(rotations) - 1, 0, size, self.updateGensetsMin)

        return self._gensets.copy()

    # Minimal generating sets, reduced (S2 U (S1 \ S3) method)
    def gensetsMinReduced(self, n):
        S1 = self.gensetsMin(n)
        S1 = set([tuple(genset) for genset in S1])
        S2 = self.gensetsMinDivisors(n)
        S2 = set([tuple(genset) for genset in S2])
        zn = []
        for i in range(1, n):
            if gcd(i, n) == 1: zn.append(i)
        S3 = S2.copy()
        for genset in list(S2):
            for z in zn:
                newset = [min(z*g % n, n - (z*g % n)) for g in list(genset)]
                newset.sort()
                S3.add(tuple(newset))
        return S2.union(S1.difference(S3))
