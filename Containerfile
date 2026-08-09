FROM floryn90/hugo:ext

# Arbeitsverzeichnis im Container festlegen
WORKDIR /src

# Projektdateien kopieren
COPY . /src

# Port für den Dev-Server bereitstellen
EXPOSE 1313

# Standardbefehl beim Starten: Hugo Server
CMD ["server", "-D", "--bind", "0.0.0.0"]
