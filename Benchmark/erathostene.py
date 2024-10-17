import time
def cribble_erathostene(n=10):
    liste_boolean_prime = [True for _ in range(0,n)]
    for i in range(1,n):
        for j in range(i+1,n):
            if liste_boolean_prime[j]:
                if divmod(j+1,i+1)[1] == 0:
                    liste_boolean_prime[j] = False
        
    index_primes = [i+1 for i, x in enumerate(liste_boolean_prime) if x]
    print("Les nombres premiers de 1 à " + str(n) + " sont :")
    print(index_primes)
    return index_primes

number= 10000
time_start = time.time()
cribble_erathostene(n=number)
time_final = time.time() - time_start
print("For " + str(number) + ", it took : " + str(time_final) + 'seconds.')