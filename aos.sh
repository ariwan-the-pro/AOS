#!/bin/bash

# ==========================
# AOS 1.0
# ==========================

VERSION="AOS 1.0"
PASSWORD="aos"

APPS_DIR="$HOME/aos_apps"
DATA_DIR="$HOME/aos_data"
FAV_FILE="$DATA_DIR/browser_favs.txt"
NOTES_FILE="$DATA_DIR/notes.txt"
BROWSER_HOME="https://duckduckgo.com"

mkdir -p "$APPS_DIR" "$DATA_DIR"
touch "$FAV_FILE" "$NOTES_FILE"

# ==========================
# BASIS-APPS (vooraf geïnstalleerd)
# ==========================
BASE_APPS=(files terminal notepad settings systeminfo)

for app in "${BASE_APPS[@]}"; do
  touch "$APPS_DIR/$app.app"
done

pause() {
  read -p "Enter om verder te gaan..."
}

# ==========================
# LOCK SCREEN
# ==========================
lock_screen() {
  while true; do
    clear
    echo "========================"
    echo "        AOS LOCK"
    echo "========================"
    echo
    read -s -p "Wachtwoord: " input
    echo
    if [[ "$input" == "$PASSWORD" ]]; then
      break
    else
      echo "Fout wachtwoord"
      sleep 1
    fi
  done
}

# ==========================
# BOOT
# ==========================
boot() {
  clear
  echo "Booting $VERSION"
  sleep 1
  echo "Initializing system..."
  sleep 1
}

# ==========================
# APPS
# ==========================
app_notepad() {
  clear
  echo "[Notepad]"
  echo "Typ tekst. Lege regel = opslaan."
  while true; do
    read line
    [[ -z "$line" ]] && break
    echo "$line" >> "$NOTES_FILE"
  done
  echo "Opgeslagen."
  pause
}

app_terminal() {
  clear
  echo "=== AOS Linux Terminal ==="
  echo "Typ 'exit' om terug te gaan"
  while true; do
    read -p "aos@linux:$PWD$ " cmd
    [[ "$cmd" == "exit" ]] && break
    bash -c "$cmd"
  done
}

app_files() {
  clear
  echo "[Files]"
  ls -lah
  pause
}

app_settings() {
  clear
  echo "[Settings]"
  echo "Versie     : $VERSION"
  echo "Gebruiker  : $USER"
  echo "Home map   : $HOME"
  pause
}

app_systeminfo() {
  clear
  echo "[System Info]"
  uname -a
  pause
}

app_browser() {
  while true; do
    clear
    echo "[AOS Browser]"
    echo "1) Startpagina"
    echo "2) Website openen"
    echo "3) Favorieten"
    echo "4) Terug"
    read -p "Keuze: " b

    case $b in
      1) lynx "$BROWSER_HOME" ;;
      2)
        read -p "URL: " url
        lynx "$url"
        read -p "Opslaan als favoriet? (j/n): " s
        [[ $s == "j" ]] && echo "$url" >> "$FAV_FILE"
        ;;
      3)
        clear
        nl "$FAV_FILE"
        pause
        ;;
      4) return ;;
    esac
  done
}

# ==========================
# APP STORE
# ==========================
appstore() {
  APPS=(browser calculator)

  while true; do
    clear
    echo "[AOS App Store]"
    echo "1) Browser"
    echo "2) Calculator"
    echo "0) Terug"
    read -p "Installeer: " k

    [[ $k == 0 ]] && return

    app="${APPS[$((k-1))]}"
    touch "$APPS_DIR/$app.app"
    echo "$app geïnstalleerd."
    sleep 1
  done
}

app_calculator() {
  clear
  echo "[Calculator]"
  read -p "Nummer 1: " a
  read -p "Nummer 2: " b
  echo "Resultaat: $((a + b))"
  pause
}

# ==========================
# APPS OPENEN
# ==========================
open_apps() {
  while true; do
    clear
    echo "[Apps]"
    ls "$APPS_DIR"
    echo
    echo "Typ appnaam of 'terug':"
    read app

    [[ "$app" == "terug" ]] && return
    [[ ! -f "$APPS_DIR/$app.app" ]] && continue

    case $app in
      notepad) app_notepad ;;
      terminal) app_terminal ;;
      files) app_files ;;
      settings) app_settings ;;
      systeminfo) app_systeminfo ;;
      browser) app_browser ;;
      calculator) app_calculator ;;
    esac
  done
}

# ==========================
# HOOFDMENU
# ==========================
main_menu() {
  while true; do
    clear
    echo "========================"
    echo "        $VERSION"
    echo "========================"
    echo "1) Apps openen"
    echo "2) App Store"
    echo "3) Lock screen"
    echo "4) Afsluiten"
    read -p "Keuze: " m

    case $m in
      1) open_apps ;;
      2) appstore ;;
      3) lock_screen ;;
      4) clear; echo "AOS afgesloten"; exit ;;
    esac
  done
}

# ==========================
# START
# ==========================
boot
lock_screen
main_menu
