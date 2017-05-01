OPT=-g -Wall

UTILBIN=util/bin/

UTILSRC=util/src/

LIBBIN=lib/bin/

LIBSRC=lib/src/

all : $(UTILBIN)rf_pendol $(UTILBIN)flux_check1 $(UTILBIN)flux_check2 $(UTILBIN)lorenz_int $(UTILBIN)rtbps_int $(UTILBIN)variacionals \
$(UTILBIN)qrexemple $(UTILBIN)qrerror $(UTILBIN)qrtemps $(UTILBIN)cmani_pendol $(UTILBIN)cmani_rtbp $(UTILBIN)dibuix

# ==========
# Utilitats
# ==========

# Part 1 - Retrat fase i Flux
$(UTILBIN)rf_pendol : $(UTILSRC)rf_pendol.c $(LIBBIN)pendol.o $(LIBBIN)rk78.o
	gcc -o $(UTILBIN)rf_pendol $(OPT) $(UTILSRC)rf_pendol.c $(LIBBIN)pendol.o $(LIBBIN)rk78.o -lm

$(UTILBIN)flux_check1 : $(UTILSRC)flux_check1.c $(LIBBIN)flux.o
	gcc -o $(UTILBIN)flux_check1 $(OPT) $(UTILSRC)flux_check1.c $(LIBBIN)flux.o $(LIBBIN)rk78.o -lm

$(UTILBIN)flux_check2 : $(UTILSRC)flux_check2.c $(LIBBIN)flux.o
	gcc -o $(UTILBIN)flux_check2 $(OPT) $(UTILSRC)flux_check2.c $(LIBBIN)flux.o $(LIBBIN)rk78.o -lm

$(UTILBIN)lorenz_int : $(UTILSRC)lorenz_int.c $(LIBBIN)lorenz.o $(LIBBIN)flux.o
	gcc -o $(UTILBIN)lorenz_int $(OPT) $(UTILSRC)lorenz_int.c $(LIBBIN)lorenz.o $(LIBBIN)flux.o $(LIBBIN)rk78.o -lm

$(UTILBIN)rtbps_int : $(UTILSRC)rtbps_int.c $(LIBBIN)rtbps.o $(LIBBIN)flux.o
	gcc -o $(UTILBIN)rtbps_int $(OPT) $(UTILSRC)rtbps_int.c $(LIBBIN)rtbps.o $(LIBBIN)flux.o $(LIBBIN)rk78.o -lm

# Part 2 - Variacionals primeres i diferencial del Flux
$(UTILBIN)variacionals : $(UTILSRC)variacionals.c $(LIBBIN)flux.o
	gcc -o $(UTILBIN)variacionals $(OPT) $(UTILSRC)variacionals.c $(LIBBIN)flux.o $(LIBBIN)rk78.o -lm

# Part 3 - Metode QR
$(UTILBIN)qrexemple : $(UTILSRC)qrexemple.c $(LIBBIN)qrres.o
	gcc -o $(UTILBIN)qrexemple $(OPT) $(UTILSRC)qrexemple.c $(LIBBIN)qrres.o -lm

$(UTILBIN)qrerror : $(UTILSRC)qrerror.c $(LIBBIN)qrres.o
	gcc -o $(UTILBIN)qrerror $(OPT) $(UTILSRC)qrerror.c $(LIBBIN)qrres.o -lm

$(UTILBIN)qrtemps : $(UTILSRC)qrtemps.c $(LIBBIN)qrres.o
	gcc -o $(UTILBIN)qrtemps $(OPT) $(UTILSRC)qrtemps.c $(LIBBIN)qrres.o -lm

# Part 4 - Calcul de les maniobres
$(UTILBIN)cmani_pendol : $(UTILSRC)cmani_pendol.c $(LIBBIN)cmani.o $(LIBBIN)pendolampliat.o
	gcc -o $(UTILBIN)cmani_pendol $(OPT) $(UTILSRC)cmani_pendol.c $(LIBBIN)cmani.o $(LIBBIN)pendolampliat.o $(LIBBIN)qrres.o $(LIBBIN)flux.o $(LIBBIN)rk78.o -lm

$(UTILBIN)cmani_rtbp : $(UTILSRC)cmani_rtbp.c $(LIBBIN)cmani.o $(LIBBIN)rtbps.o
	gcc -o $(UTILBIN)cmani_rtbp $(OPT) $(UTILSRC)cmani_rtbp.c $(LIBBIN)cmani.o $(LIBBIN)rtbps.o $(LIBBIN)qrres.o $(LIBBIN)flux.o $(LIBBIN)rk78.o -lm

$(UTILBIN)dibuix : $(UTILSRC)dibuix.c $(LIBBIN)cmani.o $(LIBBIN)rtbps.o $(LIBBIN)flux.o
	gcc -o $(UTILBIN)dibuix $(OPT) $(UTILSRC)dibuix.c $(LIBBIN)cmani.o $(LIBBIN)rtbps.o $(LIBBIN)qrres.o $(LIBBIN)flux.o $(LIBBIN)rk78.o -lm
	
# ========
# Rutines
# ========

# Integracio d'EDOs
$(LIBBIN)rk78.o : $(LIBSRC)rk78.c
	gcc -c -o $(LIBBIN)rk78.o $(OPT) $(LIBSRC)rk78.c

$(LIBBIN)flux.o : $(LIBSRC)flux.c $(LIBBIN)rk78.o
	gcc -c -o $(LIBBIN)flux.o $(OPT) $(LIBSRC)flux.c

# Metode QR
$(LIBBIN)qrres.o : $(LIBSRC)qrres.c
	gcc -c -o $(LIBBIN)qrres.o $(OPT) $(LIBSRC)qrres.c

# Calcul de maniobres
$(LIBBIN)cmani.o : $(LIBSRC)cmani.c $(LIBBIN)qrres.o $(LIBBIN)flux.o $(LIBBIN)rk78.o
	gcc -c -o $(LIBBIN)cmani.o $(OPT) $(LIBSRC)cmani.c

# Camps vectorials
$(LIBBIN)pendol.o : $(LIBSRC)pendol.c
	gcc -c -o $(LIBBIN)pendol.o $(OPT) $(LIBSRC)pendol.c

$(LIBBIN)pendolampliat.o : $(LIBSRC)pendolampliat.c
	gcc -c -o $(LIBBIN)pendolampliat.o $(OPT) $(LIBSRC)pendolampliat.c
	
$(LIBBIN)lorenz.o : $(LIBSRC)lorenz.c
	gcc -c -o $(LIBBIN)lorenz.o $(OPT) $(LIBSRC)lorenz.c

$(LIBBIN)rtbps.o : $(LIBSRC)rtbps.c
	gcc -c -o $(LIBBIN)rtbps.o $(OPT) $(LIBSRC)rtbps.c

#========
# Neteja
#========

cleanobjects : 
	rm -f $(LIBBIN)/*.o
	
cleanall : cleanobjects
	rm -f $(UTILBIN)/*
