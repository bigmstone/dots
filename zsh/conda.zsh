# Conda initialization
# Only loads if conda is installed

__conda_setup="$('/Users/mstone/dev/aiPlay/text-generation-webui/installer_files/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/mstone/dev/aiPlay/text-generation-webui/installer_files/conda/etc/profile.d/conda.sh" ]; then
        . "/Users/mstone/dev/aiPlay/text-generation-webui/installer_files/conda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/mstone/dev/aiPlay/text-generation-webui/installer_files/conda/bin:$PATH"
    fi
fi
unset __conda_setup
