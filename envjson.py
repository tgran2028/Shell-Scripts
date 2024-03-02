#!/usr/bin/env python3
"""
Dumps environment variables as formatted JSON.

Usage:
    ./your_script_name.py  # Replace with the actual script name
"""

import json
import os
import sys
from typing import Dict, Literal, Any 


def parse_int(x: Any):
    if not isinstance(x, str):
        return x 
    x: str = str(x)

    if x.isdigit() and x

    



def main() -> Literal[0, 1]:
    """Retrieves environment variables and outputs them as formatted JSON.

    Args:
        None

    Returns:
        Literal[0, 1]: 0 on success, 1 on error.

    Raises:
        Exception: Any errors encountered during environment variable retrieval
                   or JSON formatting.
    """

    try:
        environ: Dict[str, str] = {k: os.environ.get(k) for k in sorted(os.environ)}
        sys.stdout.write(
            f"{json.dumps(environ, indent=2)}\n"
        )
        return 0

    except Exception as e:
        sys.stderr.write(f"Error: {e.msg}\n")
        return 1


if __name__ == "__main__":
    sys.exit(main())
