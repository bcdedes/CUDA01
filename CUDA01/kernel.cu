
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>


__device__ __managed__ int ret[1000];
__global__ void add(int *a, int *b, int *c) {
	*c = *a + *b;
}

int main(void) {
	//int *um_a, *um_b, *um_c; // unified memory values
	int h_a, h_b, h_c; // host values
	int *d_a, *d_b, *d_c;
	int size = sizeof(int);

	// allocate memory for unified values
	//cudaMallocManaged((void **)&um_a, size);
	//cudaMallocManaged((void **)&um_b, size);
	//cudaMallocManaged((void **)&um_c, size);

	// allocate memory for device values
	cudaMalloc((void **)&d_a, size);
	cudaMalloc((void **)&d_b, size);
	cudaMalloc((void **)&d_c, size);

	h_a = 2;
	h_b = 7;
	//&um_a = 4;
	//&um_b = 6;

	// Copy inputs to device
	cudaMemcpy(d_a, &h_a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, &h_b, size, cudaMemcpyHostToDevice);

	add<<<1,1>>>(d_a, d_b, d_c);
	//add << <1, 1 >> >(um_a, um_b, um_c);

	// Copy result back to host
	cudaMemcpy(&h_c, d_c, size, cudaMemcpyDeviceToHost);

	//printf("unified memory = %d\n", um_c);
	printf("device memory: %d\n", h_c);

	// Cleanup
	cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);



	return 0;
}
