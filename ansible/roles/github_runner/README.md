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
- `github_runner_config_marker_path`: local marker used to detect runner config drift
- `github_runner_install_build_tools`: install build toolchain packages (default `true`)
- `github_runner_debian_build_packages`: Debian build package list (default includes `build-essential`)
- `github_runner_redhat_build_packages`: RedHat build package list (default includes `make`, `gcc`, `gcc-c++`)

The role re-runs `config.sh --replace` when runner configuration inputs change
(`github_runner_url`, `github_runner_runner_name`, `github_runner_work_dir`,
or `github_runner_labels`).

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
