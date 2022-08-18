FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y  build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libjpeg-dev  autoconf autogen asciidoc libarchive-dev pkg-config liblzma-dev
RUN git clone https://github.com/JayXon/Leanify.git
WORKDIR /Leanify
RUN CC=afl-gcc CXX=afl-g++ make
RUN mkdir /leanifyCorpus
RUN wget https://github.com/strongcourage/fuzzing-corpus/blob/master/png/ImageMagick/affine.png
RUN echo "DUMMYTEXT" > dummy.txt
RUN zip -r sample1.zip dummy.txt
RUN zip -r sample2.zip affine.png
RUN mv *.zip /leanifyCorpus

ENTRYPOINT ["afl-fuzz", "-t", "5000+", "-i", "/leanifyCorpus", "-o", "/leanifyOut"]
CMD ["/Leanify/leanify", "@@"]
