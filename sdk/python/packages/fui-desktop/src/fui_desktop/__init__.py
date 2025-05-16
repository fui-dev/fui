import asyncio
import logging
import os
import signal
import subprocess
import tarfile
import tempfile
import urllib.request
import zipfile
from pathlib import Path

from fui.utils import (
    get_arch,
    is_linux,
    is_macos,
    is_windows,
    random_string,
    safe_tar_extractall,
)

import fui_desktop
import fui_desktop.version

logger = logging.getLogger(fui_desktop.__name__)


def get_package_bin_dir():
    return str(Path(__file__).parent.joinpath("app"))


def open_fui_view(page_url, assets_dir, hidden):
    args, fui_env, pid_file = __locate_and_unpack_fui_view(
        page_url, assets_dir, hidden
    )
    return subprocess.Popen(args, env=fui_env), pid_file


async def open_fui_view_async(page_url, assets_dir, hidden):
    args, fui_env, pid_file = __locate_and_unpack_fui_view(
        page_url, assets_dir, hidden
    )
    return (
        await asyncio.create_subprocess_exec(args[0], *args[1:], env=fui_env),
        pid_file,
    )


def close_fui_view(pid_file):
    if pid_file is not None and os.path.exists(pid_file):
        try:
            with open(pid_file) as f:
                fvp_pid = int(f.read())
            logger.debug(f"fui View process {fvp_pid}")
            os.kill(fvp_pid, signal.SIGKILL)
        except Exception:
            pass
        finally:
            os.remove(pid_file)


def __locate_and_unpack_fui_view(page_url, assets_dir, hidden):
    logger.info("Starting fui View app...")

    args = []

    # pid file - fui client writes its process ID to this file
    pid_file = str(Path(tempfile.gettempdir()).joinpath(random_string(20)))

    if is_windows():
        fui_exe = "fui.exe"
        temp_fui_dir = Path.home().joinpath(
            ".fui", "bin", f"fui-{fui_desktop.version.version}"
        )

        # check if fui_view.exe exists in "bin" directory (user mode)
        fui_path = os.path.join(get_package_bin_dir(), "fui", fui_exe)
        if os.path.exists(fui_path):
            logger.info(f"fui View found in: {fui_path}")
        else:
            # check if fui.exe is in fui_VIEW_PATH (fui developer mode)
            fui_path = os.environ.get("FUI_VIEW_PATH")
            if fui_path and os.path.exists(fui_path):
                logger.info(f"fui View found in PATH: {fui_path}")
                fui_path = os.path.join(fui_path, fui_exe)
            else:
                if not temp_fui_dir.exists():
                    zip_file = __download_fui_client("fui-windows.zip")

                    logger.info(f"Extracting fui.exe from archive to {temp_fui_dir}")
                    temp_fui_dir.mkdir(parents=True, exist_ok=True)
                    with zipfile.ZipFile(zip_file, "r") as zip_arch:
                        zip_arch.extractall(str(temp_fui_dir))
                    os.remove(zip_file)
                fui_path = str(temp_fui_dir.joinpath("fui", fui_exe))
        args = [fui_path, page_url, pid_file]
    elif is_macos():
        # build version-specific path to fui.app
        temp_fui_dir = Path.home().joinpath(
            ".fui", "bin", f"fui-{fui_desktop.version.version}"
        )

        # check if fui.exe is in fui_VIEW_PATH (fui developer mode)
        fui_path = os.environ.get("FUI_VIEW_PATH")
        if fui_path:
            logger.info(f"fui.app is set via fui_VIEW_PATH: {fui_path}")
            temp_fui_dir = Path(fui_path)
        else:
            # check if fui_view.app exists in a temp directory
            if not temp_fui_dir.exists():
                # check if fui.tar.gz exists
                gz_filename = "fui-macos.tar.gz"
                tar_file = os.path.join(get_package_bin_dir(), gz_filename)
                if not os.path.exists(tar_file):
                    tar_file = __download_fui_client(gz_filename)

                logger.info(f"Extracting fui.app from archive to {temp_fui_dir}")
                temp_fui_dir.mkdir(parents=True, exist_ok=True)
                with tarfile.open(str(tar_file), "r:gz") as tar_arch:
                    safe_tar_extractall(tar_arch, str(temp_fui_dir))
                os.remove(tar_file)
            else:
                logger.info(f"fui View found in: {temp_fui_dir}")

        app_name = None
        for f in os.listdir(temp_fui_dir):
            if f.endswith(".app"):
                app_name = f
        assert app_name is not None, f"Application bundle not found in {temp_fui_dir}"
        app_path = temp_fui_dir.joinpath(app_name)
        args = ["open", str(app_path), "-n", "-W", "--args", page_url, pid_file]
    elif is_linux():
        # build version-specific path to fui folder
        temp_fui_dir = Path.home().joinpath(
            ".fui", "bin", f"fui-{fui_desktop.version.version}"
        )

        app_path = None
        # check if fui.exe is in fui_VIEW_PATH (fui developer mode)
        fui_path = os.environ.get("FUI_VIEW_PATH")
        if fui_path:
            logger.info(f"fui View is set via fui_VIEW_PATH: {fui_path}")
            temp_fui_dir = Path(fui_path)
            app_path = temp_fui_dir.joinpath("fui")
        else:
            # check if fui_view.app exists in a temp directory
            if not temp_fui_dir.exists():
                # check if fui.tar.gz exists
                gz_filename = f"fui-linux-{get_arch()}.tar.gz"
                tar_file = os.path.join(get_package_bin_dir(), gz_filename)
                if not os.path.exists(tar_file):
                    tar_file = __download_fui_client(gz_filename)

                logger.info(f"Extracting fui from archive to {temp_fui_dir}")
                temp_fui_dir.mkdir(parents=True, exist_ok=True)
                with tarfile.open(str(tar_file), "r:gz") as tar_arch:
                    safe_tar_extractall(tar_arch, str(temp_fui_dir))
                os.remove(tar_file)
            else:
                logger.info(f"fui View found in: {temp_fui_dir}")

            app_path = temp_fui_dir.joinpath("fui", "fui")
        args = [str(app_path), page_url, pid_file]

    fui_env = {**os.environ}

    if assets_dir:
        args.append(assets_dir)

    if hidden:
        fui_env["FUI_HIDE_WINDOW_ON_START"] = "true"

    return args, fui_env, pid_file

def __download_fui_client(file_name):
    ver = fui_desktop.version.version
    temp_arch = Path(tempfile.gettempdir()).joinpath(file_name)
    logger.info(f"Downloading fui v{ver} to {temp_arch}")
    fui_url = f"https://github.com/fui-dev/fui/releases/download/v{ver}/{file_name}"
    urllib.request.urlretrieve(fui_url, temp_arch)
    return str(temp_arch)