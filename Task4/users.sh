#!/bin/bash
create_user() {
  local USERNAME=$1
  local ORG=$2
  local DURATION=365

  echo "Создаем ключ для пользователя ${USERNAME}..."
  openssl genrsa -out ${USERNAME}.key 2048

  echo "Создаем запрос на сертификат (CSR) для ${USERNAME}..."
  openssl req -new -key ${USERNAME}.key -out ${USERNAME}.csr -subj "/CN=${USERNAME}/O=${ORG}"

  echo "Подписываем сертификат для пользователя ${USERNAME} (self-signed)..."
  openssl x509 -req -in ${USERNAME}.csr -signkey ${USERNAME}.key -out ${USERNAME}.crt -days ${DURATION}

  echo "Добавляем пользователя ${USERNAME} в kubeconfig..."
  
  kubectl config set-credentials ${USERNAME} \
    --client-certificate=$(pwd)/${USERNAME}.crt \
    --client-key=$(pwd)/${USERNAME}.key

  echo "Пользователь ${USERNAME} успешно создан и добавлен в kubeconfig."
  echo "-------------------------------------"
}

create_user "alice" "Безопасность"
create_user "bob" "Эксплуатация"
create_user "charlie" "Разработка"

echo "Генерация пользователей завершена."
