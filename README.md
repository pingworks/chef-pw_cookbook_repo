# pw_cookbook_repo-cookbook

Installs and configures cookbook_repo

## Supported Platforms

Ubuntu 14.04

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['pw_cookbook_repo']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### pw_cookbook_repo::default

Include `pw_cookbook_repo` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[pw_cookbook_repo::default]"
  ]
}
```

## License and Authors

Author:: Christoph Lukas (<christoph.lukas@gmx.net>)
