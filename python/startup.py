import site
import pathlib


# PYTHON_HISTORY has been set such that it's not simply ~/.python_history. The
# site package will print a warning if it can't access the history file, and it
# won't automatically create the parent directory when needed. Here we create
# the directory so that subsequent updates will work.
history_file = pathlib.Path(site.gethistoryfile())
try:
    history_file.parent.mkdir(parents=True, exist_ok=True)
except Exception as e:
    print(f'Could not create history directory: {e}')
