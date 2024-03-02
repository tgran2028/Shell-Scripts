#!/usr/bin/python3

import os
import re
import sys
from pathlib import Path
from typing_extensions import Annotated
from typing import List, Optional, Union, cast
import click


import typer
from typer import Argument, Option, colors, echo, secho, style

app = typer.Typer(
    name="path-util",
    short_help="Path utilities for cleaning, normalizing, and deduplicating paths.",
    add_completion=True
)



def set_path(value: str) -> None:
    """
    Sets the value of the `PATH` environment variable.

    Args:
        value (str): The new value for the PATH environment variable.

    Returns:
        None

    """
    os.environ["PATH"] = value


def clean_path(
    path: str, expand_user: bool = True, expand_vars: bool = True, absolute: bool = True
) -> str:
    """
    Cleans and normalizes a given path by expanding user and environment variables, and optionally returning an absolute path.

    Args:
        path (str): The path to be cleaned and normalized.
        expand_user (bool, optional): Whether to expand the user's home directory in the path. Defaults to True.
        expand_vars (bool, optional): Whether to expand environment variables in the path. Defaults to True.
        absolute (bool, optional): Whether to return an absolute path. Defaults to True.

    Returns:
        str: The cleaned and normalized path.

    """
    if expand_user:
        path = os.path.expanduser(path)
    if expand_vars:
        path = os.path.expandvars(path)
    if absolute:
        path = os.path.abspath(path)
    return path


def _deduplicate(
    paths: Union[str, List[str]], clean: bool = True, sep: Optional[str] = os.pathsep
) -> List[str]:
    """
    Deduplicates a list of paths by removing any duplicate entries, while preserving the order of the original list.

    Args:
        paths (Union[str, List[str]]): The paths to be deduplicated. It can be either a string of paths separated by `sep` or a list of paths.
        clean (bool): Clean each path using clean_path. Defaults to True.
        sep (Optional[str], optional): The separator used to split the string of paths. Defaults to os.pathsep.


    Returns:
        List[str]: The deduplicated list of paths.

    """
    if isinstance(paths, str):
        paths = paths.split(sep)

    assert isinstance(paths, list)

    if clean:
        paths = [clean_path(p) for p in paths]

    deduplicated_paths = []
    for p in paths:
        if p not in deduplicated_paths:
            deduplicated_paths.append(p)

    return deduplicated_paths


@app.command(
    name="deduplicate",
    help="Deduplicates the PATH environment variable by removing any duplicate entries",
    short_help="Deduplicate paths in PATH",
)
def deduplicate(
    sort: Annotated[
        bool,
        typer.Option(
            "-s",
            "--sort",
            is_flag=True,
            help="Sort PATH entries by global or local priority",
        ),
    ] = False,
    newline: Annotated[
        bool,
        typer.Option(
            "-n",
            "--no-newline",
            is_flag=True,
            help="Do not output the trailing newline",
        ),
    ] = False,
) -> None:
    """
    Deduplicates the PATH environment variable by removing any duplicate entries, while preserving the order of the original list.

    Args:
        newline (typer.Option, optional): _description_. Defaults to True, help="Do not output the trailing newline", default=True, ).
    """
    deduplicated_paths = _deduplicate(
        paths=os.environ["PATH"], clean=True, sep=os.pathsep
    )

    if sort:
        global_paths = []
        local_paths = []

        for p in deduplicated_paths:
            if p.startswith(str(Path.home())):
                local_paths.append(p)
            else:
                global_paths.append(p)

        deduplicated_paths = local_paths + global_paths
        
    PATH = os.pathsep.join(deduplicated_paths)
    set_path(PATH)

    typer.echo(
        message=PATH,
        nl=not newline,
    )


@app.command(
    name="append",
    help="Append a path to the PATH environment variable",
    short_help="Append path to PATH 'PATH=$PATH:<PATH>'",
)
def append(
    path: Annotated[
        str,
        typer.Argument(
            exists=True,
            file_okay=False,
            help="The path to be appended to the PATH environment variable",
            metavar="<PATH>",
            resolve_path=True,
        ),
    ]
) -> None:

    deduplicated_path = _deduplicate(
        paths=os.environ["PATH"] + os.pathsep + path, clean=True, sep=os.pathsep
    )

    path = clean_path(path)
    if path not in deduplicated_path:
        deduplicated_path.insert(-1, path)

    typer.echo(os.pathsep.join(deduplicated_path))


@app.command(
    name="prepend",
    help="Prepend a path to the PATH environment variable",
    short_help="Prepend path to PATH 'PATH=<PATH>:$PATH'",
)
def prepend(
    path: Annotated[
        str,
        typer.Argument(
            exists=True,
            file_okay=False,
            help="The path to be prepended to the PATH environment variable",
            metavar="<PATH>",
            resolve_path=True,
        ),
    ]
) -> None:

    deduplicated_path = _deduplicate(
        paths=os.environ["PATH"] + os.pathsep + path, clean=True, sep=os.pathsep
    )

    path = clean_path(path)
    if path not in deduplicated_path:
        deduplicated_path.insert(0, path)
        
    PATH = os.pathsep.join(deduplicated_path)
    set_path(PATH)

    typer.echo(PATH)


@app.command(
    name="list",
    help="List the PATH environment variable",
    short_help="List the PATH environment variable",
)
def list_paths(
    delimiter: Annotated[
        str,
        typer.Option(
            help="The delimiter used to separate the paths",
            metavar="<DELIMITER>",
            show_default=True,
        ),
    ] = "\n",
) -> None:
    paths = _deduplicate(os.environ["PATH"], clean=True, sep=os.pathsep)
    typer.echo(
        delimiter.join(paths),
    )


def search_path_by_substring(
    path: str, pattern: str, case_insensative: bool = True, as_bool: bool = False
) -> Union[str, bool]:
    """
    Search the PATH environment variable for a given pattern.
    """
    case_sensative_lookup = {
        "original": path,
        "lower": path.lower(),
        "use": path.lower() if case_insensative else path,
    }
    path = case_sensative_lookup["use"]

    if re.search(pattern, path):
        return True if as_bool else case_sensative_lookup["original"]
    else:
        return False if as_bool else ""


@app.command(
    name="find",
    help="Find paths that contain a given substring pattern",
    short_help="Find paths that contain a given substring pattern",
)
def find_path(
    pattern: str = typer.Argument(
        ...,
        help="The substring pattern to search for in the PATH environment variable",
        metavar="<PATTERN>",
    ),
    case_insensative: Annotated[
        bool,
        Option(
            "--ignore-case",
            "-i",
            help="Perform a case-insensative search",
            show_default=False,
            is_flag=True,
        ),
    ] = False,
    delimiter: Annotated[
        str,
        typer.Option(
            "-d",
            "--delimiter",
            help="The delimiter used to separate the paths",
            metavar="<DELIMITER>",
            show_default=True,
        ),
    ] = "\n",
):
    """
    Find paths that contain a given substring pattern.
    """
    paths = _deduplicate(os.environ["PATH"], clean=True, sep=os.pathsep)
    matching_paths = []
    for p in paths:
        if search_path_by_substring(
            path=p, pattern=pattern, case_insensative=case_insensative, as_bool=True
        ):
            matching_paths.append(p)

    typer.echo(delimiter.join(matching_paths))


@app.command(
    name="remove",
    help="Remove paths from the PATH environment variable that contain a given substring pattern",
    short_help="Remove paths from the PATH environment variable that contain a given substring pattern",
)
def remove_path(
    pattern: str = typer.Argument(
        ...,
        help="The substring pattern to search for in the PATH environment variable",
        metavar="<PATTERN>",
    ),
    case_insensative: Annotated[
        bool,
        Option(
            "--ignore-case",
            "-i",
            help="Perform a case-insensative search",
            show_default=False,
            is_flag=True,
        ),
    ] = False,
):
    """
    Remove paths from the PATH environment variable that contain a given substring pattern.
    """
    paths = _deduplicate(os.environ["PATH"], clean=True, sep=os.pathsep)
    non_matching_paths = []
    for p in paths:
        if not search_path_by_substring(
            path=p, pattern=pattern, case_insensative=case_insensative, as_bool=True
        ):
            non_matching_paths.append(p)
            
    PATH = os.pathsep.join(non_matching_paths)
    set_path(PATH)
    
    typer.echo(PATH) 


if __name__ == "__main__":
    app()
