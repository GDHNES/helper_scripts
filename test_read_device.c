#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char *argv[]) {
    int randomData = open(argv[1], O_RDONLY);
    if (randomData < 0) {
        fprintf(stderr,"Failed to open %s\n",argv[1]);
        return 1;
    }

    // Buffer to hold the random data
    unsigned char buffer[4];

    // Read random data
    ssize_t result = read(randomData, buffer, sizeof(buffer));
    if (result < 0) {
        fprintf(stderr,"Failed to read from %s\n",argv[1]);
        close(randomData);
        return 1;
    }
    printf("%u,%u,%u,%u\n",buffer[0],buffer[1],buffer[2],buffer[3]);

    close(randomData);

    return 0;
}
