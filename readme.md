# do-not-disturb [![Build Status](https://travis-ci.org/sindresorhus/do-not-disturb.svg?branch=master)](https://travis-ci.org/sindresorhus/do-not-disturb)

> Control the macOS `Do Not Disturb` feature


## Install

```
$ npm install @sindresorhus/do-not-disturb
```


## Usage

```js
const doNotDisturb = require('@sindresorhus/do-not-disturb');

(async () => {
	await doNotDisturb.enable();
})();
```


## API

### doNotDisturb

All the methods return a `Promise`. You only really need to `await` them if you use multiple methods at once.

#### .enable()

#### .disable()

#### .toggle([force])

##### force

Type: `boolean`

Force it to be enabled/disabled.

#### .isEnabled(): `Promise<boolean>`


## Related

- [do-not-disturb-cli](https://github.com/sindresorhus/do-not-disturb-cli) - CLI for this module
- [dark-mode](https://github.com/sindresorhus/dark-mode) - Control the macOS dark mode
- [file-icon](https://github.com/sindresorhus/file-icon) - Get the icon of a file or app as a PNG image
- [app-path](https://github.com/sindresorhus/app-path) - Get the path to an app


## License

MIT © [Sindre Sorhus](https://sindresorhus.com)
