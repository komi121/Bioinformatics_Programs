# Используем базовый образ Ubuntu
FROM ubuntu:20.04

# Устанавливаем переменные окружения для автоматической настройки tzdata и кодировки
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
ENV JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"
ENV LANG="C.UTF-8"
ENV LC_ALL="C.UTF-8"

# Фиксируем версии специализированных биоинформатических инструментов
ARG BWAMEM2_VERSION=2.2.1
ARG SAMTOOLS_VERSION=1.21
ARG PICARD_VERSION=3.3.0
ARG MULTIQC_VERSION=1.27.1

# Устанавливаем переменную окружения для директории инструментов
ENV TOOLS=/tools
ENV PATH="$TOOLS/bwa-mem2-${BWAMEM2_VERSION}:$TOOLS/samtools-${SAMTOOLS_VERSION}:$TOOLS/picard-${PICARD_VERSION}:$PATH"

# Установка неспециализированных пакетов отдельным слоем
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    tar \
    bzip2 \
    automake \
    make \
    autoconf \
    gcc \
    perl \
    zlib1g-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libncurses5-dev \
    libdeflate-dev \
    libbz2-dev \
    openjdk-17-jdk \
    git \
    build-essential \
    python3 \
    python3-pip \
    python3-yaml \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Создаем директорию для инструментов
RUN mkdir $TOOLS

# BWA-MEM2
# Версия: 2.2.1
# Дата релиза: 17 May 2021
RUN cd $TOOLS && \
    wget https://github.com/bwa-mem2/bwa-mem2/releases/download/v${BWAMEM2_VERSION}/bwa-mem2-${BWAMEM2_VERSION}_x64-linux.tar.bz2 && \
    tar -xjf bwa-mem2-${BWAMEM2_VERSION}_x64-linux.tar.bz2 && \
    rm bwa-mem2-${BWAMEM2_VERSION}_x64-linux.tar.bz2 && \
    mv bwa-mem2-${BWAMEM2_VERSION}_x64-linux bwa-mem2-${BWAMEM2_VERSION} && \
    chmod +x bwa-mem2-${BWAMEM2_VERSION}/bwa-mem2

# Устанавливаем переменную для исполняемого файла BWA-MEM2
ENV BWAMEM2="$TOOLS/bwa-mem2-${BWAMEM2_VERSION}/bwa-mem2"

# SAMtools
# Версия: 1.21
# Дата релиза: 12 September 2024
RUN cd $TOOLS && \
    wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    tar -xjf samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    rm samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd samtools-${SAMTOOLS_VERSION} && \
    ./configure --prefix=$TOOLS/samtools-${SAMTOOLS_VERSION} && \
    make && \
    make install && \
    cd .. && \
    rm -rf samtools-${SAMTOOLS_VERSION}/[^b]* && \
    cd samtools-${SAMTOOLS_VERSION} && \
    ln -s bin/samtools samtools

# Устанавливаем переменную для исполняемого файла SAMtools
ENV SAMTOOLS="$TOOLS/samtools-${SAMTOOLS_VERSION}/samtools"

# Picard
# Версия: 3.3.0
# Дата релиза: 10 October 2024
RUN cd $TOOLS && \
    mkdir -p picard-${PICARD_VERSION} && \
    cd picard-${PICARD_VERSION} && \
    wget https://github.com/broadinstitute/picard/releases/download/${PICARD_VERSION}/picard.jar

# Устанавливаем переменную для исполняемого файла Picard
ENV PICARD="$TOOLS/picard-${PICARD_VERSION}/picard.jar"

# MultiQC
# Версия: 1.27.1
# Дата релиза: 7 February 2025
RUN pip3 install multiqc==${MULTIQC_VERSION} && \
    pip3 cache purge

# Устанавливаем переменную для исполняемого файла MultiQC
ENV MULTIQC="multiqc"

# Устанавливаем рабочую директорию
WORKDIR /data

# Команда по умолчанию
CMD ["bash"]