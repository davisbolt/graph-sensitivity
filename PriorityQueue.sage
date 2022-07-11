import sys

class BinaryHeap:
    # Creates the heap as a list with a single dictionary containing a list of vertices, and a lowerbound, O(1)
    def __init__(self, vertices, lb):
        self.array = [{"vertices": vertices, "lb": lb}]
        self.primaryKey = self.depth
        self.secondaryKey = self.lb

    # returns the lower bound of ith entry in the queue, O(1)
    def lb(self, i):
        return self.array[i]["lb"]

    # returns the depth of ith entry in the queue, O(1)
    def depth(self, i):
        return -len(self.array[i]["vertices"])

    # Gets the index of the parent, O(1)
    def parent(self, i):
        return (i - 1)//2

    # Gets the index of the left child, O(1)
    def left(self, i):
        return 2*i + 1

    # Gets the index of the right child, O(1)
    def right(self, i):
        return 2*i + 2

    # Returns true iff the array is empty, O(1)
    def isEmpty(self):
        return len(self.array) == 0

    # Returns the lengths of the queue, O(1)
    def length(self):
        return len(self.array)

    # Makes the array into a proper heap
    # O(n), according to answer by user Jeremy West at
    # https://stackoverflow.com/questions/9755721/how-can-building-a-heap-be-on-time-complexity
    def buildHeap(self):
        for i in reversed(range(len(self.array)//2)):
            self.bubbleDown(i)

    # Swaps two items in the array, O(1)
    def swap(self, a, b):
        self.array[a], self.array[b] = self.array[b], self.array[a]

    # Makes a node fall down the heap until it is in the right spot, O(logn)
    def bubbleDown(self, i):
        while self.left(i) < len(self.array) and self.right(i) < len(self.array):
            m = min([i, self.left(i), self.right(i)], key=self.primaryKey)
            if m == i: break
            self.swap(i, m)
            i = m

        value = self.primaryKey(i)
        while self.left(i) < len(self.array) and self.right(i) < len(self.array):
            m = min([i, self.left(i), self.right(i)], key=self.secondaryKey)
            if m == i or self.primaryKey(m) != value: break
            self.swap(i, m)
            i = m

    # Brings a node up to the heap to the correct spot, O(logn)
    def bubbleUp(self, i):
        while i > 0 and self.primaryKey(i) < self.primaryKey(self.parent(i)):
            self.swap(i, self.parent(i))
            i = self.parent(i)

        value = self.primaryKey(i)
        while i > 0 and self.secondaryKey(i) < self.secondaryKey(self.parent(i)):
            if self.primaryKey(self.parent(i)) != value: break
            self.swap(i, self.parent(i))
            i = self.parent(i)

    # Inserts node at the end of the heap and bubbles it up, O(logn)
    def insert(self, vertices, lb):
        self.array.append({"vertices": vertices, "lb": lb})
        self.bubbleUp(len(self.array) - 1)

    # Swaps the root with the last node, pops it, and bubbles down the new root, O(logn)
    def deleteMin(self):
        self.swap(0, -1)
        root = self.array.pop()
        if len(self.array) > 0:
            self.bubbleDown(0)
        return root