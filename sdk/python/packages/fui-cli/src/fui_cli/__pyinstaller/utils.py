import os
import tempfile
import uuid
from pathlib import Path

from fui.utils import copy_tree
from fui_desktop import get_package_bin_dir


def get_fui_bin_path():
    bin_path = get_package_bin_dir()
    if not os.path.exists(bin_path):
        return None
    return bin_path


def copy_fui_bin():
    bin_path = get_fui_bin_path()
    if not bin_path:
        return None

    # create temp bin dir
    temp_bin_dir = Path(tempfile.gettempdir()).joinpath(str(uuid.uuid4()))
    copy_tree(bin_path, str(temp_bin_dir))
    return str(temp_bin_dir)
