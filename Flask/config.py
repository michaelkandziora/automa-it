import os

class Config:
    def __init__(self) -> None:
        self.root_path = './Scripts/'
        self.common_files = ['header.sh', 'menu.sh', 'utils.sh', 'config.toml']
        self.tags = {
            'default': ['Setup/oh-my-zsh', 'Setup/Docker', 'Setup/Python', 'Setup/Vim', 'Setup/Git'],
            'pro': ['Setup/oh-my-zsh', 'Setup/Docker', 'Setup/Python', 'Setup/Vim', 'Setup/Git', 'Setup/Backup'],
            'zsh': ['Setup/oh-my-zsh'],
            'docker': ['Setup/Docker'],
            'python': ['Setup/Python'],
            'nodejs': ['Setup/Nodejs'],
            'backup': ['Backup'],
            'forensic': ['Security'],
            'info': ['Info'],
            'cluster': ['Cluster']
        }
        self.filepaths = self.make_dict()

    def make_dict(self) -> dict:
        full_paths = {}
        for tag, paths in self.tags.items():
            all_paths = self.common_files + paths
            full_paths[tag] = [os.path.join(self.root_path, p) for p in all_paths]
        return full_paths
