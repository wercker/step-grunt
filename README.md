# webpack

A wercker step to execute a webpack build.

You should have nodejs and npm installed and you have to add the `webpack`
package to your package.json.

## Example Usage

In your [wercker.yml](http://devcenter.wercker.com/articles/werckeryml/) file under the `build` section:

``` bash
build:
  steps:
    - webpack:
        config-file: mywebpack.config.js
```

## Properties

### config-file
- type: string
- optional: true
- description: Specify an alternate webpack file. By default, webpack looks in the source directory for a file named `webpack.config.js`.
- example: `config: webpack.config-server.js`

### verbose
- type: boolean
- optional: true (default: false)
- description: Run webpack in verbose mode

### colors
- type: boolean
- optional: true (default: false)
- description: colored messages

### fail-on-warnings
- type: boolean
- optional: true (default: false)
- description: If webpack returns an error code of 6 (warning) then fail the build.

### display-error-details
- type: boolean
- optional: true (default: false)
- description: 

