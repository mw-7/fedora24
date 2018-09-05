FROM fedora:24

ADD ./environment.yml .

RUN dnf update -y
RUN dnf install -y make automake gcc-gfortran gcc gcc-c++ kernel-devel cmake redis git tar bzip2 qt5-qttools-devel libgfortran boost-python3 libasan libubsan postgresql socat
RUN dnf install -y libpqxx-devel boost-devel blas-devel lapack-devel

RUN git clone --recursive --branch 3.5.4 https://github.com/Cylix/cpp_redis.git && cd cpp_redis && git submodule init && git submodule update && mkdir build && cd build && cmake .. && make && make install && cd .. && cd tacopie && cmake . && make install

RUN git clone --branch yaml-cpp-0.6.2 https://github.com/jbeder/yaml-cpp.git && cd yaml-cpp && mkdir build && cd build && cmake -DBUILD_SHARED_LIBS=ON -DYAML_CPP_BUILD_TOOLS=OFF -DYAML_CPP_BUILD_TESTS=OFF .. && make && make install
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

RUN curl --silent -o miniconda-installer.sh https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh && bash miniconda-installer.sh -b -p $HOME/anaconda3
ENV PATH="$HOME/anaconda3/bin:$PATH"
RUN $HOME/anaconda3/bin/conda env create
