### Misc graph constructions ###

# Returns the bipartite double cover of a graph g
def bipartiteDoubleCover(g):
    return g.tensor_product(graphs.CompleteGraph(2))

# Returns the blow up of a graph g of order t
def blowUp(g, t):
    A = g.adjacency_matrix()
    B = ones_matrix(t)
    h = Graph()
    from_adjacency_matrix(h, A.tensor_product(B))
    return h
