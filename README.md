<h1 align="center">
    Discord.sh Resource
</h1>

<p align="center">
<img src="https://user-images.githubusercontent.com/9924643/196964076-4b4c7ecb-4c09-453b-9876-3a7e4b07afa4.png" alt="Discord notification example" />
</p>
<p align="center">Wrapper resource for discord.sh to send notifications with concourse metadata</p>

### Configuration

For a full list of available options, check out [**discord.sh**](https://github.com/ChaoticWeg/discord.sh)

It could be configured as a task.
```yaml
# ci/tasks/notify.yml
# Sends a webhook request to discord
---
platform: linux

params:
  message: ((message))

image_resource:
  type: docker-image
  source:
    repository: registry.gitlab.com/user/project
    tag: image-tag
    username: ((git.username))
    password: ((git.password_or_access_token))
run:
  path: /bin/bash
  args:
    - -c
    - |
      discord \
          --username "CI/CD Bot" \
          --text="((message))" \
          --timestamp \
          --webhook-url=((discord.webhook))
```

Then used later in a pipeline using the image created for it.
```yaml
# some-pipeline.yml
--
resource_types:
- name: discord-notification-type
  type: registry-image
  source:
    repository: registry.gitlab.com/user/project
    tag: concourse-discord-sh-resource
    username: ((git.username))
    password: ((git.password_or_access_token))
resources:
- name: notify
  type: discord-notification-type
  source:
     DISCORD_WEBHOOK: ((discord.webhook))
```

Then within an on success or on failure hook as shown below:

```yaml
# some-pipeline.yml
# ... under a step on_failure hook:
on_failure:
  task: notify
  file: ci/tasks/notify.yml
  vars:
    message: '🔥 $host $BUILD_PIPELINE_NAME: $BUILD_JOB_NAME ([Build $BUILD_NAME]($ATC_EXTERNAL_URL/teams/$BUILD_TEAM_NAME/pipelines/$BUILD_PIPELINE_NAME/jobs/$BUILD_JOB_NAME/builds/$BUILD_NAME))'
```
Reference: https://concourse-ci.org/on-failure-hook.html


### Thanks

ChaoticWeg & fieu, and other contributors for making [**discord.sh**](https://github.com/ChaoticWeg/discord.sh)

### Support

If you like or found this project helpful, please leave a star or support its development.

<a href="https://liberapay.com/kevinpham/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg" style="height: 40px; padding-right: 10px">
<a href="https://www.buymeacoffee.com/keevan" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 40px !important" ></a>
<a href="https://ko-fi.com/H2H3AFFHJ" target='_blank'><img height='36' style='border:0px;height:40px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

### License

GPL-3.0

