//
//  main.cpp
//  benchmark_cpp
//
//  Created by Lancelot on 07/11/2024.
//

#include <iostream>
#include <vector>
#include <chrono>

void crible_erathostene(int n) {
    std::vector<bool> liste_boolean_prime(n, true);

    for (int i = 1; i < n; ++i) {
        for (int j = i + 1; j < n; ++j) {
            if (liste_boolean_prime[j]) {
                if ((j + 1) % (i + 1) == 0) {
                    liste_boolean_prime[j] = false;
                }
            }
        }
    }

    std::vector<int> index_primes;
    for (int i = 0; i < n; ++i) {
        if (liste_boolean_prime[i]) {
            index_primes.push_back(i + 1);
        }
    }
}

int main() {
    int number = 100000;

        crible_erathostene(number);
        return 0;
}