#include <math.h>
#define N 2

int pendol (int n, double t, double *x, double *f, void *prm) {

	f[0]=x[1];
	f[1]=-sin(x[0]);
	if(n>N){
		f[2]=x[3];
		f[3]=-cos(x[0])*x[2];
		f[4]=x[5];
		f[5]=-cos(x[0])*x[4];
	}
	
	return 0;
}

