.PHONY: dev prod stop pdf clean deploy help

help:
	@echo "Verfügbare Befehle:"
	@echo "  make dev    - Startet den Hugo Live-Server (Port 1313)"
	@echo "  make prod   - Baut & startet den Caddy Produktions-Container (Port 8080)"
	@echo "  make stop   - Stoppt den Produktions-Container"
	@echo "  make pdf    - Erzeugt commands.pdf aus commands/commands.md mit XeLaTeX"
	@echo "  make clean  - Löscht temporäre Bau-Dateien"
	@echo "  make deploy - Baue Hugo und übertrage Dateien per rsync auf sv1"

dev:
	podman run --rm -it --user 0:0 -p 1313:1313 -v $$(pwd):/src:Z mein-hugo-blog

prod:
	podman build -f Containerfile.prod -t mein-hugo-blog:prod .
	podman run --rm -d -p 8080:80 --name blog-prod mein-hugo-blog:prod

stop:
	podman stop blog-prod || true

pdf:
	pandoc commands/commands.md -o commands/commands.pdf --pdf-engine=xelatex

clean:
	rm -rf public .hugo_build.lock commands/commands.pdf

deploy:
	@echo "--> Baue Hugo-Seite..."
	hugo --minify
	@echo "--> Übertrage Dateien nach sv1..."
	rsync -avz --delete public/ stephan@sv1:/home/stephan/HTML/
	@echo "--> Fertig deployt!"
