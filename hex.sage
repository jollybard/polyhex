
# -*- coding: utf-8 -*-

#Les hexagones sont tuples (x,y,z) d'entiers tels que x + y + z = 0
#
#Ce programme a été conçu pour être utilisé de façcon interactive.
#Cependant, vous pouvez aussi utiliser `sage hex.sage <n>`, où
# <n> est la taille maximale de polyhex qui vous intéresse.
#
#Utiliser maxFeuilles(n) pour énumérer les arbres de taille jusqu'à n
#et donner le maximum du nombre de feuilles 
#
#
#ATTENTION: l'algorithme devient rapidement très lent, je suggère une
#valeur de n = 9
#
#
###
import sys
###

def maxFeuilles(n):
    A = genArbres(n)
    for i in range(len(A)):
        M = max([len(feuillesDe(Hex(T))) for T in A[i]])
        print "L_hex(" + str(i+1) + ") = " + str(M)

def genArbres(n): 
    #retourne une liste de listes d'ensembles de points
    #où genArbres(n)[i][j] est le j-ième arbre de taille i-1
    print "Énumération..."
    A = []
    return genArbres_iter(A, 1, n)

###
###

DIR = [
        (1, -1, 0),
        (1, 0, -1),
        (0, 1, -1),
        (-1, +1, 0),
        (-1, 0, +1),
        (0, -1, 1)
    ]

def dist(h1, h2):
   return sum((abs(i-j) for i,j in zip(h1,h2)))/2

def sontVoisins(h1, h2): #h1 et h2 sont des hexagones
   if dist(h1, h2) == 1:
      return True
   else:
      return False

def add(h1, h2):
    return tuple([i+j for i,j in zip(h1,h2)])

def diff(h1, h2):
    return tuple([i-j for i,j in zip(h1,h2)])


def Hex(sommets):
    return Graph([sommets, sontVoisins] )

def v_of_depth(graph,depth): 
    #returns list of vertices of depth up to n
    T = graph.copy()
    V = []
    for i in range(depth):
        if len(T.vertices()) == 1:
            V = V + T.vertices()
        else:
            V = V + feuillesDe(T)
        T = Hex([v for v in T.vertices() if v not in feuillesDe(T)])
    return V    

def hexplot(graph):
    sommets = graph.vertices()
    pos = (hexpos((x,y,z)) for (x,y,z) in sommets)
    posdict = {k:v for (k,v) in zip(sommets, pos)}
    return graph.plot(pos = posdict)

def hexpos((x,y,z)):
    return (sqrt(3) * (x + z/2), 3/2 * z)


def feuillesDe(T):
    return [f for f in T if T.degree(f) == 1]

def genArbres_iter(A, k, n):
    #les arbres sont représentés avec leur centre sur (0,0,0) pour ne pas
    # compter deux fois le même arbre modulo translations
    if k == 1:
        A.append([{(0,0,0)}])
    elif k > n:
        return A
    else:
        print 'n = ' + str(k) + ', ',
        B = []
        for T in A[k-2]: #A[0] est l'arbre à un seul sommet
            if k == 2:
                V = T
            else:
                V = v_of_depth(Hex(T), 2)
            for h in V:
            #for h in T:
                voisins = 0
                for d in DIR:
                    if voisins == 3:
                        continue
                    l = add(h,d)
                    if l in T:
                        voisins += 1
                        continue
                    TP = T.copy()
                    TP.add(l)
                    TP = recentrer(TP)
                    if TP in B:
                        continue
                    if not Hex(TP).is_tree():
                        continue
                    B.append(TP)
        A.append(B)
        print len(B), 'arbres'
    return genArbres_iter(A, k+1, n)

def recentrer(T): #ensemble de tuples -> ensemble de tuples
    C = Hex(T).center()
    if len(C) == 1:
        centre = C[0]
    else:
        if sum(hexpos(C[0])) <= sum(hexpos(C[1])):
            centre = C[0]
        else:
            centre = C[1]
    #centre = C[0]
    return set([diff(p, centre) for p in T])


#outdated
def genArbres_rec(n):
    if n == 1: 
        return [Hex([(0,0,0)])]
    else:
        A = []
        for T in genArbres(n-1):
            for h in T.vertices():
                for d in DIR:
                    l = add(h,d)
                    if l not in T:
                        TP = Hex(T.vertices() + [l])
                        if TP.is_tree():
                            b = True
                            for a in A: ## MAUVAISE IDÉE
                                if TP in A: b = false
                            if b:
                                A.append(TP)
        return A

if __name__ == "__main__" :
    try:
        maxFeuilles(sys.argv)
    except:
        pass
