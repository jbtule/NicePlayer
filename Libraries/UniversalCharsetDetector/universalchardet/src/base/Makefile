

OBJS= CharDistribution.o \
	JpCntx.o \
	LangBulgarianModel.o \
	LangCyrillicModel.o \
	LangGreekModel.o \
	LangHungarianModel.o \
	LangHebrewModel.o \
	LangThaiModel.o \
	nsHebrewProber.o \
	nsCharSetProber.o \
	nsBig5Prober.o \
	nsEUCJPProber.o \
	nsEUCKRProber.o \
	nsEUCTWProber.o \
	nsEscCharsetProber.o \
	nsEscSM.o \
	nsGB2312Prober.o \
	nsMBCSGroupProber.o \
	nsMBCSSM.o \
	nsSBCSGroupProber.o \
	nsSBCharSetProber.o \
	nsSJISProber.o \
	nsUTF8Prober.o \
	nsLatin1Prober.o \
	nsUniversalDetector.o \
	UniversalChardet.o
	
all: $(OBJS)

%.o: %.mm
	gcc $(CFLAGS) -framework Cocoa -c -o $@ $<

%.o: %.cpp
	g++ $(CFLAGS) -c -o $@ $<

clean:
	rm -f *.o