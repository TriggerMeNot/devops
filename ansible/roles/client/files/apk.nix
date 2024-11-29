{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "ionic-android-env";

  buildInputs = with pkgs; [
    # General packages
    curl
    gnupg
    git
    unzip
    p7zip
    python3
    openjdk17
    gradle
    nodejs-20_x

    # Android SDK tools
    (androidsdk.buildTools "34.0.0")
    androidsdk.platformTools
    (androidsdk.platforms "android-34")
  ];

  # Set environment variables
  shellHook = ''
    # Locale settings
    export LANG=en_US.UTF-8
    export DEBIAN_FRONTEND=noninteractive

    # Android SDK settings
    export ANDROID_HOME=${pkgs.androidsdk}/libexec
    export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

    # Gradle settings
    export GRADLE_HOME=${pkgs.gradle}
    export PATH=$GRADLE_HOME/bin:$PATH

    # NPM global settings
    export NPM_CONFIG_PREFIX=$HOME/.npm-global
    export PATH=$HOME/.npm-global/bin:$PATH

    # Install Ionic and Capacitor CLI globally
    if ! command -v ionic > /dev/null; then
      npm install -g @ionic/cli@7.2.0
    fi
    if ! command -v cap > /dev/null; then
      npm install -g @capacitor/cli@6.1.2
    fi

    echo "Environment set up for Ionic Capacitor Android development."
  '';
}
