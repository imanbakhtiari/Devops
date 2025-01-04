import requests

# Configuration
OLD_GITLAB_URL = "https://gitlab.xaas.ir"
NEW_GITLAB_URL = "https://gitlab2.xaas.ir"
OLD_GITLAB_TOKEN = "your_old_gitlab_personal_access_token"
NEW_GITLAB_TOKEN = "your_new_gitlab_personal_access_token"

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

def get_variables(project_id, gitlab_url, token):
    """Fetch CI/CD variables for a project."""
    url = f"{gitlab_url}/api/v4/projects/{project_id}/variables"
    response = requests.get(url, headers=get_headers(token))
    response.raise_for_status()
    return response.json()

def find_project_by_path(path_with_namespace, gitlab_url, token):
    """Find a project by its path_with_namespace."""
    url = f"{gitlab_url}/api/v4/projects/{requests.utils.quote(path_with_namespace, safe='')}"
    response = requests.get(url, headers=get_headers(token))
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Project {path_with_namespace} not found on {gitlab_url}.")
        return None

def import_variables_to_new_server(project_path, variables):
    """Import variables to a new GitLab server."""
    project = find_project_by_path(project_path, NEW_GITLAB_URL, NEW_GITLAB_TOKEN)
    if not project:
        print(f"Skipping project {project_path} as it does not exist on the new server.")
        return

    project_id = project['id']
    for var in variables:
        url = f"{NEW_GITLAB_URL}/api/v4/projects/{project_id}/variables"
        data = {
            "key": var["key"],
            "value": var["value"],
            "protected": var.get("protected", False),
            "masked": var.get("masked", False),
            "variable_type": var.get("variable_type", "env_var")
        }
        response = requests.post(url, headers=get_headers(NEW_GITLAB_TOKEN), json=data)
        if response.status_code == 201:
            print(f"Imported variable {var['key']} to project {project_path}")
        elif response.status_code == 400 and "key" in response.json().get("message", {}):
            print(f"Variable {var['key']} already exists in project {project_path}. Skipping.")
        else:
            print(f"Failed to import variable {var['key']} to project {project_path}: {response.text}")

def main():
    # Step 1: Extract variables from the old server and import to the new server
    print("Fetching projects from the old server...")
    old_projects = get_projects(OLD_GITLAB_URL, OLD_GITLAB_TOKEN)

    for project in old_projects:
        project_id = project["id"]
        project_path = project["path_with_namespace"]
        print(f"Processing project: {project_path} (ID: {project_id})")
        variables = get_variables(project_id, OLD_GITLAB_URL, OLD_GITLAB_TOKEN)
        import_variables_to_new_server(project_path, variables)

if __name__ == "__main__":
    main()

