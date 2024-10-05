#!/usr/bin/python3
"""Fabric script which generates a tgz archive"""
from datetime import datetime
from os.path import isdir
from fabric.api import local


def do_pack():
    """
    Generates a tgz archive
    Returns:
        str: The file path of the archive
    """
    try:
        date = datetime.now().strftime("%Y%m%d%H%M%S")
        if not isdir("versions"):
            local("mkdir versions")
        file_name = f"versions/web_static_{date}.tgz"
        local(f"tar -cvzf {file_name} web_static")
        return file_name
    except Exception:
        return None
