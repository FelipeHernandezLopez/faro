#!/bin/bash
# Publica esta carpeta como https://felipehernandezlopez.github.io/faro/
# Se puede correr otra vez sin problema: las siguientes veces sólo sube los cambios.
set -e
cd "$(dirname "$0")"
# Esta app es personal, no de Hyginix: me aseguro de la cuenta correcta.
ANTES=$(gh api user --jq .login 2>/dev/null || echo "")
gh auth switch -u FelipeHernandezLopez >/dev/null
trap '[ -n "$ANTES" ] && [ "$ANTES" != "FelipeHernandezLopez" ] && gh auth switch -u "$ANTES" >/dev/null 2>&1' EXIT
if [ ! -d .git ]; then
  git init -q -b main
  git add .
  git -c user.name="Felipe Hernandez" -c user.email="felipeherlo1293@gmail.com" \
      commit -q -m "Portada de pantalla de inicio para Faro"
  gh repo create FelipeHernandezLopez/faro --public --source . --push \
      --description "Icono y marco de pantalla de inicio para Faro"
  gh api -X POST repos/FelipeHernandezLopez/faro/pages \
      -f "source[branch]=main" -f "source[path]=/" >/dev/null
else
  git add .
  git -c user.name="Felipe Hernandez" -c user.email="felipeherlo1293@gmail.com" \
      commit -q -m "Actualización" || true
  git push -q
fi
echo "✓ Publicado. En un minuto abre en: https://felipehernandezlopez.github.io/faro/"
