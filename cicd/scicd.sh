variables:
  CI_REPOSITORY_URL: "ssh://git@git.basa.ir:2222/dev/main.git"
  CI_COMMIT_USER_EMAIL: "imanbakhtiarinet@gmail.com"
  CI_COMMIT_USER_NAME: "iman"
  GITLAB_URL: "https://git.basa.ir"
  FILE_PATH: "/opt/app/project1/app"  # Set this to the actual path of your filess
  INITIAL_VERSION: "v1.0.0" 
  PROJECT_ID: "6" 
stages:
  - update
  - build
  - release

update_all_submodules:
  stage: update
  script:
    # Step 1: Initialize and update all submodulesss
    - echo "Initializing submodules..."
    - ls -ltrha $CI_PROJECT_DIR/project1/ && sleep 30
    - git submodule
    - rm -rf project1 project2 project3 project4 project5
    - git submodule
    - git submodule update --init --recursive
    - ls -a
    - cat .gitmodules
    - git submodule sync
    - git submodule update --init
    #- for d in project1 project2 project3 project4 project5; do (cd "$d" && git fetch); done
    - for d in project1 project2 project3 project4 project5; do (cd "$d" && git pull origin main); done
    #- git submodule -q foreach git pull -q origin master
    #- git submodule update --remote --recursive
    
    # Step 2: Configure Git and commit changes
    - git config --global user.email "$CI_COMMIT_USER_EMAIL"  # Set the Git config for commit
    - git config --global user.name "$CI_COMMIT_USER_NAME"
    - git remote set-url origin "$CI_REPOSITORY_URL"  # Ensure the correct remote URL is set
    #- |
    #  if [[ $(git status --porcelain) ]]; thenn
    #    echo "Submodules have updates. Preparing to commit...";
    #    git add .gitmodules  # Add the .gitmodules file if it changed
    #    git add .  # Stage changes (updates in submodule references)
    #    git commit -m "CI Update all submodules to the latest versions"  # Commit changes
    #    git push origin "$(git rev-parse --abbrev-ref HEAD)"  # Push changes back to the current branch
    #  else
    #    echo "No updates in submodules.";
    #  fi

    - ls project1
    - ls
    - ls project2
    - ssh gitlab 'sudo mkdir -p /opt/app/'
    - sudo chown -R basa:basa /opt/app
    - ssh gitlab 'sudo docker compose -f /opt/app/project1/docker-compose.yml down'
    - ssh gitlab 'sudo rm -rf /opt/app/*'
    - scp -r $CI_PROJECT_DIR/* gitlab:/opt/app/
    - ssh gitlab 'sudo docker compose -f /opt/app/project1/docker-compose.yml up --build -d'
    - ls -ltrha $CI_PROJECT_DIR/project1/
  rules:
  when: manual

release_job:
  stage: release
  only:
    - tags  # Trigger the pipeline only when a tag is created
  script:
    # Push source code (GitLab CI/CD will already have checked out the code)
    # If you need to push changes, you can do it here, but typically source code is already in the repo at this point.

    # Optionally upload a file as part of the release
    - echo "Uploading file to GitLab..."

    # Check if FILE_PATH is set and upload the file
    
    - >
      curl --header "PRIVATE-TOKEN: ${TOKENCI}" --form "file=@${FILE_PATH}" \
             "${GITLAB_URL}/api/v4/projects/${CI_PROJECT_ID}/uploads"
   
    # Optionally create a release using GitLab's API
    - >
      curl --header "PRIVATE-TOKEN: ${TOKENCI}" --header "Content-Type: application/json" \
           --data "{\"name\": \"Release ${CI_COMMIT_TAG}\", \"tag_name\": \"${CI_COMMIT_TAG}\", \"ref\": \"${CI_COMMIT_TAG}\", \"description\": \"Release description\"}" \
           --request POST "${GITLAB_URL}/api/v4/projects/${CI_PROJECT_ID}/releases"

    

