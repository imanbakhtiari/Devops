stages:
  - sandbox

sandbox:
  stage: sandbox
  script:
    - echo "Deplying back..."
    - echo "Finished UI Deployment!"
  rules:
  when: manual

