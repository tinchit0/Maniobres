#include <stdio.h>
#include <string.h>
#include "../../lib/hdr/cmani.h"
#include "../../lib/hdr/flux.h"
#include "../../lib/hdr/rtbps.h"

int main(int argc, char *argv[]){
	/* Calcula els dv0 dv1 que envien un objecte amb condicions x0 a xf en temps dt sotmes al camp RTBP */
	/*	Entrada:
			- "dt x0 y0 z0 v0x v0y v0z xf yf zf vfx vfy vfz" : temps, condicions inicials i condicions finals
		Sortida:
			- "t x y z vx vy vz" a 2000 punts de la trajectoria total
	*/
	
	double mu; double tolnwt; int maxitnwt;	
	if (argc!=4
	  || sscanf(argv[1], "%lf", &mu)!=1
	  || sscanf(argv[2], "%lf", &tolnwt)!=1
	  || sscanf(argv[3], "%d", &maxitnwt)!=1
	) {
	  printf("cmani_rtbp mu tolnwt maxitnwt\n");
	  return -1;
	} void *prm = (void *) &mu;
	
	int m = 3; int n = 2*m;
	double x0[n], xf[n], dv[n],dt;
	double pas0=1E-8, pasmin=1E-14, pasmax=1., tolfl=1E-15, npasmx=1000;
	int nt = 1000; double T; int i; double t; double h; double x[n];
	
	while (scanf("%lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf",&dt,&x0[0],&x0[1],&x0[2],&x0[3],&x0[4],&x0[5],&xf[0],&xf[1],&xf[2],&xf[3],&xf[4],&xf[5])==13) {
	  dv[0]=0.; dv[1]=0.; dv[2]=0.; dv[3]=0.; dv[4]=0.; dv[5]=0.;
	  cmani (m, x0, xf, dt, dv, tolnwt, maxitnwt,
	  pas0, pasmin, pasmax, tolfl, npasmx,
	  rtbps, prm);
	  T = (dt/2)/nt; t = 0; h=pas0; memcpy(x,x0,n*sizeof(double));
	  printf("%lf %lf %lf %lf %lf %lf %lf\n", t, x[0], x[1], x[2], x[3], x[4], x[5]);
	  // Primer impulso
	  for(i=0;i<m;i++){
	    x[i+m] += dv[i];
	  }
	  // Vuelo libre
	  for(i=0;i<nt;i++){
	    flux(&t,x,&h,T,pasmin,pasmax,tolfl,npasmx,6,rtbps,prm);
	    printf("%lf %lf %lf %lf %lf %lf %lf\n", t, x[0], x[1], x[2], x[3], x[4], x[5]);
	  }
	  // Segundo impulso
	  for(i=0;i<m;i++){
	    x[i+m] += dv[i+m];
	  }
	  // Vuelo libre
	  for(i=0;i<nt;i++){
	    flux(&t,x,&h,T,pasmin,pasmax,tolfl,npasmx,6,rtbps,prm);
	    printf("%lf %lf %lf %lf %lf %lf %lf\n", t, x[0], x[1], x[2], x[3], x[4], x[5]);
	  }		
	  printf("\n\n");
	}
	
	return 0;
}
