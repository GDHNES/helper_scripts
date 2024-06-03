#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

unsigned int data=0xefbeadde;

int main(int argc, char *argv[]) {
    int filep = open(argv[1], O_WRONLY);
    if (filep < 0) {
        fprintf(stderr,"Failed to open %s\n",argv[1]);
        return 1;
    }

    ssize_t result = write(filep, &data, sizeof(data));
    if (result < 0) {
        fprintf(stderr,"Failed to write to %s\n",argv[1]);
        close(filep);
        return 1;
    }
    close(filep);

    return 0;
}
