# Usa la imagen base oficial de PyTorch con CUDA 
FROM nvcr.io/nvidia/pytorch:24.06-py3

# Configura debconf para ser no interactivo durante la construcción
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependencias necesarias adicionales
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    git \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instala pyenv
RUN curl https://pyenv.run | bash

# Configura el entorno para pyenv
ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"

# Instala Python 3.9 y lo establece como la versión global
RUN /bin/bash -c "source ~/.bashrc && pyenv install 3.9.7 && pyenv global 3.9.7"

# Asegura que setuptools, pip y wheel estén actualizados
RUN pip install --upgrade pip setuptools wheel

# Verifica la versión de Python
RUN python --version

# Procede con la instalación de dependencias como antes
# Instala Cython
RUN pip install Cython 

# Instalar JAX con soporte para CUDA
RUN pip install --upgrade pip

# Instala JAX y JAXLIB con soporte para CUDA 12
RUN pip install jax[cuda12] -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

# Copiar el archivo requirements.txt al contenedor
COPY requirements.txt /tmp/
# Instalar las dependencias adicionales de Python desde requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copiar el directorio actual al contenedor
COPY . /app/

# Establecer el directorio de trabajo
WORKDIR /app

# Exponer el puerto 8086
EXPOSE 7002
