import EventEmitter from 'node:events';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import execa from 'execa';
import electronUtil from 'electron-util/node.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const binary = path.join(electronUtil.fixPathForAsarUnpack(__dirname), 'do-not-disturb');

const isEnabled = async () => {
	const {stdout} = await execa(binary, ['status']);
	return stdout === 'on';
};

let emitter;

const createEmitter = (pollInterval = 3000) => {
	if (emitter) {
		return emitter;
	}

	emitter = new EventEmitter();

	emitter.once('newListener', async event => {
		if (event === 'change') {
			let currentValue = await isEnabled();

			const pollingInterval = setInterval(async () => {
				if (emitter.listenerCount('change') === 0) {
					clearInterval(pollingInterval);
					return;
				}

				const nextValue = await isEnabled();

				if (nextValue !== currentValue) {
					currentValue = nextValue;
					emitter.emit('change', nextValue);
				}
			}, pollInterval);
		}
	});

	return emitter;
};

const doNotDisturb = {};

doNotDisturb.on = (eventName, listener, options = {}) =>
	createEmitter(options.pollInterval).on(eventName, listener);

doNotDisturb.off = (eventName, listener, options = {}) =>
	createEmitter(options.pollInterval).off(eventName, listener);

doNotDisturb.enable = async () => {
	await execa.sync(binary, ['on']);
};

doNotDisturb.disable = async () => {
	await execa(binary, ['off']);
};

doNotDisturb.toggle = async force => {
	if (force !== undefined) {
		await execa(binary, [force ? 'on' : 'off']);
		return;
	}

	await execa(binary, ['toggle']);
};

doNotDisturb.isEnabled = isEnabled;

export default doNotDisturb;
