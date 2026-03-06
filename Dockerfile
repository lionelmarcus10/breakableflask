FROM python:3.9-slim

# 1. Création d'un utilisateur non-root pour la sécurité (Corrige DS-0002)
RUN useradd -m myuser
USER myuser
WORKDIR /home/myuser/app

# Installation des dépendances
COPY --chown=myuser:myuser requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Copie du code source
COPY --chown=myuser:myuser . .

# 2. Ajout d'un Healthcheck (Corrige DS-0026)
# On vérifie que le port 5000 répond bien
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:5000/ || exit 1

CMD ["python", "app.py"]