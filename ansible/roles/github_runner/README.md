# github_runner role

Installs and configures a GitHub Actions self-hosted runner as a systemd service.

The role:

- installs runner dependencies
- downloads and extracts the pinned runner release
- configures the runner in unattended mode
- installs `github-actions-runner.service`
- enables and starts the service

## Requirements

- Ubuntu or RedHat-family Linux host
- `github_runner_registration_token` must be provided at runtime

## Variables

Important variables in `defaults/main.yml`:

- `github_runner_repo`: repository slug, for example `mkrakowitzer/Saas`
- `github_runner_url`: repository URL derived from `github_runner_repo`
- `github_runner_version`: runner version (default `2.331.0`)
- `github_runner_registration_token`: short-lived registration token

## Example

```yaml
- hosts: github_runner_targets
  become: true
  roles:
    - role: github_runner
      vars:
        github_runner_repo: mkrakowitzer/Saas
        github_runner_registration_token: "{{ token_from_api }}"
```
