
# **Git How-To Guide**

## **1. Set Username and Email**

### **Purpose**

In Git, the username and email are used to identify the author of changes. It's crucial to set these correctly for every project you work on to ensure accurate commit history.

### **Setting Username and Email**

To set the username and email globally (for all projects):

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

To set the username and email locally (for a specific project):

```bash
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### **Example**

```bash
git config --global user.name "Alice Johnson"
git config --global user.email "alice@example.com"
```

```bash
git config user.name "Bob Smith"
git config user.email "bob@example.com"
```

### **Viewing Configuration**

To view the current configuration:

```bash
git config --list
```

---

## **2. Set Remote URL**

### **Purpose**

The remote URL refers to the address of a repository on a server or another machine where your code is stored. This is important for collaborating with others or deploying your code.

### **Adding a Remote URL**

To add a new remote repository:

```bash
git remote add origin https://github.com/username/repository.git
```

### **Changing the Remote URL**

To change the remote URL for an existing remote:

```bash
git remote set-url origin https://github.com/username/new-repository.git
```

### **Example**

```bash
git remote add origin https://github.com/alice/my-project.git
```

```bash
git remote set-url origin https://github.com/alice/new-project-url.git
```

### **Viewing Remotes**

To view existing remotes:

```bash
git remote -v
```

---

## **3. Staging (git add)**

### **Purpose**

Staging allows you to select changes you want to include in the next commit. It acts as a preparation step before saving changes.

### **Staging Files**

To stage a specific file:

```bash
git add <filename>
```

To stage all changes in the current directory:

```bash
git add .
```

### **Example**

```bash
git add app.py
```

```bash
git add .
```

---

## **4. Remove Files (git rm)**

### **Purpose**

`git rm` is used to remove files from the repository. It also unstages the file if it was staged.

### **Removing Files**

To remove a file from the working directory and the staging area:

```bash
git rm <filename>
```

To only unstage a file but keep it in the working directory:

```bash
git rm --cached <filename>
```

### **Example**

```bash
git rm old_file.txt
```

```bash
git rm --cached temp_file.txt
```

**Note**: `git rm` permanently deletes a file from the working directory, so use it cautiously.

---

## **5. Fetch**

### **Purpose**

Fetching downloads changes from a remote repository but does not merge them into the local branch. It's useful for seeing what others have committed without changing your local work.

### **Fetching from a Remote**

To fetch changes from a remote:

```bash
git fetch origin
```

### **Example**

```bash
git fetch origin
```

### **Viewing Fetch Results**

After fetching, you can view the differences between your branch and the fetched branch using:

```bash
git diff HEAD origin/main
```

---

## **6. Merge**

### **Purpose**

Merging combines changes from one branch into another. It's commonly used to integrate features or bug fixes.

### **Merging Branches**

To merge changes from `feature` branch into `main`:

```bash
git checkout main
git merge feature
```

### **Merge Conflicts**

If there are conflicting changes between branches, Git will notify you and pause the merge. You need to resolve conflicts manually:

1. Open conflicting files and look for conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).
2. Edit the files to resolve the conflicts.
3. Mark the conflicts as resolved:

   ```bash
   git add <filename>
   ```

4. Complete the merge:

   ```bash
   git commit -m "Resolved conflicts"
   ```

### **Example**

```bash
git checkout main
git merge feature
```

---

## **7. Git Status**

### **Purpose**

`git status` shows the current state of the working directory and staging area, helping you understand what's going on with your project.

### **Using `git status`**

To check the status:

```bash
git status
```

### **Output**

`git status` typically shows:

1. **Untracked files** - New files not being tracked by Git.
2. **Changes not staged for commit** - Files that have been modified but not yet staged.
3. **Changes to be committed** - Files that are staged and ready to be committed.

### **Example**

```bash
git status
```

---

# **Summary**

1. **Set Username and Email**:
   - Global: `git config --global user.name "Your Name"`
   - Local: `git config user.name "Your Name"`
2. **Set Remote URL**:
   - Add: `git remote add origin <URL>`
   - Change: `git remote set-url origin <URL>`
3. **Staging (git add)**:
   - Specific file: `git add <filename>`
   - All changes: `git add .`
4. **Remove Files (git rm)**:
   - Remove: `git rm <filename>`
   - Unstage: `git rm --cached <filename>`
5. **Fetch**:
   - Fetch: `git fetch origin`
   - Diff: `git diff HEAD origin/main`
6. **Merge**:
   - Merge: `git merge <branch>`
   - Resolve Conflicts: `git add <filename>`, then `git commit -m "Resolved conflicts"`
7. **Git Status**:
   - Status: `git status`

With this guide, you should now have a solid understanding of these fundamental Git operations and workflows.