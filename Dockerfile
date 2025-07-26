FROM fedora:42

RUN dnf install -y \
    python3 \
    python3-pip \
    osslsigncode \
    openssl-pkcs11 \
    opensc \
    && dnf clean all

RUN pip install PyJWT[crypto] cryptography
RUN set -eux; \
    curl -L -o proCertumCardManager-install.bin https://files.certum.eu/software/proCertumCardManager/Linux-RedHat/2.2.13/proCertumCardManager-2.2.13-x86_64-centos.bin; \
    chmod +x proCertumCardManager-install.bin; \
    sh ./proCertumCardManager-install.bin --noexec --keep --nox11 --nochown --target /opt/proCertumCardManager; \
    ls /opt/proCertumCardManager;

WORKDIR /app
COPY me3-signing-api-server poetry.lock pyproject.toml certificate.pem /app/
EXPOSE 3000

ENTRYPOINT ["python3", "/app/me3-signing-api-server"]
