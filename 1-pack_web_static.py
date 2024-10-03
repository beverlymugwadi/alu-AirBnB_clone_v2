#!/usr/bin/python3
"""Fabric script which generates a tgz archive"""

from datetime import datetime
from fabric.api import local
from os.path import isdir


def do_pack():
    """
    Generates a tgz archive

    Returns:
        str: The file path of the archive
    """
    
    try:
        date = datetime.now().strftime("%Y%m%d%H%M%S")
        if isdir("versions") is False:
            local("mkdir versions")
        file_name = "versions/web_static_{}.tgz".format(date)
        local("tar -cvzf {} web_static".format(file_name))
        return file_name
    except BaseException:
        return None