import logging
import os

import fui

logger = logging.getLogger(fui.__name__)


logger.info("Running PyInstaller runtime hook for fui...")

os.environ["FUI_SERVER_IP"] = "127.0.0.1"
