import os

import fui_cli.__pyinstaller.config as hook_config
from fui_cli.__pyinstaller.utils import get_fui_bin_path

bin_path = hook_config.temp_bin_dir
if not bin_path:
    bin_path = get_fui_bin_path()

if bin_path:
    # package "bin/fuid" only
    if os.getenv("PACKAGE_fuiD_ONLY"):
        bin_path = os.path.join(bin_path, "fuid*")

    datas = [(bin_path, "fui/bin")]
