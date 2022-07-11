︠f1680f79-2ee9-4f91-b2ee-0acbf749b270s︠
## Tests and Verification of conjectures/results

# Compare adjacency matrices of cube graphs to folded cube graphs
A = [[0], [[0,1],[1,0]]]
B = [[0], [[0,1],[1,0]]]
for i in range(2, 6):
    print("Hypercube, n = " + str(i))
    A.append([[None for x in range(2**i)] for y in range(2**i)])
    for x in range(2**(i-1)):
        for y in range(2**(i-1)):
            A[i][x][y] = A[i-1][x][y]
        for y in range(2**(i-1), 2**i):
            A[i][x][y] = 1 if y == 2**(i-1) + x else 0
    for x in range(2**(i-1), 2**i):
        for y in range(2**(i-1)):
            A[i][x][y] = 1 if x == 2**(i-1) + y else 0
        for y in range(2**(i-1), 2**i):
            A[i][x][y] = -A[i-1][x-2**(i-1)][y-2**(i-1)]
    A2 = matrix(A[i])
    [e.real().numerical_approx(digits = 3) for e in A2.eigenvalues()]

    print("\nFolded Hypercube, n = " + str(i))
    B.append([[None for x in range(2**i)] for y in range(2**i)])
    for x in range(2**(i-1)):
        for y in range(2**(i-1)):
            B[i][x][y] = A[i-1][x][y]
        for y in range(2**(i-1), 2**i):
            if (y == 2**(i-1) + x):
                 B[i][x][y] = 1
            elif (y == 2**i - x - 1):
                if (x < 2**(i-2)):
                    B[i][x][y] = 1
                else:
                    B[i][x][y] = 1
            else:
                 B[i][x][y] = 0
    for x in range(2**(i-1), 2**i):
        for y in range(2**(i-1)):
            if (x == 2**(i-1) + y):
                B[i][x][y] = 1
            elif (x == 2**i - y - 1):
                if (y < 2**(i-2)):
                    B[i][x][y] = 1
                else:
                    B[i][x][y] = 1
            else:
                B[i][x][y] = 0
        for y in range(2**(i-1), 2**i):
            B[i][x][y] = -A[i-1][x-2**(i-1)][y-2**(i-1)]
    B2 = matrix(B[i])
    B2
    [e.numerical_approx(digits = 3) for e in B2.eigenvalues()]
    print("\n")


# for i in range(2, 7):
#     graphs.FoldedCubeGraph(i).show()
︡df975e8d-c3d5-4ea2-af27-f93293e14cac︡{"stdout":"Hypercube, n = 2\n[-1.41, -1.41, 1.41, 1.41]\n\nFolded Hypercube, n = 2\n[ 0  1  1  1]\n[ 1  0  1  1]\n[ 1  1  0 -1]\n[ 1  1 -1  0]\n[1.00, -1.00, -2.24, 2.24]\n\n\nHypercube, n = 3\n[-1.73, -1.73, -1.73, -1.73, 1.73, 1.73, 1.73, 1.73]"}︡{"stdout":"\n\nFolded Hypercube, n = 3\n[ 0  1  1  0  1  0  0  1]\n[ 1  0  0  1  0  1  1  0]\n[ 1  0  0 -1  0  1  1  0]\n[ 0  1 -1  0  1  0  0  1]\n[ 1  0  0  1  0 -1 -1  0]\n[ 0  1  1  0 -1  0  0 -1]\n[ 0  1  1  0 -1  0  0  1]\n[ 1  0  0  1  0 -1  1  0]\n[-2.61, -2.61, -1.08, -1.08, 1.08, 1.08, 2.61, 2.61]\n\n\nHypercube, n = 4\n[2.00, 2.00, 2.00, 2.00, 2.00, 2.00, 2.00, 2.00, -2.00, -2.00, -2.00, -2.00, -2.00, -2.00, -2.00, -2.00]\n\nFolded Hypercube, n = 4\n[ 0  1  1  0  1  0  0  0  1  0  0  0  0  0  0  1]\n[ 1  0  0  1  0  1  0  0  0  1  0  0  0  0  1  0]\n[ 1  0  0 -1  0  0  1  0  0  0  1  0  0  1  0  0]\n[ 0  1 -1  0  0  0  0  1  0  0  0  1  1  0  0  0]\n[ 1  0  0  0  0 -1 -1  0  0  0  0  1  1  0  0  0]\n[ 0  1  0  0 -1  0  0 -1  0  0  1  0  0  1  0  0]\n[ 0  0  1  0 -1  0  0  1  0  1  0  0  0  0  1  0]\n[ 0  0  0  1  0 -1  1  0  1  0  0  0  0  0  0  1]\n[ 1  0  0  0  0  0  0  1  0 -1 -1  0 -1  0  0  0]\n[ 0  1  0  0  0  0  1  0 -1  0  0 -1  0 -1  0  0]\n[ 0  0  1  0  0  1  0  0 -1  0  0  1  0  0 -1  0]\n[ 0  0  0  1  1  0  0  0  0 -1  1  0  0  0  0 -1]\n[ 0  0  0  1  1  0  0  0 -1  0  0  0  0  1  1  0]\n[ 0  0  1  0  0  1  0  0  0 -1  0  0  1  0  0  1]\n[ 0  1  0  0  0  0  1  0  0  0 -1  0  1  0  0 -1]\n[ 1  0  0  0  0  0  0  1  0  0  0 -1  0  1 -1  0]\n[-2.80, -2.80, -2.80, -2.80, -1.47, -1.47, -1.47, -1.47, 1.47, 1.47, 1.47, 1.47, 2.80, 2.80, 2.80, 2.80]\n\n\nHypercube, n = 5\n[-2.24, -2.24, -2.24, -2.24, -2.24, -2.24, -2.24, -2.24, -2.24, -2.24, -2.24, -2.24, -2.24, -2.24, -2.24, -2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24]\n\nFolded Hypercube, n = 5\n32 x 32 dense matrix over Integer Ring\n[-3.08, -3.08, -3.08, -3.08, -3.08, -3.08, -3.08, -3.08, -1.59, -1.59, -1.59, -1.59, -1.59, -1.59, -1.59, -1.59, 1.59, 1.59, 1.59, 1.59, 1.59, 1.59, 1.59, 1.59, 3.08, 3.08, 3.08, 3.08, 3.08, 3.08, 3.08, 3.08]\n\n\n"}︡{"done":true}









