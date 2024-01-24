Bash Prompts and Hooks
======================

If the `PROMPT_COMMAND` variable is set, its value is executed as a command
prior to issuing each primary prompt.

Some care must be taken to correctly deal with return values, signals
during your operation, and so on. The [bash hook][direnv-bh] from direnv
provides a good example of how to handle this properly and also how to
properly set PROMPT_COMMAND:

    _direnv_hook() {
        local previous_exit_status=$?;
        trap -- '' SIGINT;
        eval "$("{{.SelfPath}}" export bash)";
        trap - SIGINT;
        return $previous_exit_status;
    };

    if ! [[ "${PROMPT_COMMAND[*]:-}" =~ _direnv_hook ]]; then
        if [[ "$(declare -p PROMPT_COMMAND 2>&1)" == "declare -a"* ]]; then
            PROMPT_COMMAND=(_direnv_hook "${PROMPT_COMMAND[@]}")
        else
            PROMPT_COMMAND="_direnv_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
        fi
    fi



<!-------------------------------------------------------------------->
[direnv-bh]: https://github.com/direnv/direnv/blob/e2ead48259e73a1c90a545b12c28a5a2cb193294/internal/cmd/shell_bash.go#L11-L17
