FROM armhf/debian

MAINTAINER Rio <onslaught89@gmail.com>

RUN apt-get update && \
    apt-get -q -y install --no-install-recommends python3 \
      python3-dev python3-pip build-essential cmake \
      pkg-config libjpeg-dev libtiff5-dev libjasper-dev \
      libpng12-dev libavcodec-dev libavformat-dev libswscale-dev \
      libv4l-dev libxvidcore-dev libx264-dev python3-yaml \
      python3-scipy python3-h5py git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Keras Tensorflow
RUN pip3 install keras
ADD https://github.com/samjabrahams/tensorflow-on-raspberry-pi/releases/download/v1.0.0/tensorflow-1.0.0-cp34-cp34m-linux_armv7l.whl /tensorflow-1.0.0-cp34-cp34m-linux_armv7l.whl
RUN pip3 install /tensorflow-1.0.0-cp34-cp34m-linux_armv7l.whl && rm /tensorflow-1.0.0-cp34-cp34m-linux_armv7l.whl

# OpenCV
ENV OPENCV_VERSION="3.2.0"
ENV OPENCV_DIR="/opt/opencv/"

ADD https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz ${OPENCV_DIR}

RUN cd ${OPENCV_DIR} && \
    tar -xzf ${OPENCV_VERSION}.tar.gz && \
    rm ${OPENCV_VERSION}.tar.gz && \
    mkdir ${OPENCV_DIR}opencv-${OPENCV_VERSION}/build && \
    cd ${OPENCV_DIR}opencv-${OPENCV_VERSION}/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. && make -j4 && make install && \
    mv /usr/local/lib/python3.4/dist-packages/cv2.cpython-34m.so /usr/local/lib/python3.4/dist-packages/cv2.so && \
    rm -rf ${OPENCV_DIR}

#Jupyter section

# Set the variables
ENV DEBIAN_FRONTEND noninteractive
ENV PYTHON_VERSION 3.6.0

# Update pip and install jupyter
RUN apt-get install -y libncurses5-dev
RUN pip3 install --upgrade pip
RUN pip3 install readline jupyter

# Configure jupyter
RUN jupyter notebook --generate-config
RUN mkdir notebooks
RUN sed -i "/c.NotebookApp.open_browser/c c.NotebookApp.open_browser = False" /root/.jupyter/jupyter_notebook_config.py \
        && sed -i "/c.NotebookApp.ip/c c.NotebookApp.ip = '*'" /root/.jupyter/jupyter_notebook_config.py \
        && sed -i "/c.NotebookApp.notebook_dir/c c.NotebookApp.notebook_dir = '/root/notebooks'" /root/.jupyter/jupyter_notebook_config.py

VOLUME /root/notebooks

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION 0.14.0
ENV CFLAGS="-DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37"

ADD https://github.com/krallin/tini/archive/v${TINI_VERSION}.tar.gz /root/v${TINI_VERSION}.tar.gz
RUN apt-get install -y cmake
RUN tar zxvf v${TINI_VERSION}.tar.gz \
        && cd tini-${TINI_VERSION} \
        && cmake . \
        && make \
        && cp tini /usr/bin/. \
        && cd .. \
        && rm -rf "./tini-${TINI_VERSION}" \
        && rm "./v${TINI_VERSION}.tar.gz"

ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888

CMD ["jupyter", "notebook"]