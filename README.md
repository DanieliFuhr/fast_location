# FastLocation

Aplicativo mobile desenvolvido em Flutter para consulta de endereços por meio do CEP, utilizando a API ViaCEP, com armazenamento local do histórico de pesquisas e funcionalidade de localização e navegação até o endereço consultado.

## Objetivo do projeto

O FastLocation tem como objetivo facilitar a consulta de endereços, permitindo que o usuário pesquise informações por CEP ou endereço, visualize os dados encontrados, consulte pesquisas anteriores e abra uma rota até o endereço desejado.

## Funcionalidades

- Consulta de CEP por meio da API ViaCEP.
- Pesquisa de endereços.
- Exibição dos dados retornados pela API.
- Indicador de carregamento durante as consultas.
- Mensagem de erro quando o CEP não é encontrado.
- Armazenamento local do histórico de pesquisas.
- Consulta ao histórico de endereços pesquisados.
- Obtenção da localização atual do dispositivo.
- Abertura da rota entre a localização atual e o endereço consultado no Google Maps.
- Tela inicial animada com direcionamento para a página principal.

## Tecnologias e bibliotecas utilizadas

- **Flutter:** desenvolvimento da aplicação mobile.
- **Dart:** linguagem de programação.
- **Dio:** comunicação com a API ViaCEP.
- **MobX e Flutter MobX:** gerenciamento reativo de estado.
- **Hive e Hive Flutter:** armazenamento local do histórico.
- **Geolocator:** obtenção da localização do dispositivo.
- **Geocoding:** recursos de conversão de informações geográficas.
- **Map Launcher:** integração com aplicativos de mapas.
- **URL Launcher:** abertura de links externos.

## Organização do projeto

```text
lib/
├── main.dart
└── src/
    ├── http/
    ├── modules/
    │   ├── home/
    │   │   ├── components/
    │   │   ├── controller/
    │   │   ├── model/
    │   │   ├── page/
    │   │   ├── repositories/
    │   │   └── service/
    │   ├── history/
    │   │   ├── controller/
    │   │   └── page/
    │   └── initial/
    │       └── page/
    ├── routes/
    └── shared/
        ├── colors/
        ├── components/
        ├── metrics/
        └── storage/
```

## Requisitos para execução

- Flutter instalado e configurado.
- Dart SDK compatível com a versão do projeto.
- Android Studio ou Visual Studio Code.
- Emulador Android ou dispositivo Android físico.

## Como executar o projeto

1. Clone o repositório:

```bash
git clone https://github.com/DanieliFuhr/fast_location.git
```

2. Acesse a pasta do projeto:

```bash
cd fast_location
```

3. Instale as dependências:

```bash
flutter pub get
```

4. Execute o aplicativo:

```bash
flutter run
```

## Testes e validação

Para verificar a qualidade do código:

```bash
flutter analyze
```

Para executar os testes automatizados:

```bash
flutter test
```

## API utilizada

O projeto utiliza a API pública ViaCEP para consulta de informações de endereços brasileiros.

Documentação: https://viacep.com.br/

## Projeto acadêmico

Aplicação desenvolvida como atividade acadêmica da unidade curricular **Desenvolvimento de Sistemas Móveis**.
