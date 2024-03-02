#!/usr/bin/python3


import typer
from click import Argument, Option, Command
import subprocess
from subprocess import PIPE
from typing import Annotated

app = typer.Typer(no_args_is_help=True)


@app.command("search")
def search(
    term: str,
    installed: Annotated[bool, Option("-i", "--installed", is_flag=True, show_choices=False)] = False,
) -> str:
    """Search apt packages

    Args:
        term (str): apt package name
        installed (bool): Only installed packages. Defaults to False.

    Raises:
        subprocess.SubprocessError: Any error raised by nala

    Returns:
        str: stdout
    """

    args = [
        'nala',
        'search'
    ]
    if installed: 
        args.append('--installed')

    proc = subprocess.run(
        ["nala", "search", "--full", term],
        capture_output=True,
        text=True,
        stderr=PIPE,
        stdout=PIPE,
        shell=False,
        check=True,
    )

    if proc.returncode != 0:
        raise subprocess.SubprocessError(proc.stderr)

    return proc.stdout


if __name__ == "__main__":
    app()
