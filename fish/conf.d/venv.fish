function activate_venv --on-variable PWD
    # Check for .pyvirtualenv file in current directory
    if test -f .pyvirtualenv
        set -l AB_PY_VERSION (cat .pyvirtualenv)
        set -l NEW_VENV "$PWD/$AB_PY_VERSION"

        # If different to current virt env, deactivate old and then load
        if test "$AB_VENV" != "$NEW_VENV"
            if test -n "$AB_VENV"
                if functions -q deactivate
                    echo "Deactivating virtual environment '$AB_VENV'"
                    deactivate
                end
            end

            set -l AB_ACTIVATE "$NEW_VENV/bin/activate.fish"
            if test -f $AB_ACTIVATE
                echo "Activating virtual environment at '$AB_PY_VERSION'"
                source $AB_ACTIVATE
            else
                echo "Please setup virtual environment at '$AB_PY_VERSION' so I can load it"
            end
            set -g AB_VENV $NEW_VENV
        end
    end
end
