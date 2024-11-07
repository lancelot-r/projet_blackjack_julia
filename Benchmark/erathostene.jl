# Import de la fonction Python
using PyCall

# Fonction cribble Python
py"""
import time

def cribble_erathostene(n=10):
    liste_boolean_prime = [True for _ in range(0, n)]
    for i in range(1, n):
        for j in range(i + 1, n):
            if liste_boolean_prime[j]:
                if divmod(j + 1, i + 1)[1] == 0:
                    liste_boolean_prime[j] = False

    index_primes = [i + 1 for i, x in enumerate(liste_boolean_prime) if x]
    return index_primes
"""

# Importer la fonction Python pour l'utiliser dans Julia
cribble_erathostene_python = py"cribble_erathostene"

# Fonction cribble en Julia
function cribble_erathostene_julia(n::Int64)
    list_boolean_prime = ones(Bool,n)

    for i in range(2,n)
        for j in range(i+1,n)
            # Si j est potentiellement premier
            if (list_boolean_prime[j])
                # Si i divise j
                if (rem(j,i) == 0)
                    # j n'est pas premier
                    list_boolean_prime[j] = false
                end
            end
        end
    end
    # On retourne les index de list_boolean_prime dont la valeur est true.
    index_primes = findall(list_boolean_prime)
    return index_primes
end


# Temps Python
function cribble_erathostene_python_time(n::Int64)
    time_start = pyimport("time").time()
    cribble_erathostene_python(n=n)  # Appel de la fonction cribble_erathostene
    time_final = pyimport("time").time() - time_start
    return time_final
end

# Temps Julia
function cribble_erathostene_julia_time(n::Int64)
    @time cribble_erathostene_julia(n)
end

# Résultats
number = 100000
println("Julia :")
time_julia = cribble_erathostene_julia_time(number)
println("Python :")
time_python = cribble_erathostene_python_time(number)
println("For $number it took $time_python second for Python")