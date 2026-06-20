# 🚀 Aplicacão exemplo SonarQube (.NET)

Este projeto é uma demonstração prática de como integrar análises de qualidade de código, segurança e manutenibilidade utilizando o **SonarQube** em um ecossistema **.NET**. O objetivo principal é garantir as melhores práticas de desenvolvimento (*Clean Code*) e monitorar o débito técnico da aplicação de forma automatizada.

---

## 🛠️ Pré-requisitos

Antes de iniciar, certifique-se de ter instalado em sua máquina:

* [.NET SDK 9.0](https://dotnet.microsoft.com/download) (ou a versão utilizada no seu projeto)
* [Docker & Docker Compose](https://www.docker.com/)
* [Java Runtime Environment (JRE) ou JDK 17+](https://adoptium.net/) *(Necessário porque o SonarScanner depende do Java para rodar a análise localmente)*

---

## 📦 1. Subindo o Ambiente do SonarQube

O ambiente do servidor do SonarQube está conteinerizado junto com um banco de dados **PostgreSQL** para garantir que o histórico das suas análises locais não seja perdido ao reiniciar os containers.

Na raiz do projeto (onde está o arquivo `docker-compose.yml`), execute:

```bash
docker compose up -d
```

> ⏳ **Nota:** O SonarQube pode levar de 1 a 2 minutos para inicializar completamente na primeira vez, pois estará estruturando o banco de dados. Você pode acompanhar o progresso rodando `docker logs -f sonarqube_server`.

Assim que estiver pronto, acesse o painel web em: **`http://localhost:9000`**

* **Usuário padrão:** `admin`
* **Senha padrão:** `admin`
  *(O sistema solicitará a alteração da senha no primeiro acesso).*

---

## ⚙️ 2. Configurando o Projeto no Painel do Sonar

1. No painel do SonarQube, clique em **Create Project** -> **Manually**.
2. Defina o nome e a chave do projeto como: `sonarqube_example` e clique em **Set Up**.
3. Na tela seguinte, selecione a opção de análise **Locally** (Localmente).
4. Clique em **Generate** para criar o seu Token de Acesso. **Copie e guarde esse token.**

---

## 🔍 3. Rodando a Análise de Qualidade

Para evitar a digitação manual de múltiplos comandos, o projeto conta com um script de automação Bash (`sonar.sh`) que executa o fluxo completo da análise (o formato "sanduíche" do .NET).

### Instalação do Scanner (Apenas na primeira vez)

Se você nunca usou o SonarScanner no seu ambiente .NET, instale a ferramenta globalmente executando:

```bash
dotnet tool install --global dotnet-sonarscanner

```

### Executando o Script

Abra o seu terminal (preferencialmente Git Bash se estiver no Windows, ou terminal nativo no Linux/macOS) na raiz do projeto e execute o script passando o token gerado no passo anterior:

```bash
# Dê permissão de execução ao script (apenas na primeira vez)
chmod +x sonar.sh

# Execute a análise passando o seu token
./sonar.sh SEU_TOKEN_AQUI

```

O script irá automaticamente:

1. Inicializar o monitoramento do SonarScanner.
2. Compilar a aplicação e os projetos de teste (`dotnet build`).
3. Finalizar a análise e enviar o relatório para o container Docker.

Ao finalizar com sucesso, atualize a página em `http://localhost:9000` para visualizar as métricas de Bugs, Vulnerabilidades, Cobertura de Testes e *Code Smells*.

<br>
<br>

<br>
<br>

---
# 🔍 Guia de Introdução: O Universo Sonar

Este documento tem como objetivo explicar os conceitos fundamentais do **SonarQube**, suas principais utilidades no ciclo de desenvolvimento de software e as diferentes maneiras de arquitetar e executar essa ferramenta no seu projeto ou esteira de CI/CD.

---

## 1. O que é o SonarQube e para que serve?

O **SonarQube** é uma plataforma de código aberto para **análise estática de código**. Ele atua como um revisor automatizado que inspeciona o código-fonte sem a necessidade de executá-lo, identificando problemas de qualidade, segurança e manutenibilidade antes que o software seja implantado em produção.

Seu principal objetivo é mitigar o **débito técnico** e garantir a entrega de um código limpo (*Clean Code*).

### Os 4 Pilares de Análise

Durante a varredura, o SonarQube categoriza os problemas encontrados em quatro frentes:

* **Bugs:** Erros de lógica ou sintaxe que impactarão diretamente o funcionamento da aplicação (ex: loops infinitos, potenciais exceções de ponteiro nulo).
* **Vulnerabilidades (Vulnerabilities):** Brechas de segurança que expõem o sistema a ataques (ex: SQL Injection, chaves de API expostas no código).
* **Cheiros de Código (Code Smells):** Trechos que não estão necessariamente quebrando o sistema, mas que foram escritos de forma confusa, duplicada ou ineficiente. Afetam diretamente a manutenção futura.
* **Cobertura de Testes (Coverage):** Integra-se aos relatórios de testes unitários do seu projeto para exibir a porcentagem exata de linhas de código que estão protegidas por testes.

> 💡 **Conceito Chave: Quality Gates (Portões de Qualidade)**
> O *Quality Gate* é o conjunto de critérios de sucesso que o projeto precisa atingir para ser aprovado (ex: "mínimo de 80% de cobertura" e "zero vulnerabilidades críticas"). Se o código enviado não atingir a meta, o SonarQube reprova a análise e pode bloquear o avanço da esteira de deploy.

---

## 2. A Arquitetura Básica: Server vs. Scanner

Para entender as formas de rodar o Sonar, é preciso saber que ele é dividido em duas partes independentes que se comunicam:

1. **SonarQube Server:** A centralizadora. É onde fica o painel web, os gráficos, o histórico de análises e o banco de dados. Ele recebe os relatórios e exibe na interface.
2. **SonarScanner:** O motor de varredura. Ele precisa rodar **onde o código está** (sua máquina local ou no servidor de CI/CD). Ele lê os arquivos, gera o relatório analítico e envia via rede para o *Server*.
* *Nota para C# (.NET):* O ecossistema .NET utiliza um scanner específico (`dotnet-sonarscanner`) que atua acoplado ao processo de compilação (`dotnet build`).



---

## 3. As Formas Possíveis de Rodar o "Universo Sonar"

A SonarSource (empresa responsável) oferece três abordagens complementares que se adaptam a diferentes momentos do desenvolvimento:

### A. SonarQube Cloud (SaaS / Na Nuvem)

É a versão gerenciada como serviço. Toda a infraestrutura do painel web e do banco de dados fica hospedada nos servidores da própria Sonar.

* **Características:** Zero manutenção de infraestrutura, atualizações automáticas e **totalmente gratuito para repositórios públicos** (excelente para portfólios no GitHub).
* **Como funciona:** Você vincula sua conta do GitHub/GitLab, e a sua esteira de CI/CD (como GitHub Actions) executa o *Scanner* e envia o resultado para a nuvem deles.

### B. SonarQube Server (Self-Hosted / Servidor Próprio)

É a versão onde você é responsável por hospedar e gerenciar o servidor do SonarQube. Pode ser executado de três formas principais:

| Forma de Execução | Casos de Uso Comuns | Características |
| --- | --- | --- |
| **Docker (Imagem Única)** | Testes rápidos e POCs locais. | Sobe rápido via comando `docker run`, mas usa um banco de dados embutido temporário (os dados somem se o container for apagado). |
| **Docker Compose** | Ambientes de desenvolvimento local e portfólios robustos. | Sobe o servidor SonarQube integrado a um container de banco de dados real (como PostgreSQL), garantindo a persistência das análises. |
| **Produção (VMs / Kubernetes)** | Ambientes corporativos. | Instalado em servidores dedicados na nuvem (AWS, Azure, etc.) com alta disponibilidade para atender múltiplos times simultaneamente. |

### C. SonarQube for IDE (Antigo SonarLint)

Uma extensão/plugin instalada diretamente no seu editor de código ou IDE (como VS Code, Visual Studio ou IntelliJ).

* **Como funciona:** Atua como um "corretor ortográfico" em tempo real. Conforme você digita seu código, ele sublinha as linhas problemáticas imediatamente, antes mesmo de você salvar ou realizar um commit.
* **Foco:** Feedback imediato para o desenvolvedor, evitando que o erro chegue até o repositório Git.

---

## 🛠️ Resumo do Fluxo Ideal de Trabalho

1. **Durante a escrita:** O desenvolvedor usa o **SonarQube for IDE** para pegar erros bobos na hora.
2. **No Commit / Pull Request:** A esteira de CI/CD dispara o **SonarScanner** adequado para a linguagem do projeto.
3. **Na Governança:** O relatório é enviado para o **SonarQube Server** (Local via Docker) ou **SonarQube Cloud** (Nuvem), onde o *Quality Gate* valida se o código pode ou não seguir para a branch principal.

