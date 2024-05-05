import os

class Config:
    def __init__(self) -> None:
        self.root_path = './Scripts/'
        self.common_files = ['header.sh', 'menu.sh', 'utils.sh']
        self.tags = {
            'default': ['Setup/oh-my-zsh', 'Setup/Docker', 'Setup/Python'],
            'pro': ['Setup/oh-my-zsh', 'Setup/Docker', 'Setup/Python', 'Setup/Backup'],
            'zsh': ['Setup/oh-my-zsh'],
            'docker': ['Setup/Docker'],
            'python': ['Setup/Python'],
            'nodejs': ['Setup/Nodejs'],
            'backup': ['Setup/Backup'],
            'forensic': ['Setup/Security']
        }
        self.filepaths = self.make_dict()

    def make_dict(self) -> dict:
        full_paths = {}
        for tag, paths in self.tags.items():
            all_paths = self.common_files + paths
            full_paths[tag] = [os.path.join(self.root_path, p) for p in all_paths]
        return full_paths
