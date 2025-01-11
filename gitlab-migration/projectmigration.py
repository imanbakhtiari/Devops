import os
import subprocess
import requests

# Configuration
OLD_GITLAB_URL = "https://gitlab.domain.ir"
NEW_GITLAB_URL = "https://gitlab2.domain.ir"
OLD_GITLAB_TOKEN = "your_old_gitlab_personal_access_token"
NEW_GITLAB_TOKEN = "your_new_gitlab_personal_access_token"
WORKING_DIRECTORY = "./gitlab_migration_temp"  # Temporary directory for cloning repositories

def get_headers(token):
    return {
        "PRIVATE-TOKEN": token,
        "Content-Type": "application/json"
    }

def get_projects(gitlab_url, token):
    """Fetch all projects from the GitLab server."""
    projects = []
    page = 1
    while True:
        url = f"{gitlab_url}/api/v4/projects?per_page=100&page={page}"
        response = requests.get(url, headers=get_headers(token))
        response.raise_for_status()
        data = response.json()
        if not data:
            break
        projects.extend(data)
        page += 1
    return projects

def create_project_on_new_server(project_name, namespace_id=None):
    """Create a project on the new GitLab server."""
    url = f"{NEW_GITLAB_URL}/api/v4/projects"
    payload = {
        "name": project_name,
        "namespace_id": namespace_id,
    }
    response = requests.post(url, headers=get_headers(NEW_GITLAB_TOKEN), json=payload)
    if response.status_code == 201:
        return response.json()
    elif response.status_code == 409:
        print(f"Project {project_name} already exists on the new server.")
        return None
    else:
        print(f"Failed to create project {project_name} on the new server: {response.text}")
        return None

def migrate_project(project, old_gitlab_url, new_gitlab_url):
    """Migrate a project including all branches from old to new GitLab."""
    project_path = project["path_with_namespace"]
    clone_url = project["http_url_to_repo"].replace(old_gitlab_url, f"https://oauth2:{OLD_GITLAB_TOKEN}@{old_gitlab_url}")
    project_name = project["name"]
    
    # Create project on new GitLab
    namespace_id = project.get("namespace", {}).get("id")
    new_project = create_project_on_new_server(project_name, namespace_id)
    if not new_project:
        print(f"Skipping project {project_path}")
        return

    new_clone_url = new_project["http_url_to_repo"].replace(new_gitlab_url, f"https://oauth2:{NEW_GITLAB_TOKEN}@{new_gitlab_url}")

    # Clone the project
    project_dir = os.path.join(WORKING_DIRECTORY, project_name)
    print(f"Cloning {project_path}...")
    subprocess.run(["git", "clone", "--mirror", clone_url, project_dir], check=True)

    # Push to new GitLab
    print(f"Pushing {project_path} to new GitLab...")
    subprocess.run(["git", "-C", project_dir, "push", "--mirror", new_clone_url], check=True)

    # Clean up
    subprocess.run(["rm", "-rf", project_dir], check=True)
    print(f"Project {project_path} migrated successfully.")

def main():
    # Ensure the working directory exists
    os.makedirs(WORKING_DIRECTORY, exist_ok=True)

    # Fetch projects from the old GitLab server
    print("Fetching projects from the old server...")
    old_projects = get_projects(OLD_GITLAB_URL, OLD_GITLAB_TOKEN)

    # Migrate each project
    for project in old_projects:
        try:
            print(f"Processing project: {project['path_with_namespace']}")
            migrate_project(project, OLD_GITLAB_URL, NEW_GITLAB_URL)
        except Exception as e:
            print(f"Failed to migrate project {project['path_with_namespace']}: {e}")

if __name__ == "__main__":
    main()

