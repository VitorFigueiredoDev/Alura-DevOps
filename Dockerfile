# 1. Use uma imagem oficial do Python como imagem base.
# A tag 'slim' é uma boa escolha, pois é menor que a padrão, mas ainda inclui
# ferramentas comuns necessárias para instalar pacotes, evitando problemas de compilação
# que podem ocorrer com a 'alpine'. A versão 3.11 é estável e compatível com o projeto.
FROM python:3.11-slim

# 2. Definir o diretório de trabalho no contêiner.
WORKDIR /app

# 3. Copiar o arquivo de dependências primeiro para aproveitar o cache de camadas do Docker.
# Se o requirements.txt não mudar, o Docker não reinstalará as dependências.
COPY requirements.txt .

# 4. Instalar as dependências.
# --no-cache-dir: Desativa o cache do pip para reduzir o tamanho da imagem.
# --upgrade pip: Garante que a versão mais recente do pip seja usada.
RUN pip install --no-cache-dir --upgrade pip -r requirements.txt

# 5. Copiar o restante do código da aplicação para o diretório de trabalho.
COPY . .

# 6. Expor a porta 8000 para que a aplicação possa ser acessada de fora do contêiner.
EXPOSE 8000

# 7. Comando para executar a aplicação quando o contêiner iniciar.
# Usamos --host 0.0.0.0 para tornar o servidor acessível externamente.
# O --reload não é usado em produção, pois é para desenvolvimento.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]