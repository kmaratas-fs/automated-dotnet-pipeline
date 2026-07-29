

### Step 1: New VPS setup dependencies.
- Follow the instructions on how to run ``setup.sh``.

### Step 2: Create Enviroment Variables and SSH Key.
- Create an SSH User at VPS for the github actions. 
  - ssh-keygen -t ed25519 -C "[any-name]"
  - **Dont put password**
- Create PAT at developer settings in GitHub
- Create Environment Variables at the github repository based on the YAML file.

### Step 3: AI Prompt
- Use prompt.md to Claude

### Step 4: Trial and Error
- Validate CI/CD Workflow and deployment status

## Next Steps
- Domain and HTTPS for web security.