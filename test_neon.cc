#include<stdio.h>
#include<stdlib.h>

bool is_neon_available() {
    static bool is_cached = false;
    static bool cached;
    if (is_cached) {
        return cached;
    }
    u_int64_t id_aa64pfr0_el1;
    __asm__ ("mrs %0, ID_AA64PFR0_EL1" : "=r" (id_aa64pfr0_el1));
    cached = (15 != ((id_aa64pfr0_el1 >> 20) & (1 << 0 | 1 << 1 | 1 << 2 | 1 << 3)));
    is_cached = true;
    return cached;
}

int main(){

	printf("is neon available? [Y/N]:'%c'\n", is_neon_available()? 'Y':'N');

	return 0;
}
