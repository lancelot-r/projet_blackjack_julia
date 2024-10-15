using PythonCall
function cribble_erathostene(n::Int64=10)
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
    print("Les nombres premiers de 1 à " * string(n) * " sont :")
    print(index_primes)
    return index_primes
end

@time cribble_erathostene(10000)